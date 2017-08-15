//
//  LSFilterViewController.h
//  LSchedule
//
//  Created by 3dprint on 2017/6/21.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSViewController.h"

@class LSLeader;
@class LSFilterViewController;
@protocol LSFilterViewControllerDelegate <NSObject>

@optional

-(void)filterViewController:(LSFilterViewController*)filterViewController didSelectLeaers:(NSArray<LSLeader*>*)leaders;

@end

@interface LSFilterViewController : LSViewController

@property (nonatomic, weak) id<LSFilterViewControllerDelegate> delegate;

/** 选中数组 */
@property (nonatomic, strong) NSArray<LSLeader*>* selectLeaders;

@end
