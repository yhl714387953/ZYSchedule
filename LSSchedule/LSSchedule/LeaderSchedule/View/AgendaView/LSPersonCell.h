//
//  LSPersonCell.h
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPerson.h"
@class LSPersonCell;
@protocol LSPersonCellDelegate <NSObject>

@optional
-(void)personCell:(LSPersonCell*)cell selectLeaderChange:(NSArray<LSLeader*>*)leaders;

@end

@interface LSPersonCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

/** <#description#> */
@property (nonatomic, weak) id<LSPersonCellDelegate> delegate;

@property (strong, nonatomic) UICollectionView *collectionView;

/** <#description#> */
@property (nonatomic, strong) UILabel* label;

/** <#description#> */
@property (nonatomic, strong) UILabel* tipLabel;

/** <#description#> */
@property (nonatomic, strong) UIImageView* tipImageView;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray<LSLeader*>* leaders;

/** <#description#> */
@property (nonatomic, copy) NSString* selectPerson;

@end




@interface PCollectionCell : UICollectionViewCell

/** <#description#> */
@property (nonatomic, strong) UIButton* button;

@end
