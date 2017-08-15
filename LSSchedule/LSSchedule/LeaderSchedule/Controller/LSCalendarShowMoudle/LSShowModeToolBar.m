//
//  LSShowModeToolBar.m
//  LSchedule
//
//  Created by 3dprint on 2017/6/13.
//  Copyright © 2017年 li. All rights reserved.
//

#import "LSShowModeToolBar.h"
#import "Masonry.h"
#import "LSMacro.h"
#import "LSUtils.h"


static NSInteger kLSToolBarButtonCount = 4;
//static NSInteger kLSToolBarHeight = 94;
static NSInteger kLSToolBarBtnHeight = 47;


@interface LSShowModeToolBar ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

@end

@implementation LSShowModeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButtons];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initButtons];
}

- (void)initButtons
{
    _buttonArray = [NSMutableArray array];
    
    NSArray *normalImages = @[@"list-notselected",
                              @"month-view-notselected",
                              @"week-view-notselected",
                              @"screen-notselected"];
    
    NSArray *selectImages = @[@"list-selected",
                              @"month-view",
                              @"week-view",
                              @"screen-selected"];
    
    NSArray *btntitle = @[@"列表", @"月", @"周", @"筛选"];
    
    self.backgroundColor = [UIColor colorWithHex:KLSViewBackColor];
    for (int i = 0; i < kLSToolBarButtonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateSelected];
        [button setTitle:btntitle[i] forState:UIControlStateNormal];

        button.frame = CGRectMake(0, 0,kLSToolBarBtnHeight ,kLSToolBarBtnHeight + 10);
        button.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height, -button.imageView.frame.size.width, -2, 0.0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(- button.titleLabel.bounds.size.height, 12, 0.0,0.0)];

        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0) {
            button.selected = YES;
        }
        
        [_buttonArray addObject:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 47;
    CGFloat height = self.frame.size.height;
    CGFloat leftSpace = 60;
    CGFloat gapSpace = (self.frame.size.width - leftSpace * 2 - _buttonArray.count * width) / (_buttonArray.count - 1);
    
    for (int i = 0;  i < _buttonArray.count; i++) {
        UIView* view = _buttonArray[i];
        view.frame = CGRectMake(leftSpace + i * (width + gapSpace), 0, width, height);
    }
}

- (void)click:(UIButton *)button
{
    if (_delegate) {
        [_delegate conferenceToolBar:_buttonArray
                         clickButton:button
                          buttonType:[_buttonArray indexOfObject:button]];
    }
    
    //除了最后一个按钮，其余三个按钮互斥操作
    UIButton* lastButton = [_buttonArray lastObject];
    
    if ([button isEqual:lastButton]) {
        
        return;
    }
    
    for (UIButton* btn in _buttonArray) {
        if (![btn isEqual:lastButton]) {
            btn.selected = [btn isEqual:button];
        }
    }
    
}

-(void)setFilter:(NSString *)filter{
    _filter = filter;
    
    UIButton* button = [_buttonArray lastObject];
    if ([filter isKindOfClass:[NSString class]] && filter.length > 0) {
        button.selected = YES;
        [button setTitle:filter forState:(UIControlStateSelected)];
        [button setTitle:filter forState:(UIControlStateNormal)];
    }else{
        button.selected = NO;
        [button setTitle:@"筛选" forState:(UIControlStateNormal)];
    }

}

@end
