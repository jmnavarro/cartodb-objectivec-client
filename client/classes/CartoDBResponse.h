//
//  CartoDBResponse.h
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoJSONFactory.h"
#import "GeoJSONFeature.h"


FOUNDATION_EXPORT NSString *const kCartoDBColumName_ID;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_CreatedAt;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_UpdatedAt;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_Geom;
FOUNDATION_EXPORT NSString *const kCartoDBColumName_GeomWebmercator;

typedef enum
{
    CartoDBResponseFormat_JSON,
    CartoDBResponseFormat_GeoJSON
} CartoDBResponseFormat;


@interface CartoDBResponse : NSObject
{
    NSArray *_rows;
}

@property (nonatomic, readonly) double time;
@property (nonatomic, readonly) int count;
@property (nonatomic, readonly) CartoDBResponseFormat format;

- (id) initWithJSON:(NSString*)json andFormat:(CartoDBResponseFormat)f;

- (id) valueAtRow:(int)index andColumn:(NSString*)col;

@end
