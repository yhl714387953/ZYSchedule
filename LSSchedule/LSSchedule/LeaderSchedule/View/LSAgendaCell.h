//
//  LSAgendaCell.h
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAgendaModel.h"

@interface LSAgendaCell : UITableViewCell

/** 数据源 */
@property (nonatomic, strong) LSAgendaModel* model;

/** <#description#> */
@property (nonatomic, weak) IBOutlet UILabel* startTimeLabel;

/** <#description#> */
@property (nonatomic, weak) IBOutlet UILabel* endTimeLabel;

/** <#description#> */
@property (nonatomic, weak) IBOutlet UILabel* thtmeLabel;

/** <#description#> */
@property (nonatomic, weak) IBOutlet UILabel* personLabel;

/** <#description#> */
@property (nonatomic, weak) IBOutlet UILabel* locationLabel;

/** <#description#> */
@property (nonatomic, weak) IBOutlet UILabel* memoLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@end
