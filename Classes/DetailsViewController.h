//
//  DetailsViewController.h
//  MillenaireNE
//
//  Created by Sébastien Vaucher on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "JSON.h"
#import <CoreLocation/CoreLocation.h>
#import <Three20UI/TTImageView.h>


@interface DetailsViewController : UIViewController {
    TTImageView *pbx1;
	IBOutlet UILabel *lblText;
	Event *objEvent;
	
	NSMutableData *detailsData;
}

@property (nonatomic, retain) Event *objEvent;

@end
