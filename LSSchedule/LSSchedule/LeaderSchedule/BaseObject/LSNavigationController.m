//
//  LSNavigationController.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSNavigationController.h"
#import "LSUtils.h"

@interface LSNavigationController ()

@end

@implementation LSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBaseStyle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//给导航设置默认样式
-(void)setBaseStyle{
    UIColor* color = [UIColor colorWithHex:KLSViewBackColor];
    UIImage* image = [UIImage imageWithColor:color];
    [self.navigationBar setBackgroundImage:image forBarMetrics:(UIBarMetricsDefault)];
    
    NSDictionary* attibutes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
                                NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationBar setTitleTextAttributes:attibutes];
    
    //    self.interactivePopGestureRecognizer.delegate = self; //默认只有滑动边缘位置才会返回
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationBar.translucent = NO;//如果是YES  那么view的起始位置是屏幕的最上面
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
