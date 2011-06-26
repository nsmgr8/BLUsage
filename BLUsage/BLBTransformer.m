//
//  BLMBTransformer.m
//  BLUsage
//
//  Created by Nasimul Haque on 26/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLBTransformer.h"


@implementation BLMBTransformer

- (id)transformedValue:(id)value {
    float kb = [(NSNumber *)value floatValue];
    return [NSNumber numberWithFloat:kb/1024];
}

@end

@implementation BLGBTransformer

- (id)transformedValue:(id)value {
    float kb = [(NSNumber *)value floatValue];
    return [NSNumber numberWithFloat:kb/(1024*1024)];
}

@end

@implementation BLBTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

- (id)transformedValue:(id)value {
    float kb = [(NSNumber *)value floatValue];

    NSNumber *transformedValue = nil;
    NSString *unit = nil;
    
    if (kb < 1500) {
        transformedValue = value;
        unit = @"KB";
    }
    else if (kb < 1500000) {
        transformedValue = [NSNumber numberWithFloat:kb/1024];
        unit = @"MB";
    }
    else {
        transformedValue = [NSNumber numberWithFloat:kb/(1024*1024)];
        unit = @"GB";
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter new] autorelease];
    [f setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setFormat:@"#,##0.00"];

    return [NSString stringWithFormat:@"%@ %@", [f stringFromNumber:transformedValue], unit];
}

@end
