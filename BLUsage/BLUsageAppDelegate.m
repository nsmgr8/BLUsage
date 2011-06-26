//
//  BLUsageAppDelegate.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsageAppDelegate.h"

@implementation BLUsageAppDelegate

@synthesize window;
@synthesize controller;
@synthesize detailWindow;
@synthesize accountWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([self.controller.usageModel loadData] == NO) {
        [self.accountWindow makeKeyAndOrderFront:nil];
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *monthComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];

        [monthComponents setDay:1];
        self.controller.usageModel.from = [gregorian dateFromComponents:monthComponents];

        [monthComponents setDay:30];
        self.controller.usageModel.to = [gregorian dateFromComponents:monthComponents];
        [gregorian release];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
