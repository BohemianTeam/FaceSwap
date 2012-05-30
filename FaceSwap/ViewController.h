//
//  ViewController.h
//  FaceSwap
//
//  Created by Tien Doan on 5/26/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController     *_captureVC;
}

@property (nonatomic, retain) IBOutlet UIButton *btnGetPro;
@property (nonatomic, retain) IBOutlet UIButton *btnMore;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
- (IBAction)btnTakePhotoPressed:(id)sender;
- (IBAction)btnPhotosPressed:(id)sender;
- (void)btnHowToPressed;
@end
