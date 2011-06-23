//
//  BLUsageController.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLUsageController : NSObject {
@private
    
    NSTextField *usernameField;
    NSSecureTextField *passwordField;

    NSDatePicker *fromDate;
    NSDatePicker *toDate;
    NSTextField *lastUpdateField;
    
    NSTextField *totalUsageField;
}

@property (assign) IBOutlet NSTextField *usernameField;
@property (assign) IBOutlet NSSecureTextField *passwordField;

@property (assign) IBOutlet NSDatePicker *fromDate;
@property (assign) IBOutlet NSDatePicker *toDate;
@property (assign) IBOutlet NSTextField *lastUpdateField;

@property (assign) IBOutlet NSTextField *totalUsageField;

- (IBAction)updateUsage:(id)sender;

@end
