//
//  LSAgendaCell.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSAgendaCell.h"
#import "LSUtils.h"

@implementation LSAgendaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:YES];
    
    UIView* lineView = [self.contentView viewWithTag:110];
    if (lineView) {
        lineView.backgroundColor = [UIColor colorWithHex:KLSViewBackColor];
    }
    
}

-(void)setModel:(LSAgendaModel *)model{
    _model = model;
    

    
    self.startTimeLabel.text = [LSUtils stringFromDate:[LSUtils serverDateFromString:model.startTime] format:@"HH:mm"];
    self.endTimeLabel.text = [LSUtils stringFromDate:[LSUtils serverDateFromString:model.endTime] format:@"HH:mm"];
    self.thtmeLabel.text = [NSString stringWithFormat:@"【%@】%@", model.meetType, model.content];
    NSString* leaderStr = [LSUtils trimmingSpaceHeadTrail:model.leaders];
    
    self.personLabel.text = [LSUtils getAbsolutText:model.leaders].length < 2 ? @"待定" : [leaderStr stringByReplacingOccurrencesOfString:@" " withString:@"、"];
    
    //兼容服务器两个顿号的情况
    self.personLabel.text = [self.personLabel.text stringByReplacingOccurrencesOfString:@"、、" withString:@"、"];
    self.locationLabel.text = [LSUtils getAbsolutText:model.address].length == 0 ? @"待定" : [LSUtils getAbsolutText:model.address];// [NSString stringWithFormat:@"%@", model.address];
    NSString* remark = [LSUtils getAbsolutText:model.remark];
    self.memoLabel.text = remark.length == 0 ? @"" : remark;
    [self.contentView viewWithTag:100].hidden = remark.length == 0;
    
    self.bottomLayout.constant = remark.length == 0 ? -11 : 25;

}

@end
