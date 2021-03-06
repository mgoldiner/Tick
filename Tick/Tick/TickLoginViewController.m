//
//  TickLoginViewController.m
//  Tick
//
//  Created by Malcolm Goldiner on 6/9/13.
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "TickLoginViewController.h"
#import "TickUser.h"
#import "TickDataFetcher.h"
#import "TickProjectListViewController.h"
#import "TickTodaysEntriesViewController.h"

@interface TickLoginViewController ()
@property (strong, nonatomic) TickUser *user;
@property (strong, nonatomic) TickDataFetcher *checker;
@property (nonatomic) CGPoint originalCenter;
@property (strong, nonatomic) UIApplication *thisApplication;
@end

@implementation TickLoginViewController

#pragma mark - Lazy Instantiation

- (UIApplication *) thisApplication
{
    if (!_thisApplication) _thisApplication = [UIApplication sharedApplication];
    return  _thisApplication;
}

- (TickDataFetcher *) checker
{
    if (!_checker) _checker = [[TickDataFetcher alloc] init];
    return _checker;
}

- (TickUser *)user
{
    if (!_user) _user = [[TickUser alloc] init];
    return _user; 
}

#pragma mark - View

- (void) viewWillAppear:(BOOL)animated
{
    [self clearEnteredInfo];
    self.loadingLabel.hidden = YES;
     self.thisApplication.networkActivityIndicatorVisible = NO;
    NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
    if ([current objectForKey:@"Tick User"]) {
        NSArray *userInfo = [current objectForKey:@"Tick User"];
        self.user.email = userInfo[0];
        self.user.company = userInfo[1];
        self.user.password = userInfo[2];
        self.usernameField.hidden = YES;
        self.passwordField.hidden = YES;
        self.loadingLabel.hidden = YES;
        [self.loginButton setTitle:[NSString stringWithFormat:@"Login %@",[self.user email]] forState:UIControlStateNormal];
        self.chooseDifferentUserButton.hidden = NO; 
    } else {
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (void)viewDidLayoutSubviews
{
    if(!self.originalCenter.x && !self.originalCenter.y) self.originalCenter = self.view.center;
}

- (void) clearEnteredInfo
{
    self.user = nil;
    self.usernameField.text = @"";
    self.passwordField.text = @"";
}

- (IBAction)usernameEntered:(UITextField *)sender {
    [self.user setEmail:sender.text];
}

- (IBAction)passwordEntered:(UITextField *) sender {

    [self.user setPassword:sender.text];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    self.checker.user = self.user; 
    return [self.checker credentialsAreCorrect];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loginSegue"]){
        [[segue destinationViewController] setUser:self.user];
    }
}


#pragma mark - Buttons

- (IBAction)chooseDifferentUser:(UIButton *)sender {
    [self clearEnteredInfo];
    self.usernameField.hidden = NO;
    self.user = nil; 
    self.passwordField.hidden = NO;
    NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
    [current removeObjectForKey:@"Tick User"];
    [current synchronize];
    sender.hidden = YES;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
}

- (IBAction)loginPressed:(UIButton *)sender {
   
    if([self shouldPerformSegueWithIdentifier:@"loginSegue" sender:sender]){
         self.loadingLabel.hidden = YES;
        [self.user setFullName:[self.checker getUserFullName]];
    } else {
        [self clearEnteredInfo];
        [self.loadingLabel setText:@"Login unsucessful, please try again."];
    }
    self.thisApplication.networkActivityIndicatorVisible = NO;
}


- (IBAction)loginTouched:(id)sender {
    self.thisApplication.networkActivityIndicatorVisible = YES; 
    [self.loadingLabel setText:@"Loading..."];
    [self.loadingLabel setHidden:NO];
}

#pragma mark - Text Field

// code from http://stackoverflow.com/questions/7952762/xcode-ios5-move-uiview-up-when-keyboard-appears
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.passwordField]){
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y/1.70);
        
    } else {
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y/1.15);
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self textFieldShouldReturn:textField];
    self.view.center = self.originalCenter;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.usernameField]) [self.passwordField becomeFirstResponder];
    [textField resignFirstResponder];
    return YES;
}

@end
