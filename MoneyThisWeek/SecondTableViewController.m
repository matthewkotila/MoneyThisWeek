//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "SecondTableViewController.h"

@interface SecondTableViewController ()

@end

@implementation SecondTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
  [self updateMutableArray];
}

- (void)viewWillAppear:(BOOL)animated {
  
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"transactionChanged"] == 1) {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"transactionChanged"];
    [self updateMutableArray];
    [self.tableView reloadData];
  }
  
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"mode"] == 1)
    _savingsUIBarButtonItem.enabled = NO;
  
  else
    _savingsUIBarButtonItem.enabled = YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.mutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *iden = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
  
  NSDate *date = [[_mutableArray objectAtIndex:indexPath.row] valueForKey:@"date"];
  ((UILabel *)[cell viewWithTag:1]).text = [NSDateFormatter
                                            localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
  
  NSString *description = [[_mutableArray objectAtIndex:indexPath.row] valueForKey:@"description"];
  ((UILabel *)[cell viewWithTag:2]).text = description;
  
  float amount = [[[_mutableArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue];
  ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"-$%.2f", amount];
  
  return cell;
}

- (BOOL)  textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
  replacementString:(NSString *)string {
  
  if (string.length == 0)
    return YES;
  
  return textField.text.length < 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Description"
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
  [ac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.delegate = self;
    textField.placeholder = @"Enter your description";
   }];
  [ac addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}]];
  [ac addAction:[UIAlertAction actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
    NSString *description = ac.textFields[0].text;
    ((UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:2]).text = description;
    [[_mutableArray objectAtIndex:indexPath.row] setObject:description forKey:@"description"];
    NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask];
    NSURL *URL = [[array lastObject] URLByAppendingPathComponent:@"transactions.plist"];
    [[_mutableArray copy] writeToURL:URL atomically:YES];
  }]];
  [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)showSavings:(id)sender {
  float totSavings = [[NSUserDefaults standardUserDefaults] floatForKey:@"totalSavings"];
  NSString *savings = [NSString stringWithFormat:@"You've saved $%.2f since starting!", totSavings];
  UIAlertController *alertController = [UIAlertController
                                        alertControllerWithTitle:@"Total savings"
                                                         message:savings
                                                  preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {}]];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
