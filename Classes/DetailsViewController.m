//
//  DetailsViewController.m
//  MillenaireNE
//
//  Created by Sébastien Vaucher on 30.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"


@implementation DetailsViewController

@synthesize objEvent;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//On récupère la grande image
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//*
	NSURLRequest *eventsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:
																[NSString stringWithFormat:@"http://vaucher.homeip.net/devios/testd1.json"]]];
	detailsData = [[NSMutableData alloc] init];
	NSURLConnection *eventsUrlConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
	if(eventsUrlConnection) {
		//Ça va démarrer !
		NSLog(@"Démarrage de la connexion");
	}
	else {
		//Ça marche pas :(
		[detailsData release];
		NSLog(@"Impossible d'obtenir une connection");
	}
	//*/
	self.title = self.objEvent.titre;
	
	pbx1 = [[TTImageView alloc] init];
	pbx1.defaultImage = (UIImage *)objEvent.thumb;
	
	UIBarButtonItem *tmpRightBarbtn = [[UIBarButtonItem alloc] initWithTitle:@"Navi" style:UIBarButtonItemStyleBordered target:self action:@selector(naviTo:)];
	
	self.navigationItem.rightBarButtonItem = tmpRightBarbtn;
	[tmpRightBarbtn release];
	
	
}
//*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"En-tête reçu");
	[detailsData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
	NSLog(@"Datas reçues");
	[detailsData appendData:someData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSLog(@"Fin de la connexion");
	
	NSString *jsonS = [[NSString alloc] initWithData:detailsData encoding:NSUTF8StringEncoding];
	
	NSLog(jsonS);
	
	NSDictionary * jsonO = [jsonS JSONValue];
	[jsonS release];
	
	NSLog(@"JSON:  %@", [jsonO description]);
	
	NSLog(@"Longdesc + adresse");
	objEvent.longdesc = [jsonO objectForKey:@"longdesc"];
	objEvent.adresse = [jsonO objectForKey:@"adr"];
	
	//Image
	NSLog(@"Image :");
	
	//NE MARCHE PAS, FAIT SYSTEMATIQUEMENT TOUT PLANTER !!! TODO TODO TODO TODO TODO
	
	//pbx1 = [[TTImageView alloc] init];
	//pbx1.urlPath = [jsonO objectForKey:@"imgs"];
	
	//pbx1.urlPath = @"http://notrehistoire.ch.s3.amazonaws.com/photos/2009/10/654475b5053c0e33_JPG_530x530_q85.jpg";
	[self.view addSubview:pbx1];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//Cette ligne doit être éxécutée à la fin des traitements
	[detailsData release];
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
	[objEvent.imgs release];
	[objEvent release];
	if(detailsData == nil)
		[detailsData release];
	[super dealloc];
}


@end
