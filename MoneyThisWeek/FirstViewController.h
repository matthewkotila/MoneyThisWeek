//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>

// Main UIViewController for the expense-input view. Takes user input, and records it to the list
// of transactions and updates current balance displayed on screen and stored in NSUserDefaults.
//
//
@interface FirstViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *mutableArray;

@property (strong, nonatomic) IBOutlet UILabel *currentBalanceUILabel;

@property (strong, nonatomic) IBOutlet UITextField *expenseUITextField;

@property (strong, nonatomic) IBOutlet UILabel *dollarSignUILabel;

// Standard UIViewController method.
- (void)viewDidLoad;

// Standard UIViewController method.
- (void)viewWillAppear:(BOOL)animated;

// Updates the array holding contents of transactions.plist.
- (void)updateMutableArray;

// Animation for tabbar.
- (void)keyboardWillAppear:(NSNotification *)notification;

// Monitors legal cost input.
- (BOOL)  textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
  replacementString:(NSString *)string;

// Updates current balance and transactions.plist.
- (IBAction)submitExpense:(id)sender;

// Standard UIViewController method.
- (void)viewWillDisappear:(BOOL)animated;

// Standard UIViewController method.
- (void)didReceiveMemoryWarning;

@end
