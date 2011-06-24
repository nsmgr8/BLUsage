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
        usageModel = [[BLUsage alloc] initWithController:self];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)updateUsage:(id)sender {
    usageModel.username = self.usernameField.stringValue;
    usageModel.password = self.passwordField.stringValue;
    usageModel.from = [self.fromDate dateValue];
    usageModel.to = [self.toDate dateValue];
    
    [usageModel startUpdate];
}

- (void)updateUI:(NSDictionary *)data {
    NSLog(@"%@", data);
    [self.totalUsageField setStringValue:[NSString stringWithFormat:@"%@ KB", [data objectForKey:@"total"], nil]];
}

@end
