//
//  prucartodbTests.m
//  prucartodbTests
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartoDBResponseTests.h"
#import "CartoDBResponse.h"
#import "GeoJSONPoint.h"


@implementation CartoDBResponseTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    [_fixture release];
    
    [super tearDown];
}

- (void)testShouldWorkIfResponseHasOneRow
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":1,\"rows\":[{\"cartodb_id\":1,\"name\":\"STATIC\",\"description\":\"STATIC\",\"created_at\":\"2012-06-21T16:56:24.827Z\",\"updated_at\":\"2012-06-21T16:56:46.903Z\",\"the_geom\":\"0101000020E610000000000000000000000000000000000000\",\"the_geom_webmercator\":\"0101000020110F0000000000000000000000000040A65408BE\"}]}";

    _fixture = [[CartoDBResponse alloc] initWithJSON:json andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNotNil(_fixture, @"Response can't be nil");
    STAssertEquals(1, _fixture.count, @"Row count is not valid");
    STAssertEqualsWithAccuracy(0.011, _fixture.time, 0.001, @"Response time is not valid");
    STAssertNotNil([_fixture valueAtRow:0 andColumn:nil], @"Item 0 can't be nil");
    STAssertNil([_fixture valueAtRow:1 andColumn:nil], @"Item 1 must be nil");
}


- (void)testShouldWorkIfResponseHasNoRows
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":0,\"rows\":[]}";
    
    _fixture = [[CartoDBResponse alloc] initWithJSON:json andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNotNil(_fixture, @"Response can't be nil");
    STAssertEquals(0, _fixture.count, @"Row count is not valid");
    STAssertEqualsWithAccuracy(0.011, _fixture.time, 0.001, @"Response time is not valid");
    STAssertNil([_fixture valueAtRow:0 andColumn:nil], @"Item 0 must be nil");
}

- (void)testShouldFailIfResponseHasRownCountInconsistencies
{
    NSString* json = @"{\"time\":0.011,\"total_rows\":99,\"rows\":[]}";
    
    _fixture = [[CartoDBResponse alloc] initWithJSON:json andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNil(_fixture, @"Response must be nil");
}


- (void)testShouldFailIfResponseJSONIsEmptyString
{
    _fixture = [[CartoDBResponse alloc] initWithJSON:@"" andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNil(_fixture, @"Response must be nil");
}

- (void)testShouldFailIfResponseJSONIsNil
{
    _fixture = [[CartoDBResponse alloc] initWithJSON:nil andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNil(_fixture, @"Response must be nil");
}

- (void)testShouldFailIfResponseJSONIsEmpty
{
    _fixture = [[CartoDBResponse alloc] initWithJSON:@"{}" andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNil(_fixture, @"Response must be nil");
}


- (void)testShouldFailIfResponseJSONIsInvalid
{
    NSString* json = @"sdfget·$%$·/%&/ewrw";
    
    _fixture = [[CartoDBResponse alloc] initWithJSON:json andFormat:CartoDBResponseFormat_JSON];
    
    STAssertNil(_fixture, @"Response must be nil");
}


- (void)testShouldWorkIfGeoJSONResponseHasOneRow
{
    NSString* geojson = @"{\"type\": \"FeatureCollection\",\"features\": [{\"type\": \"Feature\",\"properties\": {\"cartodb_id\": 1, \"name\": \"centro\",\"description\": \"el centro del universo\",\"created_at\": \"2012-06-21T16:56:24.827Z\",\"updated_at\": \"2012-06-21T16:56:46.903Z\"},\"geometry\": {\"type\": \"Point\", \"coordinates\": [10.1,20.2]}}]}";
    
    _fixture = [[CartoDBResponse alloc] initWithJSON:geojson andFormat:CartoDBResponseFormat_GeoJSON];
    
    STAssertNotNil(_fixture, @"Response can't be nil");
    STAssertEquals(1, _fixture.count, @"Row count is not valid");
    STAssertEqualsWithAccuracy(-1.0, _fixture.time, 0.001, @"Response time is not valid");
    
    NSDictionary *columns = [_fixture valueAtRow:0 andColumn:nil];
    STAssertNotNil(columns, @"Item 0 can't be nil");
    STAssertEquals(6U, columns.count, @"Column count is not valid");
    STAssertNotNil([columns objectForKey:kCartoDBColumName_ID], @"Column cartodb_id must be present");
    STAssertNotNil([columns objectForKey:@"name"], @"Column cartodb_id must be present");
    STAssertNotNil([columns objectForKey:@"description"], @"Column cartodb_id must be present");
    STAssertNotNil([columns objectForKey:kCartoDBColumName_CreatedAt], @"Column cartodb_id must be present");
    STAssertNotNil([columns objectForKey:kCartoDBColumName_UpdatedAt], @"Column cartodb_id must be present");
    STAssertNotNil([columns objectForKey:kCartoDBColumName_Geom], @"Column cartodb_id must be present");

    STAssertEquals([NSNumber numberWithInt:1], [_fixture valueAtRow:0 andColumn:kCartoDBColumName_ID], @"ID is not valid");
    STAssertTrue([@"centro" isEqualToString:[_fixture valueAtRow:0 andColumn:@"name"]], @"Name is not valid");
    STAssertTrue([@"el centro del universo" isEqualToString:[_fixture valueAtRow:0 andColumn:@"description"]], @"Description is not valid");
    STAssertNotNil([_fixture valueAtRow:0 andColumn:kCartoDBColumName_Geom], @"Geometry should be not nil");
    STAssertTrue([[_fixture valueAtRow:0 andColumn:kCartoDBColumName_Geom] isKindOfClass:GeoJSONPoint.class], @"Geometry is not valid");
    
    STAssertNil([_fixture valueAtRow:1 andColumn:nil], @"Item 1 must be nil");
}


- (void)testShouldWorkIfGeoJSONResponseHasNoGeometry
{
    NSString* geojson = @"{\"type\": \"FeatureCollection\",\"features\": [{\"type\": \"Feature\",\"properties\": {\"cartodb_id\": 1, \"name\": \"centro\",\"description\": \"el centro del universo\",\"created_at\": \"2012-06-21T16:56:24.827Z\",\"updated_at\": \"2012-06-21T16:56:46.903Z\"},\"geometry\": \"<null>\"}]}";
    
    _fixture = [[CartoDBResponse alloc] initWithJSON:geojson andFormat:CartoDBResponseFormat_GeoJSON];
    
    STAssertNotNil(_fixture, @"Response can't be nil");
    STAssertEquals(1, _fixture.count, @"Row count is not valid");
    STAssertEqualsWithAccuracy(-1.0, _fixture.time, 0.001, @"Response time is not valid");
    STAssertNotNil([_fixture valueAtRow:0 andColumn:nil], @"Item 0 can't be nil");
    STAssertEquals([NSNumber numberWithInt:1], [_fixture valueAtRow:0 andColumn:kCartoDBColumName_ID], @"ID is not valid");
    STAssertTrue([@"centro" isEqualToString:[_fixture valueAtRow:0 andColumn:@"name"]], @"Name is not valid");
    STAssertTrue([@"el centro del universo" isEqualToString:[_fixture valueAtRow:0 andColumn:@"description"]], @"Description is not valid");
    STAssertTrue([NSNull null] == [_fixture valueAtRow:0 andColumn:kCartoDBColumName_Geom], @"Geom must be nil");
    
    STAssertNil([_fixture valueAtRow:1 andColumn:nil], @"Item 1 must be nil");
}


@end
