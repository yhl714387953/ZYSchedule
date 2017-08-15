//
//  LSEmptyTableView.m
//  LSchedule
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSEmptyTableView.h"
#import "LSUtils.h"
#import "UIButton+LSCategory.h"
#import "Masonry.h"

@implementation LSEmptyTableView

-(void)startAnimating{

    self.button.hidden = YES;
    
    UIActivityIndicatorView* indicatorView = (UIActivityIndicatorView*)[self viewWithTag:200];
    if ([indicatorView isKindOfClass:[UIActivityIndicatorView class]]) {
        [indicatorView startAnimating];
        indicatorView.hidden = NO;
    }
}

-(void)stopAnimating{
    self.button.hidden = NO;
    
    UIActivityIndicatorView* indicatorView = (UIActivityIndicatorView*)[self viewWithTag:200];
    if ([indicatorView isKindOfClass:[UIActivityIndicatorView class]]) {
        [indicatorView stopAnimating];
        indicatorView.hidden = YES;
    }
}

-(void)reloadData{
    [super reloadData];
    
    
    if (!self.displayView) {
        self.displayView = [[UIView alloc] initWithFrame:self.bounds];
    
        [self insertSubview:self.displayView atIndex:0];
        [self.displayView addSubview:self.button];

        //创建加载动画
        UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.tag = 200;
        indicatorView.frame = CGRectMake(10, 0, 20, 20);
        [self.displayView addSubview:indicatorView];
        
        [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(@200);
            make.height.mas_equalTo(@200);
        }];
        
        
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.top.mas_equalTo(@20);
        }];
    }
    
    
    NSInteger cellCount = self.visibleCells.count;
    
    if (cellCount > 0) {//如果有cell，那么不显示状态视图
        self.displayView.hidden = YES;
    }else{
        self.displayView.hidden = NO;
    }

}

#pragma mark -
#pragma mark - getter
-(UIButton *)button{
    if (!_button) {
        //空提示button
        _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _button.frame = CGRectMake(0, 0, 200, 200);
        [_button setImage:[UIImage imageNamed:@"no_schedule"] forState:(UIControlStateNormal)];
        [_button setTitle:@"暂无日程" forState:(UIControlStateNormal)];
        _button.titleLabel.font = [UIFont systemFontOfSize:17];
        [_button setTitleColor:[UIColor colorWithHex:kLSLight999TitleColor] forState:(UIControlStateNormal)];
        
        [_button placeImageTitlePosition:(ZYButtonImagePositionTop) space:10];
    }

    return _button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
