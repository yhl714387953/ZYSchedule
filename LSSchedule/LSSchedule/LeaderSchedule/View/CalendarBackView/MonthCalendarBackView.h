//
//  MonthCalendarBackView.h
//  LSchedule
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCalendarBackView : UIView

/** 起始Y位置 */
@property (nonatomic) CGFloat startX;

/** 起始Y位置 */
@property (nonatomic) CGFloat startY;

/** 行间距 */
@property (nonatomic) CGFloat lineSpacing;
/** 行个数 */
@property (nonatomic) CGFloat lineCount;

/** 列间距 */
@property (nonatomic) CGFloat columnSpacing;
/** 列个数 */
@property (nonatomic) CGFloat columnCount;

-(void)drawSquare;

@end
