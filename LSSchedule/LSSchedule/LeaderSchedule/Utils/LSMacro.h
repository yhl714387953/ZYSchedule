//
//  LSMacro.h
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#ifndef LSMacro_h
#define LSMacro_h

//默认title颜色
#define kLSDefaultTitleColor @"333333"

//选中title颜色
#define kLSSelectTitleColor @"3f72f3"

//title浅灰色
#define kLSLightTitleColor @"666666"

//title浅灰色
#define kLSLight999TitleColor @"999999"

//视图背景颜色
#define KLSViewBackColor @"376BFB"

//日历顶端星期几的标记
#define KLSTopDayMarkBackColor @"E3E3E3"











































//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif




//--------plist相关

//app 版本
#define kBundleVersion [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]

//构建版本
#define kBuildVersion [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]

//APP 名字
#define kBundleName [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]]






//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)





#endif /* LSMacro_h */
