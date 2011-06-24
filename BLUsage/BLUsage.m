//
//  BLUsage.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsage.h"

#import "GTMStringEncoding.h"

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
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *http_response = (NSHTTPURLResponse *)response;
    NSLog(@"%ld", [http_response statusCode]);
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%@", [NSString stringWithUTF8String:[receivedData bytes]]);

    [connection release];
    [receivedData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    [receivedData release];
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
