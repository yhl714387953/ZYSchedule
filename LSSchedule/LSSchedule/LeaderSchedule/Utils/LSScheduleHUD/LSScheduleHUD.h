//
//  LSScheduleHUD.h
//  LSchedule
//
//  Created by mac on 2017/8/15.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSHUDPostion) {
    LSHUDPostionTop = 0,
    LSHUDPostionMiddle,
    LSHUDPostionBottom
};

@interface LSScheduleHUD : NSObject

+(void)showMessage:(NSString *)message;

+(void)showMessage:(NSString *)message postion:(LSHUDPostion)postion;

@end
