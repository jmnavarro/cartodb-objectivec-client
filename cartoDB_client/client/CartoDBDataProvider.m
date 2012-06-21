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
    [super dealloc];
}

@end
