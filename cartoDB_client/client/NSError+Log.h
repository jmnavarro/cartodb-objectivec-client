//
//  NSError+Log.h
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError(Log)

- (NSString*)stringWithFormat:(NSString *)format, ...;

@end
