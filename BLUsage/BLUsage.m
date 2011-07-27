//
//  BLUsage.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsage.h"
#import "BLDetailUsage.h"
#import "BLDailyUsage.h"

#import "GTMStringEncoding.h"

@implementation BLUsage

@synthesize accountName;
@synthesize username;
@synthesize password;

@synthesize from;
@synthesize to;
@synthesize lastUpdate;

@synthesize capacity;
@synthesize remaining;

@synthesize detailUsages;

@synthesize fetching;
@synthesize errorMessage;

- (id)init
{
    self = [super init];
    if (self) {
        self.username = nil;
        self.fetching = NO;
        self.capacity = 0;
        self.remaining = @"Unlimited";
        self.detailUsages = [NSMutableArray array];
        
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd/MM/YYYY"];

        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *monthComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        
        [monthComponents setDay:1];
        self.from = [gregorian dateFromComponents:monthComponents];
        
        [monthComponents setDay:30];
        self.to = [gregorian dateFromComponents:monthComponents];
        [gregorian release];
        
        [self addObserver:self forKeyPath:@"detailUsages" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"capacity" options:0 context:NULL];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.accountName = [aDecoder decodeObjectForKey:@"account"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];

        self.from = [aDecoder decodeObjectForKey:@"from"];
        self.to = [aDecoder decodeObjectForKey:@"to"];
        self.lastUpdate = [aDecoder decodeObjectForKey:@"lastupdate"];
        
        self.detailUsages = [aDecoder decodeObjectForKey:@"detail"];
        
        self.capacity = [[aDecoder decodeObjectForKey:@"capacity"] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accountName forKey:@"account"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];

    [aCoder encodeObject:self.from forKey:@"from"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.lastUpdate forKey:@"lastupdate"];

    [aCoder encodeObject:self.detailUsages forKey:@"detail"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.capacity] forKey:@"capacity"];
}

- (void)dealloc
{
    [accountName release];
    [username release];
    [password release];

    [from release];
    [to release];
    [lastUpdate release];

    [detailUsages release];
    [remaining release];

    [dateFormatter release];

    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"detailUsages"] || [keyPath isEqualToString:@"capacity"]) {
        if (self.remaining) {
            [remaining release];
        }
        
        if (self.capacity == 0) {
            self.remaining = @"Unlimited";
            return;
        }
        
        NSInteger total = 0;
        for (BLDailyUsage *daily in self.detailUsages) {
            total += [daily.dataKB integerValue];
        }
        
        float rem = self.capacity - total;
        NSString *unit = nil;
        if (fabs(rem) < 1500) {
            unit = @"KB";
        }
        else if (fabs(rem) < 1500000) {
            rem /= 1024;
            unit = @"MB";
        }
        else {
            rem /= 1024 * 1024;
            unit = @"GB";
        }
        self.remaining = [NSString stringWithFormat:@"%0.2f %@", rem, unit];
    }
}


- (void)copyContent:(BLUsage *)anOther {
    self.accountName = anOther.accountName;
    self.username = anOther.username;
    self.password = anOther.password;
    
    self.from = anOther.from;
    self.to = anOther.to;
    self.lastUpdate = anOther.lastUpdate;
    
    self.detailUsages = anOther.detailUsages;
    self.capacity = anOther.capacity;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ [%@, %@]", self.username, [dateFormatter stringFromDate:self.from], [dateFormatter stringFromDate:self.to], nil];
}

- (void)startUpdate {
    NSURL *url = [NSURL URLWithString:@"https://care.banglalionwimax.com/User"];
    NSString *postString = [NSString stringWithFormat:@"Page=UsrSesHit&Title=Session Calls&UserID=%@&StartDate=%@&EndDate=%@&Submit=Submit", self.username, [dateFormatter stringFromDate:self.from], [dateFormatter stringFromDate:self.to], nil];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self username], [self password]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [coder encode:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection) {
        receivedData = [[NSMutableData data] retain];
        [connection start];
        self.fetching = YES;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *http_response = (NSHTTPURLResponse *)response;
    if ([http_response statusCode] != 200) {
        [connection cancel];
        self.fetching = NO;
        self.errorMessage = @"Cannot get data. Please check your credentials.";
    }
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.fetching = NO;
    
    NSString *html = [NSString stringWithUTF8String:[receivedData bytes]];
    if (!html) {
        self.errorMessage = @"Couldn't get any data. Please try again later.";
        return;
    }
    NSError *error = nil;
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:html options:NSXMLDocumentTidyHTML error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    // Find the table listing the usage data
    NSXMLNode *node = [[doc nodesForXPath:@"/html/body//table" error:nil] objectAtIndex:14];
    // Get all the rows from the table
    NSArray *trs = [node nodesForXPath:@"./tr" error:nil];
    // Ignore first (header) and last (total) row
    NSRange range = {1, [trs count] - 2};
    NSArray *chunk_trs = [trs subarrayWithRange:range];
    
    NSMutableArray *data = [NSMutableArray array];
    // We are only intersted in the last three columns
    range.location = 2;
    range.length = 3;
    for(NSXMLNode *tr in chunk_trs) {
        NSArray *columns = [tr nodesForXPath:@"./td" error:nil];
        NSArray *cols = [columns subarrayWithRange:range];
        [data addObject:[[[BLDetailUsage alloc] initWithArray:cols] autorelease]];
    }
    
    NSMutableArray *groupedData = [NSMutableArray array];
    while ([data count]) {
        BLDetailUsage *day = [data objectAtIndex:0];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dayString = %@", day.dayString, nil];
        NSArray *daily = [data filteredArrayUsingPredicate:predicate];
        [groupedData addObject:daily];
        [data removeObjectsInArray:daily];
    }
    
    [data removeAllObjects];
    for (NSArray *a in groupedData) {
        [data addObject:[[[BLDailyUsage alloc] initWithArray:a] autorelease]];
    }

    if (self.detailUsages) {
        [self.detailUsages release];
    }
    self.detailUsages = data;
    

    self.lastUpdate = [NSDate date];

    [doc release];
    [connection release];
    [receivedData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.fetching = NO;
    [connection release];
    [receivedData release];
    self.errorMessage = [error localizedDescription];
    NSLog(@"%@", error);
}

/** We need to accept the unknown-untrusted certificate for the HTTPS **/
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
