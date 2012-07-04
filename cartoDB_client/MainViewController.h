//
//  MainViewController.h
//  cartodb-objectivec-client
//
//  Created by JM on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<CartoDBClientDelegate>
{
    int _page;
}

@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, retain) IBOutlet UITextView *result;

@property (nonatomic, retain) IBOutlet UIButton *run;
@property (nonatomic, retain) IBOutlet UIButton *next;
@property (nonatomic, retain) IBOutlet UIButton *prev;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction) runAction;
- (IBAction) nextAction;
- (IBAction) prevAction;

@end
