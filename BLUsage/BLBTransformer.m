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
