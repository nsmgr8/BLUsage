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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *monthComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];

    [monthComponents setDay:1];
    [self.controller.fromDate setDateValue:[gregorian dateFromComponents:monthComponents]];

    [monthComponents setDay:30];
    [self.controller.toDate setDateValue:[gregorian dateFromComponents:monthComponents]];
}

@end
