//
//  prucartodbTests.m
//  prucartodbTests
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBClientTests.h"
#import "CartoDBResponse.h"
#import "CartoDBDataProviderHTTP.h"
#import "NSError+Log.h"
#import "macros.h"
#import "CartoDBCredentialsApiKey.h"

#import "YourData.h"

@implementation CartoDBClientTests



- (void)setUp
{
    [super setUp];
    
    _fixture = [[CartoDBClient alloc] init];
    _fixture.delegate = self;
    
    _dataProvider = [[CartoDBDataProviderStatic alloc] init];
    _fixture.provider = _dataProvider;
}

- (void)tearDown
{
    SAFE_RELEASE(_fixture);
    _dataProvider.response = nil;
    SAFE_RELEASE(_dataProvider);
    
    SAFE_RELEASE(_lastError);
    SAFE_RELEASE(_lastResponse);
    
    [super tearDown];
}


- (void)testShouldFailIfSQLIsEmpty
{
    STAssertFalse([_fixture startRequestWithSQL:@""], @"Must fail!");
}

- (void)testShouldFailIfSQLIsNil
{
    STAssertFalse([_fixture startRequestWithSQL:nil], @"Must fail!");
}

- (void)testShouldFailIfDelegateIsNotSet
{
    _fixture.delegate = nil;
    STAssertFalse([_fixture startRequestWithSQL:@"the-sql"], @"Must fail!");
}

- (void)testShouldWorkIfClientAndRequestIsOKWithFormatJSON
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":1,\"rows\":[{\"cartodb_id\":1,\"name\":\"STATIC \",\"description\":\"STATIC \",\"created_at\":\"2012-06-21T16:56:24.827Z\",\"updated_at\":\"2012-06-21T16:56:46.903Z\",\"the_geom\":\"0101000020E610000000000000000000000000000000000000\",\"the_geom_webmercator\":\"0101000020110F0000000000000000000000000040A65408BE\"}]}";
    
    _dataProvider.responseFormat = CartoDBResponseFormat_JSON;

    _dataProvider.error = nil;
    _dataProvider.response = [[CartoDBResponse alloc] initWithJSON:json andFormat:_dataProvider.responseFormat];
    
    STAssertTrue([_fixture startRequestWithSQL:@"valid-sql"], @"Cant start request");
    
    // check expectations
    STAssertNil(_lastError, @"Last error must be nil");
    STAssertEquals(_dataProvider.response, _lastResponse, @"Bad response received");
    STAssertEquals(CartoDBResponseFormat_JSON, _lastResponse.format, @"Bad response format");
}


- (void)testShouldWorkIfClientAndRequestIsOKWithFormatGeoJSON
{
    NSString* geojson = @"{\"type\": \"FeatureCollection\",\"features\": [{\"type\": \"Feature\",\"properties\": {\"cartodb_id\": 1, \"name\": \"centro\",\"description\": \"el centro del universo\",\"created_at\": \"2012-06-21T16:56:24.827Z\",\"updated_at\": \"2012-06-21T16:56:46.903Z\"},\"geometry\": {\"type\": \"Point\", \"coordinates\": [10.1,20.2]}}]}";
    
    _dataProvider.responseFormat = CartoDBResponseFormat_GeoJSON;
    
    _dataProvider.error = nil;
    _dataProvider.response = [[CartoDBResponse alloc] initWithJSON:geojson andFormat:_dataProvider.responseFormat];
    
    STAssertTrue([_fixture startRequestWithSQL:@"valid-sql"], @"Cant start request");
    
    // check expectations
    STAssertNil(_lastError, @"Last error must be nil");
    STAssertEquals(_dataProvider.response, _lastResponse, @"Bad response received");
    STAssertEquals(CartoDBResponseFormat_GeoJSON, _lastResponse.format, @"Bad response format");
}








- (void) cartoDBClient:(CartoDBClient*)client receivedResponse:(CartoDBResponse*)response
{
    STAssertEquals(client, _fixture, @"Source object is incoherent");
    
    _lastResponse = [response retain];
    _lastError = nil;
}

- (void) cartoDBClient:(CartoDBClient*)client failedWithError:(NSError*)err
{
    STAssertEquals(client, _fixture, @"Source object is incoherent");
    
    _lastResponse = nil;
    _lastError = [err retain];
}




@end
