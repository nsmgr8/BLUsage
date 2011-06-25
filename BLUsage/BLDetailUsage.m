//
//  BLDetailUsage.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLDetailUsage.h"


@implementation BLDetailUsage

@synthesize dateUsed;
@synthesize usedData;

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        NSString *date = [[array objectAtIndex:0] stringValue];
        NSString *time = [[array objectAtIndex:1] stringValue];
        NSString *data = [[array objectAtIndex:2] stringValue];
        
        NSNumberFormatter *numFormatter = [NSNumberFormatter new];
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSRange range = {0, 2};
        NSNumber *day = [numFormatter numberFromString:[date substringWithRange:range]];
        
        range.location = 3;
        NSNumber *month = [numFormatter numberFromString:[date substringWithRange:range]];
        
        range.location = 6;
        range.length = 4;
        NSNumber *year = [numFormatter numberFromString:[date substringWithRange:range]];
        
        range.location = 0;
        range.length = 2;
        NSNumber *hour = [numFormatter numberFromString:[time substringWithRange:range]];
        
        range.location = 3;
        NSNumber *minute = [numFormatter numberFromString:[time substringWithRange:range]];
        
        NSDateComponents *components = [NSDateComponents new];
        [components setMinute:[minute intValue]];
        [components setHour:[hour intValue]];
        [components setDay:[day intValue]];
        [components setMonth:[month intValue]];
        [components setYear:[year intValue]];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.dateUsed = [gregorian dateFromComponents:components];
        
        self.usedData = [numFormatter numberFromString:data];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)description {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"%@ KB on %@", self.usedData, [formatter stringFromDate:self.dateUsed], nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.usedData forKey:@"usedData"];
    [aCoder encodeObject:self.dateUsed forKey:@"dateUsed"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.dateUsed = [[aDecoder decodeObjectForKey:@"dateUsed"] retain];
        self.usedData = [[aDecoder decodeObjectForKey:@"usedData"] retain];
    }
    return self;
}


@end
