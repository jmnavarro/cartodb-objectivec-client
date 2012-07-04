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
#import "SBJsonParser.h"


static  NSString* const kDefaultAPIVersion = @"1";
static  NSString* const kSQLBaseURL = @"https://%@.cartodb.com/api/v%@/sql/?q=%@";


@implementation CartoDBDataProviderHTTP

@synthesize timeout = _timeout;
@synthesize cachePolicy = _cachePolicy;


- (id) init
{
    if (self = [super init]) {
        _timeout = 30.0;
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.apiVersion = kDefaultAPIVersion;
    }
    return self;
}

- (bool) valid
{
    return [super valid] && self.delegate && self.credentials.valid;
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

- (NSURL*) newURLForSQL:(NSString*)sql
{
    NSString* encodedSQL = [self newEncoded:sql];
    
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:kSQLBaseURL, self.credentials.username, self.apiVersion, encodedSQL];
    
    if (self.responseFormat == CartoDBResponseFormat_GeoJSON) {
        // see https://github.com/Vizzuality/cartodb/issues/795
        [str appendString:@"&format=geojson"];
    }
    
    if (self.page >= 0) {
        [str appendFormat:@"&page=%d&rows_per_page=%d", self.page, self.pageSize, nil];
    }
    
    if ([self.credentials respondsToSelector:@selector(apiKey)]) {
        NSString *ak = [(CartoDBCredentialsApiKey*)self.credentials apiKey];
        [str appendFormat:@"&api_key=%@", ak];
    }
    
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

- (NSError*) errorWithJSON:(NSString*)json
{
#ifdef DEBUG
        NSLog(@"Parsing error %@...", json);
#endif
        
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dict = [parser objectWithString:json error:&error];
    [parser release];
    
    NSError *ret;
    if (error != nil || dict.count == 0) {
        NSLog(@"%@", [error stringWithFormat:@"Error parsing error JSON response \"%@\"", json]);
        ret = [NSError errorWithDomain:@"cartoDB" code:-1 userInfo:nil];
    } else {
        NSArray *msgs = [dict objectForKey:@"error"];
        ret = [NSError errorWithDomain:@"cartoDB" code:-1 userInfo:[NSDictionary dictionaryWithObject:[msgs objectAtIndex:0] forKey:NSLocalizedDescriptionKey]];
    }
        
    return ret;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self retain]; // auto protect for release in callback
    
    NSString *json = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSON:json andFormat:self.responseFormat];
    if (response) {
        [self.delegate cartoDBProvider:self finishedWithResponse:response];
        [response release]; // <- note you should retain the response in the callback
    } else {
        [self.delegate cartoDBProvider:self failedWithError:[self errorWithJSON:json]];
    }
    
    [json release];
    [connection release];
    SAFE_RELEASE(_data);
    
    [self release];
}


@end
