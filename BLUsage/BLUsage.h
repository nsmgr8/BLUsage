//
//  BLUsage.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUsage : NSObject <NSCoding> {
@private
    NSString *accountName;
    NSString *username;
    NSString *password;

    NSDate *from;
    NSDate *to;
    NSDate *lastUpdate;

    NSInteger capacity;
    NSString *remaining;

    NSMutableArray *detailUsages;

    NSDateFormatter *dateFormatter;
    NSMutableData *receivedData;

    BOOL fetching;
    NSString *errorMessage;
}

@property (retain, nonatomic) NSString *accountName;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;

@property (retain, nonatomic) NSDate *from;
@property (retain, nonatomic) NSDate *to;
@property (retain, nonatomic) NSDate *lastUpdate;

@property (assign, nonatomic) NSInteger capacity;
@property (retain, nonatomic) NSString *remaining;

@property (retain) NSMutableArray *detailUsages;

@property (assign, getter = isFetching) BOOL fetching;
@property (assign, nonatomic) NSString *errorMessage;

- (void)copyContent:(BLUsage *)anOther;

- (void)startUpdate;

@end
