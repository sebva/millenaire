//
//  DetailsViewController.h
//  MillenaireNE
//
//  Created by Sébastien Vaucher on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "MillenaireNEAppDelegate.h"
#import "JSON.h"
#import <CoreLocation/CoreLocation.h>

//Three20
#import <Three20/Three20.h>
#import <Three20Core/NSStringAdditions.h>
#import <Three20UI/TTImageView.h>



@interface DetailsViewController : UIViewController {
    IBOutlet TTImageView *pbx1;
	IBOutlet UITextView *lblText;
	IBOutlet UIScrollView *scrollView;
	Event *objEvent;
	
	MillenaireNEAppDelegate *delegate;
	
	NSMutableData *detailsData;
}

- (void)naviTo:(id)sender;

@property (nonatomic, retain) Event *objEvent;

@end
