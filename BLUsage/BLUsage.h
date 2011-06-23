//
//  BLUsage.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLUsage : NSObject {
@private
    NSString *username;
    NSString *password;
    
    NSDate *from;
    NSDate *to;
    NSDate *lastUpdated;
    
    int totalUsage;
}

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;

@property (retain, nonatomic) NSDate *from;
@property (retain, nonatomic) NSDate *to;
@property (retain, nonatomic) NSDate *lastUpdate;

@property (readwrite) int totalUsage;

@end
