//
//  BaseCalendarViewController.h
//  LSchedule
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSViewController.h"
#import "FSCalendar.h"
#import "LSPerson.h"

@class BaseCalendarViewController;
@protocol BaseCalendarVCDelegate <NSObject>

@optional
-(void)baseCalendarViewController:(BaseCalendarViewController*)controller didSelcetDate:(NSDate*)date;
-(void)baseCalendarViewController:(BaseCalendarViewController*)controller pageChange:(NSDate*)date;

@end


/* 子类重写的时候要在viewDidLoad 方法内重新定义大小约束 [super viewDidLoad]要优先调用 */
@interface BaseCalendarViewController : LSViewController

/** 代理 */
@property (nonatomic, weak) id<BaseCalendarVCDelegate> delegate;



/** 默认时间戳格式 */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/** 阳历 */
@property (strong, nonatomic) NSCalendar *gregorianCalendar;

/** 农历 */
@property (strong, nonatomic) NSCalendar *lunarCalendar;

/** 农历标题数组 */
@property (strong, nonatomic) NSArray<NSString *> *lunarChars;


#pragma mark -
#pragma mark - UIControl
/** 视图是否更新完成 */
@property (nonatomic) BOOL hasLayoutSubViews;

/** 当前视图是否是从其他页面切换过来 */
@property (nonatomic) BOOL isTransitioFromOther;






/** 筛选条件 */
@property (nonatomic, strong) NSArray<LSLeader*>* filterLeaders;

/** 筛选条件 id  空格分割组合字符串，根据上面的条件拼接 */
@property (nonatomic, copy) NSString* filterIds;

/** 日历 */
@property (nonatomic, strong) FSCalendar* calendar;

/** 当前选中日期 */
@property (nonatomic, strong) NSDate* currentSelectDate;

/**
 刷新数据，子控制器重写即可
 */
-(void)reloadData;

-(void)startLoading;

-(void)endLoading;

-(void)endLoadingError:(id)error;

@end
