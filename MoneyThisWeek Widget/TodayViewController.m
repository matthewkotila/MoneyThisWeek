//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "TodayViewController.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateBalance];
  [self updateInterface];
}

- (void)viewWillAppear:(BOOL)animated {
  [self updateBalance];
  [self updateInterface];
}

- (void)updateBalance {
  NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.com.matthewkotila.MoneyThisWeek"];
  _currentBalance = [userDefaults floatForKey:@"currentBalance"];
}

- (void)updateInterface {
  self.balanceLabel.text = [NSString stringWithFormat:@"$%.2f", _currentBalance];
  if (_currentBalance > 0.0)
    _balanceLabel.textColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
  else if (_currentBalance == 0.0)
    _balanceLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  else
    _balanceLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
}

- (IBAction)goToApp:(id)sender {
  NSURL *appURL = [NSURL URLWithString:@"MoneyThisWeek://home"];
  [self.extensionContext openURL:appURL completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
  [self updateBalance];
  [self updateInterface];
  completionHandler(NCUpdateResultNewData);
}

@end
