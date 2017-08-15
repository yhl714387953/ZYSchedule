//
//  LSBottomButtonCell.h
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSBottomButtonCell;
@protocol LSBottomButtonCellDelegate <NSObject>

@optional
-(void)bottomButtonCell:(LSBottomButtonCell*)cell clickAtIndex:(NSInteger)buttonIndex;

@end

@interface LSBottomButtonCell : UIView
/** <#description#> */
@property (nonatomic, weak) id<LSBottomButtonCellDelegate> delegate;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@end
