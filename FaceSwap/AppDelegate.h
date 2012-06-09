//
//  AppDelegate.h
//  FaceSwap
//
//  Created by Tien Doan on 5/26/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class FacebookViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    NSMutableDictionary     *userPermissions;
    UIAlertView *buyAlert;
    FacebookViewController  *facebookViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, retain) FacebookViewController *facebookViewController;

@end
