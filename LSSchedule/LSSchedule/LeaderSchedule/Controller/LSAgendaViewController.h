//
//  LSAgendaViewController.h
//  LSchedule
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAgendaModel.h"
#import "LSTableViewController.h"
#import "LSViewController.h"

@interface LSAgendaViewController : LSViewController

/** 数据模，修改的时候这个是存在的 */
@property (nonatomic, strong) LSAgendaModel* model;

/** 操作成功，会回调更新UI */
@property (nonatomic, copy) void (^operateSuccessBlock)();


@end
