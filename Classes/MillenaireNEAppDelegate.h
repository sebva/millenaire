//
//  MillenaireNEAppDelegate.h
//  MillenaireNE
//
//  Created by ServiceInformatique on 28.09.10.
//  Copyright CPLN 2010. All rights reserved.
//

@interface MillenaireNEAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	NSDictionary *config;
	CLLocation *currentLocation;
}

@property (nonatomic, retain) NSDictionary *config;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) CLLocation *currentLocation;

@end

