//
//  DetailsViewController.m
//  MillenaireNE
//
//  Created by Sébastien Vaucher on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"
#import <CoreLocation/CoreLocation.h>


@implementation DetailsViewController

@synthesize objEvent;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//On récupère la grande image
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	/*
	NSURLRequest *eventsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:
																[NSString stringWithFormat:@"http://vaucher.homeip.net/devios/details.php?id=%i", objEvent.idE]]];
	eventsData = [[NSMutableData alloc] init];
	NSURLConnection *eventsUrlConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
	if(eventsUrlConnection) {
		//Ça va démarrer !
	}
	else {
		//Ça marche pas :(
		[eventsData release];
		lblText.text = @"Impossible d'obtenir une connection";
	}
	//*/
	self.title = self.objEvent.titre;
	pbx1.image = objEvent.thumb;
	
	UIBarButtonItem *tmpRightBarbtn = [[UIBarButtonItem alloc] initWithTitle:@"Navi" style:UIBarButtonItemStyleBordered target:self action:@selector(naviTo:)];
	
	self.navigationItem.rightBarButtonItem = tmpRightBarbtn;
	[tmpRightBarbtn release];
	
	
}
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//En-tête reçu
	[eventsData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
	[eventsData appendData:someData];
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
		tmpEvenement.idE = [[jsonO objectForKey:@"id"] integerValue];
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
		
		
		//tmpEvenement.thumb = [jsonO objectForKey:@""];
		CLLocationCoordinate2D coord = {[[loc objectForKey:@"lat"] doubleValue], [[loc objectForKey:@"lng"] doubleValue]};
		tmpEvenement.coordinate = coord;
		
		[eventsMap addAnnotation:tmpEvenement];
		[tmpEvenement release];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//Cette ligne doit être éxécutée à la fin des traitements
	[eventsData release];
}
//*/
- (void)naviTo:(id)sender {
	
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
	
	//TODO: récupérer la position actuelle
	CLLocationCoordinate2D currLoc={0.0,0.0};
	
	//*
	NSURL *url = [[NSURL alloc] initWithScheme:@"http"
										  host:@"maps.google.com"
										  path:[NSString stringWithFormat:@"/maps?saddr=%f,%f+(%@)&daddr=%f,%f+(%@)&hl=%@",
												currLoc.latitude, currLoc.longitude, @"Ma position",
												objEvent.coordinate.latitude, objEvent.coordinate.longitude, objEvent.titre,
												[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]]];
	
	
	if([[UIApplication sharedApplication] canOpenURL:url] && url!=nil)
		[[UIApplication sharedApplication] openURL:url];
	else
		NSLog(@"L'application ne peut pas ouvrir %@", url);
	
	[url release];
	//[cll release];
	//*/
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	
	//Toutes les orientatons autorisées sauf UpsideDown
	if(interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) return NO;
	else return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[objEvent release];
	[super dealloc];
}


@end
