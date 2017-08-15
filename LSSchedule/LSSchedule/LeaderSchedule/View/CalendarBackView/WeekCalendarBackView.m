//
//  WeekCalendarBackView.m
//  LSchedule
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "WeekCalendarBackView.h"
#import "LSUtils.h"

@interface WeekCalendarBackView()

/** 存放label的数组 */
@property (nonatomic, strong) NSMutableArray<UILabel*>* labels;
@end

@implementation WeekCalendarBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        self.labels = [NSMutableArray array];
        NSArray* titles = @[@"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00"];
        
        for (int i = 0; i < titles.count; i++) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-40, self.lineSpacing + self.lineSpacing * i, 40, 14)];
            label.textAlignment = NSTextAlignmentRight;
            label.text = titles[i];
            label.textColor = [UIColor colorWithHex:@"333333"];
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            
            [self.labels addObject:label];
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self drawSquare];
    
    for (int i = 0; i < self.labels.count; i++) {
        UILabel* label = self.labels[i];
        label.frame = CGRectMake(-43, self.lineSpacing + self.lineSpacing * i - 7, 40, 14);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
