//
//  TakePhotoViewController.m
//  FaceSwap
//
//  Created by Tien Doan on 5/27/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "FaceSwappingViewController.h"
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
                if (_captureVC) {
                    [_captureVC release];
                    _captureVC = nil;
                }
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
    if (!_hasFirstRun) {
        [self presentModalViewController:_captureVC animated:YES];
        _hasFirstRun = !_hasFirstRun;
    }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [_captureVC dismissModalViewControllerAnimated:YES];
    if (_captureVC) {
        [_captureVC release];
        _captureVC = nil;
    }
    
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    } else {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    
    
    FaceSwappingViewController * FSVC = [[FaceSwappingViewController alloc] initWithNibName:@"FaceSwappingViewController" bundle:nil];
    [FSVC.img setImage:[image retain]];
    [self.navigationController pushViewController:FSVC animated:YES];
    [FSVC release];
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSLog(@"SAVE IMAGE COMPLETE");
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }
}


@end
