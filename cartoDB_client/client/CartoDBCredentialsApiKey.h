//
//  CartoDBCredentialsApiKey.h
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartoDBCredentials.h"


@interface CartoDBCredentialsApiKey : CartoDBCredentials


@property (nonatomic, retain) NSString* apiKey;

@end
