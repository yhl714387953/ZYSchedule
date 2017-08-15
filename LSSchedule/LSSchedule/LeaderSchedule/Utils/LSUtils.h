//
//  LSUtils.h
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSMacro.h"

@interface LSUtils : NSObject


/**
 获取绝对的字符串

 @param string 任意格式数据
 @return 绝对的字符串
 */
+(NSString*)getAbsolutText:(id)string;

//去除两端空格
+(NSString*)trimmingSpaceHeadTrail:(NSString*)string;

//去除两端空格和回车
+(NSString*)trimmingEnterSpaceHeadTrail:(NSString*)string;

//是否包含Emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string;

//字符串去除Emoji表情
+ (NSString *)disable_emoji:(NSString *)text;

#pragma mark -
#pragma mark - 时间
/**
 获取固定格式的日期  yyyy-MM-dd HH:mm:ss
 
 @param date 日期NSDate
 @param format 字符串格式
 @return 格式化后的字符串
 */
+ (NSString*)stringFromDate:(NSDate *)date format:(NSString *)format;

//本地化后的时间字符串
+ (NSString *)localTimeStringFromDate:(NSDate *)date format:(NSString *)format;
//yyyy-MM-dd HH:mm:ss  转换为date
+(NSDate*)dateFormString:(NSString*)string format:(NSString *)format;

//本地化后的时间
+(NSDate*)localDateFormString:(NSString*)string format:(NSString *)format;

//是否在同一个月
+(BOOL)isInSameMonthDay:(NSDate *)date1 date2:(NSDate *)date2;


/**
 获取当前月的第一天

 @param date 当前日期
 @return 当前月的第一天
 */
+(NSDate*)firstDateInMonth:(NSDate*)date;


/**
 获取当前月的最后一天

 @param date 当前日期
 @return 当前月的最后一天
 */
+(NSDate*)lastDateInMonth:(NSDate *)date;


/**
 获取一个月有多少周

 @param date 当月的某一天
 @return 多少周
 */
+(NSInteger)weeksInMonth:(NSDate*)date;


/**
 将服务器获取到的时间转化为NSDate类型2017-04-28 00:00  可容错yyyy-MM-dd HH:mm:ss.S      yyyy-MM-dd HH:mm:ss 这两种格式

 @param string 服务器获取到的时间
 @return 时间对象
 */
+(NSDate *)serverDateFromString:(NSString*)string;


/**
 获取两天之间的额所有时间  yyyy-MM-dd

 @param startDate 起始时间
 @param endDate 结束时间
 @return 时间字符串数组  yyyy-MM-dd
 */
+(NSMutableArray<NSString*>*)getDaysBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;


/**
 两个时间点是否有有非节假日的时间

 @param startDate 起始时间
 @param endDate 结束时间
 @return 是否有非节假日
 */
+(BOOL)isAllHolidayBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;


/**
 时间比较

 @param date1 时间1
 @param date2 时间2
 @return 比较结果
 */
+(NSComparisonResult)compareDate1:(NSDate*)date1 date2:(NSDate*)date2;

/**
 获取当前日期是星期几
 
 @param curDate 当前时间
 @return 星期几
 */
+ (NSInteger)getWeekdayWith:(NSDate *)curDate;

#pragma mark -
#pragma mark - 提示
+(void)showMessage:(NSString*)message;


@end


@interface UIColor (LSHex)

+ (UIColor *)colorWithHex:(NSString *)string;

+ (UIColor *)colorWithStr:(NSString *)colorStr;


@end

@interface UIImage (LSColor)

+(UIImage*) imageWithColor:(UIColor*)color;

+(UIImage*) imageWithColor:(UIColor *)color size:(CGSize)size;

+(UIImage*) imageWithString:(NSString*)string;

+(UIImage*) imageWithView:(UIView*)view;



@end
