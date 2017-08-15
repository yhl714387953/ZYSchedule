//
//  UIButton+LSCategory.h
//  LSchedule
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LSCategory)

@end

@interface UIButton (ESubmit)

/** 加载进度菊花 */
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;


-(void)startAnimating;
-(void)stopAnimating;
@end



typedef NS_ENUM(NSInteger, ZYButtonImagePosition) {
    
    ZYButtonImagePositionLeft,
    ZYButtonImagePositionRight,
    ZYButtonImagePositionTop,
    ZYButtonImagePositionBottom
};

@interface UIButton (EPlaceContent)

/**
 重新摆放按钮的image和label  注意调用时机，按钮的大小确定之后再去调用，布局前要确保图片文字都充分展示全
 
 @param position 图片的位置
 @param space 图片和文字之间的距离
 */
-(void)placeImageTitlePosition:(ZYButtonImagePosition)position space:(CGFloat)space;

@end
