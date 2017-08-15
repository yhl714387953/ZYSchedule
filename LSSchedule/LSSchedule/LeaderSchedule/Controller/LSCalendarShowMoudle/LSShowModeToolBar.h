//
//  LSShowModeToolBar.h
//  LSchedule
//
//  Created by 3dprint on 2017/6/13.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSShowModeToolBar;

//显示模式
typedef NS_ENUM(NSUInteger,LSShowModeType){
    LSShowMode_ListShow = 0,           // 列表显示
    LSShowMode_MothShow,               // 按月显示
    LSShowMode_WeekShow,               // 按周显示
    LSShowMode_Filter
};

@protocol LSShowModeToolBarDelegate <NSObject>

@optional
- (void)conferenceToolBar:(NSArray *)btnArray
              clickButton:(UIButton *)button
               buttonType:(LSShowModeType)type;

@end

@interface LSShowModeToolBar : UIView

@property (nonatomic, weak) id<LSShowModeToolBarDelegate> delegate;

@property (nonatomic, readonly, strong) NSArray<UIButton *> *buttons; // 按钮数组

/** 过滤的关键字 */
@property (nonatomic, copy) NSString* filter;


@end
