//
//  FaceSwappingViewController.m
//  FaceSwap
//
//  Created by helios-team on 5/29/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import "FaceSwappingViewController.h"
#import "FaceSwappedViewController.h"
#import "Config.h"
@interface FaceSwappingViewController ()

@end

@implementation FaceSwappingViewController
@synthesize btnBack,btnFlip,btnSwap,bannerView,img, pickedImg;

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
    [self.img setImage:self.pickedImg];
    
    if(kFaceSwapVersion == kFaceSwapProVersion)
        self.bannerView.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Button Actions
- (void)didBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didFlipClicked:(id)sender {
    FaceSwappedViewController * vc = [[FaceSwappedViewController alloc] initWithNibName:@"FaceSwappedViewController" bundle:nil];
    vc.pickedImg = [self.pickedImg retain];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)didSwapClicked:(id)sender {
    FaceSwappedViewController * vc = [[FaceSwappedViewController alloc] initWithNibName:@"FaceSwappedViewController" bundle:nil];
    vc.pickedImg = [self.pickedImg retain];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
