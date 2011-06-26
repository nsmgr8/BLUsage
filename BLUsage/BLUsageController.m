//
//  BLUsageController.m
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "BLUsageController.h"
#import "BLDetailUsage.h"
#import "BLDailyUsage.h"

#import "GrowlApplicationBridge.h"

@implementation BLUsageController

@synthesize progressIndicator;
@synthesize updateButton;
@synthesize detailView;

@synthesize usageModel;

@synthesize detailUsages;

- (id)init
{
    self = [super init];
    if (self) {
        usageModel = [[BLUsage alloc] initWithController:self];
        root = nil;
        [GrowlApplicationBridge setGrowlDelegate:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [usageModel release];
    [detailUsages release];

    [root release];
    [super dealloc];
}

- (void)startProgress {
    [progressIndicator startAnimation:nil];
    [updateButton setEnabled:NO];
}

- (void)stopProgress {
    [progressIndicator stopAnimation:nil];
    [updateButton setEnabled:YES];
}

- (void)updateUI:(NSDictionary *)data {
    [data retain];

    self.usageModel.accountName = [data objectForKey:@"account"];
    self.usageModel.username = [data objectForKey:@"username"];
    self.usageModel.password = [data objectForKey:@"password"];
    self.usageModel.from = [data objectForKey:@"from"];
    self.usageModel.to = [data objectForKey:@"to"];
    self.usageModel.lastUpdate = [data objectForKey:@"updated_at"];

    if (self.detailUsages) {
        [self.detailUsages release];
    }
    self.detailUsages = [data objectForKey:@"detail"];
    [self buildTree:[data objectForKey:@"detail"]];

    [data release];
    
    [self sendGrowl];

    NSTimeInterval delay = 24 * 60 * 60;
    [self.usageModel performSelector:@selector(startUpdate) withObject:nil afterDelay:delay];
}

- (void)sendGrowl {
    NSInteger totalKB = 0;
    for (BLDailyUsage *d in self.detailUsages) {
        totalKB += [d.dataKB integerValue];
    }
    float totalMB = totalKB / 1024.0, totalGB = totalMB / 1024;
    
    NSDate *start = [[self.detailUsages objectAtIndex:0] date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    
    NSString *desc = [NSString stringWithFormat:@"You have used\n"
                        "\t%0.2f GB or\n"
                        "\t%0.2f MB or\n"
                        "\t%.0f KB\n"
                        "since\n\t%@", totalGB, totalMB, (float)totalKB,
                            [formatter stringFromDate:start]];
    
    [formatter release];

    [GrowlApplicationBridge notifyWithTitle:@"Bangla Lion Usage"
                                description:desc
                           notificationName:@"Usage"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];
}

- (void)buildTree:(NSArray *)data {
    if (root) {
        [root release];
        root = nil;
    }
    root = [[NSTreeNode treeNodeWithRepresentedObject:@"root"] retain];
    for (BLDailyUsage *daily in data) {
        NSTreeNode *childNode = [NSTreeNode treeNodeWithRepresentedObject:daily];
        for (BLDetailUsage *detail in daily.timelyData) {
            NSTreeNode *timeChild = [NSTreeNode treeNodeWithRepresentedObject:detail];
            [[childNode mutableChildNodes] addObject:timeChild];
        }
        [[root mutableChildNodes] addObject:childNode];
    }

    [self.detailView reloadData];
}

- (void)showMessage:(NSString *)msg {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"OK"];
    [alert setInformativeText:msg];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];

}

- (IBAction)expandAll:(id)sender {
    NSButton *button = (NSButton *)sender;
    
    if ([button state]) {
        [self.detailView expandItem:nil expandChildren:YES];
    }
    else {
        [self.detailView collapseItem:nil collapseChildren:YES];
    }
}

- (NSArray *)childrenForItem:(id)item {
    if (item == nil) {
        return [root childNodes];
    } else {
        return [item childNodes];
    }
}

/**
 * Outline datasource methods
 */
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    NSArray *children = [self childrenForItem:item];
    return [children objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return ![[item representedObject] isKindOfClass:[BLDetailUsage class]];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [[self childrenForItem:item] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    id itemrepr = [item representedObject];
    BOOL isDetail = [itemrepr isKindOfClass:[BLDetailUsage class]];

    if ([[tableColumn identifier] isEqualToString:@"date"]) {
        NSDateFormatter *f = [[NSDateFormatter new] autorelease];
        if (isDetail) {
            [f setTimeStyle:NSDateFormatterShortStyle];
            return [f stringFromDate:[(BLDetailUsage *)itemrepr dateUsed]];
        }
        else {
            [f setDateStyle:NSDateFormatterMediumStyle];
            return [f stringFromDate:[(BLDailyUsage *)itemrepr date]];
        }
    }
    else {
        if (isDetail) {
            return [(BLDetailUsage *)itemrepr usedData];
        }
        else {
            return [(BLDailyUsage *)itemrepr dataKB];
        }
    }

    return @"";
}

@end
