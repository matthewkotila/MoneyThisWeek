//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (nonatomic, assign) float currentBalance;

// Standard UIViewController method.
- (void)viewDidLoad;

// Standard UIViewController method.
- (void)viewWillAppear:(BOOL)animated;

// Updates the current balance from the shared NSUserDefaults.
- (void)updateBalance;

// updates the balance label on the Today Widget.
- (void)updateInterface;

- (IBAction)goToApp:(id)sender;

// Standard UIViewController method.
- (void)didReceiveMemoryWarning;

// Standard NCWidgetProviding method.
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler;

@end
