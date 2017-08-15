
//
//  LSUtils.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSUtils.h"
#import "LSScheduleHUD.h"

@implementation LSUtils

#pragma mark -
#pragma mark - 字符串相关
+(NSString*)getAbsolutText:(id)string{
    NSString* tempStr = @"";
    if ([string isKindOfClass:[NSString class]]) {
        tempStr = (NSString*)string;// [NSString stringWithFormat:@"%@", string];
    }else if ([string isKindOfClass:[NSNull class]] || !string){
        tempStr = @"";
    }

    return [NSString stringWithFormat:@"%@", tempStr];
}

//去除两端空格
+(NSString*)trimmingSpaceHeadTrail:(NSString*)string{
    if (![string isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//去除两端空格和回车
+(NSString*)trimmingEnterSpaceHeadTrail:(NSString*)string{
    if (![string isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//是否包含Emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string{

    return string.length != [self disable_emoji:string].length;
}

//字符串去除Emoji表情
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //去除表情后的字符串
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma mark -
#pragma mark - 日期时间相关
//yyyy-MM-dd HH:mm:ss
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

//yyyy-MM-dd HH:mm:ss
+ (NSString *)localTimeStringFromDate:(NSDate *)date format:(NSString *)format
{
    NSString * deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:deviceLanguage];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}
//yyyy-MM-dd HH:mm:ss  转换为date
+(NSDate*)dateFormString:(NSString*)string format:(NSString *)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:string];
    
    return date;
}

//本地化后的时间
+(NSDate*)localDateFormString:(NSString*)string format:(NSString *)format{
    NSString * deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:deviceLanguage];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:string];
    
    return date;
}

+(BOOL)isInSameMonthDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return ([comp1 year] == [comp2 year]) && ([comp1 month] == [comp2 month]);
}

//- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
//    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
//    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
//}

+(NSInteger)weeksInMonth:(NSDate*)date{
    if (!date) {
        date = [NSDate date];
    }
    //  获取一个月的第一天
    NSDate* fistDate = [LSUtils firstDateInMonth:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //获取一个月有多少天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:fistDate];

    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday = [components weekday];
    //周日是1  周一是2
    //补充1号之前的空白天数
    NSInteger blankDay = weekday - 2;
    if(weekday == 1) blankDay = 6;
    
    NSInteger left = (range.length + blankDay) % 7;
    NSInteger weeks = (range.length + blankDay) / 7;
    
    return left == 0 ? weeks : weeks + 1;
}

//获取当前月的第一天
+(NSDate*)firstDateInMonth:(NSDate*)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString* dateString = [NSString stringWithFormat:@"%04ld-%02ld-01 00:00:01", (long)dateComponent.year, (long)dateComponent.month];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter dateFromString:dateString];
}

//获取当前月的最后一天
+(NSDate *)lastDateInMonth:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSString* dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", (long)dateComponent.year, (long)dateComponent.month, (unsigned long)range.length];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter dateFromString:dateString];
}

//将服务器获取到的时间转化为NSDate类型2017-04-28 00:00:00.0
+(NSDate *)serverDateFromString:(NSString*)string{
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
//    秒的格式占位是大写的 S
    //服务器给的时间就不要相信了，后面秒的位数不一定一样，我们要转化为自己固定格式的时间 yyyy-MM-dd HH:mm:ss.S
    NSArray* array = [string componentsSeparatedByString:@"."];
    NSString* timeString = string;
    if (array.count > 0) {
        timeString = array[0];
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    return [formatter dateFromString:timeString];
}

//获取两天之间的额所有时间  yyyy-MM-dd 
+(NSMutableArray<NSString*>*)getDaysBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate{
    NSMutableArray *dates = [NSMutableArray array];
    long long nowTime = [startDate timeIntervalSince1970];// 1471491674, //开始时间
    long long endTime = [endDate timeIntervalSince1970];// 1472528474,//结束时间
    long long dayTime = 24*60*60,
    time = nowTime - nowTime % dayTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    while (time < endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dates addObject:showOldDate];
        time += dayTime;
    }

    return dates;
}


//时间比较
+(NSComparisonResult)compareDate1:(NSDate*)date1 date2:(NSDate*)date2{
    NSString* str1 = [self stringFromDate:date1 format:@"yyyy-MM-dd"];
    NSString* str2 = [self stringFromDate:date2 format:@"yyyy-MM-dd"];
    
    return [str1 compare:str2];
}


+(BOOL)isAllHolidayBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate{
    NSArray* days = [self getDaysBetweenStartDate:startDate endDate:endDate];
    NSString* holidays = [[NSUserDefaults standardUserDefaults] stringForKey:@"holidays"];
    
    BOOL isAllHoliday = YES;
    for (NSString* day in days) {
        if (![holidays containsString:day]) {//只要有一个不是，那就有非节假日
            isAllHoliday = NO;
        }
    }

    return isAllHoliday;
}

// 获取当前是星期几
+ (NSInteger)getWeekdayWith:(NSDate *)curDate {
    
    NSString * deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:deviceLanguage];
    
//    [dateFormatter setDateFormat:@"EEEE dd MMMM"];//星期一 03 七月
    [dateFormatter setDateFormat:@"EEEE"]; //星期一
    [dateFormatter setLocale:locale];
    
    NSString * dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger weekday = 0;
    
    NSArray *arr = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    for (NSInteger i = 0; i < arr.count; i++ ) {
        if ([dateString isEqualToString:arr[i]]) {
            weekday = i+1;
        }
    }
    return weekday;
}

#pragma mark -
#pragma mark - 提示
+(void)showMessage:(NSString*)message{
    
    [LSScheduleHUD showMessage:[NSString stringWithFormat:@"%@", message] postion:(LSHUDPostionBottom)];
}

@end



@implementation UIColor (LSHex)

+ (UIColor *)colorWithHex:(NSString *)string
{
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}



+ (UIColor *)colorWithStr:(NSString *)colorStr
{
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end





@implementation UIImage (LSColor)

+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage*)imageWithString:(NSString*)string{
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:kLSSelectTitleColor];
    label.text = string;
    label.font = [UIFont systemFontOfSize:10];
    
    CGSize s = label.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

+(UIImage*)imageWithView:(UIView*)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
