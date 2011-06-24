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
@synthesize detailTableView;

- (id)init
{
    self = [super init];
    if (self) {
        usageModel = [[BLUsage alloc] initWithController:self];
        usageDict = nil;
    }
    
    return self;
}

- (void)dealloc
{
    if (usageDict) {
        [usageDict release];
    }
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
    if (usageDict) {
        [usageDict release];
    }
    usageDict = [data retain];

    [self.totalUsageField setStringValue:[NSString stringWithFormat:@"%@ KB", [usageDict objectForKey:@"total"], nil]];

    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [lastUpdateField setStringValue:[formatter stringFromDate:[NSDate date]]];

    [detailTableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[usageDict objectForKey:@"detail"] count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return [[[usageDict objectForKey:@"detail"] objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
}

@end
