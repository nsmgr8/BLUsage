//
//  BLUsageController.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLUsage.h"


@interface BLUsageController : NSObject {
@private
    
    NSProgressIndicator *progressIndicator;
    NSButton *updateButton;
    
    BLUsage *usageModel;

    NSMutableArray *detailUsages;
}

@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSButton *updateButton;

@property (readonly) BLUsage *usageModel;

@property (retain) NSMutableArray *detailUsages;

- (void)updateUI:(NSDictionary *)data;

- (void)startProgress;
- (void)stopProgress;

- (void)showMessage:(NSString *)msg;

@end
