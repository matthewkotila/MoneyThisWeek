//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>

// Main UITableViewController for the transactions view. Shows data stored in transactions.plist
// and allows user to add descriptions to each transaction in the table.
//
//
@interface SecondTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *mutableArray;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *savingsUIBarButtonItem;

// Standard UITableViewController method.
- (void)viewDidLoad;

// Standard UITableViewController method.
- (void)viewWillAppear:(BOOL)animated;

// Updates the array holding contents of transactions.plist.
- (void)updateMutableArray;

// Standard UITableViewController method.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Standard UITableViewController method.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// Monitors legal description length.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string;

// Standard UITableViewController method.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// Displays an alert showing how much the user has saved since the start of using Saver mode.
- (IBAction)showSavings:(id)sender;

// Standard UITableViewController method.
- (void)didReceiveMemoryWarning;

@end
