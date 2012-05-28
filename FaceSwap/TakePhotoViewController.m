//
//  TakePhotoViewController.m
//  FaceSwap
//
//  Created by Tien Doan on 5/27/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface TakePhotoViewController ()

@end

@implementation TakePhotoViewController
@synthesize captureVC = _captureVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
                // create our image picker
                _captureVC = [[UIImagePickerController alloc] init];
                _captureVC.delegate = self;
                _captureVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                _captureVC.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
                
            }
        }
    }
    return self;
}
- (void)dealloc
{
    [_captureVC release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentModalViewController:_captureVC animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
