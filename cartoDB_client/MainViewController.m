//
//  MainViewController.m
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "macros.h"

#import "../cartoDB_clientTests/YourData.h"


@implementation MainViewController
@synthesize text, result;

- (void) viewDidLoad 
{
    [super viewDidLoad];
    
    self.text.text = [NSString stringWithFormat:@"SELECT * FROM %@", kTableWithData]; // <- put your query here 
}

- (IBAction) click
{
    CartoDBCredentialsApiKey *credentials = [[CartoDBCredentialsApiKey alloc] init];
    credentials.username = kUser;
    credentials.apiKey = kAPIKey;
    
    CartoDBDataProvider *provider = [[CartoDBDataProviderHTTP alloc] init];
    provider.credentials = credentials;
    [credentials release];
    
    CartoDBClient *client = [[CartoDBClient alloc] init];
    client.provider = provider;
    [provider release];
    client.delegate = self;

    [client startRequestWithSQL:self.text.text];
}


- (void) cartoDBClient:(CartoDBClient*)client receivedResponse:(CartoDBResponse*)response
{
    NSString *columns[] = {kCartoDBColumName_ID, kCartoDBColumName_Name, kCartoDBColumName_Description, kCartoDBColumName_CreatedAt, kCartoDBColumName_UpdatedAt, kCartoDBColumName_GeomLng,kCartoDBColumName_GeomLat};
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:256];
    
    [str appendFormat:@"CartoDBResponse -> %d rows", response.count];
    for (int i = 0; i < response.count; ++i) {
        [str appendFormat:@"\n\t %d ->", i];
        
        for (int j = 0; j < ARRAY_LEN(columns); ++j) {
            [str appendFormat:@"\n\t\t %@ = %@", columns[j], [response valueAtRow:i andColumn:columns[j]]];
        }

        CartoDBGeomType type = [[response valueAtRow:i andColumn:kCartoDBColumName_GeomType] intValue];
        [str appendFormat:@"\n\t\t %@ = %@", kCartoDBColumName_GeomType, NSStringFromGeomType(type)];
    }

    self.result.text = str;
    
    [str release];
    [client release];
}


- (void) cartoDBClient:(CartoDBClient*)client failedWithError:(NSError*)err
{
    NSLog(@"Error");
    [client release];    
}


- (void) dealloc
{
    [self.text release];
    [self.result release];
    [super dealloc];
}


@end
