//
//  DetailsViewController.m
//  MillenaireNE
//
//  Created by Sébastien Vaucher on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"
#import <CoreLocation/CoreLocation.h>


@implementation DetailsViewController

@synthesize objEvent;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.objEvent.titre;
	pbx1.image = objEvent.thumb;
	
	UIBarButtonItem *tmpRightBarbtn = [[UIBarButtonItem alloc] initWithTitle:@"Navi" style:UIBarButtonItemStyleBordered target:self action:@selector(naviTo:)];
	
	self.navigationItem.rightBarButtonItem = tmpRightBarbtn;
	[tmpRightBarbtn release];
	
	
}

- (void)naviTo:(id)sender {
	
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
	
		///*
	CLLocationCoordinate2D currLoc; 
	CLLocation *cll = [[CLLocation alloc] init];
	currLoc = cll.coordinate;
	
	[cll release];
	
	NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f+(%@)&daddr=%f,%f+(%@)&hl=%@",
					 currLoc.latitude, currLoc.longitude, @"Ma position",
					 objEvent.coordinate.latitude, objEvent.coordinate.longitude, objEvent.titre,
					 [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
	
	NSLog(url);
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
		//[url release];
		//*/
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[objEvent release];
    [super dealloc];
}


@end
