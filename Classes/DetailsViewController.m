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
	TTNetworkRequestStarted();
	
	NSURLRequest *eventsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:
																[NSString stringWithFormat:@"http://vaucher.homeip.net/devios/testd%i.json", objEvent.idE]]];
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

	self.title = self.objEvent.titre;
	
	pbx1.defaultImage = (UIImage *)objEvent.thumb;
	
	UIBarButtonItem *tmpRightBarbtn = [[UIBarButtonItem alloc] initWithTitle:@"Navi" style:UIBarButtonItemStyleBordered target:self action:@selector(naviTo:)];
	
	self.navigationItem.rightBarButtonItem = tmpRightBarbtn;
	[tmpRightBarbtn release];
	
	
}

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
	lblText.text = objEvent.longdesc;
	
	objEvent.adresse = [jsonO objectForKey:@"adr"];
	
	//Image
	NSLog(@"Image :");
	pbx1.urlPath = [jsonO objectForKey:@"imgs"];
	
	TTNetworkRequestStopped();
	
	//Cette ligne doit être éxécutée à la fin des traitements
	[detailsData release];
}

- (void)naviTo:(id)sender {
	
	//TODO: récupérer la position actuelle
	CLLocationCoordinate2D currLoc={0.0,0.0};
	
	NSURL *url = [[NSURL alloc] initWithScheme:@"http"
										  host:@"maps.google.com"
										  path:[NSString stringWithFormat:@"/maps?saddr=%f,%f+(%@)&daddr=%f,%f+(%@)&hl=%@",
												currLoc.latitude, currLoc.longitude, NSLocalizedString(@"Ma position", nil),
												objEvent.coordinate.latitude, objEvent.coordinate.longitude, objEvent.titre,
												[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]]];
	
	[self.navigationController pushViewController:TTOpenURL([url absoluteString]) animated:YES];
	
	[url release];
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
