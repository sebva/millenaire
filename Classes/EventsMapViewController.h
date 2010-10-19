//
//  EventsMapViewController.h
//  MillenaireNE
//
//  Created by ServiceInformatique on 28.09.10.
//  Copyright 2010 CPLN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JSON.h"
#import "Tools.h"
#import "Event.h"


@interface EventsMapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *eventsMap;
}

@property (retain) MKMapView *eventsMap;

@end