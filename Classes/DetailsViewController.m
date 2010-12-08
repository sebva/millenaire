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
	
	delegate = ((MillenaireNEAppDelegate *)[[UIApplication sharedApplication] delegate]);
	
	//On récupère la grande image
	TTNetworkRequestStarted();
	NSLog(@"Démarrage de la requête");
	NSLog(@"%d", objEvent.idE);
	//NSLog(@"%@", [delegate.config objectForKey:@"domain"]);
	//NSURL *urlRequest = [[NSURL alloc] initWithScheme:@"http" host:((NSString *)[delegate.config objectForKey:@"domain"])
												// path:[NSString stringWithFormat:((NSString *)[delegate.config objectForKey:@"pathById"]), objEvent.idE]];
	NSURL *urlRequest = [[NSURL alloc] initWithScheme:@"http" host:@"devinter.cpln.ch"
												 path:[NSString stringWithFormat:@"/millenaire/michael/json_by_id.php?id=%d", objEvent.idE]];

	NSLog(@"OK");
	NSLog([urlRequest description]);
	NSURLRequest *eventsRequest = [NSURLRequest requestWithURL:urlRequest];
	[urlRequest release];
	
	detailsData = [[NSMutableData alloc] init];
	
	NSURLConnection *eventsUrlConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
	if(eventsUrlConnection) {
		//Ça va démarrer !
		NSLog(@"Démarrage de la connexion");
	}
	else {
		//Ça marche pas :(
		[detailsData release];
		NSLog(@"Impossible d'obtenir une connexion");
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
	
	/*
	 {
	 "id": "41",
	 "longdesc": "Savez-vous quels personnages célèbres se sont embrassés pour la 1ère fois sur un banc neuchâtelois ? Combien d’instruments de mesure y a-t-il sur la colonne météo ? Sur quel bâtiment trouve-t-on un gnome sculpté ? Et un diablotin ?\r\nLa chasse au trésor est une promenade dans la vieille ville ponctuée de 20 questions révélant un mot-mystère. Un petit cadeau récompensera vos efforts en fin de parcours. Mais également chasse aux trésors…. car il propose de découvrir (ou redécouvrir) quelques petits trésors de notre ville. Notre patrimoine commun fédère d’une manière ludique, accessible à tous.\r\nLe circuit se fait de manière autonome, il est très flexible d’utilisation. Seul ou en groupe, en famille, avec sa classe, à tout moment. L’objectif est de s’intéresser au lieu où nous vivons et de le regarder d’un œil plus curieux. A l’Office du tourisme, vous trouverez les dépliants, en plusieurs langues, qui vous conduiront de question en question jusqu’à la récompense finale. Nous célébrons un anniversaire, il s’agit de s’amuser ! En levant les yeux dans ces lieux familiers pendant une heure, ou deux, selon le temps à disposition.",
	 "img": null,
	 "adresse": null
	 }
	 */
	
	NSLog(@"Longdesc + adresse");
	objEvent.longdesc = [jsonO objectForKey:@"longdesc"];
	lblText.text = objEvent.longdesc;
	
	if([[jsonO objectForKey:@"adresse"] class] != [NSNull class])
		objEvent.adresse = [jsonO objectForKey:@"adresse"];
	
	//Image
	NSLog(@"Image :");
	if([[jsonO objectForKey:@"img"] class] != [NSNull class])
		pbx1.urlPath = [jsonO objectForKey:@"img"];
	
	TTNetworkRequestStopped();
	
	//Cette ligne doit être éxécutée à la fin des traitements
	[detailsData release];
}

- (void)naviTo:(id)sender {
	
	//TODO: récupérer la position actuelle
	CLLocationCoordinate2D currLoc=((CLLocation *)((MillenaireNEAppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation).coordinate;
	
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
