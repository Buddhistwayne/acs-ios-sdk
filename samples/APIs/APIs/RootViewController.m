//
//  RootViewController.m
//  APIs
//
//  Created by Wei Kong on 3/18/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "RootViewController.h"
#import "Cocoafish.h"
#import "LoginViewController.h"
#import "APIViewController.h"
#import "AlertPrompt.h"
#import "APIsAppDelegate.h"
#import "PhotoAddViewController.h"

@interface RootViewController ()

-(Boolean)checkTestPlace;
-(Boolean)checkTestPhoto;
-(Boolean)checkTestEvent;
-(Boolean)checkTestMessage;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_ccNetworkManager) {
        _ccNetworkManager = [[CCNetworkManager alloc] initWithDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[Cocoafish defaultCocoafish] getCurrentUser]) {
        // not logged in yet, show the login/signup window
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:NO];
        [controller release];
    } else {
        UIBarButtonItem *button;
        
		// create the logout button	
		button = [[UIBarButtonItem alloc] initWithTitle:@"Delete Account" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAccount)];
		self.navigationItem.rightBarButtonItem = button;
		[button release];
		
        button = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(startLogout)];
        self.navigationItem.leftBarButtonItem = button;
		[button release];
		
    }
    testPlace = ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPlace;
    testPhoto = ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPhoto;
    testEvent = ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testEvent;
    testMessage = ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testMessage;
    if (!testPlace) {
        // remove test place from last run
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *test_place_id = [prefs stringForKey:@"test_place_id"];
        if (test_place_id) {
            [_ccNetworkManager deletePlace:test_place_id];
            [prefs removeObjectForKey:@"test_place_id"];
        }
    }

    [self.tableView reloadData];
}

-(void)startLogout
{
    if (testPlace) {
        [_ccNetworkManager deletePlace:testPlace.objectId];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"test_place_id"];
    }
    [_ccNetworkManager logout];
}

-(void)deleteAccount
{
    if (testPlace) {
        [_ccNetworkManager deletePlace:testPlace.objectId];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"test_place_id"];
    }
    [_ccNetworkManager deleteUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return NUM_SECTIONS;
}

// Some actions requires a test place to be creatd first
-(Boolean)checkTestPlace
{
    if (!testPlace) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Missing test place" 
                              message:@"Please goto Places section and create a test place first!"
                              delegate:self 
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
    
}

// Some actions requires a test place to be creatd first
-(Boolean)checkTestPhoto
{
    Boolean ret = YES;
    if (ret && !testPhoto) {
        ret = NO;
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Missing test photo" 
                              message:@"Please goto Photos section and upload a photo to user first!"
                              delegate:self 
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return ret;
    
}

// Some actions requires a test place to be creatd first
-(Boolean)checkTestEvent
{
    Boolean ret = YES;
    if (ret && !testEvent) {
        ret = NO;
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Missing test event" 
                              message:@"Please goto Events section and create a test event first!"
                              delegate:self 
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return ret;
    
}

// Some actions requires a test place to be creatd first
-(Boolean)checkTestMessage
{
    Boolean ret = YES;
    if (ret && !testMessage) {
        ret = NO;
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Missing test message" 
                              message:@"Please goto Messages section and send a test message first!"
                              delegate:self 
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return ret;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case USERS: 
            return 5;
        case PLACES:
            return 4;
        case CHECKINS:
            return 3;
        case STATUSES:
            return 2;
        case MESSAGES:
            return 7;
        case PHOTOS:
            return 6;
        case KEY_VALUES:
            return 4;
        case EVENTS:
            return 4;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case USERS:
            return @"Users";
        case PLACES:
            return @"Places";
        case CHECKINS:
            return @"Checkins";
        case STATUSES:
            return @"Statuses";
        case MESSAGES:
            return @"Messages";
        case PHOTOS:
            return @"Photoes";
        case KEY_VALUES:
            return @"Key/Value Pairs";
        case EVENTS:
            return @"Events";
        default:
            break;
    }
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    switch (indexPath.section) {
        case USERS:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Show user profile";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Show current user profile";
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Update current user profile";
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"Search users";
            } else {
                if ([[Cocoafish defaultCocoafish] getCurrentUser].facebookAccessToken != nil) {
                    cell.textLabel.text = @"Unlink from Facebook";
                } else {
                    cell.textLabel.text = @"Link to Facebook";
                }
            }
            break;
        case PLACES:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Search places";
                    break;
                case 1:
                    cell.textLabel.text = @"Show the test place";
                    break;
                case 2:
                    if (testPlace) {
                        cell.textLabel.text = @"Delete the test place";
                    } else {
                        cell.textLabel.text = @"Create a test place";
                    }
                    break;
                case 3:
                default:
                    cell.textLabel.text = @"Update the test place";
                    break;
                
            }
            break;
        case CHECKINS:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Check into a place";
                    break;
                case 1: 
                    cell.textLabel.text = @"List checkins of a place";
                    break;
                case 2:
                default:
                    cell.textLabel.text = @"List a user's checkins";
                    break;
                    break;
            }
            break;
        case STATUSES:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Create Status";
                    break;
                case 1:
                default:
                    cell.textLabel.text = @"Show a user's statuses";
                    break;
            }
            break;
        case MESSAGES:
            switch (indexPath.row) {
                case 0:
                    if (!testMessage) {
                        cell.textLabel.text = @"Send a test message";
                    } else {
                        cell.textLabel.text = @"Delete the test message";
                    }
                    break;
                case 1:
                    cell.textLabel.text = @"Reply to a message";
                    break;
                case 2:
                    cell.textLabel.text = @"Show a message";
                    break;
                case 3:
                    cell.textLabel.text = @"Show Inbox Messages";
                    break;
                case 4:
                    cell.textLabel.text = @"Show Sent Messages";
                    break;
                case 5:
                    cell.textLabel.text = @"Show Message Threads";
                    break;
                case 6:
                default:
                    cell.textLabel.text = @"Show Messages in a Thread";
                    break;
            }
            
            break;
        case PHOTOS:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Upload a place photo";
                    break;
                case 1:
                    cell.textLabel.text = @"Show photos of a place";
                    break;
                case 2:
                    cell.textLabel.text = @"upload a user photo";
                    break;
                case 3:
                    cell.textLabel.text = @"Show a photo";
                    break;
                case 4:
                    cell.textLabel.text = @"Show photos of a user";
                    break;
                case 5:
                default:
                    cell.textLabel.text = @"Delete a photo";
                    break;
            }
            break;
        case KEY_VALUES:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Set Value for Key('Test')";
                    break;
                case 1:
                    cell.textLabel.text = @"Get Value of key('Test')";
                    break;
                case 2:
                    cell.textLabel.text = @"Append value of key('Test')";
                    break;
                case 3:
                default:
                    cell.textLabel.text = @"Delete a key/value('Test')";
                    break;
                }
                
            break;
        case EVENTS:
            switch (indexPath.row) {
                case 0:
                    if (!testEvent) {
                        cell.textLabel.text = @"Create a test event";
                    } else {
                        cell.textLabel.text = @"Delete the test event";
                    }
                    break;
                case 1:
                    cell.textLabel.text = @"Get an event";
                    break;
                case 2:
                    cell.textLabel.text = @"Update an event";
                    break;
                case 3:
                default:
                    cell.textLabel.text = @"Search events";
                    break;
            }
            
            break;
        default:
            break;
    }
    // Configure the cell.
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/

    AlertPrompt *prompt;
    APIViewController *controller = [[APIViewController alloc] initWithNibName:@"APIViewController" bundle:nil];  
    CCPlace *newPlace;
    CheckinViewController *checkinController;
    PhotoAddViewController *photoController;
    UIAlertView *alert;
    CCRequest *request = nil;
    switch (indexPath.section) {
        case USERS:
            if (indexPath.row == 0) {
                // show user profile
                [controller.ccNetworkManager showUser:[[Cocoafish defaultCocoafish] getCurrentUser].objectId];
            } else if (indexPath.row == 1) {
                // show current user profile
                [controller.ccNetworkManager showCurrentUser];
            } else if (indexPath.row == 2) {
                // update user
                prompt = [AlertPrompt alloc];
                prompt = [prompt initWithTitle:@"Update User Email" message:@"Please enter your email" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:[[Cocoafish defaultCocoafish] getCurrentUser].email];
                lastIndexPath = [indexPath copy];
                [prompt show];
                [prompt release];
                [controller release];
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;

            } else if (indexPath.row == 3) {
                [controller.ccNetworkManager searchUsers:[[Cocoafish defaultCocoafish] getCurrentUser].firstName page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
            } else {
                if ([[Cocoafish defaultCocoafish] getFacebook] == nil) {
                    // check if a facebook id is provided
                    alert = [[UIAlertView alloc] 
                                          initWithTitle:@"Error" 
                                          message:@"Please initialize Cocoafish with a valid facebook id first!"
                                          delegate:self 
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                } else if ([[Cocoafish defaultCocoafish] getCurrentUser].facebookAccessToken == nil) {
                    // link with facebook
                    [[Cocoafish defaultCocoafish] facebookAuth:[NSArray arrayWithObjects:@"publish_stream", @"email", @"offline_access", nil] delegate:self];
                } else {
                    // unlink rom facebook
                    NSError *error;
                    [[Cocoafish defaultCocoafish] unlinkFromFacebook:&error];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

                return;
            }
            break;
        case PLACES:
            switch (indexPath.row) {

                case 0:
                    // show all places
                    [controller.ccNetworkManager searchPlaces:@"Cocoafish"
                        location:[[[CLLocation alloc] initWithLatitude:37.743961 longitude:-122.42202] autorelease] 
                        distance:[NSNumber numberWithDouble:5.0] page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
                case 1:
                    // show the test place
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager showPlace:testPlace.objectId];
                    break;
                case 2:
                    if (testPlace) {
                        // delete the test place
                        [controller.ccNetworkManager deletePlace:testPlace.objectId];
                    } else {
                        // create a test place
                        newPlace = [[CCPlace alloc] init];
                        newPlace.name = @"Cocoafish";
                        newPlace.address = @"58 South Park Ave.";
                        newPlace.city = @"San Francisco";
                        newPlace.state = @"California";
                        newPlace.postalCode = @"94107-1807";
                        newPlace.country = @"United States";
                        newPlace.website = @"http://cocoafish.com";
                        newPlace.twitter = @"cocoafish";
                        newPlace.location = [[CLLocation alloc] initWithLatitude:37.782227 longitude:-122.393159];
                        [controller.ccNetworkManager createPlace:newPlace image:[[[CCUploadImage alloc] initWithImage:[UIImage imageNamed:@"sample.png"]] autorelease]];
                        
                    }
                    break;
                case 3:
                default:
                    // update the test place
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    prompt = [AlertPrompt alloc];
                    prompt = [prompt initWithTitle:@"Change Place Name" message:@"Please enter new place name" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:testPlace.name];
                    lastIndexPath = [indexPath copy];
                    [prompt show];
                    [prompt release];
                    [controller release];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                    return;
                    break;
                    
            }
            break;
        case CHECKINS:
            switch (indexPath.row) {
                case 0:
                    // checkins require a test place to be created first
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    // check in to the test place
                    checkinController = [[CheckinViewController alloc] initWithNibName:@"CheckinViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:checkinController  animated:YES];
                    [checkinController release];
                    return;
                    break;
                case 1: 
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    // get checkins of a place
                    [controller.ccNetworkManager searchCheckins:testPlace page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
                case 2:
                default:
                    // show a user's checkins
                     [controller.ccNetworkManager searchCheckins:[[Cocoafish defaultCocoafish] getCurrentUser] page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
            }
            break;
        case STATUSES:
            switch (indexPath.row) {
                case 0:
                    // create a new user status
                    prompt = [AlertPrompt alloc];
                    prompt = [prompt initWithTitle:@"New Status" message:@"Please enter your status" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:@"Feeling good!"];
                    lastIndexPath = [indexPath copy];
                    [prompt show];
                    [prompt release];
                    [controller release];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                    
                    return;

                    break;
                case 1:
                default:
                    // get a user's statuses
                    request = [Cocoafish restRequest:controller httpMethod:@"GET" baseUrl:@"statuses/search.json" paramDict:[NSDictionary dictionaryWithObjectsAndKeys:[[Cocoafish defaultCocoafish] getCurrentUser].objectId, @"user_id", [NSDate distantPast], @"start_time", nil]  attachment:nil];
                    break;
            }
            break;
        case PHOTOS:
            
            switch (indexPath.row) {
                case 0:
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    // Add a photo to a place
                    photoController = [[PhotoAddViewController alloc] initWithNibName:@"PhotoAddViewController" bundle:nil];
                    photoController.object = testPlace;
                    [self.navigationController pushViewController:photoController  animated:YES];
                    [photoController release];
                    return;
                    break;
                case 1:
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    // get Photos of a place
                    [controller.ccNetworkManager searchPhotos:testPlace collectionName:nil page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
                case 2:
                    // add a photo to a user
                    photoController = [[PhotoAddViewController alloc] initWithNibName:@"PhotoAddViewController" bundle:nil];
                    photoController.object = [[Cocoafish defaultCocoafish] getCurrentUser];
                    [self.navigationController pushViewController:photoController  animated:YES];
                    [photoController release];
                    return;
                    break;
                case 3:
                    // show a test photo
                    if (![self checkTestPhoto]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager showPhoto:testPhoto.objectId];
                    break;
                case 4:
                    // show photos of a user
                    [controller.ccNetworkManager searchPhotos:[[Cocoafish defaultCocoafish] getCurrentUser] collectionName:nil page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
                case 5:
                default:
                    // delete a photo
                    if (![self checkTestPhoto]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager deletePhoto:testPhoto.objectId];
                    break;
            }
            break;
        case KEY_VALUES:
            switch (indexPath.row) {
                case 0:
                    prompt = [AlertPrompt alloc];
                    prompt = [prompt initWithTitle:@"Enter a value for key 'Test'" message:@"Please enter a Value for Key 'Test'" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:@"Awesome!"];
                    lastIndexPath = [indexPath copy];
                    [prompt show];
                    [prompt release];
                    [controller release];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                
                    return;
                    break;
                case 1:
                    [controller.ccNetworkManager getValueForKey:@"Test"];
                    break;
                case 2:
                    prompt = [AlertPrompt alloc];
                    prompt = [prompt initWithTitle:@"Enter a value to append for key 'Test'" message:@"Please enter a Value to append for Key 'Test'" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:@"More awesomeness!"];
                    lastIndexPath = [indexPath copy];
                    [prompt show];
                    [prompt release];
                    [controller release];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                    
                    return;
                    break;
                case 3:
                default:
                    [controller.ccNetworkManager deleteKeyValue:@"Test"];
                    break;
            }
            break;
        case MESSAGES:
            switch (indexPath.row) {
                case 0:
                    if (!testMessage) {
                        prompt = [AlertPrompt alloc];
                        prompt = [prompt initWithTitle:@"Enter a subject for Message 'Test'" message:@"Please enter a Subject for Message 'Test'" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:@"Hello from Cocoafish"];
                        lastIndexPath = [indexPath copy];
                        [prompt show];
                        [prompt release];
                        [controller release];
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        
                        return;

                    } else {
                        [controller.ccNetworkManager deleteMessage:testMessage.objectId];
                    }
                    break;
                case 1:
                    if (![self checkTestMessage]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    prompt = [AlertPrompt alloc];
                    prompt = [prompt initWithTitle:@"Enter a reply for message" message:@"Please enter a reply message" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:@"I have received it!"];
                    lastIndexPath = [indexPath copy];
                    [prompt show];
                    [prompt release];
                    [controller release];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                    
                    return;
                    break;
                case 2:
                    if (![self checkTestMessage]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager showMessage:testMessage.objectId];
                    break;
                case 3:
                    [controller.ccNetworkManager showInboxMessages:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];

                    break;
                case 4:
                    [controller.ccNetworkManager showSentMessages:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
                case 5:
                    [controller.ccNetworkManager showMessageThreads:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
                case 6:
                default:
                    if (![self checkTestMessage]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager showThreadMessages:testMessage.threadId page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];

                    break;
            }
            
            break;
        case EVENTS:
            switch (indexPath.row) {
                case 0:
                    if (!testEvent) {
                        if (![self checkTestPlace]) {
                            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                            return;
                        }
                        [controller.ccNetworkManager createEvent:@"Cocoafish Happy Hour" details:@"Bring your own drink" placeId:testPlace.objectId startTime:[NSDate date] endTime:[NSDate dateWithTimeIntervalSinceNow:7200] image:[[[CCUploadImage alloc] initWithImage:[UIImage imageNamed:@"sample.png"]] autorelease]];
                    } else {
                        [controller.ccNetworkManager deleteEvent:testEvent.objectId];
                    }
                    break;
                case 1:
                    if (![self checkTestEvent]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager showEvent:testEvent.objectId];
                    break;
                case 2:
                    if (![self checkTestEvent]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    prompt = [AlertPrompt alloc];
                    prompt = [prompt initWithTitle:@"Enter a a new event name" message:@"Please enter a new Event name" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay" defaultInput:testEvent.name];
                    lastIndexPath = [indexPath copy];
                    [prompt show];
                    [prompt release];
                    [controller release];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                    
                    return;
                    break;
                case 3:
                default:
                    if (![self checkTestPlace]) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                        return;
                    }
                    [controller.ccNetworkManager searchEvents:testPlace page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
                    break;
            }
            
            break;
        default:
            break;
    }
    [request startAsynchronous];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [_ccNetworkManager release];
    [lastIndexPath release];
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSString *entered = [(AlertPrompt *)alertView enteredText];
        APIViewController *controller = [[APIViewController alloc] initWithNibName:@"APIViewController" bundle:nil];  
        if (lastIndexPath.section == USERS) {
            CCUser *updatedUser = [[[Cocoafish defaultCocoafish] getCurrentUser] copy];
            updatedUser.email = entered;
            [controller.ccNetworkManager updateUser:updatedUser image:[[[CCUploadImage alloc] initWithImage:[UIImage imageNamed:@"sample.png"]] autorelease]];
        } else if (lastIndexPath.section == STATUSES) {
            [controller.ccNetworkManager createUserStatus:entered image:[[[CCUploadImage alloc] initWithImage:[UIImage imageNamed:@"sample.png"]] autorelease]];
        } else if (lastIndexPath.section == KEY_VALUES){
            if (lastIndexPath.row == 0) {
                // set key value
                [controller.ccNetworkManager setValueForKey:@"Test" value:entered];
            } else {
                // append key value
                [controller.ccNetworkManager appendValueForKey:@"Test" appendValue:entered];
            }
        } else if (lastIndexPath.section == EVENTS) {
            [controller.ccNetworkManager updateEvent:testEvent.objectId name:entered details:nil placeId:nil startTime:nil endTime:nil image:[[[CCUploadImage alloc] initWithImage:[UIImage imageNamed:@"sample.png"]] autorelease]];
        } else if (lastIndexPath.section == MESSAGES) {
            if (lastIndexPath.row == 0) {
                [controller.ccNetworkManager createMessage:entered body:@"Thanks for using Cocoafish" toUserIds:[NSArray arrayWithObject:[[Cocoafish defaultCocoafish] getCurrentUser].objectId]];
            } else {
                [controller.ccNetworkManager replyMessage:testMessage.objectId body:entered];

            }
        } else {
            CCPlace *updatedPlace = [testPlace copy];
            updatedPlace.name = entered;
            [controller.ccNetworkManager updatePlace:updatedPlace image:[[[CCUploadImage alloc] initWithImage:[UIImage imageNamed:@"sample.png"]] autorelease]];
        }
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        [lastIndexPath release];
        lastIndexPath = nil;
    } 
}

#pragma - CCNetworkManager delegate
-(void)networkManager:(CCNetworkManager *)networkManager didFailWithError:(NSError *)error
{

}

// successful logout
- (void)didLogout:(CCNetworkManager *)networkManager
{	
    ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPlace = nil;
    ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testEvent = nil;
    ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPhoto = nil;
    ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testMessage = nil;
    testPlace = nil;
    testEvent = nil;
    testPhoto = nil;
    testMessage = nil;
    
	// show login window
	LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	[self.navigationController pushViewController:loginViewController animated:NO];
	[loginViewController release];
	
}

-(void)networkManager:(CCNetworkManager *)networkManager didDelete:(Class)objectType
{
    if (objectType == [CCUser class]) {
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPlace = nil;
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testEvent = nil;
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPhoto = nil;
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testMessage = nil;
        testPlace = nil;
        testEvent = nil;
        testPhoto = nil;
        testMessage = nil;
        
        // show login window
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:NO];
        [loginViewController release];
    }
}

#pragma -
#pragma mark CCFBSessionDelegate methods
-(void)fbDidLogin
{
	NSLog(@"fbDidLogin");

    [self.tableView reloadData];
    
}

-(void)fbDidNotLogin:(BOOL)cancelled error:(NSError *)error
{
	if (error == nil) {
		// user failed to login to facebook or cancelled the login
		return;
	}
	NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Failed to link with Facebook" 
						  message:msg
						  delegate:self 
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
