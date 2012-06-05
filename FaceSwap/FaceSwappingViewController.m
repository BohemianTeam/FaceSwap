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
#import <iAd/iAd.h>

@interface FaceSwappingViewController ()

@end

@implementation FaceSwappingViewController
@synthesize btnBack,btnFlip,btnSwap,bannerView,img, pickedImg, bannerIsVisible;

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
    
    self.bannerView.delegate = self;
    self.bannerIsVisible = NO;
    self.bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark -
#pragma mark iAd delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 0);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        // stop all interactive processes in the app
        
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // resume everything you've stopped
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait||UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    else
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
}

@end
