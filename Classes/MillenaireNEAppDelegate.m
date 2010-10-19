//
//  MillenaireNEAppDelegate.m
//  MillenaireNE
//
//  Created by ServiceInformatique on 28.09.10.
//  Copyright CPLN 2010. All rights reserved.
//

#import "MillenaireNEAppDelegate.h"
#import "RootViewController.h"


@implementation MillenaireNEAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

