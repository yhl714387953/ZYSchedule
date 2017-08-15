//
//  LSTypePickerViewController.h
//  LSchedule
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSShowViewController.h"

@interface LSTypePickerViewController : LSShowViewController

/** 选中title*/
@property (nonatomic, copy) NSString* selectTitle;

/** 点击回调 */
@property (nonatomic, copy) void (^clickBlock)(NSString* title);

@end
