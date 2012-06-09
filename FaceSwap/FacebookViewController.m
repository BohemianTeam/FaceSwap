//
//  FacebookViewController.m
//  Bars
//
//  Created by Trinh Hung on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"
#import "AppDelegate.h"
#import "Util.h"

#define Alert_Open_Url_Tag      100001
@interface FacebookViewController ()

@end

@implementation FacebookViewController
@synthesize permissions = _permissions;
@synthesize delegate = _delegate;
@synthesize facebook = _facebook;

- (void) dealloc {
    [_permissions release];
    
    [_photoTag release];
    [mainMenuItems release];
    [menuTableView release];
    [headerView release];
    [nameLabel release];
    [profilePhotoImageView release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
         _permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        delegate.facebook.sessionDelegate = self;
        _facebook = [delegate facebook];
        _facebook.sessionDelegate = self;

    }
    return self;
}

#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
//    [Util showLoading:@"Feeding ..." view:self.view];
    [Util showLoading:@"Feeding ..." view:self.view];
    _fbRequest = FBFeedInfo;
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [_facebook requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    NSLog(@"me/permissions");
    _fbRequest = FBFeedMe;
    [_facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}


#pragma - Private Helper Methods

/**
 * Show the logged in menu
 */

- (void)showLoggedIn {
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [self apiFQLIMe];
}

/**
 * Show the logged in menu
 */

- (void)showLoggedOut {
    // Clear personal info
    nameLabel.text = @"";
    // Get the profile image
    [profilePhotoImageView setImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    if (![_facebook isSessionValid]) {
        [_facebook authorize:_permissions];
    } else {
        [self showLoggedIn];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    [_facebook logout];
}


#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate didUploadToFacebookSuccess];
}
 
#pragma mark - ViewController life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Facebook";
    mainMenuItems = [[NSMutableArray alloc] initWithObjects:@"Profile",@"Upload to Facebook", nil];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    
    // Main Menu Table
    menuTableView = [[UITableView alloc] initWithFrame:self.view.bounds                                                 style:UITableViewStyleGrouped];
    [menuTableView setBackgroundColor:[UIColor whiteColor]];
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTableView.autoresizingMask =  (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    menuTableView.dataSource = self;
    menuTableView.delegate = self;
    menuTableView.hidden = NO;
    // Table header
    headerView = [[UIView alloc]
                  initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    headerView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    headerView.backgroundColor = [UIColor clearColor];
    CGFloat xProfilePhotoOffset = self.view.center.x - 25.0;
    profilePhotoImageView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(xProfilePhotoOffset, 20, 50, 50)];
    profilePhotoImageView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [headerView addSubview:profilePhotoImageView];
    nameLabel = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 20.0)];
    nameLabel.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    nameLabel.textAlignment = UITextAlignmentCenter;
    nameLabel.text = @"";
    nameLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:nameLabel];

    [self.view addSubview:menuTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObject:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObject:UIKeyboardDidHideNotification];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _fbRequest = FBRequestNone;
    if (![_facebook isSessionValid]) {
        [self login];
    } else {
        [self showLoggedIn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
#pragma mark - NSNotificationCenter methods
- (void)keyboardDidShow {
    menuTableView.contentInset =  UIEdgeInsetsMake(0, 0, self.view.frame.size.height / 2, 0);
    [menuTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)keyboardDidHide {
    menuTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UITableViewDatasource and UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    if (indexPath.row == 0) {
        if (section == 0) {
            return 100;  
        } else if (section == 1) {
            return 180;
        }
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return 41.0;
    }
    return 60.0;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [mainMenuItems count];
    } else {
        return 3;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell addSubview:headerView];
        } else if (indexPath.row == 1) {
            //create the button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(20, 5, (cell.contentView.frame.size.width - 40), 44);
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            [button setBackgroundImage:[[UIImage imageNamed:@"MenuButton.png"]
                                        stretchableImageWithLeftCapWidth:9 topCapHeight:9]
                              forState:UIControlStateNormal];
            [button setTitle:@"LogOut"
                    forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = indexPath.section;
            [cell.contentView addSubview:button];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *name = [[UILabel alloc]
                             initWithFrame:CGRectMake(0, 155, self.view.bounds.size.width, 20.0)];
            name.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            name.textAlignment = UITextAlignmentCenter;
            name.text = @"Image to upload";
            name.backgroundColor = [UIColor clearColor];
            [cell addSubview:name];
            [name release];
            
            CGFloat xProfilePhotoOffset = self.view.center.x - 150.0 / 2;
            UIImageView* profilePhoto = [[UIImageView alloc]
                                         initWithFrame:CGRectMake(xProfilePhotoOffset, 5, 150, 150)];
            profilePhoto.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            profilePhoto.backgroundColor = [UIColor clearColor];
            [profilePhoto setImage:_currentImage];
            [cell addSubview:profilePhoto];
            [profilePhoto release];
        } else if (indexPath.row == 1) {
            _photoTag = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 320 - 40, 31)];
            _photoTag.delegate = self;
            _photoTag.placeholder = @"tag";
            _photoTag.backgroundColor = [UIColor clearColor];
            _photoTag.borderStyle = UITextBorderStyleRoundedRect;
            
            [cell addSubview:_photoTag];
        } else if (indexPath.row == 2) {
            //create the button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(20, 5, (cell.contentView.frame.size.width - 40), 44);
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            [button setBackgroundImage:[[UIImage imageNamed:@"MenuButton.png"]
                                        stretchableImageWithLeftCapWidth:9 topCapHeight:9]
                              forState:UIControlStateNormal];
            [button setTitle:[mainMenuItems objectAtIndex:indexPath.section]
                        forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = indexPath.section;
            [cell.contentView addSubview:button];
        }
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [mainMenuItems objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_photoTag resignFirstResponder];
    return YES;
}

#pragma mark - Public Methods
- (void) setImage:(UIImage *)img withMessage:(NSString *)msg {
    _currentImage = [img retain];
}

#pragma mark - Private Methods
- (void) apiGraphUserPhotosPost {
    [Util showLoading:@"Uploading ..." view:self.view];
    _fbRequest = FBUpload;
    NSString *tag = @"tag";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _currentImage, @"picture",
                                   tag,@"message",
                                   nil];

    [_facebook requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}
- (void) menuButtonClicked: (id) sender {
    [_photoTag resignFirstResponder];
    switch ([sender tag]) {
        case 0:
            [self logout];
            break;
        case 1:
            [self apiGraphUserPhotosPost];
            break;
        default:
            break;
    }
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    NSLog(@"fbDIdLogin");
    [self showLoggedIn];
    
    [self storeAuthData:[_facebook accessToken] expiresAt:[_facebook expirationDate]];

}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"%@",@"facebook did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"request did load");
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if (_fbRequest == FBFeedInfo) {
        // This callback can be a result of getting the user's basic
        // information or getting the user's permissions.
        if ([result objectForKey:@"name"]) {
            NSLog(@"Display info");
            // If basic information callback, set the UI objects to
            // display this.
            nameLabel.text = [result objectForKey:@"name"];
            // Get the profile image
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
            
            // Resize, crop the image to make sure it is square and renders
            // well on Retina display
            float ratio;
            float delta;
            float px = 100; // Double the pixels of the UIImageView (to render on Retina)
            CGPoint offset;
            CGSize size = image.size;
            if (size.width > size.height) {
                ratio = px / size.width;
                delta = (ratio * size.width - ratio * size.height);
                offset = CGPointMake(delta / 2, 0);
            } else {
                ratio = px / size.height;
                delta = (ratio * size.height - ratio * size.width);
                offset = CGPointMake(0, delta / 2);
            }
            CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                         (ratio * size.width) + delta,
                                         (ratio * size.height) + delta);
            UIGraphicsBeginImageContext(CGSizeMake(px, px));
            UIRectClip(clipRect);
            [image drawInRect:clipRect];
            UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [profilePhotoImageView setImage:imgThumb];
            
            [self apiGraphUserPermissions];
        } else {
            
            // Processing permissions information
            AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
        }
    } else if (_fbRequest == FBUpload) {
        [Util hideLoading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Photo uploaded successfully."
                                                       delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else if (_fbRequest == FBFeedMe) {
        [Util hideLoading];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
    [Util hideLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
