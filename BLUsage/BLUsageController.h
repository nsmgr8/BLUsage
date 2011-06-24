//
//  BLUsageController.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLUsage.h"


@interface BLUsageController : NSObject <NSTableViewDataSource> {
@private
    
    NSTextField *usernameField;
    NSSecureTextField *passwordField;

    NSDatePicker *fromDate;
    NSDatePicker *toDate;
    NSTextField *lastUpdateField;
    
    NSTextField *totalUsageField;
    NSTableView *detailTableView;
    NSProgressIndicator *progressIndicator;
    NSButton *updateButton;
    
    BLUsage *usageModel;
    NSDictionary *usageDict;
}

@property (assign) IBOutlet NSTextField *usernameField;
@property (assign) IBOutlet NSSecureTextField *passwordField;

@property (assign) IBOutlet NSDatePicker *fromDate;
@property (assign) IBOutlet NSDatePicker *toDate;
@property (assign) IBOutlet NSTextField *lastUpdateField;

@property (assign) IBOutlet NSTextField *totalUsageField;
@property (assign) IBOutlet NSTableView *detailTableView;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSButton *updateButton;

@property (readonly) BLUsage *usageModel;

- (IBAction)updateUsage:(id)sender;

- (void)updateUI:(NSDictionary *)data;

- (void)startProgress;
- (void)stopProgress;

@end
