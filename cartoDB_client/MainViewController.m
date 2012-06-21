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

    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 1", kTableWithData]; // <- put your query here
    [client startRequestWithSQL:sql];
}


- (void) cartoDBClient:(CartoDBClient*)client receivedResponse:(CartoDBResponse*)response
{
    NSString *columns[7] = {kCartoDBColumName_ID, kCartoDBColumName_Name, kCartoDBColumName_Description, kCartoDBColumName_CreatedAt, kCartoDBColumName_UpdatedAt, kCartoDBColumName_Geom, kCartoDBColumName_GeomWebmercator};
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:256];
    
    [str appendFormat:@"CartoDBResponse -> %d rows", response.count];
    for (int i = 0; i < response.count; ++i) {
        [str appendFormat:@"\n\t %d ->", i];
        
        for (int j = 0; j < ARRAY_LEN(columns); ++j) {
            [str appendFormat:@"\n\t\t %@ = %@", columns[j], [response valueAtRow:i andColumn:columns[j]]];
        }
    }
    NSLog(@"%@", str);
    
    [str release];
    [client release];
}


- (void) cartoDBClient:(CartoDBClient*)client failedWithError:(NSError*)err
{
    NSLog(@"Error");
    [client release];    
}


@end
