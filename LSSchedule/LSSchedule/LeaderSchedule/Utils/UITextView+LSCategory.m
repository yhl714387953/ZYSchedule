//
//  UITextView+LSCategory.m
//  LSchedule
//
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "UITextView+LSCategory.h"
#import "LSUtils.h"
#import "UIButton+LSCategory.h"

@implementation UITextView (LSCategory)

@end


@implementation UITableView (LSSwizzle)

+(void)load{
    /*
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        Class class = [UITableView class];
        Class class = [self class];
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(ls_reloadData);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(originalMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
    */
}

-(void)ls_reloadData{
    
    [self ls_reloadData];//这样调用并不会死循环，因为方法已经置换了，这句相当于调用了reloadData
    
    
    if (!self.displayView) {
        self.displayView = [[UIView alloc] initWithFrame:self.bounds];
        self.displayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.displayView atIndex:0];
        
        //空提示button
        UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = 100;
        button.frame = CGRectMake(0, 0, 200, 200);
        button.center = CGPointMake(self.displayView.frame.size.width / 2.0, self.displayView.frame.size.height / 2.0);
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [button setImage:[UIImage imageNamed:@"no_schedule"] forState:(UIControlStateNormal)];
        [button setTitle:@"暂无日程" forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitleColor:[UIColor colorWithHex:kLSLight999TitleColor] forState:(UIControlStateNormal)];
        
        [button placeImageTitlePosition:(ZYButtonImagePositionTop) space:10];
        
        [self.displayView addSubview:button];
        
        
        //创建加载动画
        UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.frame = CGRectMake(10, 0, 20, 20);
//        indicatorView.center = CGPointMake(self.frame.size.width / 2.0, 30);
        
        indicatorView.tag = 200;
        [self.displayView addSubview:indicatorView];
        
    }
    
    
    NSInteger cellCount = self.visibleCells.count;
    
    if (cellCount > 0) {//如果有cell，那么不显示状态视图
        self.displayView.hidden = YES;
    }else{
        self.displayView.hidden = NO;
    }

}



@end


@implementation UITableView (LSDisplayState)

static const NSString* LSDisplayView = @"LSDisplayView";
-(void)setDisplayView:(UIView *)displayView{
    if (displayView != self.displayView) {
        
        //删除旧的，添加新的
        [self.displayView removeFromSuperview];
        [self addSubview:displayView];
        
        //存储新的
        [self willChangeValueForKey:@"LSDisplayView"];
        objc_setAssociatedObject(self, &LSDisplayView, displayView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"LSDisplayView"];
        
    }
}

-(UIView *)displayView{
    return objc_getAssociatedObject(self, &LSDisplayView);
}


-(void)startAnimating{
    UIView* view = [self viewWithTag:100];
    view.hidden = YES;
    
    UIActivityIndicatorView* indicatorView = (UIActivityIndicatorView*)[self viewWithTag:200];
    if ([indicatorView isKindOfClass:[UIActivityIndicatorView class]]) {
        [indicatorView startAnimating];
        indicatorView.hidden = NO;
    }
}

-(void)stopAnimating{
    UIView* view = [self viewWithTag:100];
    view.hidden = NO;
    
    UIActivityIndicatorView* indicatorView = (UIActivityIndicatorView*)[self viewWithTag:200];
    if ([indicatorView isKindOfClass:[UIActivityIndicatorView class]]) {
        [indicatorView stopAnimating];
        indicatorView.hidden = YES;
    }
}


@end


