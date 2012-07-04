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
@synthesize text, result, run, next, prev, spinner;

- (void) viewDidLoad 
{
    [super viewDidLoad];
    
    self.text.text = [NSString stringWithFormat:@"SELECT * FROM %@", kTableWithData]; // <- put your query here 
}

- (void) viewDidUnload
{
    self.text = nil;
    self.result = nil;
    self.run = nil;
    self.prev = nil;
    self.next = nil;
    self.spinner = nil;

    [super viewDidUnload];
}

- (void) queryForPage:(int)page
{
    CartoDBCredentials *credentials = kAPIKey ? [[CartoDBCredentialsApiKey alloc] initWithApiKey:kAPIKey] : [[CartoDBCredentials alloc] init];
    credentials.username = kUser;
    
    CartoDBDataProvider *provider = [[CartoDBDataProviderHTTP alloc] init];
    provider.credentials = credentials;
    provider.page = page;
    [credentials release];
    
    CartoDBClient *client = [[CartoDBClient alloc] init];
    client.provider = provider;
    [provider release];
    client.delegate = self;
    
    self.run.enabled = NO;
    self.prev.enabled = NO;
    self.next.enabled = NO;
    [self.spinner startAnimating];
    
    [client startRequestWithSQL:self.text.text];
}

- (IBAction) runAction
{
    _page = 0;
    [self queryForPage:_page];
}

- (IBAction) nextAction
{
    [self queryForPage:++_page];
}

- (IBAction) prevAction
{
    if (_page > 0) {
        [self queryForPage:--_page];
    }
}




- (void) cartoDBClient:(CartoDBClient*)client receivedResponse:(CartoDBResponse*)response
{
    NSString *columns[] = {kCartoDBColumName_ID, @"name", @"address", @"city", @"url", @"phone", @"type", @"zip", kCartoDBColumName_CreatedAt, kCartoDBColumName_UpdatedAt};
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:response.count * 512];
    
    [str appendFormat:@"CartoDBResponse -> %d rows (page %d)", response.count, _page, nil];
    for (int i = 0; i < response.count; ++i) {
        [str appendFormat:@"\n\t %d ->", i];
        
        for (int j = 0; j < ARRAY_LEN(columns); ++j) {
            [str appendFormat:@"\n\t\t %@ = %@", columns[j], [response valueAtRow:i andColumn:columns[j]]];
        }

        id geometry = [response valueAtRow:i andColumn:kCartoDBColumName_Geom];
        [str appendFormat:@"\n\t\t Geometry = %@", [geometry description]];
    }

    self.result.text = str;
    
    [str release];
    [client release];
    
    [self.spinner stopAnimating];
    self.run.enabled = YES;
    self.prev.enabled = YES;
    self.next.enabled = YES;
}


- (void) cartoDBClient:(CartoDBClient*)client failedWithError:(NSError*)err
{
    self.result.text = [NSString stringWithFormat:@"Error: %@", err];

    [client release];    
    [self.spinner stopAnimating];
    self.run.enabled = YES;
    self.prev.enabled = YES;
    self.next.enabled = YES;
}



@end
