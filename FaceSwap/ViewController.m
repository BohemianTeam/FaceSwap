//
//  ViewController.m
//  FaceSwap
//
//  Created by Tien Doan on 5/26/12.
//  Copyright (c) 2012 tiendnuit@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "TakePhotoViewController.h"
#import "FaceSwappingViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize btnGetPro, btnMore;
@synthesize backgroundImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btnHow = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHow setFrame:CGRectMake(0, 0, 66, 30)];
    [btnHow setImage:[UIImage imageNamed:@"btn_how"] forState:UIControlStateNormal];
    [btnHow addTarget:self action:@selector(btnHowToPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHow];
    
    if (kFaceSwapVersion == kFaceSwapProVersion) {
        self.btnGetPro.hidden = YES;
        self.btnMore.frame = CGRectMake(105, 302, 110, 45);
        self.backgroundImage.image = [UIImage imageNamed:@"bg_main_pro1"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [backgroundImage release];
    [btnMore release];
    [btnGetPro release];
}

- (void)dealloc
{
    [_captureVC release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - event methods
- (IBAction)btnTakePhotoPressed:(id)sender
{
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
            [self presentModalViewController:_captureVC animated:YES];
        }
    }
//    TakePhotoViewController *takePhotoVC = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
//    [self presentModalViewController:takePhotoVC animated:NO];
    
    //***FIX ME: using temp
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
//            // create our image picker
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
//            picker.allowsEditing = YES;
//            [self presentModalViewController:picker animated:YES];
//            [picker release];
//        }
//    }
}

- (IBAction)btnPhotosPressed:(id)sender
{
    if (_captureVC) {
        [_captureVC release];
        _captureVC = nil;
    }
    _captureVC = [[UIImagePickerController alloc] init];
    _captureVC.delegate = self;
    _captureVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _captureVC.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self presentModalViewController:_captureVC animated:YES];
}

- (void)btnHowToPressed
{
    UIViewController *howtoVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    howtoVC.title = @"How To";
    howtoVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_howto"]];
    [self.navigationController pushViewController:howtoVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    } else {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    [_captureVC dismissModalViewControllerAnimated:YES];
    if (_captureVC) {
        [_captureVC release];
        _captureVC = nil;
    }
    
    FaceSwappingViewController * FSVC = [[FaceSwappingViewController alloc] initWithNibName:@"FaceSwappingViewController" bundle:nil];
    FSVC.pickedImg = [image retain];
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
