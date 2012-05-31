//
//  FacebookViewController.h
//  Bars
//
//  Created by Trinh Hung on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
typedef enum FacebookRequest {
    FBRequestNone = 0,
    FBFeedMe,
    FBFeedInfo,
    FBUpload,
}FacebookRequest;

@protocol FacebookViewControllerDelegate

- (void) didUploadToFacebookSuccess;

@end


@interface FacebookViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>{

    Facebook                *_facebook;
    NSArray                 *_permissions;
    
    NSMutableArray          *mainMenuItems;
    
    UITableView             *menuTableView;
    UIView                  *headerView;
    UILabel                 *nameLabel;
    UIImageView             *profilePhotoImageView;
    UITextField             *_photoTag;
    
    NSURL                   *_urlOpenInExternalBrowser;

    UIImage                 *_currentImage;
    
    FacebookRequest         _fbRequest;
    
    id                      _delegate;

}
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) Facebook * facebook;

- (void) setImage:(UIImage *) img withMessage:(NSString *) msg;
@end
