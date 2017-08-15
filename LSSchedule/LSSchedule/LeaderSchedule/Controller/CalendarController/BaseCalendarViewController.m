//
//  BaseCalendarViewController.m
//  LSchedule
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "BaseCalendarViewController.h"
#import "LSUtils.h"
#import "Masonry.h"

@interface BaseCalendarViewController ()

/** 选中日期 */
@property (nonatomic, readonly, strong) NSDate* selectedDate;

/** 筛选条件 */
@property (nonatomic, copy) NSString* filterLeadersId;

@end

@implementation BaseCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.calendar];
    
    [self initCalendar];
    
     [self setupLeftRightView];
    
    // Do any additional setup after loading the view.
}

-(void)initCalendar{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.calendar.accessibilityIdentifier = @"calendar";
    self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSLocale *chinese = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    self.lunarCalendar.locale = chinese;
    self.lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"廿十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    [self.calendar selectDate:[NSDate date]];
    
    [self calendar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData{

}

-(void)startLoading{

}

-(void)endLoading{
    
}

-(void)endLoadingError:(id)error{
    
}

#pragma mark -
#pragma mark - getter
-(NSDate *)selectedDate{
    return self.calendar.selectedDate;
}

-(NSString *)filterIds{
    if (!self.filterLeaders || self.filterLeaders.count == 0) {
        return nil;
    }
    
    NSString* filterLeadersId = @"";
    
    //这个就有点尴尬了
    for (LSLeader* leader in self.filterLeaders) {
        filterLeadersId = [filterLeadersId stringByAppendingFormat:@" %@", leader.userId];
    }
    if (filterLeadersId.length > 0) {
        filterLeadersId = [filterLeadersId substringFromIndex:1];
    }
    
    return filterLeadersId;
}

-(FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
//        _calendar.dataSource = self;
//        _calendar.delegate = self;
        
        _calendar.appearance.titleFont = [UIFont systemFontOfSize:19];
        _calendar.appearance.titleSelectionColor = [UIColor whiteColor];
        
        _calendar.appearance.subtitleFont = [UIFont systemFontOfSize:11];
        _calendar.appearance.subtitleSelectionColor = [UIColor whiteColor];
        //        _calendar.appearance.subtitleOffset = CGPointMake(0, 3);
        
        _calendar.appearance.borderRadius = 1;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat scale = MIN(size.width, size.height) / 320.f;
        
        _calendar.appearance.imageOffset = CGPointMake(16 * scale, -34 * scale);
        _calendar.appearance.eventOffset = CGPointMake(0, 0);
        _calendar.appearance.subtitleOffset = CGPointMake(0, 2);
        
        _calendar.appearance.eventDefaultColor = [UIColor colorWithHex:@"666666"];
        _calendar.appearance.eventSelectionColor = [UIColor colorWithHex:@"666666"];
        
        _calendar.appearance.weekdayTextColor = [UIColor blackColor];
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase|FSCalendarCaseOptionsHeaderUsesUpperCase;
        
        _calendar.allowsMultipleSelection = NO;
        _calendar.firstWeekday = 2;
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;// FSCalendarPlaceholderTypeFillHeadTail; //FSCalendarPlaceholderTypeFillSixRows;// FSCalendarPlaceholderTypeNone;//不显示上个月的日期
        
        _calendar.headerHeight = 0;
//        _calendar.calendarWeekdayView.backgroundColor = [UIColor colorWithHex:KLSTopDayMarkBackColor];// = [[FSCalendarWeekdayView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        _calendar.calendarWeekdayView.backgroundColor = [UIColor whiteColor];
        
        //        _calendar.scope = FSCalendarScopeWeek;
        _calendar.scope = FSCalendarScopeMonth;
        
    }
    
    return _calendar;
}

-(void)setupLeftRightView{
    UIView* leftView = [[UIView alloc] init];
//    leftView.backgroundColor = [UIColor colorWithHex:KLSTopDayMarkBackColor];
    [self.view insertSubview:leftView atIndex:0];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendar.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        //高度可能会引起警告，因为日历控件的星期视图不一定有约束
        make.height.mas_equalTo(self.calendar.calendarWeekdayView.mas_height);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
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
