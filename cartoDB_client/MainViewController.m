//
//  MainViewController.m
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "macros.h"



static NSString* const kUser = @"examples";
static NSString* const kAPIKey = nil;
static NSString* const kTableWithData = @"nyc_wifi";




@implementation MainViewController
@synthesize text, result;

- (void) viewDidLoad 
{
    [super viewDidLoad];
    
    self.text.text = [NSString stringWithFormat:@"SELECT * FROM %@", kTableWithData]; // <- put your query here 
}

- (IBAction) click
{
    CartoDBCredentials *credentials = kAPIKey ? [[CartoDBCredentialsApiKey alloc] initWithApiKey:kAPIKey] : [[CartoDBCredentials alloc] init];
    credentials.username = kUser;
    
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
    NSString *columns[] = {kCartoDBColumName_ID, @"name", @"address", @"city", @"url", @"phone", @"type", @"zip", kCartoDBColumName_GeomLng,kCartoDBColumName_GeomLat, kCartoDBColumName_CreatedAt, kCartoDBColumName_UpdatedAt};
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:response.count * 512];
    
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
