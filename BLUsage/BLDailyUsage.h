//
//  BLDailyUsage.h
//  BLUsage
//
//  Created by Nasimul Haque on 25/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLDailyUsage : NSObject <NSCoding> {
@private
    NSDate *date;
    NSNumber *dataKB;
    NSArray *timelyData;
}

@property (retain) NSDate *date;
@property (retain) NSNumber *dataKB;
@property (retain) NSArray *timelyData;

- (id)initWithArray:(NSArray *)array;

@end
