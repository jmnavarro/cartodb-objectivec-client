//
//  CartoDBCredentialsApiKey.m
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBCredentialsApiKey.h"

@implementation CartoDBCredentialsApiKey

@synthesize apiKey = _apiKey;


- (bool) valid
{
    return [super valid] && _apiKey.length == 40;
}

- (void) dealloc
{
    [_apiKey release];
    [super dealloc];
}

@end
