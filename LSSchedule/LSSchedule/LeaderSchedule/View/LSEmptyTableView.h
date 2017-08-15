//
//  LSEmptyTableView.h
//  LSchedule
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSDisplayState) {
    LSDisplayStateDefault,
    LSDisplayStateLoading,
    LSDisplayStateEmpty
};

@interface LSEmptyTableView : UITableView

/** 展示菊花和暂无提成提示的背景容器 */
@property (nonatomic, strong) UIView* displayView;

/** <#description#> */
@property (nonatomic, strong) UIButton* button;

-(void)startAnimating;
-(void)stopAnimating;

@end
