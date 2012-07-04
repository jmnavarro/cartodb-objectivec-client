//
//  CartoDBDataProvider.h
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartoDBResponse.h"

@class CartoDBDataProvider;
@class CartoDBCredentials;




@protocol CartoDBDataProviderDelegate <NSObject>

- (void) cartoDBProvider:(CartoDBDataProvider*)provider finishedWithResponse:(CartoDBResponse*)response;
- (void) cartoDBProvider:(CartoDBDataProvider*)provider failedWithError:(NSError*)err;

@end






@interface CartoDBDataProvider : NSObject

@property (nonatomic, assign) id<CartoDBDataProviderDelegate> delegate;
@property (nonatomic, retain) NSString* apiVersion;
@property (nonatomic, retain) CartoDBCredentials *credentials;
@property (nonatomic, assign) CartoDBResponseFormat responseFormat;
@property (nonatomic, readonly) bool valid;

- (bool) startRequestWithSQL:(NSString*)sql;

@end
