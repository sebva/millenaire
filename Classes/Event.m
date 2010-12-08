//
//  Event.m
//  MillenaireNE
//
//  Created by ServiceInformatique on 28.09.10.
//  Copyright 2010 CPLN. All rights reserved.
//

#import "Event.h"


@implementation Event

@synthesize idE;
@synthesize titre;
@synthesize shortdesc;
@synthesize longdesc;
@synthesize beginDate;
@synthesize endDate;
@synthesize thumb;
@synthesize imgs;
@synthesize adresse;
@synthesize coordinate;

//Constantes
NSString * const REGARD_CULTURE = @"culture";
NSString * const REGARD_ECONOMIE = @"économie";
NSString * const REGARD_IDENTITE = @"identité";
NSString * const REGARD_POLITIQUE = @"politique";
NSString * const REGARD_RELIGION = @"religion";
NSString * const REGARD_URBANISME = @"urbanisme";

- (NSString *) title {
	return self.titre;
}
- (NSString *) subtitle {
	return self.shortdesc;
}

- (void) dealloc {
	[titre release];
	[shortdesc release];
	[longdesc release];
	[beginDate release];
	[endDate release];
	[thumb release];
	[imgs release];
	[adresse release];
	[super dealloc];
}

@end
