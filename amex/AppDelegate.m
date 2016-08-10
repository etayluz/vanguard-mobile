//
//  AppDelegate.m
//  amex
//
//  Created by Etay Luz on 7/28/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


#import "AppDelegate.h"
#import "Chat.h"
#import "AccountOverview.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()
@property UITextField *topTextField;
@property UITextField *bottomTextField;
@property UIButton *micButton1;
@property UIImageView *topTextBox;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [Fabric with:@[[Crashlytics class]]];

  UIViewController *viewController = [[AccountOverview alloc] init];
  
#if (TARGET_OS_SIMULATOR)
  viewController = [[Chat alloc] init];
#endif
  
  UINavigationController *navigationController =
  [[UINavigationController alloc] initWithRootViewController:viewController];
  [navigationController setNavigationBarHidden:YES];
  
  self.window.rootViewController = navigationController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

CGRect Frame(float x, float y, float w, float h)
{
  
  /* iPad Air, iPad Mini, iPad 2, iPad Retina */
  if ([UIScreen mainScreen].bounds.size.width == 768) {
    x = x;
    y = y;
    w = w;
    h = h;
  }
  /* iPad Pro */
  else if ([UIScreen mainScreen].bounds.size.width == 1024) {
    x = x * 1024/768.0;
    y = y * 1024/768.0;
    w = w * 1024/768.0;
    h = h * 1024/768.0;
  }

  return CGRectMake(x,y,w,h);
}


double Normalize(double val)
{
  /* iPad Air, iPad Mini, iPad 2, iPad Retina */
  if ([UIScreen mainScreen].bounds.size.width == 768)
    val = val;
  /* iPad Pro */
  else if ([UIScreen mainScreen].bounds.size.width == 1024)
    val = val * 1024/768.0;

  return val;
}

double Denormalize(double val)
{
  /* iPad Air, iPad Mini, iPad 2, iPad Retina */
  if ([UIScreen mainScreen].bounds.size.width == 768)
    val = val;
  /* iPad Pro */
  else if ([UIScreen mainScreen].bounds.size.width == 1024)
    val = val * 768.0/1024;
  
  return val;
}

void ShowViewBorders(UIView *view)
{
  CALayer * layer = [view layer];
  [layer setBorderWidth:1.0];
  [layer setBorderColor:[[UIColor blackColor] CGColor]];
}

@end
