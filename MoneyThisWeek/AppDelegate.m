//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isFirstLaunch"] == 0) {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isFirstLaunch"];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedIndex = 2;
  }
  return YES;
}

- (void)                application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  int currentDay = (int)[[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                  fromDate:[NSDate date]] - 2;
  int weekStart = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"weekStart"];
  int weekCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"weekCompletionChecked"];
  
  if (currentDay ==  weekStart && weekCheck == 0) {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"weekCompletionChecked"];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"group.com.matthewkotila.MoneyThisWeek"];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"mode"] == 0) {
      float oldTotalSavings = [[NSUserDefaults standardUserDefaults] floatForKey:@"totalSavings"];
      float currentBalance = [userDefaults floatForKey:@"currentBalance"];
      [[NSUserDefaults standardUserDefaults] setFloat:(oldTotalSavings + currentBalance)
                                               forKey:@"totalSavings"];
      float weekBudget = [[NSUserDefaults standardUserDefaults] floatForKey:@"weeklyBudgetAmount"];
      [userDefaults setFloat:weekBudget forKey:@"currentBalance"];
    }
    
    else {
      float oldCurrentBalance = [userDefaults floatForKey:@"currentBalance"];
      float weekBudget = [[NSUserDefaults standardUserDefaults] floatForKey:@"weeklyBudgetAmount"];
      [userDefaults setFloat:(oldCurrentBalance + weekBudget) forKey:@"currentBalance"];
    }
    completionHandler(UIBackgroundFetchResultNewData);
  }
  
  else if (currentDay != weekStart) {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"weekCompletionChecked"];
    completionHandler(UIBackgroundFetchResultNoData);
  }
  
  else {
    completionHandler(UIBackgroundFetchResultNoData);
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
