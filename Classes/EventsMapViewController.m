//
//  EventsMapViewController.m
//  MillenaireNE
//
//  Created by ServiceInformatique on 28.09.10.
//  Copyright 2010 CPLN. All rights reserved.
//

#import "EventsMapViewController.h"
#import "DetailsViewController.h"


@implementation EventsMapViewController

- (void) centrerNe:(id)sender {
	//Centrage sur Neuchâtel
	MKCoordinateRegion NEcoord;
	NEcoord.center.latitude = 46.9920060;
	NEcoord.center.longitude = 6.9309210;
	NEcoord.span.latitudeDelta = 0.0618432;
	NEcoord.span.longitudeDelta = 0.1361188;
	
	[eventsMap setRegion:NEcoord animated:TRUE];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//TODO: Update the user's location automatically
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self centrerNe:nil];
	
	UIBarButtonItem *tmpLeftBarbtn = [[UIBarButtonItem alloc]
									  initWithTitle:@"NE"
									  style:UIBarButtonItemStyleBordered
									  target:self action:@selector(centrerNe:)];
	UIBarButtonItem *tmpRightBarbtn = [[UIBarButtonItem alloc] 
									   initWithTitle:NSLocalizedString(@"Actualiser", nil)
									   style:UIBarButtonItemStyleBordered
									   target:self action:@selector(refreshEvents:)];
	
	self.navigationItem.leftBarButtonItem = tmpLeftBarbtn;
	self.navigationItem.rightBarButtonItem = tmpRightBarbtn;
	
	
	[tmpLeftBarbtn release];
	[tmpRightBarbtn release];
	
	[self refreshEvents];
}

- (void)refreshEvents:(id)sender {
	[self refreshEvents];
}

- (void)refreshEvents {
	TTNetworkRequestStarted();
	
	NSURLRequest *eventsRequest = [NSURLRequest requestWithURL:
								   [NSURL URLWithString:
									[NSString stringWithFormat:@"http://%@/devios/test.json",
									 ((MillenaireNEAppDelegate *)[[UIApplication sharedApplication] delegate]).servDomain]]];
	eventsData = [[NSMutableData alloc] init];
	NSURLConnection *eventsUrlConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
	if(eventsUrlConnection) {
		//Ça va démarrer !
	}
	else {
		//Ça marche pas :(
		[eventsData release];
		TTNetworkRequestStopped();
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//En-tête reçu
	[eventsData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
	[eventsData appendData:someData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//La connexion a rencontré une erreur
	
	
	[connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *jsonS = [[NSString alloc] initWithData:eventsData encoding:NSUTF8StringEncoding];
	
	NSArray * jsonA = [jsonS JSONValue];
	[jsonS release];
	
	for (int i = 0; i < [jsonA count]; i++) {
		Event *tmpEvenement = [[Event alloc] init];
		
		NSDictionary *jsonO = [jsonA objectAtIndex:i];
		
		NSLog(@"%@", [jsonO description]);
		
		
		NSDictionary *loc=[jsonO objectForKey:@"loc"];
		tmpEvenement.idE = (NSInteger *)[[jsonO objectForKey:@"id"] integerValue];
		tmpEvenement.titre = [jsonO objectForKey:@"titre"];
		tmpEvenement.shortdesc = [jsonO objectForKey:@"shortdesc"];
		
		tmpEvenement.beginDate = [NSDate dateWithTimeIntervalSince1970:[[jsonO objectForKey:@"begindate"] intValue]];
		tmpEvenement.endDate = [NSDate dateWithTimeIntervalSince1970:[[jsonO objectForKey:@"enddate"] intValue]];
		
		//Image
		
		if ([jsonO objectForKey:@"thumb"] != nil) {
			tmpEvenement.thumb = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonO objectForKey:@"thumb"]]]];
		}
		else {
			tmpEvenement.thumb = nil;
		}
		
		CLLocationCoordinate2D coord = {[[loc objectForKey:@"lat"] doubleValue], [[loc objectForKey:@"lng"] doubleValue]};
		tmpEvenement.coordinate = coord;
		
		[eventsMap addAnnotation:tmpEvenement];
		[tmpEvenement release];
		
	}
	
	TTNetworkRequestStopped();
	
	//Cette ligne doit être éxécutée à la fin des traitements
	[eventsData release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	
	if(annotation == mapView.userLocation) { return nil; }
	
	MKAnnotationView *annotationView = nil;
	
	annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"eventIdentifier"];
	if(nil == annotationView) {
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"eventIdentifier"];
	}
	
	UIImage *thumb = ((Event *)annotation).thumb;
	
	if(thumb!=nil) {	
		annotationView.image = thumb;
		annotationView.canShowCallout = YES;
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		return annotationView;
	}
	else {
		NSLog(@"Pas d'image pour %@", ((Event *)annotationView.annotation).titre);
		MKPinAnnotationView * pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"eventIdentifier"];
		//TODO : utiliser une image par défaut
		pinView.pinColor = MKPinAnnotationColorPurple;
		pinView.canShowCallout = YES;
		pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		return pinView;
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control { 
	
	Event *ann=view.annotation;
	NSLog(@"%@ A été séléctionné !", ann.title);
	
	DetailsViewController *dvc = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
	
	dvc.objEvent = ann;
	[self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//Sur iPhone: tout sauf upsideDown; Sur iPad: tout
	return TTIsSupportedOrientation(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[eventsMap release];
	[super dealloc];
}

@synthesize eventsMap;

@end
