//
//  UITextView+LSCategory.h
//  LSchedule
//
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITextView (LSCategory)

@end

@interface UITableView (LSSwizzle)

@end


//扩展列表刷新与空数据显示等问题
@interface UITableView (LSDisplayState)

/** 展示菊花和暂无提成提示的背景容器 */
@property (nonatomic, strong) UIView* displayView;

//-(void)startAnimating;
//-(void)stopAnimating;

@end
