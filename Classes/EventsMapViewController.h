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


@interface EventsMapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *eventsMap;
	NSMutableData *eventsData;
	IBOutlet UIActivityIndicatorView *spinner;
	MillenaireNEAppDelegate *delegate;
	NSDictionary* config;
}

- (void)refreshEvents:(id)sender;
- (void)refreshEvents;

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;


@property (retain) MKMapView *eventsMap;

@end