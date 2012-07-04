//
//  prucartodbTests.m
//  prucartodbTests
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBDataProviderHTTPTests.h"
#import "CartoDBDataProviderHTTP.h"
#import "CartoDBCredentialsApiKey.h"

@implementation CartoDBDataProviderHTTPTests

- (void)setUp
{
    [super setUp];
    
    _fixture = [[CartoDBDataProviderHTTP alloc] init];
}

- (void)tearDown
{
    [_fixture release];
    
    [super tearDown];
}


- (void) assertURL:(NSURL*)url
{
    STAssertNotNil(url, @"URL can't be nil");
    STAssertNotNil(url.absoluteString, @"URL string can't be nil");
    STAssertTrue(url.absoluteString.length > 0, @"URL string can't be empty");
}

- (void)testURLShouldContainGeoJSONFormat
{
    _fixture.responseFormat = CartoDBResponseFormat_GeoJSON;
    
    NSURL *url = [_fixture newURLForSQL:@"sql"];
    
    [self assertURL:url];
    STAssertTrue(NSNotFound != [url.absoluteString rangeOfString:@"format=geojson"].location, 
                 @"Format doesn't found");
    
    [url release];
}


- (void)testURLShouldNotContainJSONFormat
{
    _fixture.responseFormat = CartoDBResponseFormat_JSON;
    
    NSURL *url = [_fixture newURLForSQL:@"sql"];

    [self assertURL:url];
    STAssertTrue(NSNotFound == [url.absoluteString rangeOfString:@"format="].location, 
                 @"Format does found");
    
    [url release];
}


- (void)testURLShouldContainEscapedSQL
{
    _fixture.responseFormat = CartoDBResponseFormat_GeoJSON;
    
    NSURL *url = [_fixture newURLForSQL:@"SELECT * FROM a"];
    
    [self assertURL:url];
    STAssertTrue(NSNotFound != [url.absoluteString rangeOfString:@"q=SELECT%20%2A%20FROM%20a"].location, 
                 @"Escaped SQL doesn't found");
    
    [url release];
}


- (void)testURLShouldNotContainApiKeyIfItIsNotPresent
{
    NSURL *url = [_fixture newURLForSQL:@"SELECT * FROM a"];
    
    [self assertURL:url];
    STAssertTrue(NSNotFound == [url.absoluteString rangeOfString:@"api_key="].location, 
                 @"Api key does found");
    
    [url release];
}


- (void)testURLShouldContainApiKeyIfItIsPresent
{
    CartoDBCredentialsApiKey *credentials = [[CartoDBCredentialsApiKey alloc] init];
    credentials.apiKey = @"aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd";
    _fixture.credentials = credentials;
    
    NSURL *url = [_fixture newURLForSQL:@"SELECT * FROM a"];
    
    [self assertURL:url];
    NSString *expectedStr = [NSString stringWithFormat:@"api_key=%@", credentials.apiKey];
    STAssertTrue(NSNotFound != [url.absoluteString rangeOfString:expectedStr].location, @"Api key doesn't found");
    
    [credentials release];
    [url release];
}


- (void)testURLShouldContainUsername
{
    CartoDBCredentials *credentials = [[CartoDBCredentials alloc] init];
    credentials.username = @"my-username";
    _fixture.credentials = credentials;
    [credentials release];
    
    NSURL *url = [_fixture newURLForSQL:@"SELECT * FROM a"];
    
    [self assertURL:url];
    NSString *expectedStr = [NSString stringWithFormat:@"://%@.cartodb.com", credentials.username];
    STAssertTrue(NSNotFound != [url.absoluteString rangeOfString:expectedStr].location, @"Username doesn't found");
    
    [url release];
}


@end
