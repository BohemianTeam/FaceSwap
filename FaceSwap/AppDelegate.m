//
//  AppDelegate.m
//  FaceSwap
//
//  Created by Tien Doan on 5/26/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "Config.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
- (void)dealloc
{
    [_window release];
    [_navigationController release];

    [super dealloc];
}
- (void)showAlertBuyProVersion
{
    if(kFaceSwapVersion == kFaceSwapFreeVersion)
    {
        UIAlertView *buyAlert = [[UIAlertView alloc] initWithTitle:@"Get Face Swap Pro" message:@"Face Swap Pro is a premium ad free version that alows you to save your Face Swap images with no watermark" delegate:self cancelButtonTitle:@"Maybe Later" otherButtonTitles:@"Get it Now!", nil];
        [buyAlert show];
        [buyAlert release];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //check show alert buy pro version
    [self showAlertBuyProVersion];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_navi"] forBarMetrics:UIBarMetricsDefault];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    ViewController *faceSwapVC = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:faceSwapVC]autorelease];
    self.window.rootViewController = self.navigationController;
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

@end
