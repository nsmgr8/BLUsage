//
//  BLDetailUsage.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLDetailUsage : NSObject <NSCoding> {
@private
    NSDate *dateUsed;
    NSNumber *usedData;
}

@property (retain, nonatomic) NSDate *dateUsed;
@property (retain, nonatomic) NSNumber *usedData;

- (id)initWithArray:(NSArray *)array;

@end
