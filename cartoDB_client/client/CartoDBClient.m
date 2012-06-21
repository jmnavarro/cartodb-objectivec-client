//
//  CartoDBClient.m
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBClient.h"
#import "macros.h"
#import "CartoDBResponse.h"
#import "CartoDBDataProviderHTTP.h"


@implementation CartoDBClient


@synthesize delegate = _delegate;
@synthesize provider = _provider;



- (bool) startRequestWithSQL:(NSString*)sql
{
    if (sql.length == 0 || !_delegate || !_provider.valid) {
        return NO;
    }
    
    return [_provider startRequestWithSQL:sql];
}



- (void) cartoDBProvider:(CartoDBDataProvider*)provider finishedWithResponse:(CartoDBResponse*)response
{
    [_delegate cartoDBClient:self receivedResponse:response];
}

- (void) cartoDBProvider:(CartoDBDataProvider*)provider failedWithError:(NSError*)err
{
    [_delegate cartoDBClient:self failedWithError:err];
}

- (void) setProvider:(CartoDBDataProvider *)value
{
    value.delegate = self;
    _provider = [value retain];
}


- (void) dealloc
{
    [_provider release];
    [super dealloc];
}


@end
