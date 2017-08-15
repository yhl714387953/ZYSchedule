//
//  LSPersonFilterCell.h
//  LSchedule
//
//  Created by 3dprint on 2017/6/22.
//  Copyright © 2017年 zuiye. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LSPerson.h"
@class LSPersonFilterCell;
@protocol LSPersonFilterCellDelegate <NSObject>

@optional

-(void)personFilterCell:(LSPersonFilterCell*)cell didSelectLeaders:(NSArray<LSLeader*>*)leaders;

@end

@interface LSPersonFilterCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

/** <#description#> */
@property (nonatomic, weak) id<LSPersonFilterCellDelegate> delegate;

@property (strong, nonatomic) UICollectionView *collectionView;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray<LSLeader*>* leaders;

/** 人员id 字符串 */
@property (nonatomic, copy) NSString* selectPerson;

@property (nonatomic, strong) NSSet* filterLeaderNames;


@end



@interface PCollectionFilterCell : UICollectionViewCell

/** <#description#> */
@property (nonatomic, strong) UIButton* button;

/** 颜色标记的layer */
@property (nonatomic, strong) CAShapeLayer *colorMarkLayer;


@end

