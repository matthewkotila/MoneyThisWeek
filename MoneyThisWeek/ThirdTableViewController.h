//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>

// Main UITableViewController for the settings view. Allows the user to set the weekly budget
// amount, week start day, Saver vs. Spender mode, and reset all transactions and current week.
// This is also the first tab shown when the user opens the app for the first time to allow a weekly
// budget amount to be set.
//
//
@interface ThirdTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *weeklyBudgetAmountUILabel;

@property (strong, nonatomic) IBOutlet UISwitch *modeUISwitch;

@property (strong, nonatomic) IBOutlet UISegmentedControl *weekStartUISegmentedControl;

// Standard UITableViewController method.
- (void)viewDidLoad;

// Standard UITableViewController method.
- (void)viewWillAppear:(BOOL)animated;

// Monitors legal weekly budget amount input.
- (BOOL)  textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
  replacementString:(NSString *)string;

// Standard UITableViewController method.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// Updates the NSUserDefaults containing the week start day.
- (IBAction)weekStartChanged:(id)sender;

// Updates the NSUserDefaults containing the app mode.
- (IBAction)modeChanged:(id)sender;

// Standard UITableViewController method.
- (void)didReceiveMemoryWarning;

@end
