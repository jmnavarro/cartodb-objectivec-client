//
//  CartoDBClient.h
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartoDBDataProvider.h"


@class CartoDBResponse;
@class CartoDBClient;


@protocol CartoDBClientDelegate <NSObject>

- (void) cartoDBClient:(CartoDBClient*)client receivedResponse:(CartoDBResponse*)response;
- (void) cartoDBClient:(CartoDBClient*)client failedWithError:(NSError*)err;

@end


@interface CartoDBClient : NSObject<CartoDBDataProviderDelegate>

@property (nonatomic, assign) id<CartoDBClientDelegate> delegate;
@property (nonatomic, retain) CartoDBDataProvider *provider;


- (bool) startRequestWithSQL:(NSString*)sql;

@end
