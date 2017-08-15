//
//  WeekEventCell.m
//  LSchedule
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "WeekEventCell.h"
#import "LSPerson.h"
#import "LSUtils.h"

@interface WeekEventCell()

/** layer数组 */
@property (nonatomic, strong) NSMutableArray<LeaderLayer*>* leaderLayers;

@end

@implementation WeekEventCell

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

    NSArray* leaders = [LSLeader queryLeaders];
    
    if (self.leaderLayers.count != leaders.count) {
        [self createLayers:leaders.count];
    }
    
    for (int i = 0; i < leaders.count; i++) {
        LSLeader* leader = leaders[i];
        LeaderLayer* layer = self.leaderLayers[i];

        CGFloat space = self.contentView.frame.size.width / 6.0f;
        CGFloat width = (self.contentView.frame.size.width - (leaders.count + 1) * space) / leaders.count;
        
        CGFloat leftRight = self.contentView.frame.size.width * 0.27;
        space = (self.contentView.frame.size.width - 2 * leftRight) / 4;
        width = 2.0f;//现在固定了，呵呵
        CGFloat height = self.contentView.frame.size.height;
        
//        layer.frame = CGRectMake(space + i * (width + space), 0, width, height - 0.5);
        //现在改了，呵呵
        layer.frame = CGRectMake(leftRight + i * space - 1, 0, width, height - 0.5);
        
        if (self.showLeaderIDs.count == 0) {//筛选条件为空
            layer.hidden = YES;
        }else{
            layer.hidden = ![self.showLeaderIDs containsObject:leader.userId];
        }
        
//        layer.hidden = NO;
        
        if (!layer.isHidden) {
            [layer drawEventsPoints:[self createPointsUserId:leader.userId] color:[UIColor colorWithHex:leader.color]];
        }
        
        
    }
}

-(void)createLayers:(NSInteger)count{
    
    for (CALayer* layer in self.leaderLayers) {
        [layer removeFromSuperlayer];
    }
    
    [self.leaderLayers removeAllObjects];
    
    for (int i = 0; i < count; i++) {
        LeaderLayer* layer = [LeaderLayer layer];
        layer.hidden = YES;
        CGFloat width = 5;
        CGFloat height = self.contentView.frame.size.height / 2.0;
        
        layer.frame = CGRectMake(5 + i * (width + 5), height, 5, height);
        [self.contentView.layer addSublayer:layer];
        [self.leaderLayers addObject:layer];
    }
}

//构建起始和终止的点
-(NSArray<LeaderPoint*>*)createPointsUserId:(NSString*)userId{
    
    NSPredicate* predicate =  [NSPredicate predicateWithFormat:@"leadersId CONTAINS[cd] %@", userId];
    NSArray* filterArr = [self.models filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray<LeaderPoint*>* points = [NSMutableArray array];
    
    for (LSAgendaModel* model in filterArr) {
        //  早八点到晚六点的总秒数
        NSInteger time_8_6 = 10 * 3600;
        //  构造早八点的date
        NSString* eightStr = [NSString stringWithFormat:@"%@ 08:00:00", [model.startTime substringToIndex:10]];
        NSDateFormatter* fm = [[NSDateFormatter alloc] init];
        [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* eightDate = [fm dateFromString:eightStr];
        
        // 构造时间差
        NSTimeInterval start = [[LSUtils serverDateFromString:model.startTime] timeIntervalSince1970];
        NSTimeInterval end = [[LSUtils serverDateFromString:model.endTime] timeIntervalSince1970];
        NSTimeInterval time_to_8 = [eightDate timeIntervalSince1970];
        
        CGFloat p_start = start - time_to_8 > 0 ? start - time_to_8 : 0;
        
        if (p_start < 0) {
            p_start = 0;
        }else if (p_start > time_8_6){
            p_start = time_8_6;
        }
        
        
        CGFloat p_end = end - time_to_8;
        if (p_end < 0) {
            p_end = 0;
        }else if (p_end > time_8_6){
            p_end = time_8_6;
        }
        
        LeaderPoint* point = [[LeaderPoint alloc] init];
        point.startY = p_start / (float)time_8_6;
        point.endY = p_end / (float)time_8_6;
        [points addObject:point];

    }
    
    return points;
    
    
    
    
    /*
    LeaderPoint* p = [[LeaderPoint alloc] init];
    p.startY = 0.25;
    p.endY = 0.5;
    
    LeaderPoint* p1 = [[LeaderPoint alloc] init];
    p1.startY = 0.6;
    p1.endY = 0.75;
    
    return @[p, p1];
    */
}

@end







































































@implementation LeaderPoint

@end



@implementation LeaderLayer

-(void)drawEventsPoints:(NSArray<LeaderPoint *> *)points color:(UIColor*)color{
    for (CALayer* layer in self.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //    画竖线
    for (int i = 0; i < points.count; i++) {
        LeaderPoint* p = points[i];
        CGPathMoveToPoint(pathRef, NULL, self.frame.size.width / 2.0, p.startY * self.frame.size.height);
        CGPathAddLineToPoint(pathRef, NULL, self.frame.size.width / 2.0, p.endY * self.frame.size.height);
    }
    
    CAShapeLayer* shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    shaperLayer.strokeColor = color.CGColor;
    //    shaperLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    shaperLayer.lineWidth = self.frame.size.width;
    shaperLayer.lineCap = kCALineCapButt;
    
    shaperLayer.path = pathRef;
    
    //    背景的layer要放在最底层
    [self insertSublayer:shaperLayer atIndex:0];
    
}

@end
