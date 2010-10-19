//
//  Event.h
//  MillenaireNE
//
//  Created by ServiceInformatique on 28.09.10.
//  Copyright 2010 CPLN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Event : NSObject <MKAnnotation> {
	NSInteger *idE;
	NSString *titre;
	NSString *shortdesc;
	NSString *longdesc;
	NSDate *beginDate;
	NSDate *endDate;
	UIImage *thumb;
	NSArray *imgs;
	NSString *adresse;
	CLLocationCoordinate2D coordinate;
}

- (NSString *) title;
- (NSString *) subtitle;

@property (nonatomic) NSInteger *idE;
@property (nonatomic, retain) NSString *titre;
@property (nonatomic, retain) NSString *shortdesc;
@property (nonatomic, retain) NSString *longdesc;
@property (nonatomic, retain) NSDate *beginDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) UIImage *thumb;
@property (nonatomic, retain) NSArray *imgs;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *adresse;

@end
