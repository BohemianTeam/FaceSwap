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
        self.bannerView.hidden = YES;
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
        case 0://email
            [self mailShareOpenMail];
            break;
        case 1://facebook
            
            break;
        case 2://twitter
            
            break;
        case 3://remove watermark
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Twitter sharing


#pragma mark -
#pragma mark Mail Share

- (void) sendMailByDefaultApp {
    NSLog(@"send mail");
    NSString *mailTo = @"trinhduchung266@gmail.com";
    NSString *cc = @"";
    NSString *subject = @"I want to request new city";
    NSString *body = @"";
    NSString *email = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
					   mailTo,cc,subject,body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void) sendMailByMFMailComposer {
    NSLog(@"send mail");
    NSString *mailTo = @"trinhduchung266@gmail.com";
    NSString *cc = @"";
    NSString *subject = @"Share Image";
    NSString *body = @"";
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:subject];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
