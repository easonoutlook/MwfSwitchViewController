//
//  MwfAppDelegate.m
//  MwfSwitchViewController
//
//  Created by Meiwin Fu on 19/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import "MwfAppDelegate.h"
#import "MwfSwitchViewController.h"
#import "MwfDemoFirstViewController.h"
#import "MwfDemoSecondViewController.h"

@implementation MwfAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  MwfSwitchViewController * switchController = [[MwfSwitchViewController alloc] initWithNibName:nil bundle:nil];

#ifndef TEST
  MwfDemoFirstViewController * first = [[MwfDemoFirstViewController alloc] initWithNibName:@"MwfDemoFirstViewController" bundle:nil];
  MwfDemoSecondViewController * second = [[MwfDemoSecondViewController alloc] initWithNibName:@"MwfDemoSecondViewController" bundle:nil];
  NSArray * controllers = [NSArray arrayWithObjects:first, second, nil];
  switchController.viewControllers = controllers;
  UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
  UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
  NSArray * toolbarItems = [NSArray arrayWithObjects:item1,item2,nil];
  switchController.toolbarItems = toolbarItems;
  switchController.delegate = self;  
#endif
  
  self.window.rootViewController = switchController;
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void) switchViewController:(MwfSwitchViewController *)controller didSwitchToViewController:(UIViewController *)viewController
{
  if ([viewController isKindOfClass:[MwfDemoFirstViewController class]]) {
    [viewController.switchViewController setToolbarHidden:YES animated:YES];
  } else {
    [viewController.switchViewController setToolbarHidden:NO animated:YES];
  }
}
@end
