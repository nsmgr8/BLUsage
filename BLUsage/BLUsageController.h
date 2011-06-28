//
//  BLUsageController.h
//  BLUsage
//
//  Created by Nasimul Haque on 24/06/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLUsage;

@interface BLUsageController : NSObject <NSOutlineViewDataSource> {
@private
    
    NSOutlineView *detailView;
    NSDrawer *detailDrawer;
    
    BLUsage *usageModel;

    NSTreeNode *root;
    NSString *archivePath;
    
    BOOL scheduled;
}

@property (assign) IBOutlet NSOutlineView *detailView;
@property (assign) IBOutlet NSDrawer *detailDrawer;

@property (readonly) BLUsage *usageModel;

- (void)updateUI;
- (void)buildTree;
- (void)sendGrowl;
- (void)fetchScheduled;

- (void)showMessage:(NSString *)msg;

- (IBAction)toggleDetail:(id)sender;
- (IBAction)expandAll:(id)sender;

@end
