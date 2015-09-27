//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>

// Main UIResponder for app. Controls interaction with OS.
//
//
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Checks for first launch to send user to settings tab to set weekly budget amount. Establishes
// background fetch interval for weekly balance updates.
- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

// Checks if one week cycle has completed. If so, modifies current balance.
- (void)                application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

// Standard AppDelegate method.
- (void)applicationWillResignActive:(UIApplication *)application;

// Standard AppDelegate method.
- (void)applicationDidEnterBackground:(UIApplication *)application;

// Standard AppDelegate method.
- (void)applicationWillEnterForeground:(UIApplication *)application;

// Standard AppDelegate method.
- (void)applicationDidBecomeActive:(UIApplication *)application;

// Standard AppDelegate method.
- (void)applicationWillTerminate:(UIApplication *)application;

@end
