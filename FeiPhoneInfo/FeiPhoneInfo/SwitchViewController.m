//
//  SwitchViewController.m
//  FeiPhoneInfo
//
//  Created by hongkai.qian on 11-9-26.
//  Copyright 2011年 TTPod. All rights reserved.
//

#import "SwitchViewController.h"
#import "GeneralViewController.h"
#import "TaskViewController.h"
#import "ProfilesViewController.h"
#import "NetworkViewController.h"
#import "CameraViewController.h"
#import "HardwareViewController.h"
#import "AboutViewController.h"

@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)init
{
	[super init];
	
	if (self)
	{

	}
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	
	CGRect rect = [[UIScreen mainScreen] bounds];
	CGRect rectbottom = CGRectMake(0, rect.size.height - 20 - 44, rect.size.width, 44);
	
	tabBar = [[UITabBar alloc] initWithFrame:rectbottom];
	tabBarItem0 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"General", @"for general info") image:[UIImage imageNamed:@"generalinfo.png"] tag:100];
	tabBarItem1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Tasks", @"for phone tasks") image:[UIImage imageNamed:@"tasks.png"] tag:101];
	tabBarItem2 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profiles", @"for phone profiles") image:[UIImage imageNamed:@"profiles.png"] tag:102];
//	tabBarItem3 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Network", @"for phone network") image:[UIImage imageNamed:@"network.png"] tag:103];
//	tabBarItem4 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Camera", @"for camera") image:[UIImage imageNamed:@"Camera.png"] tag:104];
	tabBarItem5 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Hardware", @"for hardware text") image:[UIImage imageNamed:@"hardware.png"] tag:105];
	tabBarItem6 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"About", @"for about prompt") image:[UIImage imageNamed:@"about.png"] tag:106];
	NSArray* array = [NSArray arrayWithObjects:tabBarItem0,tabBarItem1,tabBarItem2/*,tabBarItem3*//*,tabBarItem4*/, tabBarItem5,tabBarItem6, nil];
	[tabBar setItems:array animated:YES];
	[tabBar setDelegate:self];
	[self.view addSubview:tabBar];
	
	generalController = [[GeneralViewController alloc] initWithStyle:UITableViewStylePlain];
	taskController = [[TaskViewController alloc] initWithStyle:UITableViewStylePlain];
	profilesController = [[ProfilesViewController alloc] initWithStyle:UITableViewStylePlain];
//	networkController = [[NetworkViewController alloc] initWithStyle:UITableViewStylePlain];
//	cameraController = [[CameraViewController alloc] initWithStyle:UITableViewStylePlain];
	hardwareController = [[HardwareViewController alloc] initWithStyle:UITableViewStylePlain];
	aboutController = [[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped];

	[self.view addSubview:generalController.view];
	[self.view addSubview:taskController.view];
	[self.view addSubview:profilesController.view];
//	[self.view addSubview:networkController.view];
//	[self.view addSubview:cameraController.view];
	[self.view addSubview:hardwareController.view];
	[self.view addSubview:aboutController.view];
	
	tabBar.selectedItem = tabBarItem0;
	[self.view bringSubviewToFront:generalController.view];
}

- (void)dealloc
{
	[generalController release];
	[taskController release];
	[profilesController release];
	[networkController release];
	[cameraController release];
	[hardwareController release];
	[aboutController release];
	
	[tabBarItem0 release];
	[tabBarItem1 release];
	[tabBarItem2 release];
	[tabBarItem3 release];
	[tabBarItem4 release];
	[tabBarItem5 release];
	[tabBarItem6 release];
	[tabBar release];
	[imgView release];
	[bkgView release];
	
	[super dealloc];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGRect rect = [[UIScreen mainScreen] bounds];
	CGRect rectbottom;
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
	{
		rectbottom = CGRectMake(0, rect.size.height - 20 - 44, rect.size.width, 44);
	}
	else
	{
		rectbottom = CGRectMake(0, rect.size.width - 20 - 44, rect.size.height, 44);
	}
	[tabBar setFrame:rectbottom];
	
	[aboutController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	switch (item.tag)
	{
		case 100:
			[self.view bringSubviewToFront:generalController.view];
			break;
			
		case 101:
			[self.view bringSubviewToFront:taskController.view];
			break;
			
		case 102:
			[self.view bringSubviewToFront:profilesController.view];
			break;
			
		case 103:
			[self.view bringSubviewToFront:networkController.view];
			break;
			
		case 104:
			[self.view bringSubviewToFront:cameraController.view];
			break;
			
		case 105:
			[self.view bringSubviewToFront:hardwareController.view];
			break;
			
		case 106:
			[self.view bringSubviewToFront:aboutController.view];
			break;
			
		default:
			break;
	}
}

@end
