//
//  ListCalendarVC.m
//  LSchedule
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "ListCalendarVC.h"
#import "Masonry.h"
#import "LSAgendaModel.h"
#import "LSEmptyTableView.h"
#import "LSUtils.h"
#import "LSAgendaCell.h"
#import "LSAgendaHeader.h"
#import "LSAgendaViewController.h"

@interface ListCalendarVC ()<FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate>

/** 上下滑动的手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/** 列表 */
@property (nonatomic, strong) LSEmptyTableView* tableView;

/** 日程数据源 按日期获取 */
@property (nonatomic, strong) NSMutableArray<LSAgendaModel*>* dataSource;

@end

@implementation ListCalendarVC


#pragma mark -
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@(self.view.frame.size.width));
    }];
    
    [self.calendar setScope:(FSCalendarScopeWeek) animated:NO];
    
    [self configureCalendar];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.calendar.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
//    [self.calendar selectDate:[NSDate date]];
    
    [self addGesture];
//    [self setupLeftRightView];
    // Do any additional setup after loading the view.
}

-(void)configureCalendar{
    UIView* line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.calendar.calendarWeekdayView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendar.calendarWeekdayView.mas_left).offset(0);
        make.right.equalTo(self.calendar.calendarWeekdayView.mas_right).offset(0);
        make.bottom.equalTo(self.calendar.calendarWeekdayView.mas_bottom).offset(0);
        //高度可能会引起警告，因为日历控件的星期视图不一定有约束
        make.height.mas_equalTo(@(0.5));
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.hasLayoutSubViews = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.currentSelectDate) {
//        [self.calendar setCurrentPage:self.currentSelectDate animated:YES];
        [self.calendar selectDate:self.currentSelectDate scrollToDate:YES];
        self.isTransitioFromOther = NO;
    }
    
    if (self.hasLayoutSubViews) {
        [self reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startLoading{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startAnimating];
}

-(void)endLoading{
    [self.tableView stopAnimating];
}

-(void)reloadData{
    NSArray* array = [LSAgendaModel queryModelsDate:self.calendar.selectedDate leadersId:self.filterIds];
    self.dataSource = [NSMutableArray arrayWithArray:array];
    [self.calendar reloadData];
    [self.tableView reloadData];
}

-(void)endLoadingError:(id)error{
    [self reloadData];
}

#pragma mark -
#pragma mark - method
-(void)addGesture{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:self.panGesture];
    
    //    self.scopeGesture = panGesture;
    //
    //    // While the scope gesture begin, the pan gesture of tableView should cancel.
    //
    //    //打开以下两个方法，那么会处理tableview滚动和手势联动的问题，可全屏滑动；目前只能在日历上上下滑动
    ////    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    ////    panGesture.delegate = self;
    //
    //    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    //
    //    // For UITest
    //    self.calendar.accessibilityIdentifier = @"calendar";
}

-(void)addScheduleWithModel:(LSAgendaModel*)model{
    //这里跳转到创建日程页面
    LSAgendaViewController* vc = [[LSAgendaViewController alloc] init];
    vc.model = model;
    __weak typeof(self) wealkSelf = self;
    vc.operateSuccessBlock = ^{
        [wealkSelf reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - FSCalendarDelegate
-(void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{
    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(bounds));
    }];
    [self.view layoutIfNeeded];
    
    
}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    self.currentSelectDate = date;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCalendarViewController:didSelcetDate:)]) {
        [self.delegate baseCalendarViewController:self didSelcetDate:date];
    }
    
    [self reloadData];
}

-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
//    self.currentSelectDate = calendar.currentPage;

    
    if (self.calendar.scope == FSCalendarScopeWeek) {
        //当前选中日期跟当前的page比较，如果比当前的小  往后减七天  否则加七天
        NSTimeInterval interval = 0;
        if ([self.calendar.selectedDate compare:self.calendar.currentPage] == NSOrderedAscending) { //selectedDate -> currentPage 递增的  表示往大的日期滑动 + 7 * 24 * 60 * 60
            interval = 7 * 24 * 60 * 60;
        }else{
            interval = -(7 * 24 * 60 * 60);
        }
        
        if (!self.isTransitioFromOther) {
            [self.calendar selectDate:[NSDate dateWithTimeInterval:interval sinceDate:self.calendar.selectedDate]];
        }else{
        
        }
        
        
    }else{
        [self.calendar selectDate:self.calendar.currentPage];
    }
    
//    [self.calendar selectDate:self.calendar.currentPage];
    self.currentSelectDate = self.calendar.selectedDate;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCalendarViewController:didSelcetDate:)]) {
        [self.delegate baseCalendarViewController:self didSelcetDate:calendar.selectedDate];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCalendarViewController:pageChange:)]) {
        [self.delegate baseCalendarViewController:self pageChange:calendar.selectedDate];
    }
    
}

#pragma mark -
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSAgendaCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //控件赋值
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSAgendaModel* model = self.dataSource[indexPath.row];//获取当前日程对象
    LSUser* user = [LSUser currentUser];//查询当前用户
    
    if (!user) {
        return;
    }
    
    if (![user.userId isEqualToString:model.creatorId]) {//只有本人创建的才能够修改
        return;
    }
    
    //修改编辑日程
    [self addScheduleWithModel:model];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.dataSource.count > 0 ? 62.5 : 10;
}

#pragma mark -
#pragma mark - getter
-(LSEmptyTableView *)tableView{
    if (!_tableView) {
        _tableView = [[LSEmptyTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSAgendaCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSAgendaHeader class]) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"header"];
        
    }
    
    return _tableView;
}

#pragma mark - FSCalendarDataSource
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    
    NSInteger day = [self.lunarCalendar component:NSCalendarUnitDay fromDate:date];
    return [self.gregorianCalendar isDateInToday:date] ? @"今天" : self.lunarChars[day - 1];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    
    return [LSAgendaModel queryModelsDate:date leadersId:self.filterIds].count == 0 ? 0 : 1;
}


-(UIImage*)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date{
    if (![[LSAgendaModel holidays] isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString* dateStr = [self.dateFormatter stringFromDate:date];
    
    return [[LSAgendaModel holidays] containsString:dateStr] ? [UIImage imageWithString:@"休"] : nil;
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

#pragma mark -
#pragma mark - FSCalendarDelegateAppearance
//今天
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date{
    
    return [self.gregorianCalendar isDateInToday:date] ? [UIColor colorWithHex:KLSViewBackColor] : nil;
}

//默认背景填充颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    
    return  [self.gregorianCalendar isDateInToday:date] ? [UIColor whiteColor] : nil;
}

//选中背景填充颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    
    return [UIColor colorWithHex:KLSViewBackColor];
}

// 日历主标题默认颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:kLSDefaultTitleColor];
}

// 日历副标题选中颜色
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(nonnull NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:@"666666"];
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
