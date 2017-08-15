//
//  LSViewController.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSViewController.h"

@interface LSViewController ()

@end

@implementation LSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:(UIBarButtonItemStylePlain) target:self action:@selector(lsBack)];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"%@销毁了", self.class.description);
}

-(void)lsBack{
    [self.navigationController popViewControllerAnimated:YES];
    
    /*
    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
     */
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
