//
//  BLUsage.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLUsageController;

@interface BLUsage : NSObject {
@private
    NSString *username;
    NSString *password;
    
    NSDate *from;
    NSDate *to;
    
    NSDateFormatter *dateFormatter;
    NSMutableData *receivedData;
    BLUsageController *controller;
    
    NSString *plistPath;
}

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;

@property (retain, nonatomic) NSDate *from;
@property (retain, nonatomic) NSDate *to;

- (id)initWithController:(BLUsageController *)ctrlr;

- (BOOL)loadData;
- (void)startUpdate;

@end
