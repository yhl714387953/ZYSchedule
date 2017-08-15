//
//  LSAutoHeightTextView.m
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSAutoHeightTextView.h"

@interface LSAutoHeightTextView ()
@property (nonatomic,assign)NSInteger textH;
@property (nonatomic,assign)NSInteger MaxTitleH;

@end

@implementation LSAutoHeightTextView

-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.enablesReturnKeyAutomatically = YES;
//    self.layer.borderWidth = 1;
    self.maxNumOfLines = 5;
    self.cornerRadius = 5;
    self.font = [UIFont systemFontOfSize:14];
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textValueChanged) name:UITextViewTextDidChangeNotification object:self];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == self && [keyPath isEqualToString:@"text"]) {
        NSLog(@"text did change -- observeValueForKeyPath");
        NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        if (self.textDidSetBlock) {
            self.textDidSetBlock(self.text, height);
            [self.superview layoutIfNeeded];
        }
    }
}

-(void)setTextHeightChangeBlock:(void (^)(NSString *, CGFloat))textHeightChangeBlock{
    _textHeightChangeBlock = textHeightChangeBlock;
    [self textValueChanged];
}

- (void)textValueChanged{
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (_textH != height) { // 高度不一样，就改变了高度
        
        // 最大高度，可以滚动
        self.scrollEnabled = height > _MaxTitleH && _MaxTitleH > 0;
        
        _textH = height;
        
        if (_textHeightChangeBlock && self.scrollEnabled == NO) {
            _textHeightChangeBlock(self.text,height);
            [self.superview layoutIfNeeded];
            //            self.placeholderView.frame = self.bounds;
        }
    }
    
}
-(void)setCornerRadius:(NSInteger)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
-(void)setMaxNumOfLines:(NSInteger)maxNumOfLines{
    _maxNumOfLines = maxNumOfLines;
    // 根据给定的最大行数计算出最大允许的高度.当超出这个高度时,就可以滚动textView.小于这个高度时,textView高度增加.
    // 使用ceil函数拿到最大值,ceil() 方法执行的是向上取整计算,它返回的是大于或等于函数参数.每行的高度*最大行数 + 顶部 + 底部间距.
    _MaxTitleH = ceil(self.font.lineHeight * maxNumOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    NSLog(@"lineH:%zd",self.font.lineHeight);
    NSLog(@"最多行数:%zd,最高度:%ld",maxNumOfLines,(long)_MaxTitleH);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeObserver:self forKeyPath:@"text"];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
