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

- (void)afficherBoutons {
	UIBarButtonItem *tmpLeftBarbtn = [[UIBarButtonItem alloc]
									  initWithTitle:@"NE"
									  style:UIBarButtonItemStyleBordered
									  target:self action:@selector(centrerNe:)];
	self.navigationItem.leftBarButtonItem = tmpLeftBarbtn;
	[tmpLeftBarbtn release];
	/*
	UIBarButtonItem *tmpRightBarbtn = [[UIBarButtonItem alloc] 
									   initWithTitle:NSLocalizedString(@"Actualiser", nil)
									   style:UIBarButtonSystemItemRefresh
									   target:self action:@selector(refreshEvents:)];
	self.navigationItem.rightBarButtonItem = tmpRightBarbtn;
	[tmpRightBarbtn release];
	//*/
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	delegate = ((MillenaireNEAppDelegate *)[[UIApplication sharedApplication] delegate]);
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1000ne.png"]];
	self.navigationItem.titleView = imageView;
	[imageView release];
	
	[self centrerNe:nil];
	[self refreshEvents];
}

- (void)refreshEvents:(id)sender {
	[self refreshEvents];
}

- (void)refreshEvents {
	TTNetworkRequestStarted();
	
	NSURL *urlRequest = [[NSURL alloc] initWithScheme:@"http" host:[delegate.config objectForKey:@"domain"] path:[delegate.config objectForKey:@"pathEvents"]];
	NSURLRequest *eventsRequest = [NSURLRequest requestWithURL:urlRequest];
	[urlRequest release];
	
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
	TTAlert(@"Erreur de connexion !");
	[connection release];
	TTNetworkRequestStopped();
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *jsonS = [[NSString alloc] initWithData:eventsData encoding:NSUTF8StringEncoding];
	
	NSArray * jsonA = [jsonS JSONValue];
	[jsonS release];
	
	/*
	 {
	 "id": "41",
	 "titre": "Chasse au tr\u00e9sor en ville de Neuch\u00e2tel",
	 "shortdesc": "Savez-vous quels personnages c&eacute;l&egrave;bres se sont embrass&eacute;s pour la 1&egrave;re fois sur un banc neuch&acirc;telois ? Combien d&rsquo;instruments de mesure y a-t-il sur la colonne m&eacute;t&eacute;o ? Sur quel b&acirc;timent trouve-t-on un gnome sculpt&eacute; ? Et un diablotin ?",
	 "begindate": "2011-04-24 00:00:00",
	 "enddate": "2011-09-25 00:00:00",
	 "thumb": null,
	 "lat": null,
	 "lng": null,
	 "regard": "identit\u00e9"
	 }
	 */
	
	for (int i = 0; i < [jsonA count]; i++) {
		Event *tmpEvenement = [[Event alloc] init];
		
		NSDictionary *jsonO = [jsonA objectAtIndex:i];
		
		NSLog(@"%@", [jsonO description]);
		
		NSLog(@"id");
		tmpEvenement.idE = (NSInteger *)[[jsonO objectForKey:@"id"] integerValue];
		NSLog(@"titre");
		tmpEvenement.titre = [jsonO objectForKey:@"titre"];
		NSLog(@"shortdesc");
		if([[jsonO objectForKey:@"shortdesc"] class] != [NSNull class])
			tmpEvenement.shortdesc = [jsonO objectForKey:@"shortdesc"];
		tmpEvenement.regard = [jsonO objectForKey:@"regard"];
		
		//tmpEvenement.beginDate = [NSDate dateWithTimeIntervalSince1970:[[jsonO objectForKey:@"begindate"] intValue]];
		//tmpEvenement.endDate = [NSDate dateWithTimeIntervalSince1970:[[jsonO objectForKey:@"enddate"] intValue]];
		
		//Image
		
		NSLog(@"thumb");
		if ([[jsonO objectForKey:@"thumb"] class] != [NSNull class] /*|| [jsonO objectForKey:@"thumb"] != nil*/) {
			tmpEvenement.thumb = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonO objectForKey:@"thumb"]]]];
		}
		else {
			if(tmpEvenement.regard !=nil && tmpEvenement.regard != REGARD_NONLABELISE)
				tmpEvenement.thumb = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", tmpEvenement.regard]];
			else
				tmpEvenement.thumb = nil;
		}
		
		NSLog(@"latlng");
		if([[jsonO objectForKey:@"lat"] class] != [NSNull class] && [[jsonO objectForKey:@"lng"] class] != [NSNull class]) {
			//if([jsonO objectForKey:@"lat"] != @"0.000000" && [jsonO objectForKey:@"lng"] != @"0.000000") {
				tmpEvenement.coordinate = (CLLocationCoordinate2D){[[jsonO objectForKey:@"lat"] doubleValue], [[jsonO objectForKey:@"lng"] doubleValue]};
			//}
		}
		
		[eventsMap addAnnotation:tmpEvenement];
		[tmpEvenement release];
		
	}
	
	[spinner stopAnimating];
	eventsMap.hidden = NO;
	[self afficherBoutons];
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
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.canShowCallout = YES;
		pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		return pinView;
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control { 
	
	Event *ann=view.annotation;
	NSLog(@"%@ A été séléctionné !", ann.titre);
	
	DetailsViewController *dvc = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
	
	((MillenaireNEAppDelegate *)[UIApplication sharedApplication].delegate).currentLocation = eventsMap.userLocation.location;
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
