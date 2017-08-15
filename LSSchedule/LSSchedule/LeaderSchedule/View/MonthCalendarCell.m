//
//  MonthCalendarCell.m
//  LSchedule
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "MonthCalendarCell.h"
#import "Masonry.h"
#import "LSUtils.h"
#import "LSPerson.h"

@interface MonthCalendarCell()

/** layer数组 */
@property (nonatomic, strong) NSMutableArray<CALayer*>* leaderLayers;

@end

@implementation MonthCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leaderLayers = [NSMutableArray array];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height / 2.0);
    
    NSArray* leaders = [LSLeader queryLeaders];
    
    if (self.leaderLayers.count != leaders.count) {
        [self createLayers:leaders.count];
    }
    
    for (int i = 0; i < leaders.count; i++) {
        LSLeader* leader = leaders[i];
        CALayer* layer = self.leaderLayers[i];
        layer.backgroundColor = [UIColor colorWithHex:leader.color].CGColor;
        
        CGFloat space = self.contentView.frame.size.width / 15.0f;
        CGFloat width = (self.contentView.frame.size.width - (leaders.count + 1) * space) / leaders.count;
        CGFloat height = self.contentView.frame.size.height / 2.0;
        
        layer.frame = CGRectMake(space + i * (width + space), height, width, height - 0.5);
    
        if (self.showLeaderIDs.count == 0) {//筛选条件为空
            layer.hidden = YES;
        }else{
            layer.hidden = ![self.showLeaderIDs containsObject:leader.userId];
        }
    }
}

-(void)createLayers:(NSInteger)count{
    
    for (CALayer* layer in self.leaderLayers) {
        [layer removeFromSuperlayer];
    }
    
    [self.leaderLayers removeAllObjects];
    
    for (int i = 0; i < count; i++) {
        CALayer* layer = [CALayer layer];
        layer.hidden = YES;
        CGFloat width = 5;
        CGFloat height = self.contentView.frame.size.height / 2.0;
        
        layer.frame = CGRectMake(5 + i * (width + 5), height, 5, height);
        [self.contentView.layer addSublayer:layer];
        [self.leaderLayers addObject:layer];
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
