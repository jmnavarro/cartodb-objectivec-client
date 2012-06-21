//
//  prucartodbTests.m
//  prucartodbTests
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBResponseTests.h"
#import "CartoDBResponse.h"

@implementation CartoDBResponseTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testShouldWorkIfResponseHasOneRow
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":1,\"rows\":[{\"cartodb_id\":1,\"name\":\"STATIC\",\"description\":\"STATIC\",\"created_at\":\"2012-06-21T16:56:24.827Z\",\"updated_at\":\"2012-06-21T16:56:46.903Z\",\"the_geom\":\"0101000020E610000000000000000000000000000000000000\",\"the_geom_webmercator\":\"0101000020110F0000000000000000000000000040A65408BE\"}]}";

    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNotNil(response, @"Response can't be nil");
    STAssertEquals(1, response.count, @"Row count is not valid");
    STAssertEqualsWithAccuracy(0.011, response.time, 0.001, @"Response time is not valid");
    STAssertNotNil([response valueAtRow:0 andColumn:nil], @"Item 0 can't be nil");
    STAssertNil([response valueAtRow:1 andColumn:nil], @"Item 1 must be nil");
    
    [response release];
}


- (void)testShouldWorkIfResponseHasNoRows
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":0,\"rows\":[]}";
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNotNil(response, @"Response can't be nil");
    STAssertEquals(0, response.count, @"Row count is not valid");
    STAssertEqualsWithAccuracy(0.011, response.time, 0.001, @"Response time is not valid");
    STAssertNil([response valueAtRow:0 andColumn:nil], @"Item 0 must be nil");

    [response release];
}

- (void)testShouldFailIfResponseHasRownCountInconsistencies
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":99,\"rows\":[]}";
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNil(response, @"Response must be nil");
}


- (void)testShouldFailIfResponseJSONIsEmptyString
{
    NSString* json = @"";
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNil(response, @"Response must be nil");
}

- (void)testShouldFailIfResponseJSONIsNil
{
    NSString* json = nil;
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNil(response, @"Response must be nil");
}

- (void)testShouldFailIfResponseJSONIsEmpty
{
    NSString* json = @"{}";
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNil(response, @"Response must be nil");
}


- (void)testShouldFailIfResponseJSONIsInvalid
{
    NSString* json = @"sdfget·$%$·/%&/ewrw";
    
    CartoDBResponse *response = [[CartoDBResponse alloc] initWithJSONResponse:json];
    
    STAssertNil(response, @"Response must be nil");
}




@end
