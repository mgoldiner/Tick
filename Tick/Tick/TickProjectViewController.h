//
//  MHNYCTickProjectViewController.h
//  Tick
//
//  Created by Malcolm Goldiner on 6/4/13.
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

#import <UIKit/UIKit.h>
#import "TickUser.h"

@interface TickProjectViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id project;

@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionView;
@property (strong, nonatomic) TickUser *user;
@property (strong, nonatomic) NSMutableDictionary *TickData;
@property (weak, nonatomic) IBOutlet UITextField *hoursField;
@property (weak, nonatomic) IBOutlet UIButton *createEntryButton;
@property (weak, nonatomic) IBOutlet UITextView *notesField;
@property (weak, nonatomic) IBOutlet UIButton *submitEntry;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UITableView *entriesTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
