//
//  CartoDBDataProviderHTTP.h
//  prucartodb
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBDataProvider.h"



@interface CartoDBDataProviderStatic : CartoDBDataProvider

@property (nonatomic, assign) NSError *error;
@property (nonatomic, assign) CartoDBResponse *response;

@end
