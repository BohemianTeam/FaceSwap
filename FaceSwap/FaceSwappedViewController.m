//
//  FaceSwappedViewController.m
//  FaceSwap
//
//  Created by helios-team on 5/29/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import "FaceSwappedViewController.h"

@interface FaceSwappedViewController ()

@end

@implementation FaceSwappedViewController
@synthesize btnShare,btnFlip,btnSwap,bannerView,img, pickedImg,icon,btnSave;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (kFaceSwapVersion == kFaceSwapProVersion) {
        self.icon.hidden = YES;
    }
    [self.img setImage:self.pickedImg];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Button Actions
- (void)didSaveClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didFlipClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSwapClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didShareClicked:(id)sender {
    UIActionSheet * shareAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook", @"Twitter", @"Remove Watermark", nil];
    [shareAction showInView:self.view];
    [shareAction release];
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
    switch (index) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
