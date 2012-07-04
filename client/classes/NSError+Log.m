//
//  NSError+Log.m
//  cartoDB_client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSError+Log.h"

@implementation NSError(Log)


- (NSString*)stringWithFormat:(NSString *)format, ...
{
    NSString *msg;
    va_list args;
    if (format) {
        va_start(args, format);
        msg = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    } else {
        msg = [[NSString string] retain];
    }
    
    NSString *ret = [NSString stringWithFormat:@"********************************************\nError %p: %@,\n   - Domain: %@\n   - code: %d\n   - Desc: %@\n   - Reason: %@\n   - Recovery: %@ (options=%@)\n   - Help anchor: %@\n*********************************************************",
          self, msg, self.domain, self.code, self.localizedDescription, self.localizedFailureReason, self.localizedRecoverySuggestion, self.localizedRecoveryOptions, self.helpAnchor];
    
    [msg release];
    
    return ret;
}


@end
