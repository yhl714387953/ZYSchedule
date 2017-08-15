//
//  LSTextFieldCell.m
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSTextFieldCell.h"
#import "Masonry.h"
#import "LSUtils.h"

@implementation LSTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.indicatorButton];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
//            make.right.equalTo(self.view.mas_right).offset(0);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(11).priority(999);
            make.height.mas_equalTo(@(30));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-11).priority(999);
            make.left.equalTo(self.contentView.mas_left).offset(85);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.left.equalTo(self.textField.mas_left).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo(@(150));
        }];
        
        [self.indicatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(125);
   
        }];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)textChange:(UITextField *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldCell:textChange:)]) {
        [self.delegate textFieldCell:self textChange:sender.text];
    }
}

#pragma mark -
#pragma mark - getter
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textColor = [UIColor colorWithHex:kLSLightTitleColor];
        _label.font = [UIFont systemFontOfSize:16];
        
    }

    return _label;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.font = [UIFont systemFontOfSize:16];
    }
    
    return _textField;
}

-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_button setImage:[UIImage imageNamed:@"checkbox"] forState:(UIControlStateNormal)];
        [_button setImage:[UIImage imageNamed:@"checked"] forState:(UIControlStateSelected)];
        [_button setTitle:@"包含节假日" forState:(UIControlStateNormal)];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
        _button.userInteractionEnabled = NO;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
        
    }
    
    return _button;
}

-(UIButton *)indicatorButton{

    if (!_indicatorButton) {
        _indicatorButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_indicatorButton setImage:[UIImage imageNamed:@"drop-down-arrow"] forState:(UIControlStateNormal)];
        _indicatorButton.userInteractionEnabled = NO;
    }
    
    return _indicatorButton;

}


@end
