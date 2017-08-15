//
//  LSShowViewController.m
//  LSchedule
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSShowViewController.h"

@interface LSShowViewController ()

/** 容器视图 */
@property (nonatomic, strong) UIView* containerView;



@end

@implementation LSShowViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    // Do any additional setup after loading the view.
}

-(void)dealloc{
    NSLog(@"%@销毁了", self.class.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCustomView:(UIView *)customView{
    _customView = customView;

    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, customView.frame.size.width, customView.frame.size.height)];
    [self.containerView addSubview:customView];
    [self.view addSubview:self.containerView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.showBlock) {
        self.showBlock(self, self.containerView);
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.containerView.frame = CGRectMake(0, self.view.frame.size.height - self.containerView.frame.size.height, self.view.frame.size.width, self.containerView.frame.size.height);
    }];
    
}

-(void)hideContainerView{
    [UIView animateWithDuration:0.25 animations:^{
//        self.containerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.containerView.frame.size.height);
        self.containerView.center = CGPointMake(self.containerView.center.x, self.view.frame.size.height + self.containerView.frame.size.height / 2.0);
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.hideBlock) {
        return;
    }
    
    if (self.disabledBackTouchDismiss) {
        return;
    }
    
    [self hideContainerView];
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
