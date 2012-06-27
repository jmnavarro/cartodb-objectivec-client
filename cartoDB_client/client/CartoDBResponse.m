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


NSString *const kCartoDBColumName_ID = @"cartodb_id";
NSString *const kCartoDBColumName_Name = @"name";
NSString *const kCartoDBColumName_Description = @"description";
NSString *const kCartoDBColumName_CreatedAt = @"created_at";
NSString *const kCartoDBColumName_UpdatedAt = @"updated_at";
NSString *const kCartoDBColumName_Geom = @"the_geom";
NSString *const kCartoDBColumName_GeomWebmercator = @"the_geom_webmercator";

NSString *const kCartoDBColumName_GeomType = @"geom.type";
NSString *const kCartoDBColumName_GeomLat = @"geom.lat";
NSString *const kCartoDBColumName_GeomLng = @"geom.lng";



CartoDBGeomType GeomTypeFromString(NSString* str)
{
    if ([@"Point" isEqualToString:str]) {
        return CartoDBGeomType_Point;
    }
    return CartoDBGeomType_Undefined;
}



@implementation CartoDBResponse

@synthesize time = _time;
@synthesize count = _count;


- (id) initWithJSONResponse:(NSString*)json
{
    if (self = [super init]) {
        NSDictionary* dict = [self parseJSON:json];
        if (![self fillWithJSON:dict]) {
            return nil;
        }
    }
    return self;
}


- (id) initWithGeoJSONResponse:(NSString*)geojson
{
    if (self = [super init]) {
        NSDictionary* dict = [self parseJSON:geojson];
        if (![self fillWithGeoJSON:dict]) {
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
    
    NSArray *features = [dict objectForKey:@"features"];
    if (features) {
        _count = features.count;
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:_count];
        for (int i = 0; i < _count; ++i) {
            NSDictionary *attrs = [features objectAtIndex:i];
            NSDictionary *properties = [attrs objectForKey:@"properties"];
            NSDictionary *geom = [attrs objectForKey:@"geometry"];
            
            NSMutableDictionary *columns = [[NSMutableDictionary alloc] initWithCapacity:16];
            
            [columns addEntriesFromDictionary:properties];
            
            CartoDBGeomType type = GeomTypeFromString([geom objectForKey:@"type"]);
            [columns setObject:[NSNumber numberWithInt:type] forKey:kCartoDBColumName_GeomType];
            
            switch (type) {
                case CartoDBGeomType_Point:
                {
                    NSArray *coord = [geom objectForKey:@"coordinates"];
                    [columns setObject:[coord objectAtIndex:0] forKey:kCartoDBColumName_GeomLng];
                    [columns setObject:[coord objectAtIndex:1] forKey:kCartoDBColumName_GeomLat];
                    break;
                }
                default:
                {
                    NSAssert1(NO, @"Geometry type %@ not implemented", [geom objectForKey:@"type"]);
                }
            }
            
            [tmp addObject:columns];
            [columns release];
        }
        
        _rows = [[NSArray alloc] initWithArray:tmp];
        [tmp release];
        
        ok = YES;
    }
    
    return ok;
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
