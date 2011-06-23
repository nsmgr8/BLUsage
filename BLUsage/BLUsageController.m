//
//  BLUsageController.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsageController.h"


@implementation BLUsageController

@synthesize usernameField;
@synthesize passwordField;

@synthesize fromDate;
@synthesize toDate;
@synthesize lastUpdateField;

@synthesize totalUsageField;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)updateUsage:(id)sender {
}

@end
