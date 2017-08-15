//
//  MonthCalendarBackView.m
//  LSchedule
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "MonthCalendarBackView.h"

@interface MonthCalendarBackView()

/** <#description#> */
@property (nonatomic, strong) NSMutableArray<CALayer*>* userLayers;

@end

@implementation MonthCalendarBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startX = 0;
        self.startY = 0;
        self.lineSpacing = 0;
        self.columnSpacing = 0;
        
        self.lineCount = 0;
        self.columnCount = 0;
        self.backgroundColor = [UIColor clearColor];
        self.userLayers = [NSMutableArray array];
        
//        [self drawSquare];
    }
    
    return self;
}



-(void)drawSquare{
    
     for (CALayer* layer in self.userLayers) {
         [layer removeFromSuperlayer];
     }
    
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //    画横线
    for (int i = 0; i < self.lineCount + 1; i++) {
        CGPathMoveToPoint(pathRef, NULL, self.startX, self.lineSpacing * i + self.startY);
        CGPathAddLineToPoint(pathRef, NULL, self.frame.size.width, self.lineSpacing * i + self.startY);
    }
    
    //    画竖线
    for (int i = 0; i < self.columnCount + 1; i++) {
        CGPathMoveToPoint(pathRef, NULL, self.columnSpacing * i + self.startX, self.startY);
        CGPathAddLineToPoint(pathRef, NULL, self.columnSpacing * i + self.startX, self.lineCount * self.lineSpacing + self.startY);
    }
    
    CAShapeLayer* shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    shaperLayer.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    //    shaperLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    shaperLayer.lineWidth = 0.5f;
    shaperLayer.lineCap = kCALineCapButt;
    
    shaperLayer.path = pathRef;
    
    //    背景的layer要放在最底层
    [self.layer insertSublayer:shaperLayer atIndex:0];
    
    
    CALayer* backLayer = [CALayer layer];
    backLayer.frame = CGRectMake(0, self.startY, self.frame.size.width, self.frame.size.height + 100);
    backLayer.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1].CGColor;
    [self.layer insertSublayer:backLayer below:shaperLayer];
    
    [self.userLayers addObject:shaperLayer];
    [self.userLayers addObject:backLayer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
