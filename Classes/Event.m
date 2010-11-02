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
