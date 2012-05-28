//
//  TakePhotoViewController.h
//  FaceSwap
//
//  Created by Tien Doan on 5/27/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController     *_captureVC;
}
@property(nonatomic, retain)UIImagePickerController     *captureVC;
@end
