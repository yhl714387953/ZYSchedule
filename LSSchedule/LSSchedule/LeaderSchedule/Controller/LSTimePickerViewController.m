//
//  LSTimePickerViewController.m
//  LSchedule
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSTimePickerViewController.h"

#define kDatePickerHeight 216

@interface LSTimePickerViewController ()

/** <#description#> */
@property (nonatomic, strong) UIDatePicker* datePicker;

@end

@implementation LSTimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kDatePickerHeight)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.customView = self.datePicker;
    
    [self.datePicker addTarget:self action:@selector(timeChange:) forControlEvents:(UIControlEventValueChanged)];
    
    if (!self.minDateString) {
        self.datePicker.minimumDate = [NSDate date];
    }else{
        NSDateFormatter* fm = [[NSDateFormatter alloc] init];
        [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.datePicker.minimumDate = [fm dateFromString:self.minDateString];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - method
-(void)timeChange:(UIDatePicker*)picker{
    if (self.timeChange) {
        self.timeChange(picker.date);
    }
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
