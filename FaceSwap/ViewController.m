//
//  ViewController.m
//  FaceSwap
//
//  Created by Tien Doan on 5/26/12.
//  Copyright (c) 2012 tiendnuit@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "TakePhotoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btnHow = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHow setFrame:CGRectMake(0, 0, 66, 30)];
    [btnHow setImage:[UIImage imageNamed:@"btn_how"] forState:UIControlStateNormal];
    [btnHow addTarget:self action:@selector(btnHowToPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHow];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - event methods
- (IBAction)btnTakePhotoPressed:(id)sender
{
    TakePhotoViewController *takePhotoVC = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
    [self presentModalViewController:takePhotoVC animated:NO];
    
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
}
- (void)btnHowToPressed
{
    UIViewController *howtoVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    howtoVC.title = @"How To";
    howtoVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_howto"]];
    [self.navigationController pushViewController:howtoVC animated:YES];
}
@end
