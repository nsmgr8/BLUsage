//
//  BLUsage.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsage.h"


@implementation BLUsage

@synthesize username;
@synthesize password;

@synthesize from;
@synthesize to;
@synthesize lastUpdate;

@synthesize totalUsage;

- (id)init
{
    self = [super init];
    if (self) {
        dateFormatter = [NSDateFormatter new];
    }
    
    return self;
}

- (void)dealloc
{
    [dateFormatter release];
    [super dealloc];
}

- (NSString*) description {
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    return [NSString stringWithFormat:@"%@ [%@, %@]", self.username, [dateFormatter stringFromDate:self.from], [dateFormatter stringFromDate:self.to], nil];
}

@end
