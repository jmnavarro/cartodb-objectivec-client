//
//  CartoDBCredentials.h
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartoDBCredentials : NSObject

@property (nonatomic, retain) NSString* username;
@property (nonatomic, readonly) bool valid;

@end
