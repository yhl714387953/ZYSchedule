//
//  LSTimePickerViewController.h
//  LSchedule
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSShowViewController.h"

@interface LSTimePickerViewController : LSShowViewController

/** 最小时间 格式 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString* minDateString;

/** <#description#> */
@property (nonatomic, copy) void (^timeChange)(NSDate* date);

@end
