//
//  BLDailyUsage.m
//  BLUsage
//
//  Created by Nasimul Haque on 25/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLDailyUsage.h"
#import "BLDetailUsage.h"

@implementation BLDailyUsage

@synthesize date;
@synthesize dataKB;
@synthesize timelyData;

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.timelyData = array;

        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[(BLDetailUsage *)[array objectAtIndex:0] dateUsed]];
        self.date = [gregorian dateFromComponents:dayComponents];
        self.dataKB = [array valueForKeyPath:@"@sum.usedData"];
        [gregorian release];
    }
    return self;
}

- (void)dealloc
{
    [date release];
    [dataKB release];
    [timelyData release];

    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.dataKB forKey:@"data"];
    [aCoder encodeObject:self.timelyData forKey:@"timelyData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.dataKB = [aDecoder decodeObjectForKey:@"data"];
        self.timelyData = [aDecoder decodeObjectForKey:@"timelyData"];
    }
    return self;
}

- (NSString *)description {
    NSDateFormatter *f = [[NSDateFormatter new] autorelease];
    [f setDateStyle:NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"%@ KB on %@", self.dataKB, [f stringFromDate:self.date]];
}

@end
