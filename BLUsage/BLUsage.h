//
//  BLUsage.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLUsageController;

@interface BLUsage : NSObject <NSCoding> {
@private
    NSString *accountName;
    NSString *username;
    NSString *password;

    NSDate *from;
    NSDate *to;
    NSDate *lastUpdate;

    BOOL autoUpdate;
    NSInteger interval;

    NSMutableArray *detailUsages;

    NSDateFormatter *dateFormatter;
    NSMutableData *receivedData;
    BLUsageController *controller;
}

@property (retain, nonatomic) NSString *accountName;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;

@property (retain, nonatomic) NSDate *from;
@property (retain, nonatomic) NSDate *to;
@property (retain, nonatomic) NSDate *lastUpdate;

@property (assign, nonatomic) BOOL autoUpdate;
@property (assign, nonatomic) NSInteger interval;

@property (retain) NSMutableArray *detailUsages;

- (id)initWithController:(BLUsageController *)ctrlr;

- (void)copyContent:(BLUsage *)anOther;

- (void)startUpdate;

@end
