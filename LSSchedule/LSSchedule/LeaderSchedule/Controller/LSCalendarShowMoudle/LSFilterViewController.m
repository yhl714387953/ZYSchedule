//
//  LSFilterViewController.m
//  LSchedule
//
//  Created by 3dprint on 2017/6/21.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSFilterViewController.h"
#import "LSPersonFilterCell.h"
#import "LSAgendaModel.h"
#import "Masonry.h"
#import "LSUtils.h"

@interface LSFilterViewController ()<UITableViewDelegate,UITableViewDataSource,LSPersonFilterCellDelegate>
/** <#description#> */
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation LSFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(@270);
        make.height.mas_equalTo(@238);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(self.tableView.frame, point)) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.tableView.alpha = 1;
    }];
}

-(void)doneBtnClicked{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewController:didSelectLeaers:)]) {
        [self.delegate filterViewController:self didSelectLeaers:self.selectLeaders];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSPersonFilterCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSPersonFilterCell class])];

    cell.delegate = self;
    
    NSString* selectPerson = @"";
    for (LSLeader* leader in self.selectLeaders) {
        selectPerson = [selectPerson stringByAppendingFormat:@" %@", leader.userId];
    }
    if (selectPerson.length > 0) {
        selectPerson= [selectPerson substringFromIndex:1];
    }
    
    cell.selectPerson = selectPerson;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}

#pragma mark -
#pragma mark - LSPersonCellDelegate
-(void)personFilterCell:(LSPersonFilterCell *)cell didSelectLeaders:(NSArray<LSLeader *> *)leaders{
    self.selectLeaders = leaders;
    
}

#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[LSPersonFilterCell class] forCellReuseIdentifier:NSStringFromClass([LSPersonFilterCell class])];
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 145.0f;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 47)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"请选择领导";
        titleLabel.textColor = [[UIColor darkTextColor] colorWithAlphaComponent:0.7];
        titleLabel.layer.borderWidth = 0.5f;
        titleLabel.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        self.tableView.tableHeaderView = titleLabel;
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 47);
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setTitle:@"确定" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithStr:KLSViewBackColor]] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(doneBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
        self.tableView.tableFooterView = btn;
    }
    return _tableView;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
