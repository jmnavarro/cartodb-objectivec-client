//
//  CartoDBDataProviderHTTP.h
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBDataProvider.h"

@interface CartoDBDataProviderHTTP : CartoDBDataProvider
{
    NSMutableData *_data;
}

@property (nonatomic, assign) double timeout;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

@end
