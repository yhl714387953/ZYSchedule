//
//  MonthCalendarCell.h
//  LSchedule
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "FSCalendarCell.h"
#import "LSAgendaModel.h"

@interface MonthCalendarCell : FSCalendarCell

/** 筛选人员数组 */
@property (nonatomic, strong) NSMutableArray<NSString*>* showLeaderIDs;


@end
