//
//  LSScheduleHUD.m
//  LSchedule
//
//  Created by mac on 2017/8/15.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSScheduleHUD.h"

#import <UIKit/UIKit.h>

/** 显示窗口 */
static UIWindow *_window;
/** 消失 定时器 */
static NSTimer *_timer;
/** 背景视图 */
static UIView *backView;

@implementation LSScheduleHUD

+(void)createWindow{
    _window.hidden = YES;
    _window = [[UIWindow alloc] init];
    _window.backgroundColor = [UIColor clearColor];
    _window.windowLevel = UIWindowLevelAlert;
    _window.frame = CGRectMake(0, 0, 0, 0);
    _window.hidden = NO;
}

+(void)showMessage:(NSString *)message{
    [self showMessage:message postion:LSHUDPostionBottom];
}

+(void)showMessage:(NSString *)message postion:(LSHUDPostion)postion{
    [_timer invalidate];
    _timer = nil;
    
    [self createWindow];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    // 计算文本的宽高
    CGFloat maxWidth = 200;
    NSString* msg = [NSString stringWithFormat:@"%@", message];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName: paragraph};
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(maxWidth, 0) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    CGFloat backViewWidth = rect.size.width + 15;
    CGFloat backViewHeight = rect.size.height + 10;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - backViewWidth) / 2, screenSize.height - backViewHeight - 50, backViewWidth, backViewHeight)];
    
    switch (postion) {
        case LSHUDPostionTop:
            backView.frame = CGRectMake((screenSize.width - backViewWidth) / 2, 50, backViewWidth, backViewHeight);
            break;
            
        case LSHUDPostionMiddle:
            backView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
            break;
            
        default:
            break;
    }
    
    
    backView.layer.cornerRadius = 5;//圆角
    backView.layer.shadowColor = [[UIColor blackColor] CGColor];
    backView.layer.shadowOffset = CGSizeMake(0.5, 0.5f);
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    backView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.center = CGPointMake(backView.frame.size.width / 2.0, backView.frame.size.height / 2.0);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [backView addSubview:label];
    backView.transform = CGAffineTransformScale(backView.transform, 1.25, 1.25);
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         backView.transform = CGAffineTransformScale(backView.transform, 1 / 1.25, 1 / 1.25);
                         backView.alpha = 1;
                     }
                     completion:NULL];
    [_window addSubview:backView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

//隐藏定位成功提示
+ (void)dismiss {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         backView.transform = CGAffineTransformScale(backView.transform, 0.8, 0.8);
                         backView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [backView removeFromSuperview];
                         backView = nil;
                     }];
}

@end
