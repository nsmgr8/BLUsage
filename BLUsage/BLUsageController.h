//
//  BLUsageController.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLUsage.h"


@interface BLUsageController : NSObject <NSOutlineViewDataSource> {
@private
    
    NSProgressIndicator *progressIndicator;
    NSButton *updateButton;
    NSOutlineView *detailView;
    
    BLUsage *usageModel;

    NSMutableArray *detailUsages;
    NSTreeNode *root;
}

@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSButton *updateButton;
@property (assign) IBOutlet NSOutlineView *detailView;

@property (readonly) BLUsage *usageModel;

@property (retain) NSMutableArray *detailUsages;

- (void)updateUI:(NSDictionary *)data;
- (void)buildTree:(NSArray *)data;
- (void)sendGrowl;

- (void)startProgress;
- (void)stopProgress;

- (void)showMessage:(NSString *)msg;
- (IBAction)expandAll:(id)sender;

@end
