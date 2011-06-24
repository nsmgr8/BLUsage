//
//  BLUsage.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsage.h"
#import "BLUsageController.h"

#import "GTMStringEncoding.h"

@implementation BLUsage

@synthesize username;
@synthesize password;

@synthesize from;
@synthesize to;

- (id)init
{
    self = [super init];
    if (self) {
        dateFormatter = [NSDateFormatter new];
        plistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@".BLUsage.plist"] retain];
    }
    
    return self;
}

- (id)initWithController:(BLUsageController *)ctrlr {
    self = [self init];
    if (self) {
        controller = ctrlr;
    }
    return self;
}

- (void)dealloc
{
    [dateFormatter release];
    [plistPath release];
    [super dealloc];
}

- (NSString*) description {
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    return [NSString stringWithFormat:@"%@ [%@, %@]", self.username, [dateFormatter stringFromDate:self.from], [dateFormatter stringFromDate:self.to], nil];
}

- (BOOL)loadData {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (dict) {
        [controller updateUI:dict];
        return YES;
    }
    return NO;
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
        [controller startProgress];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *http_response = (NSHTTPURLResponse *)response;
    if ([http_response statusCode] != 200) {
        [connection cancel];
        [controller stopProgress];
        [controller showMessage:@"Cannot get data. Please check your credentials."];
    }
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [controller stopProgress];
    NSString *html = [NSString stringWithUTF8String:[receivedData bytes]];
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:html options:NSXMLDocumentTidyHTML error:nil];
    NSXMLNode *node = [[doc nodesForXPath:@"/html/body//table" error:nil] objectAtIndex:14];
    NSArray *trs = [node nodesForXPath:@"./tr" error:nil];
    NSRange range = {1, [trs count] - 2};
    NSArray *chunk_trs = [trs subarrayWithRange:range];
    NSMutableArray *data = [NSMutableArray array];
    range.location = 2;
    range.length = 3;
    NSArray *keys = [NSArray arrayWithObjects:@"Date", @"Time", @"Data", nil];
    for(NSXMLNode *tr in chunk_trs) {
        NSArray *elements = [tr nodesForXPath:@"./td" error:nil];
        NSArray *temp = [elements subarrayWithRange:range];
        NSMutableArray *row = [NSMutableArray array];
        for(NSXMLNode *n in temp) {
            [row addObject:[n stringValue]];
        }
        [data addObject:[NSDictionary dictionaryWithObjects:row forKeys:keys]];
    }

    NSString *total = [[[[trs lastObject] nodesForXPath:@"./td" error:nil] lastObject] stringValue];
    NSDictionary *usage = [NSDictionary dictionaryWithObjectsAndKeys:data, @"detail",
                           total, @"total", [NSDate date], @"updated_at", self.username, @"username",
                           self.password, @"password", self.from, @"from", self.to, @"to", nil];

    [usage writeToFile:plistPath atomically:YES];    
    [controller updateUI:usage];
    
    [connection release];
    [receivedData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [controller stopProgress];
    [connection release];
    [receivedData release];
    [controller showMessage:[error localizedDescription]];
    NSLog(@"%@", error);
}


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
