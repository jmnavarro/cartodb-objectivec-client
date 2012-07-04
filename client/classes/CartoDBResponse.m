//
//  CartoDBResponse.m
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBResponse.h"
#import "SBJsonParser.h"
#import "NSError+Log.h"
#import "GeoJSONFeatureCollection.h"


NSString *const kCartoDBColumName_ID = @"cartodb_id";
NSString *const kCartoDBColumName_CreatedAt = @"created_at";
NSString *const kCartoDBColumName_UpdatedAt = @"updated_at";
NSString *const kCartoDBColumName_Geom = @"the_geom";
NSString *const kCartoDBColumName_GeomWebmercator = @"the_geom_webmercator";



@implementation CartoDBResponse

@synthesize time = _time;
@synthesize count = _count;
@synthesize format = _format;


- (id) initWithJSON:(NSString*)json andFormat:(CartoDBResponseFormat)f
{
    if (self = [super init]) {
        NSDictionary* dict = [self parseJSON:json];
        bool ret = NO;

        _format = f;

        if (f == CartoDBResponseFormat_JSON) {
            ret = [self fillWithJSON:dict];
        } else if (f == CartoDBResponseFormat_GeoJSON) {
            ret = [self fillWithGeoJSON:dict];
        }
        
        if (!ret) {
            return nil;
        }
    }
    return self;
}



- (NSDictionary*)parseJSON:(NSString*)json
{
    if (json.length == 0) {
        return nil;
    }
    
#ifdef DEBUG
    NSLog(@"Parsing %@...", json);
#endif
    
	SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
	NSDictionary *dict = [parser objectWithString:json error:&error];
	[parser release];
    
    if (error != nil) {
        NSLog(@"%@", [error stringWithFormat:@"Error parsing JSON response \"%@\"", json]);
        dict = nil;
    } else if (dict.count == 0) {
        NSLog(@"Error with empty JSON response \"%@\"", json);
    }
    
    return dict;
}


- (bool) fillWithJSON:(NSDictionary*)dict
{
    if (dict.count == 0) {
        return NO;
    }
    
    bool ok = NO;
    
    _time  = [(NSNumber*)[dict objectForKey:@"time"] doubleValue];
    _count = [(NSNumber*)[dict objectForKey:@"total_rows"] intValue];
    NSArray *jsonRows = [dict objectForKey:@"rows"];
        
    if (_count != jsonRows.count) {
        NSLog(@"Inconsistency in rown count (total_rows = %d/ count = %d)", _count, jsonRows.count);
    } else {
        _rows = [[NSArray alloc] initWithArray:jsonRows copyItems:YES];
        ok = YES;
    }
    
    return ok;
}


- (bool) fillWithGeoJSON:(NSDictionary*)dict
{
    if (dict.count == 0) {
        return NO;
    }

    bool ok = NO;
    
    _time = -1.0; // unknown
    
    GeoJSONFactory *factory = [[GeoJSONFactory alloc] init];

    ok = [factory createObject:dict];
    if (ok) {
        switch (factory.type) {
            case GeoJSONType_FeatureCollection:
            {
                [self parseFeatureCollection:factory.object];
                _count = _rows.count;
                ok = YES;
                break;
            }   
            default:
                NSLog(@"ERROR: Geometry of type %@ not supported", NSStringFromGeoJSONType(factory.type)); 
                break;
        }
    }
    
    [factory release];

    return ok;
}


- (void) parseFeatureCollection:(GeoJSONFeatureCollection*)featureCollection
{
    int length = featureCollection.count;
    NSMutableArray *tmpRows = [[NSMutableArray alloc] initWithCapacity:length];
    
    for (int i = 0; i < length; ++i) {
        GeoJSONFeature *feature = [featureCollection featureAt:i];
        
        NSMutableDictionary *tmpColumns = [[NSMutableDictionary alloc] initWithCapacity:feature.properties.count + 1];
        [tmpColumns addEntriesFromDictionary:feature.properties];
        id value = feature.geometry == nil ? [NSNull null] : feature.geometry;
        [tmpColumns setObject:value forKey:kCartoDBColumName_Geom];
        
        NSDictionary *columns = [[NSDictionary alloc] initWithDictionary:tmpColumns];
        [tmpRows addObject:columns];
        [columns release];
        [tmpColumns release];
    }
    
    _rows = [[NSArray alloc] initWithArray:tmpRows];
    [tmpRows release];
}


- (id) valueAtRow:(int)index andColumn:(NSString*)col
{
    id ret;
    if (index < _rows.count) {
        NSDictionary *dic = [_rows objectAtIndex:index];
        if (col == nil) {
            ret = dic;
        } else {
            ret = [dic objectForKey:col];
        }
    } else {
        ret = nil;
    }
    return ret;
}


- (void) dealloc
{
    [_rows release];
    [super dealloc];
}


@end
