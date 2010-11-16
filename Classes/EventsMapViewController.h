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
#import "MillenaireNEAppDelegate.h"
#import "Event.h"

#import <Three20/Three20.h>


@interface EventsMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
	IBOutlet MKMapView *eventsMap;
	NSMutableData *eventsData;
}

- (void)refreshEvents:(id)sender;
- (void)refreshEvents;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@property (retain) MKMapView *eventsMap;

@end