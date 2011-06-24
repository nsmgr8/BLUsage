//
//  BLUsageAppDelegate.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BLUsageController.h"

@interface BLUsageAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    BLUsageController *controller;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet BLUsageController *controller;

@end
