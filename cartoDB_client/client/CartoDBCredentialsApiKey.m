//
//  CartoDBCredentialsApiKey.m
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBCredentialsApiKey.h"

@implementation CartoDBCredentialsApiKey

@synthesize username = _username;
@synthesize apiKey = _apiKey;


- (bool) valid
{
    return (_username.length > 0 && _apiKey.length == 40);
}

- (void) dealloc
{
    [_username release];
    [_apiKey release];
    [super dealloc];
}

@end
