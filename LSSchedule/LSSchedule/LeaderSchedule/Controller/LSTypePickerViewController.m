//
//  LSTypePickerViewController.m
//  LSchedule
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSTypePickerViewController.h"
#import "LSUtils.h"

@interface LSTypePickerViewController ()

@end

@implementation LSTypePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
     self.backgroundColor    = MMHexColor(0xFFFFFFFF);
     self.titleColor         = MMHexColor(0x666666FF);
     self.splitColor         = MMHexColor(0xCCCCCCFF);
     
     self.itemNormalColor    = MMHexColor(0x333333FF);
     self.itemDisableColor   = MMHexColor(0xCCCCCCFF);
     self.itemHighlightColor = MMHexColor(0xE76153FF);
     self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
     */
    
#define LSHexColor(color)   [UIColor colorWithHex:color]
    
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 44 * 3 + 1)];
//    view.image = [UIImage imageNamed:@"pop-up-windows"];
    view.userInteractionEnabled = YES;
//    view.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:view];
    
    NSArray* titles = @[@"会议", @"活动", @"其他"];
    for (int i = 0; i < titles.count; i++) {
        UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 44.5 * i, view.frame.size.width, 44);
        [button setTitle:titles[i] forState:(UIControlStateNormal)];
        [button setTitleColor:LSHexColor(kLSDefaultTitleColor) forState:(UIControlStateNormal)];
        
        [button setBackgroundImage:[UIImage imageWithColor:LSHexColor(@"EFEDE7FF")] forState:(UIControlStateHighlighted)];
   
        [button setBackgroundImage:[UIImage imageWithColor:LSHexColor(@"FFFFFFFF")] forState:(UIControlStateNormal)];
        [view addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(clicked:) forControlEvents:(UIControlEventTouchUpInside)];
        

        if ([self.selectTitle isEqualToString:titles[i]]) {
            [button setTitleColor:LSHexColor(kLSSelectTitleColor) forState:(UIControlStateNormal)];
        }
        
    }
    
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    
    self.customView = view;
    
    self.showBlock = ^(LSShowViewController *viewConntroller, UIView *containerView) {
        
        containerView.center = CGPointMake(viewConntroller.view.frame.size.width / 2.0, viewConntroller.view.frame.size.height + containerView.frame.size.height / 2.0);
        [UIView animateWithDuration:0.25 animations:^{
            viewConntroller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            containerView.center = CGPointMake(viewConntroller.view.frame.size.width / 2.0, viewConntroller.view.frame.size.height / 2.0);
        }];
        
    };
    
    // Do any additional setup after loading the view.
}

-(void)clicked:(UIButton*)sender{
    
    if (self.clickBlock) {
        self.clickBlock([sender titleForState:(UIControlStateNormal | UIControlStateHighlighted)]);
    }
    
    [self hideContainerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
