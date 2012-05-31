//
//  Util.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}

+ (void)showLoading:(UIView*)view;
+ (void)showLoading:(NSString*)content view:(UIView*)view;
+ (void)hideLoading;

@end
