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
    if (self.controller.usageModel.username == nil) {
        [self.accountWindow makeKeyAndOrderFront:nil];
    }
    [self.controller buildTree];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
