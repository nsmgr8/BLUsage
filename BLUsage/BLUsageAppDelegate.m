//
//  BLUsageAppDelegate.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsageAppDelegate.h"
#import "BLUsageController.h"
#import "BLUsage.h"

@implementation BLUsageAppDelegate

@synthesize window;
@synthesize controller;
@synthesize accountWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.controller.detailDrawer setMinContentSize:NSMakeSize(340, 400)];
    [self.controller.detailDrawer setMaxContentSize:NSMakeSize(340, 40000)];

    if (self.controller.usageModel.username == nil) {
        [self.accountWindow makeKeyAndOrderFront:nil];
    }
    [self.controller buildTree];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
