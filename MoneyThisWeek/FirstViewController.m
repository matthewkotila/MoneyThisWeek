//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
  _expenseUITextField.delegate = self;
  [_expenseUITextField becomeFirstResponder];
  [self updateMutableArray];
}

- (void)viewWillAppear:(BOOL)animated {
  NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.com.matthewkotila.MoneyThisWeek"];
  _currentBalanceUILabel.text = [NSString stringWithFormat:@"$%.2f",
                                 [userDefaults floatForKey:@"currentBalance"]];
  [_expenseUITextField becomeFirstResponder];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:)
                                               name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateMutableArray {
  NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask];
  NSURL *URL = [[array lastObject] URLByAppendingPathComponent:@"transactions.plist"];
  
  if ([URL checkResourceIsReachableAndReturnError:nil])
    _mutableArray = [NSMutableArray arrayWithContentsOfURL:URL];
  
  else
    _mutableArray = [[NSMutableArray alloc] init];
}

- (void)keyboardWillAppear:(NSNotification *)notification {
  CGRect frame = [[[self tabBarController] tabBar] frame];
  CGRect keyboard = [[notification.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"]
                     CGRectValue];
  frame.origin.y = keyboard.origin.y - frame.size.height;
  id duration = [notification.userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
  [UIView animateWithDuration:[duration floatValue] animations:^{
     [[[self tabBarController] tabBar] setFrame:frame];
   }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                      replacementString:(NSString *)string {
  
  NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  NSRegularExpression *regex = [NSRegularExpression
                                regularExpressionWithPattern:@"^([0-9]*)(\\.([0-9]{0,2})?)?$"
                                                     options:NSRegularExpressionCaseInsensitive
                                                       error:nil];
  
  NSUInteger numMatches = [regex numberOfMatchesInString:newString
                                                  options:0
                                                    range:NSMakeRange(0, [newString length])];
  if (numMatches == 0)
    return NO;
  
  return YES;
}

- (IBAction)submitExpense:(id)sender {
  float expenseAmount = _expenseUITextField.text.floatValue;
  if (expenseAmount != 0.0) {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"transactionChanged"];
    [self updateMutableArray];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"group.com.matthewkotila.MoneyThisWeek"];
    float oldCurrentBalance = [userDefaults floatForKey:@"currentBalance"];
    [userDefaults setFloat:(oldCurrentBalance - expenseAmount) forKey:@"currentBalance"];
    float newCurrentBalance = [userDefaults floatForKey:@"currentBalance"];
    _currentBalanceUILabel.text = [NSString stringWithFormat:@"$%.2f", newCurrentBalance];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    [objects setObject:[NSDate date] atIndexedSubscript:0];
    [objects setObject:@"" atIndexedSubscript:1];
    [objects setObject:[NSNumber numberWithFloat:expenseAmount] atIndexedSubscript:2];
    NSArray *keys = @[@"date", @"description", @"amount"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [_mutableArray insertObject:dictionary atIndex:0];
    NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                            inDomains:NSUserDomainMask];
    NSURL *URL = [[array lastObject] URLByAppendingPathComponent:@"transactions.plist"];
    [[_mutableArray copy] writeToURL:URL atomically:YES];
  }
  _expenseUITextField.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.view endEditing:YES];
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification  object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
