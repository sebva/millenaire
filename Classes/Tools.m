//
//  tools.m
//  ForwardGeocode
//
//  Created by ServiceInformatique on 08.09.10.
//  Copyright 2010 CPLN. All rights reserved.
//

#import "Tools.h"


@implementation Tools

+ (NSString *)httpRequest:(NSURL *)url {
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:url];
	[request setHTTPMethod:@"GET"];
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:NULL];
	if (responseData==nil) {
		return nil;
	}
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
		//NSLog(@"Response: %@", result);
		return result;
		//here you get the response
		
	}
	return nil;
}

@end
