//
//  LSCooCalendarViewController.m
//  LSchedule
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSCooCalendarViewController.h"

#import "LSShowModeToolBar.h"
#import "Masonry.h"
#import "LSUtils.h"
#import "Masonry.h"

#import "LSAgendaViewController.h"

#import "ListCalendarVC.h"
#import "MonthCalendarVC.h"
#import "WeekCalendarVC.h"

#import "LSShowModeToolBar.h"

#import "LSFilterViewController.h"

@interface LSCooCalendarViewController ()
<
LSShowModeToolBarDelegate,
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
LSFilterViewControllerDelegate,
BaseCalendarVCDelegate
>

/** page控制器 */
@property (nonatomic, strong) UIPageViewController* pageViewController;
/** 是否要加载其它视图 加载完成后要置NO */
@property (nonatomic) BOOL willTransition;

/** 模式切换工具栏 */
@property (nonatomic, strong) LSShowModeToolBar* showModeToolBar;

/** 列表日历 */
@property (nonatomic, strong) ListCalendarVC* listCalendarVC;

/** 月日历 */
@property (nonatomic, strong) MonthCalendarVC* monthCalendarVC;

/** 周日历 */
@property (nonatomic, strong) WeekCalendarVC* weekCalendarVC;

/** 当前日历控制器 */
@property (nonatomic, strong) BaseCalendarViewController* currentCalendarVC;

@end

@implementation LSCooCalendarViewController

#pragma mark -
#pragma mark - 预留的接口
-(void)setPhoneNumber:(NSString *)phoneNumber{
    _phoneNumber = phoneNumber;
    
    kLSTempPhoneNumber = phoneNumber;
}

-(void)setBaseUrl:(NSString *)baseUrl{
    _baseUrl = baseUrl;
    
    kLSBaseURL = baseUrl;
    [LSRequest sharedManager];
    [LSRequest checkNetworkStatus:^(AFNetworkReachabilityStatus status) {
        NSLog(@"网络变化了");
    }];
}


#pragma mark -
#pragma mark - lift circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightBarItermFromCache:NO];
    
    [self setupViews];
    
    self.title = [LSUtils stringFromDate:[NSDate date] format:@"yyyy年MM月"];
    
    [self getDataWitdDate:[NSDate date]];
    
    // Do any additional setup after loading the view.
}

-(void)lsBack{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)setupViews{
    
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    
    self.showModeToolBar = [[LSShowModeToolBar alloc] init];
    self.showModeToolBar.delegate = self;
    self.showModeToolBar.clipsToBounds = true;
    [self.view addSubview:self.showModeToolBar];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:dic];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.listCalendarVC = [[ListCalendarVC alloc] init];
    self.listCalendarVC.delegate = self;
    self.monthCalendarVC = [[MonthCalendarVC alloc] init];
    self.weekCalendarVC = [[WeekCalendarVC alloc] init];
    self.weekCalendarVC.delegate = self;
    
    //设置第一页  可以通过事件主动切换视图，切换视图注意方向
    [self.pageViewController setViewControllers:@[self.listCalendarVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:^(BOOL finished) {
        
    }];

    self.currentCalendarVC = self.listCalendarVC;
    
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view belowSubview:self.showModeToolBar];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.showModeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@47);
    }];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showModeToolBar.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if ([viewController isEqual:self.listCalendarVC]) {
        return nil;
    }else if ([viewController isEqual:self.monthCalendarVC]){
        return self.listCalendarVC;
    }else if ([viewController isEqual:self.weekCalendarVC]){
        return self.monthCalendarVC;
    }else{
        return nil;
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if ([viewController isEqual:self.listCalendarVC]) {
        return self.monthCalendarVC;
    }else if ([viewController isEqual:self.monthCalendarVC]){
        return self.weekCalendarVC;
    }else if ([viewController isEqual:self.weekCalendarVC]){
        return nil;
    }else{
        return nil;
    }
}

// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSLog(@"willTransitionToViewControllers  %@", pendingViewControllers);
    self.willTransition = YES;
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
//    if (completed && self.willTransition) {
//        id obj = [previousViewControllers lastObject];
//        self.switchBar.selectIndex = [obj isKindOfClass:[LSCommentViewController class]] ? 1 : 0;
//        self.willTransition = NO;
//    }
}

#pragma mark -
#pragma mark - LSShowModeToolBarDelegate
-(void)conferenceToolBar:(NSArray *)btnArray clickButton:(UIButton *)button buttonType:(LSShowModeType)type{
    
    BaseCalendarViewController* vc = self.listCalendarVC;
    switch (type) {
        case LSShowMode_ListShow:
            vc = self.listCalendarVC;
            break;
            
        case LSShowMode_MothShow:
            vc = self.monthCalendarVC;
            break;
            
        case LSShowMode_WeekShow:
            vc = self.weekCalendarVC;
            break;
            
        default:
        {
            LSFilterViewController *fv = [[LSFilterViewController alloc] init];
            fv.providesPresentationContextTransitionStyle = YES;
            fv.definesPresentationContext = YES;
            fv.delegate = self;
            fv.selectLeaders = self.currentCalendarVC.filterLeaders;
            fv.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:fv animated:NO completion:nil];
            
            return;
        }
            
            break;
    }
    
    vc.isTransitioFromOther = YES;
    self.currentCalendarVC = vc;
    [self.pageViewController setViewControllers:@[vc] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark - method
-(void)getDataWitdDate:(NSDate*)date{
    
    NSTimeInterval start = [[LSUtils firstDateInMonth:date] timeIntervalSince1970] * 1000;
    NSTimeInterval end = [[LSUtils lastDateInMonth:date] timeIntervalSince1970] * 1000;
    
    [self.currentCalendarVC startLoading];
    [LSAgendaModel asyncGetAgendaListStartTime:start endTime:end successBlock:^(NSMutableDictionary* data) {

        [self.currentCalendarVC endLoading];
        [self.currentCalendarVC reloadData];
        
        [self initRightBarItermFromCache:YES];
    } failureBlock:^(id msg, ERequestState state) {
        [self.currentCalendarVC endLoading];
        [self.currentCalendarVC endLoadingError:msg];
        
       if([msg isKindOfClass:[NSString class]]) [LSUtils showMessage:msg];

    }];
}

-(void)initRightBarItermFromCache:(BOOL)isFromCache{
    if (self.navigationItem.rightBarButtonItems.count > 1) {
        return;
    }
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_schedule"] style:(UIBarButtonItemStylePlain) target:self action:@selector(createSchedule)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"toolbarswitch"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"toolbarswitch"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(showModelSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0,30, 30);
    
    UIBarButtonItem* showModelSwitchBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if ([LSUser canCreateSchedule]) {
        self.navigationItem.rightBarButtonItems = isFromCache ? @[showModelSwitchBtn,rightItem] : @[showModelSwitchBtn];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = @[showModelSwitchBtn];
    }
}

-(void)showModelSwitchBtnClick:(UIButton *)button
{
    BOOL selected = !button.isSelected;
    button.selected = selected;
    
    NSNumber *barH = (selected ? @0 : @47);
    [self.showModeToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(barH);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)createSchedule{
    //这里跳转到创建日程页面
    LSAgendaViewController* vc = [[LSAgendaViewController alloc] init];
    
    __weak typeof(self) wealkSelf = self;
    vc.operateSuccessBlock = ^{
        [wealkSelf.currentCalendarVC reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LSFilterViewControllerDelegate
-(void)filterViewController:(LSFilterViewController *)filterViewController didSelectLeaers:(NSArray<LSLeader *> *)leaders{
    self.listCalendarVC.filterLeaders = leaders;
    self.monthCalendarVC.filterLeaders = leaders;
    self.weekCalendarVC.filterLeaders = leaders;
    
    [self.currentCalendarVC reloadData];
    
//    [self.listCalendarVC reloadData];
//    [self.monthCalendarVC reloadData];
//    [self.weekCalendarVC reloadData];
   
    NSString* filterLeaderNames = @"";
    
    //这个就有点尴尬了
    for (LSLeader* leader in leaders) {
        filterLeaderNames = [filterLeaderNames stringByAppendingFormat:@" %@", leader.name];
    }
    if (filterLeaderNames.length > 0) {
        filterLeaderNames = [filterLeaderNames substringFromIndex:1];
    }
    
    self.showModeToolBar.filter = filterLeaderNames;
    
}

#pragma mark -
#pragma mark - BaseCalendarVCDelegate
-(void)baseCalendarViewController:(BaseCalendarViewController *)controller pageChange:(NSDate *)date{
    
    [self getDataWitdDate:date];
}

-(void)baseCalendarViewController:(BaseCalendarViewController *)controller didSelcetDate:(NSDate *)date{
    self.title = [LSUtils stringFromDate:date format:@"yyyy年MM月"];
    
    self.listCalendarVC.currentSelectDate = date;
    self.monthCalendarVC.currentSelectDate = date;
    self.weekCalendarVC.currentSelectDate = date;
    
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
