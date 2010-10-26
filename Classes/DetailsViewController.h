//
//  DetailsViewController.h
//  MillenaireNE
//
//  Created by Sébastien Vaucher on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@interface DetailsViewController : UIViewController {
    IBOutlet UIImageView *pbx1;
	IBOutlet UILabel *lblText;
	Event *objEvent;
}

@property (nonatomic, retain) Event *objEvent;

@end
