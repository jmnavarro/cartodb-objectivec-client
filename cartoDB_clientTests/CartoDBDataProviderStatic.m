//
//  CartoDBDataProviderHTTP.m
//  prucartodb
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBDataProviderStatic.h"


@implementation CartoDBDataProviderStatic

@synthesize error = _error;
@synthesize response = _response;


- (bool) startRequestWithSQL:(NSString*)sql 
{
    if (_error) {
        [self.delegate cartoDBProvider:self failedWithError:_error];
    } else if (_response) {
        [self.delegate cartoDBProvider:self finishedWithResponse:_response];
    } else {
        return NO;
    }
    
    return YES;
}

- (bool) valid
{
    return YES;
}



@end
