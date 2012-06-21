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


@implementation CartoDBResponse

@synthesize time = _time;
@synthesize count = _count;


- (id) initWithJSONResponse:(NSString*)json
{
    if (self = [super init]) {
        if (![self parseAndFillWithJSON:json]) {
            return nil;
        }
    }
    return self;
}


- (bool) parseAndFillWithJSON:(NSString*)json
{
    if (json.length == 0) {
        return NO;
    }
    
#ifdef DEBUG
    NSLog(@"Parsing %@...", json);
#endif
    
    bool ok = NO;    
	SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
	NSDictionary *dict = [parser objectWithString:json error:&error];
	[parser release];
    
    if (error != nil) {
        NSLog(@"%@", [error stringWithFormat:@"Error parsing JSON response \"%@\"", json]);
    } else if (dict.count == 0) {
        NSLog(@"Error with empty JSON response \"%@\"", json);
    } else {
        _time  = [(NSNumber*)[dict objectForKey:@"time"] doubleValue];
        _count = [(NSNumber*)[dict objectForKey:@"total_rows"] intValue];
        NSArray *jsonRows = [dict objectForKey:@"rows"];
        
        if (_count != jsonRows.count) {
            NSLog(@"Inconsistency in rown count (total_rows = %d/ count = %d)", _count, jsonRows.count);
        } else {
            _rows = [[NSArray alloc] initWithArray:jsonRows copyItems:YES];
            ok = YES;
        }
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
