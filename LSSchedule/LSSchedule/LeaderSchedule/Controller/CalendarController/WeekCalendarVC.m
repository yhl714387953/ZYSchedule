//
//  WeekCalendarVC.m
//  LSchedule
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "WeekCalendarVC.h"
#import "Masonry.h"
#import "LSUtils.h"
#import "WeekCalendarBackView.h"
#import "WeekEventCell.h"

@interface WeekCalendarVC ()<FSCalendarDelegate, FSCalendarDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

{
    BOOL _hasResetCalendar;
    NSInteger _cellCount;
}

/** 背景格子 */
@property (nonatomic, strong) WeekCalendarBackView* backView;

/** <#description#> */
@property (nonatomic, strong) UICollectionView* collectionView;

@end

@implementation WeekCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"F4F4F4"];
    _cellCount = 7;
    
    [self configureCalendar];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendar.mas_bottom).offset(0);
        make.left.equalTo(self.calendar.mas_left).offset(0);
        make.right.equalTo(self.calendar.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self configureLeftLine];
    
    self.backView = [[WeekCalendarBackView alloc] initWithFrame:CGRectZero];
    self.collectionView.backgroundView = self.backView;

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    // Do any additional setup after loading the view.
}

-(void)configureCalendar{
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@(self.view.frame.size.width));
    }];
    
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.calendar.weekdayHeight = 30;
    self.calendar.allowsSelection = YES;
    self.calendar.appearance.selectionColor = [UIColor clearColor];
    [self.calendar setScope:(FSCalendarScopeWeek) animated:NO];
    [self setupLeftRightView];
}

-(void)configureLeftLine{
    UIView* line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.collectionView.mas_left).offset(0);
        make.top.equalTo(self.collectionView.mas_top).offset(0);
        //高度可能会引起警告，因为日历控件的星期视图不一定有约束
        make.height.mas_equalTo(@(0.5));
    }];
}

-(void)pan:(UIPanGestureRecognizer*)tap{
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.backView.frame = self.collectionView.bounds;
    
    self.hasLayoutSubViews = YES;
    self.backView.startY = 0.25;
    self.backView.startX = 0.25;
    self.backView.columnCount = -1;// 7;
    self.backView.columnSpacing = self.backView.frame.size.width / 7.0;
    self.backView.lineCount = 10;
    self.backView.lineSpacing = self.backView.frame.size.height / 10.0;
    
    [self.backView drawSquare];
    [self.collectionView reloadData];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    if (self.hasLayoutSubViews) {
        [self reloadData];
        
        if (self.currentSelectDate) {
            [self.calendar selectDate:self.currentSelectDate scrollToDate:YES];
            self.isTransitioFromOther = NO;
        }
    }
}

-(void)reloadData{
    _cellCount = 7;
    [self.collectionView reloadData];
}

-(void)startLoading{
    _cellCount = 0;
    [self.collectionView reloadData];
}

-(void)endLoading{
    
}

//加载失败了可以用本地数据刷
-(void)endLoadingError:(id)error{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - FSCalendarDelegate
-(void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{
    
    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(bounds));
    }];

    [self.view layoutIfNeeded];
    
}

/*
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    self.currentSelectDate = date;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCalendarViewController:didSelcetDate:)]) {
        [self.delegate baseCalendarViewController:self didSelcetDate:date];
    }
    
//    [self reloadData];
}
*/

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
        }
        
        
    }else{
        [self.calendar selectDate:self.calendar.currentPage];
    }

    self.currentSelectDate = self.calendar.selectedDate;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCalendarViewController:didSelcetDate:)]) {
        [self.delegate baseCalendarViewController:self didSelcetDate:calendar.selectedDate];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCalendarViewController:pageChange:)]) {
        [self.delegate baseCalendarViewController:self pageChange:calendar.selectedDate];
    }
    
}

#pragma mark -
#pragma mark - FSCalendarDelegateAppearance
//今天
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date{
    
    return [UIColor clearColor];// [self.gregorianCalendar isDateInToday:date] ? [UIColor colorWithHex:KLSViewBackColor] : nil;
}

//默认背景填充颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    
    return [UIColor clearColor];//  [self.gregorianCalendar isDateInToday:date] ? [UIColor whiteColor] : nil;
}

//选中背景填充颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    
    return [UIColor clearColor];// [UIColor colorWithHex:KLSViewBackColor];
}

//边框选中颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date{
    return [UIColor clearColor];
}

//选中主标题颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:kLSDefaultTitleColor];
}
//选中副标题颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:@"666666"];
}

// 日历主标题默认颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:kLSDefaultTitleColor];
}

// 日历副标题选中颜色
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(nonnull NSDate *)date{
    
    return [self.gregorianCalendar isDateInWeekend:date] ? [UIColor colorWithHex:@"999999"] : [UIColor colorWithHex:@"666666"];
}

#pragma mark - FSCalendarDataSource
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    
    NSInteger day = [self.lunarCalendar component:NSCalendarUnitDay fromDate:date];
    return self.lunarChars[day - 1];
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
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cellCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeekEventCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if(self.calendar.visibleCells.count > indexPath.item){
        
        NSArray* dates = [self weekDates:self.calendar.currentPage];
        NSDate* date = dates[indexPath.item];
 
        NSMutableArray* models = [NSMutableArray arrayWithArray:[LSAgendaModel queryLegalModelsDate:date leadersId:self.filterIds]];
        
        cell.models = models;
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
        [cell setNeedsLayout];
        
    }

    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = collectionView.frame.size.height;
    CGFloat width = collectionView.frame.size.width / 7;
    
    return CGSizeMake(width, height);
}

#pragma mark -
#pragma mark - getter
-(NSArray<NSDate *> *)weekDates:(NSDate*)date{
    NSMutableArray* dates = [NSMutableArray array];
    
    NSTimeInterval time_difference = 24 * 60 * 60;
    
    //获取当天星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger week = [comps weekday]; //1－－星期天    2－－星期一 一次往后
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    [dates addObject:date];
    //当天到周日
    for (NSInteger i = 1; i < 9 - week; i++) {
        NSDate* affter_date = [NSDate dateWithTimeIntervalSince1970:interval + time_difference * i];
        [dates addObject:affter_date];
    }
    
    // 周一到当天
    for (NSInteger i = 0; i < week - 2; i++) {
        NSDate* before_date = [NSDate dateWithTimeIntervalSince1970:interval - time_difference * (i + 1)];
        [dates addObject:before_date];
    }
    
    NSArray* sortArr = [dates sortedArrayUsingComparator:^NSComparisonResult(NSDate* obj1, NSDate* obj2) {
        NSDate* date1 = (NSDate*)obj1;
        NSDate* date2 = (NSDate*)obj2;
        
        return [date1 compare:date2];
    }];
    

    return sortArr;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = NO;
        [self.collectionView registerClass:[WeekEventCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    return _collectionView;
}

-(void)setupLeftRightView{
    UIView* leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor whiteColor];
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
