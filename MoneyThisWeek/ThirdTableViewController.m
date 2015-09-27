//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "ThirdTableViewController.h"

@interface ThirdTableViewController ()

@end

@implementation ThirdTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillAppear:(BOOL)animated {
  float weekBudget = [[NSUserDefaults standardUserDefaults] floatForKey:@"weeklyBudgetAmount"];
  _weeklyBudgetAmountUILabel.text = [NSString stringWithFormat:@"$%.2f", weekBudget];
  [_modeUISwitch setOn:(BOOL)[[NSUserDefaults standardUserDefaults] integerForKey:@"mode"]];
  int weekStart = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"weekStart"];
  _weekStartUISegmentedControl.selectedSegmentIndex = weekStart;
}

- (BOOL)  textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
  if (indexPath.section == 0) {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Set Amount"
                                                           message:nil
                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
      textField.delegate = self;
      textField.keyboardType = UIKeyboardTypeDecimalPad;
      textField.placeholder = @"Enter your weekly budget amount";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
      float weekBudget = [alertController.textFields[0].text floatValue];
      _weeklyBudgetAmountUILabel.text = [NSString stringWithFormat:@"$%.2f", weekBudget];
      [[NSUserDefaults standardUserDefaults] setFloat:weekBudget forKey:@"weeklyBudgetAmount"];
                                                        
      if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isFirstBudget"] == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isFirstBudget"];
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                        initWithSuiteName:@"group.com.matthewkotila.MoneyThisWeek"];
        [userDefaults setFloat:weekBudget forKey:@"currentBalance"];
        self.tabBarController.selectedIndex = 0;
      }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
  }
  
  else if (indexPath.section == 3) {
    UIAlertController *ac = [UIAlertController
                             alertControllerWithTitle:@"Reset data"
                                              message:@"This action is irreversible."
                                       preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDestructive
                                         handler:^(UIAlertAction * action) {
      [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"transactionChanged"];
      NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                      initWithSuiteName:@"group.com.matthewkotila.MoneyThisWeek"];
      float weekBudget = [[NSUserDefaults standardUserDefaults] floatForKey:@"weeklyBudgetAmount"];
      [userDefaults setFloat:weekBudget forKey:@"currentBalance"];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"totalSavings"];
      NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                              inDomains:NSUserDomainMask];
      NSURL *URL = [[array lastObject] URLByAppendingPathComponent:@"transactions.plist"];
      [[NSFileManager defaultManager] removeItemAtURL:URL error:nil];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * action) {}]];
    [self presentViewController:ac animated:YES completion:nil];
  }
}

- (IBAction)weekStartChanged:(id)sender {
  switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
    case 0:
      [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"weekStart"];
      break;
    case 1:
      [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"weekStart"];
      break;
    case 2:
      [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"weekStart"];
      break;
    case 3:
      [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"weekStart"];
      break;
    case 4:
      [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"weekStart"];
      break;
    case 5:
      [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"weekStart"];
      break;
    case 6:
      [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"weekStart"];
      break;
    default:
      break;
  }
}

- (IBAction)modeChanged:(id)sender {
  if (((UISwitch *)sender).on == YES)
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"mode"];
  else
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"mode"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
