//
//  CartoDBCredentials.m
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBCredentials.h"

@implementation CartoDBCredentials

@synthesize valid = _valid;
@synthesize username = _username;


- (bool) valid
{
    return (_username.length > 0);
}


- (void) dealloc
{
    [_username release];
    [super dealloc];
}



@end
