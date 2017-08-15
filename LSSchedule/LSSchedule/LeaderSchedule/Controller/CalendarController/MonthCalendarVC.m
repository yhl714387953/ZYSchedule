//
//  MonthCalendarVC.m
//  LSchedule
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "MonthCalendarVC.h"
#import "Masonry.h"
#import "MonthCalendarBackView.h"
#import "MonthCalendarCell.h"
#import "LSUtils.h"
#import "LSAgendaModel.h"

@interface MonthCalendarVC ()<FSCalendarDataSource, FSCalendarDelegate>

/** <#description#> */
@property (nonatomic, strong) MonthCalendarBackView* backView;

@end

@implementation MonthCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCalendar];
    self.backView = [[MonthCalendarBackView alloc] initWithFrame:CGRectZero];
    [self.calendar insertSubview:self.backView atIndex:0];
//    [self.calendar addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.calendar).insets(UIEdgeInsetsZero);
    }];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    // Do any additional setup after loading the view.
}

-(void)pan:(UIPanGestureRecognizer*)tap{
    
}

-(void)configureCalendar{
    self.calendar.scrollEnabled = NO;
    self.calendar.allowsSelection = NO;
    
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.appearance.selectionColor = [UIColor whiteColor];
    self.calendar.appearance.titleSelectionColor = [UIColor darkTextColor];
    
    self.calendar.weekdayHeight = 30;
    self.calendar.calendarWeekdayView.backgroundColor = [UIColor whiteColor];
    [self.calendar registerClass:[MonthCalendarCell class] forCellReuseIdentifier:@"cell"];
    //    [self.calendar selectDate:[NSDate date]];
    
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (self.backView.frame.size.height > 0 && !self.hasLayoutSubViews) {
        self.hasLayoutSubViews = YES;
        [self drawBackView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.currentSelectDate) {
        [self.calendar setCurrentPage:self.currentSelectDate animated:YES];
    }
    
    if (self.hasLayoutSubViews) {
        [self reloadData];
        [self drawBackView];
    }
}

-(void)drawBackView{
    self.backView.startY = 35;
    self.backView.columnCount = 7;
    self.backView.columnSpacing = self.backView.frame.size.width / 7.0;
    NSInteger weeks = [LSUtils weeksInMonth:self.currentSelectDate];
    self.backView.lineCount = weeks * 2;
    self.backView.lineSpacing = (self.backView.frame.size.height - 30 - 10) / 12.0;
    [self.backView drawSquare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData{
    [self.calendar reloadData];
}

#pragma mark -
#pragma mark - FSCalendarDataSource
-(FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    MonthCalendarCell* cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];

    NSMutableArray* models = [NSMutableArray arrayWithArray:[LSAgendaModel queryLegalModelsDate:date leadersId:self.filterIds]];
    
    NSMutableArray<NSString*>* arr = [NSMutableArray array];
    for (LSAgendaModel* model in models) {
    
        NSArray* originLeaderIDs = [model.leadersId componentsSeparatedByString:@" "];
        for (NSString* u_id in originLeaderIDs) {
            if (![arr containsObject:u_id]) {
                if (!self.filterIds || self.filterIds.length == 0) {//如果不过滤，那么都添加
                    [arr addObject:u_id];
                }else{
                    if ([self.filterIds containsString:u_id]) { [arr addObject:u_id];}
                }
            }
            
        }

    }
    
    cell.showLeaderIDs = arr;
    
    return cell;
}

#pragma mark -
#pragma mark - FSCalendarDelegate
// 日历主标题默认颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:kLSDefaultTitleColor];
}

/**
 * Asks the delegate for a fill color in selected state for the specific date.
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    
    return [UIColor clearColor];
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter dateFromString:@"2000/01/01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter dateFromString:@"2050/12/31"];
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
