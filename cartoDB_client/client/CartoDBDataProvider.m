//
//  CartoDBDataProvider.m
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBDataProvider.h"

@implementation CartoDBDataProvider

@synthesize delegate = _delegate;
@synthesize credentials = _credentials;
@synthesize valid;
@synthesize responseFormat = _responseFormat;
@synthesize apiVersion = _apiVersion;


- (id) init {
    if (self = [super init]) {
        _responseFormat = CartoDBResponseFormat_GeoJSON;
    }
    return self;
}


- (bool) startRequestWithSQL:(NSString*)sql 
{
    NSAssert(NO, @"Implement data provider");
    return NO;
}

- (bool) valid
{
    NSAssert(NO, @"Implement data provider validation");
    return NO;
}


- (void) dealloc
{
    [_credentials release];
    [_apiVersion release];
    [super dealloc];
}

@end
