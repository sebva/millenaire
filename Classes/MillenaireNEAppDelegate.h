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
	NSString *servDomain;
}

@property (nonatomic, retain) NSString *servDomain;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

