//
//  Util.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

#import "MBProgressHUD.h"

static MBProgressHUD    *loadingView;

@implementation Util

+ (void)showLoading:(NSString*)content view:(UIView*)view
{
    loadingView = [[MBProgressHUD alloc] initWithView:view];
    loadingView.labelText = content;
    [view addSubview:loadingView];
    
    [loadingView show:YES];
}

+ (void)showLoading:(UIView*)view
{
    loadingView = [[MBProgressHUD alloc] initWithView:view];
    loadingView.labelText = @"loading..!";
    [view addSubview:loadingView];
    
    [loadingView show:YES];
}

+ (void)hideLoading
{
    if(loadingView){
        [loadingView removeFromSuperview];
        [loadingView show:NO];
        [loadingView release];
    }
    
}

@end
