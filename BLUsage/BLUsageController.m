//
//  BLUsageController.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsageController.h"
#import "BLDetailUsage.h"

@implementation BLUsageController

@synthesize progressIndicator;
@synthesize updateButton;

@synthesize usageModel;

@synthesize detailUsages;

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
    [usageModel release];
    [detailUsages release];

    [super dealloc];
}

- (void)startProgress {
    [progressIndicator startAnimation:nil];
    [updateButton setEnabled:NO];
}

- (void)stopProgress {
    [progressIndicator stopAnimation:nil];
    [updateButton setEnabled:YES];
}

- (void)updateUI:(NSDictionary *)data {
    [data retain];

    self.usageModel.username = [data objectForKey:@"username"];
    self.usageModel.password = [data objectForKey:@"password"];
    self.usageModel.from = [data objectForKey:@"from"];
    self.usageModel.to = [data objectForKey:@"to"];
    self.usageModel.lastUpdate = [data objectForKey:@"updated_at"];

    if (self.detailUsages) {
        [self.detailUsages release];
    }
    self.detailUsages = [NSMutableArray arrayWithArray:[data objectForKey:@"detail"]];

    [data release];
}

- (void)showMessage:(NSString *)msg {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"OK"];
    [alert setInformativeText:msg];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];

}

@end
