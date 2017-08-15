//
//  ViewController.m
//  LSSchedule
//
//  Created by mac on 2017/8/15.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "ViewController.h"
#import "LSNavigationController.h"
#import "LSModel.h"
#import "LSCooCalendarViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.text = @"13688886666";
    
    //启用本地数据
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLocalData"];
    
    [self initShake];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clicked:(UIButton *)sender {
    
    LSCooCalendarViewController* vc = [[LSCooCalendarViewController alloc] init];
    vc.phoneNumber = self.textField.text;
    vc.baseUrl = @"www.baidu.com";
    LSNavigationController* navi = [[LSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

-(void)initShake{
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 摇一摇
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"开始摇动");
    }
    
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"取消摇动");
    }
    
    
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        
        if ([kLSBaseURL containsString:@"test"]) {//非正式环境 可以响应
            NSLog(@"摇动结束");
            //            [self shakeAction];
        }
        
        [self shakeAction];
    }
    
    
}

-(void)shakeAction{
    
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"环境选择" message:@"选择使用环境" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"上线环境" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        kLSBaseURL = @"";
    }];
    
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"测试环境" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        kLSBaseURL = @"";
    }];
    
    [ac addAction:action1];
    [ac addAction:action2];
    
    [self presentViewController:ac animated:YES completion:^{
        
    }];
    
}


@end
