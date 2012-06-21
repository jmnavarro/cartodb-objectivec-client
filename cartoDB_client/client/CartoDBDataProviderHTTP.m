//
//  CartoDBDataProviderHTTP.m
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBDataProviderHTTP.h"
#import "NSError+Log.h"
#import "CartoDBResponse.h"
#import "macros.h"
#import "CartoDBCredentialsApiKey.h"


static const NSString* kDefaultAPIVersion = @"1";
static const NSString* kSQLBaseURL = @"https://%@.cartodb.com/api/v%@/sql/?q=%@&api_key=%@";


@implementation CartoDBDataProviderHTTP

@synthesize timeout = _timeout;
@synthesize cachePolicy = _cachePolicy;


- (id) init
{
    if (self = [super init]) {
        _timeout = 30.0;
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return self;
}

- (bool) valid
{
    return (self.delegate && self.credentials.valid);
}


- (NSString*) newEncoded:(NSString*) str
{
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                               NULL,
                                                               (CFStringRef)str,
                                                               NULL,
                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                               kCFStringEncodingUTF8);
}

- (CartoDBCredentialsApiKey*) keyCredentials
{
    return (CartoDBCredentialsApiKey *) self.credentials;;
}


- (NSURL*) newURLForSQL:(NSString*)sql
{
    NSString* encodedSQL = [self newEncoded:sql];
    
    NSString *str = [[NSString alloc] initWithFormat:(NSString*)kSQLBaseURL, [self keyCredentials].username, kDefaultAPIVersion, encodedSQL, [self keyCredentials].apiKey];
    
#ifdef DEBUG
    NSLog(@"URL -> %@", str);
#endif
    
    NSURL *ret = [[NSURL alloc] initWithString:str];
    [str release];
    [encodedSQL release];
    return ret;
}

- (bool) startRequestWithSQL:(NSString*)sql 
{
    
    if (!self.valid) {
        return NO;
    }
    
    NSURL *url = [self newURLForSQL:sql];
    if (url == nil) {
        return NO;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:_cachePolicy timeoutInterval:_timeout];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [url release];
    
    [connection start];
    
    return YES;
}


#pragma mark - Network delegate


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data release];
    _data = [[NSMutableData alloc] initWithCapacity:1024];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [self retain]; // auto protect for release in callback
    
    SAFE_RELEASE(_data);
    
    NSLog(@"%@", [error stringWithFormat:@"Failed network connection"]);
    [self.delegate cartoDBProvider:self failedWithError:error];
    
    [self release];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_data appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self retain]; // auto protect for release in callback
    
    NSString *json = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    if (response) {
        [self.delegate cartoDBProvider:self finishedWithResponse:response];
        [response release]; // <- note you should retain the response in the callback
    } else {
        [self.delegate cartoDBProvider:self failedWithError:[NSError errorWithDomain:@"cartoDB" code:-1 userInfo:nil]];
    }
    
    [json release];
    [connection release];
    SAFE_RELEASE(_data);
    
    [self release];
}


@end
