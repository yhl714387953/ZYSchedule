//
//  WeekEventCell.h
//  LSchedule
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAgendaModel.h"

@interface WeekEventCell : UICollectionViewCell

/** 当日日程数组 */
@property (nonatomic, strong) NSArray<LSAgendaModel*>* models;

/** 筛选人员数组 */
@property (nonatomic, strong) NSMutableArray<NSString*>* showLeaderIDs;

@end


@interface LeaderPoint : NSObject

/** Y起始 取值范围 0~1 */
@property (nonatomic) CGFloat startY;

/** Y结束 取值范围 0~1 */
@property (nonatomic) CGFloat endY;

@end

@interface LeaderLayer : CALayer

-(void)drawEventsPoints:(NSArray<LeaderPoint *> *)points color:(UIColor*)color;

@end
