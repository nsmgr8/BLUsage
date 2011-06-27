//
//  main.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    id pool = [NSAutoreleasePool new];

    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *logPath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Logs/%@.log", appName];

    freopen([logPath fileSystemRepresentation], "a", stderr);

    [pool release];

    return NSApplicationMain(argc, (const char **)argv);
}
