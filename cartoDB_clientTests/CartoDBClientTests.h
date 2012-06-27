//
//  prucartodbTests.h
//  prucartodbTests
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CartoDBClient.h"
#import "CartoDBDataProviderStatic.h"


@interface CartoDBClientTests : SenTestCase<CartoDBClientDelegate>
{
    CartoDBClient *_fixture;
    CartoDBDataProviderStatic *_dataProvider;
    
    CartoDBResponse *_lastResponse;
    NSError *_lastError;
}

@end
