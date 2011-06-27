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
    
    NSProgressIndicator *progressIndicator;
    NSButton *updateButton;
    NSOutlineView *detailView;
    
    BLUsage *usageModel;

    NSTreeNode *root;
    NSString *archivePath;
}

@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSButton *updateButton;
@property (assign) IBOutlet NSOutlineView *detailView;

@property (readonly) BLUsage *usageModel;

- (void)updateUI;
- (void)buildTree;
- (void)sendGrowl;

- (void)startProgress;
- (void)stopProgress;

- (void)showMessage:(NSString *)msg;
- (IBAction)expandAll:(id)sender;

@end
