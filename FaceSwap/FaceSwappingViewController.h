//
//  FaceSwappingViewController.h
//  FaceSwap
//
//  Created by helios-team on 5/29/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceSwappingViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
@property (nonatomic, retain) IBOutlet UIImageView  *img;
@property (nonatomic, retain) UIImage               *pickedImg;
@property (nonatomic, retain) IBOutlet UIButton     *btnBack;
@property (nonatomic, retain) IBOutlet UIButton     *btnSwap;
@property (nonatomic, retain) IBOutlet UIButton     *btnFlip;

- (IBAction)didBackClicked:(id)sender;
- (IBAction)didSwapClicked:(id)sender;
- (IBAction)didFlipClicked:(id)sender;

@end
