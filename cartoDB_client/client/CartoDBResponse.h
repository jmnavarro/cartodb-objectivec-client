//
//  CartoDBResponse.h
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString *const kCartoDBColumName_ID;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_Name;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_Description;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_CreatedAt;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_UpdatedAt;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_Geom;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_GeomWebmercator;


@interface CartoDBResponse : NSObject
{
    NSArray *_rows;
}

@property (nonatomic, readonly) double time;
@property (nonatomic, readonly) int count;

- (id) initWithJSONResponse:(NSString*)json;

- (id) valueAtRow:(int)index andColumn:(NSString*)col;

@end
