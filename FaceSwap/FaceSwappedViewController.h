//
//  FaceSwappedViewController.h
//  FaceSwap
//
//  Created by helios-team on 5/29/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface FaceSwappedViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
}

@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
@property (nonatomic, retain) IBOutlet UIImageView  *img;
@property (nonatomic, retain) UIImage               *pickedImg;
@property (nonatomic, retain) IBOutlet UIButton     *btnSave;
@property (nonatomic, retain) IBOutlet UIButton     *btnSwap;
@property (nonatomic, retain) IBOutlet UIButton     *btnFlip;
@property (nonatomic, retain) IBOutlet UIButton     *btnShare;
@property (nonatomic, retain) IBOutlet UIImageView  *icon;

- (IBAction)didSaveClicked:(id)sender;
- (IBAction)didSwapClicked:(id)sender;
- (IBAction)didFlipClicked:(id)sender;
- (IBAction)didShareClicked:(id)sender;

@end
