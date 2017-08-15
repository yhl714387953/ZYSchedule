//
//  LSShowViewController.h
//  LSchedule
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSShowViewController : UIViewController

/** 用户自定义view  frame相对容器视图 */
@property (nonatomic, strong) UIView* customView;

/** showBlock */
@property (nonatomic, copy) void (^showBlock)(LSShowViewController* viewConntroller, UIView* containerView);
/** hideBlock */
@property (nonatomic, copy) void (^hideBlock)(LSShowViewController* viewConntroller, UIView* containerView);

/** 是否禁止触摸蒙层消失视图 默认NO*/
@property (nonatomic) BOOL disabledBackTouchDismiss;

/**
 隐藏并且dismiss
 */
-(void)hideContainerView;


@end
