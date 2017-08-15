//
//  LSBottomButtonCell.m
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSBottomButtonCell.h"
#import "Masonry.h"
#import "LSUtils.h"

@implementation LSBottomButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftButton.mas_top).offset(0);
        make.bottom.equalTo(self.leftButton.mas_bottom).offset(0);
        make.width.mas_equalTo(self.leftButton.mas_width);
        make.left.equalTo(self.leftButton.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
}


#pragma mark -
#pragma mark - method
-(void)clicked:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomButtonCell:clickAtIndex:)]) {
        [self.delegate bottomButtonCell:self clickAtIndex:sender.tag];
    }
}

#pragma mark -
#pragma mark - getter
-(UIButton*)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_leftButton setTitle:@"删除" forState:(UIControlStateNormal)];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _leftButton.tag = 0;
        [_leftButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        
        [_leftButton addTarget:self action:@selector(clicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return _leftButton;
}


-(UIButton*)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_rightButton setTitle:@"保存" forState:(UIControlStateNormal)];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _rightButton.tag = 1;
        [_rightButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:KLSViewBackColor]] forState:(UIControlStateNormal)];
        
        [_rightButton addTarget:self action:@selector(clicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return _rightButton;
}




@end
