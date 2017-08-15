//
//  LSAgendaHeader.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSAgendaHeader.h"

@implementation LSAgendaHeader

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIView* view = [self viewWithTag:1];
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.bottomLineLayout.constant = 0.5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
