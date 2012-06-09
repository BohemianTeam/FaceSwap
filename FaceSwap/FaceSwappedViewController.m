//
//  FaceSwappedViewController.m
//  FaceSwap
//
//  Created by helios-team on 5/29/12.
//  Copyright (c) 2012 Saritasa. All rights reserved.
//

#import "FaceSwappedViewController.h"
#import <Twitter/Twitter.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface FaceSwappedViewController ()

@end

@implementation FaceSwappedViewController
@synthesize btnShare,btnFlip,btnSwap,bannerView,img, pickedImg,icon,btnSave,bannerIsVisible;
@synthesize mergedImg;

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
        self.bannerView.hidden = YES;
        CGRect newFrame = self.img.frame;
        newFrame.origin.y = 0;
        newFrame.size.height = self.img.frame.size.height + 50;
        self.img.frame = newFrame;
    }
    [self.img setImage:self.pickedImg];
    [self createMergedImage];
    
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
#pragma mark Private Methods
- (void) createMergedImage {
    UIGraphicsBeginImageContext(self.img.frame.size);
    
    [self.pickedImg drawInRect:CGRectMake(0, 0, self.img.frame.size.width, self.img.frame.size.height)];
    
    
    if (kFaceSwapVersion == kFaceSwapProVersion) {
        [self.icon.image drawInRect:CGRectMake(214, 324, self.icon.frame.size.width, self.icon.frame.size.height) blendMode:kCGBlendModeNormal alpha:0.8];
    } else {
        [self.icon.image drawInRect:CGRectMake(214, 324 - 50, self.icon.frame.size.width, self.icon.frame.size.height) blendMode:kCGBlendModeNormal alpha:0.8];
    }
    
    self.mergedImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.icon.hidden = YES;
    [self.img setImage:self.mergedImg];
}

- (void) showMessageDialog {
    UIAlertView * buyAlert = [[UIAlertView alloc] initWithTitle:@"Get Face Swap Pro" message:@"Face Swap Pro is a premium ad free version that alows you to save your Face Swap images with no watermark" delegate:self cancelButtonTitle:@"Maybe Later" otherButtonTitles:@"Get it Now!", nil];
    [buyAlert show];
    [buyAlert release];
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
    
    if(kFaceSwapVersion == kFaceSwapFreeVersion){
        UIActionSheet * shareAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook", @"Twitter", @"Remove Watermark", nil];
        [shareAction showInView:self.view];
        [shareAction release];
    } else {
        UIActionSheet * shareAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook", @"Twitter", nil];
        [shareAction showInView:self.view];
        [shareAction release];
    }
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{

    switch (index) {
        case 0://email
            [self mailShareOpenMail];
            break;
        case 1://facebook
        {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            FacebookViewController * fbViewController = [[FacebookViewController alloc] init];
            if (kFaceSwapVersion == kFaceSwapProVersion) {
                [fbViewController setImage:self.pickedImg withMessage:@"msg"];
            } else {
                [fbViewController setImage:self.mergedImg withMessage:@"msg"];
            }
            [self.navigationController pushViewController:fbViewController animated:YES];
            break;
        }
        case 2://twitter
            [self tweet];
            break;
        case 3://remove watermark
            [self showMessageDialog];
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Facebook sharing -- FacebookViewcontroller delegate
- (void) didUploadToFacebookSuccess {
    NSLog(@"upload image to facebook success");
}

#pragma mark -
#pragma mark Twitter sharing
- (void) tweet {
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"Check out this photo I created using the @FaceSwapApp"];
        if (kFaceSwapVersion == kFaceSwapProVersion) {
            [tweetSheet addImage:self.pickedImg];
        } else {
            [tweetSheet addImage:self.mergedImg];
        }
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't send a tweet right now, make sure your device has version 5.0 and later with an internet connection and you have at least one Twitter account setup."                                                          
                                  delegate:nil                                              
                                  cancelButtonTitle:@"Cancel"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark Mail Share

- (void) sendMailByDefaultApp {
    NSLog(@"send mail");
    NSString *mailTo = @"";
    NSString *cc = @"";
    NSString *subject = @"Check out this photo I created using the @FaceSwapApp";
    NSString *body = @"";
    NSString *email = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
					   mailTo,cc,subject,body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void) sendMailByMFMailComposer {
    NSLog(@"send mail");
    NSString *mailTo = @"";
    NSString *cc = @"";
    NSString *subject = @"Check out this photo I created using the @FaceSwapApp";
    NSString *body = @"";
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:subject];
    // Create NSData object as PNG image data from camera image
    NSData *data = UIImagePNGRepresentation(self.pickedImg);
    if (kFaceSwapVersion == kFaceSwapFreeVersion) {
        data = UIImagePNGRepresentation(self.mergedImg);
    }
    // Attach image data to the email
    // 'CameraImage.png' is the file name that will be attached to the email
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"Face Swap Image"];
    // Set up recipients
    NSArray *toRecipients = [[NSArray alloc] initWithObjects:mailTo, nil];
    [picker setToRecipients:toRecipients];
    [toRecipients release];
    if ([cc isEqualToString:@""] == NO) {
		NSArray *ccRecipients = [NSArray arrayWithObject:cc];
		[picker setCcRecipients:ccRecipients];
    }
    
    [picker setMessageBody:body isHTML:NO];
    CGRect fram = CGRectMake(0, -20, 320, 480);
    [picker.view setFrame:fram];
    
    [self presentModalViewController:picker animated:YES];
    
    [picker release];
    
}

//MFMailComposeDelegate
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"===didFinishWithResult=");
    NSString *_msg;
    switch (result) {
		case MFMailComposeResultCancelled:
			//_msg = @"MailShareCanceled";
			break;
		case MFMailComposeResultSaved:
		{
			_msg = @"MailShareSaved";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"AlertTitleMailShare"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultSent:
		{
			_msg = @"MailShareSent";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"AlertTitleMailShare"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultFailed:
		{
			_msg = @"Failed";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"AlertTitleMailShare"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		default:
		{
			_msg = @"MailShareFailed";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"AlertTitleMailShare"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
            [alert show];
            [alert release];
		}
			break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) mailShareOpenMail {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			NSLog(@"===1=");
			//_body = @"I love this song";
			[self sendMailByMFMailComposer];
		}
		else {
			NSLog(@"===2=");
			[self sendMailByDefaultApp];
		}
    }
    else {
		NSLog(@"===3=");
		[self sendMailByDefaultApp];
    }
    
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
