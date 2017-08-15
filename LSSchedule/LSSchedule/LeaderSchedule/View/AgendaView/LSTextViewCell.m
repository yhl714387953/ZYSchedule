//
//  LSTextViewCell.m
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSTextViewCell.h"
#import "Masonry.h"
#import "LSUtils.h"

@implementation LSTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.textView];

        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            //            make.right.equalTo(self.view.mas_right).offset(0);
        }];
        
        //顶部的约束优先级最高，那么会先改变约束优先级高的，这样避免了底部在输入的换行自适应是的上下跳动问题
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(8).priority(999);
            make.height.mas_greaterThanOrEqualTo(@(16)).priority(888);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8).priority(777);
            make.left.equalTo(self.contentView.mas_left).offset(80);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        __weak typeof (self) weakSelf = self;
        self.textView.textHeightChangeBlock = ^(NSString *text, CGFloat textHeight) {
            [weakSelf.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_greaterThanOrEqualTo(@(textHeight)).priority(888);
        
            }];
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(textViewCell:textHeightChange:)]) {
                [weakSelf.delegate textViewCell:weakSelf textHeightChange:text];
            }
            
            [weakSelf layoutIfNeeded];
        };
        
        self.textView.textDidSetBlock = ^(NSString *text, CGFloat textHeight) {
            [weakSelf.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_greaterThanOrEqualTo(@(textHeight)).priority(888);
                
            }];
            
            [weakSelf layoutIfNeeded];
        };
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length > self.maxNumberWords && self.maxNumberWords > 0) {
        self.textView.text = [self.textView.text substringToIndex:self.maxNumberWords - 1];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewCell:textChange:)]) {
        [self.delegate textViewCell:self textChange:self.textView.text];
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

-(LSAutoHeightTextView *)textView{
    if (!_textView) {
        _textView = [[LSAutoHeightTextView alloc] initWithFrame:CGRectZero];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.maxNumOfLines = 1000;
        _textView.delegate = self;
//        _textView.returnKeyType = UIReturnKeyDone;
        
    }
    
    return _textView;
}

@end
