//
//  LSAgendaViewController.m
//  LSchedule
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSAgendaViewController.h"
#import "LSTextFieldCell.h"
#import "LSTextViewCell.h"
#import "LSPersonCell.h"
#import "LSBottomButtonCell.h"
#import "UITextView+LSPlaceHolder.h"
#import "LSTimePickerViewController.h"
#import "LSTypePickerViewController.h"
#import "LSUtils.h"
#import "Masonry.h"
#import "UIButton+LSCategory.h"

@interface LSAgendaViewController ()<LSTextFieldCellDelegate, UITextFieldDelegate, LSTextViewCellDelegate, LSBottomButtonCellDelegate, LSPersonCellDelegate, UITableViewDataSource, UITableViewDelegate>
/** <#description#> */
@property (nonatomic, strong) UITableView* tableView;

/** <#description#> */
@property (nonatomic, strong) LSBottomButtonCell* bottomView;

/** 数据模型，用于填充数据、保持数据、提交数据 */
@property (nonatomic, strong) LSAgendaModel* agendaModel;

@end

#define bottomViewHeight 60

@implementation LSAgendaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新日程";

    
    if(self.model){
        self.agendaModel = [LSAgendaModel copyModel:self.model];
    }else{
        self.agendaModel = [[LSAgendaModel alloc] init];
        self.agendaModel.meetType = @"会议";
        self.agendaModel.content = @"";
        self.agendaModel.startTime = [LSUtils stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
        self.agendaModel.endTime = [LSUtils stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottomViewHeight);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(-1);
        make.bottom.equalTo(self.view.mas_bottom).offset(1);
        make.right.equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(@(bottomViewHeight));
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark - method
-(void)keyboardWillShow:(NSNotification*)notification{
//    NSLog(@"%@", notification.userInfo);
//    CGFloat duration = [[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
 
        make.bottom.equalTo(self.view.mas_bottom).offset(-rect.size.height);
    }];
    
    [self.view layoutIfNeeded];
}

-(void)keyboardWillhide:(NSNotification*)notification{
//    NSLog(@"%@", notification.userInfo);

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottomViewHeight);
    }];
    
    [self.view layoutIfNeeded];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        LSPersonCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSPersonCell class])];
        cell.selectPerson = self.agendaModel.leaders ? : @"";
        cell.delegate = self;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        return cell;
    }else if (indexPath.row == 0 || indexPath.row == 6 || indexPath.row == 7){
        LSTextViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSTextViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.delegate = self;
        cell.maxNumberWords = 100;
        if (indexPath.row == 0) {
            cell.label.text = @"主题";
            cell.maxNumberWords = 50;
            cell.textView.text = self.agendaModel.content ? : @"";
            cell.textView.placeholder = @"请输入会议主题";
            
        }else if (indexPath.row == 6) {
            cell.label.text = @"地点";
            cell.textView.text = self.agendaModel.address ? : @"";
            cell.textView.placeholder = @"添加地点";
            cell.maxNumberWords = 100;
        }else{
            cell.label.text = @"备注";
            cell.textView.text = self.agendaModel.remark ? : @"";
            cell.textView.placeholder = @"添加备注";
            cell.maxNumberWords = 100;
        }
        
        return cell;
    }
    
    LSTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSTextFieldCell class])];
    cell.delegate = self;
    cell.textField.delegate = self;
    cell.button.hidden = indexPath.row != 5;
    cell.indicatorButton.hidden = indexPath.row != 1;
    if (indexPath.row == 1){
        cell.label.text = @"类型";
        cell.textField.placeholder = @"请选择类型";
        cell.textField.text = self.agendaModel.meetType ? : @"";
        cell.textField.userInteractionEnabled = NO;
    }else if (indexPath.row == 3){
        cell.label.text = @"时间";
        cell.textField.text = self.agendaModel.startTime ? [LSUtils stringFromDate:[LSUtils serverDateFromString:self.agendaModel.startTime] format:@"yyyy-MM-dd    HH:mm"] : @"";
        cell.textField.placeholder = @"请选择开始时间";
        cell.textField.userInteractionEnabled = NO;
    }else if (indexPath.row == 4){
        cell.label.text = @"";
        cell.textField.text = self.agendaModel.endTime ? [LSUtils stringFromDate:[LSUtils serverDateFromString:self.agendaModel.endTime] format:@"yyyy-MM-dd    HH:mm"] : @"";
        cell.textField.placeholder = @"请选择结束时间";
        cell.textField.userInteractionEnabled = NO;
        
    }else if (indexPath.row == 5){
        cell.label.text = @"";
        cell.textField.text = @"";
        cell.textField.placeholder = @"";
        cell.textField.userInteractionEnabled = NO;
        cell.button.selected = self.agendaModel.holiday;
    }
    
    // Configure the cell...
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (indexPath.row == 3 || indexPath.row == 4) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 85, 0, 0)];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    __weak typeof (self)weakSelf = self;
    if (indexPath.row == 1) {
        LSTypePickerViewController* vc = [[LSTypePickerViewController alloc] init];
        vc.selectTitle = self.agendaModel.meetType;
        
        vc.clickBlock = ^(NSString *title) {
            weakSelf.agendaModel.meetType = title;
            [weakSelf.tableView reloadData];
        };
        [self presentViewController:vc animated:NO completion:^{
            
        }];
    }else if (indexPath.row == 3 || indexPath.row == 4){//开始时间  结束时间
        NSInteger index = indexPath.row;
        
        if (index == 4 && !self.agendaModel.startTime) {
            NSLog(@"请选择开始时间");

            [LSUtils showMessage:@"请选择开始时间"];
            return;
        }
        
        LSTimePickerViewController* vc = [[LSTimePickerViewController alloc] init];
        
        vc.minDateString = index == 4 ? self.agendaModel.startTime : nil;
    
        vc.timeChange = ^(NSDate *date) {
            NSString* format = @"yyyy-MM-dd HH:mm:ss";
            if (index == 3) {
                weakSelf.agendaModel.startTime = [LSUtils stringFromDate:date format:format];
            }else{
                weakSelf.agendaModel.endTime = [LSUtils stringFromDate:date format:format];
            }
            
            [weakSelf.tableView reloadData];
            
        };
        [self presentViewController:vc animated:NO completion:^{
            
        }];
    }else if (indexPath.row == 5){//是否包含节假日
        self.agendaModel.holiday = !self.agendaModel.holiday;
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}



#pragma mark -
#pragma mark - TextFieldCellDelegate
-(void)textFieldCell:(LSTextFieldCell *)cell textChange:(NSString *)text{
    NSLog(@"%@",text);
}

#pragma mark -
#pragma mark - LSTextViewCellDelegate
-(void)textViewCell:(LSTextViewCell *)cell textChange:(NSString *)text{
    NSLog(@"===%@", text);
//    if ([text containsString:@"\n"]) {
//        [self.view endEditing:YES];
//        return
//    }
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {//当输入emoji表情的时候会为空，禁止输入emoji表情
        return;
    }
    
    
    if (indexPath.row == 0) {
        self.agendaModel.content = text;
    }else if (indexPath.row == 6) {
        self.agendaModel.address = text;
    }else if (indexPath.row == 7) {
        self.agendaModel.remark = text;
    }
}

-(void)textViewCell:(LSTextViewCell *)cell textHeightChange:(NSString *)text{
    //高度自适应一下
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark - LSBottomButtonCellDelegate
-(void)bottomButtonCell:(LSBottomButtonCell *)cell clickAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld", (long)buttonIndex);
    //0 左侧的按钮(删除)     1 右侧的按钮(保存和更新)
    
    if (buttonIndex == 0) {
        if (!self.agendaModel.noId) {//如果没有ID表示新建，删除就直接返回
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [self.bottomView.leftButton startAnimating];
            self.bottomView.userInteractionEnabled = NO;
            
            [LSAgendaModel asyncDeleteAgendaById:self.agendaModel.noId successBlock:^(id data) {
                [self.agendaModel deleteObject];//删除本地数据库中的日程
                
                if (self.operateSuccessBlock) {
                    self.operateSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failureBlock:^(id msg, ERequestState state) {
                [LSUtils showMessage:msg];
                self.bottomView.userInteractionEnabled = YES;
                [self.bottomView.leftButton stopAnimating];
            }];
        }
    }else{

        [self saveAgenda];
    }

}

-(void)saveAgenda{
    //参数校验
    NSString* theme = [self.agendaModel.content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (theme.length == 0) {
        [LSUtils showMessage:@"请输入主题"];
        
        return;
    }
    
    if ([LSUtils stringContainsEmoji:theme]) {
        
        [LSUtils showMessage:@"主题不能包含表情"];
        return;
    }
    
    if (!self.agendaModel.meetType) {
        [LSUtils showMessage:@"请选择类型"];
        
        return;
    }
    
    if (!self.agendaModel.startTime) {
        [LSUtils showMessage:@"请选择开始时间"];
        
        return;
    }
    
    if (!self.agendaModel.endTime) {
        [LSUtils showMessage:@"请选择结束时间"];
        
        return;
    }
    
    if (self.agendaModel.address && [LSUtils stringContainsEmoji:self.agendaModel.address]) {
        
        [LSUtils showMessage:@"地址不能包含表情"];
        return;
    }
    
    if (self.agendaModel.remark && [LSUtils stringContainsEmoji:self.agendaModel.remark]) {
        
        [LSUtils showMessage:@"备注不能包含表情"];
        return;
    }
    
    NSString* nowTime = [LSUtils stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm"];
    NSComparisonResult result_begin = [[self.agendaModel.startTime substringToIndex:16] compare:nowTime];
    if (result_begin == NSOrderedAscending || result_begin == NSOrderedSame) {
        [LSUtils showMessage:@"开始时间必须大于当前时间"];
        
        return;
    }
    
    NSComparisonResult result_end = [[self.agendaModel.endTime substringToIndex:16] compare:[self.agendaModel.startTime substringToIndex:16]];
    if (result_end == NSOrderedAscending || result_end == NSOrderedSame) {
        [LSUtils showMessage:@"结束时间必须大于开始时间"];
        
        return;
    }

    BOOL isAllHoliday = [LSUtils isAllHolidayBetweenStartDate:[LSUtils serverDateFromString:self.agendaModel.startTime] endDate:[LSUtils serverDateFromString:self.agendaModel.endTime]];
    if (isAllHoliday && !self.agendaModel.holiday) {//如果不选定节假日并且当前的时间都在节假日内，那么提示一下
        NSLog(@"obj  ===%@", @"你真的要节假日干活");
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"" message:@"当前选择时间段均在节假日范围内，您确定提交吗？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction* actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.agendaModel.holiday = YES;
            [self.tableView reloadData];
            [self submitData];
        }];
        [ac addAction:actionConfirm];
        
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
   
        }];
        [ac addAction:actionCancel];
        
        [self presentViewController:ac animated:YES completion:^{
            
        }];
 
    }else{
        [self submitData];
    }

}

-(void)submitData{
    
    if (!self.agendaModel.address) {
        self.agendaModel.address = @"";
    }
    
    if (!self.agendaModel.remark) {
        self.agendaModel.remark = @"";
    }
    
    [self.bottomView.rightButton startAnimating];
    self.bottomView.userInteractionEnabled = NO;
    [LSAgendaModel asyncUpdateAgendaInfo:self.agendaModel successBlock:^(id data) {
        if (self.operateSuccessBlock) {
            self.operateSuccessBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(id msg, ERequestState state) {
        [LSUtils showMessage:msg];
        self.bottomView.userInteractionEnabled = YES;
        [self.bottomView.rightButton stopAnimating];
    }];
}

#pragma mark -
#pragma mark - LSPersonCellDelegate
-(void)personCell:(LSPersonCell *)cell selectLeaderChange:(NSArray<LSLeader *> *)leaders{

    self.agendaModel.leaders = @"";
    self.agendaModel.leadersId = @"";
    
    //这个就有点尴尬了
    for (LSLeader* leader in leaders) {
        self.agendaModel.leaders = [self.agendaModel.leaders stringByAppendingFormat:@" %@", leader.name];
        self.agendaModel.leadersId = [self.agendaModel.leadersId stringByAppendingFormat:@" %@", leader.userId];
    }
    
    
    if (leaders.count == 0) {
        return;
    }
    self.agendaModel.leaders = [self.agendaModel.leaders substringFromIndex:1];
    self.agendaModel.leadersId = [self.agendaModel.leadersId substringFromIndex:1];
    
}

#pragma mark -
#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:@"F4F4F4"];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  
        [_tableView registerClass:[LSTextFieldCell class] forCellReuseIdentifier:NSStringFromClass([LSTextFieldCell class])];
        [_tableView registerClass:[LSTextViewCell class] forCellReuseIdentifier:NSStringFromClass([LSTextViewCell class])];
        [_tableView registerClass:[LSPersonCell class] forCellReuseIdentifier:NSStringFromClass([LSPersonCell class])];
        
        self.tableView.tableFooterView = [[UIView alloc] init];
        
    }
    
    return _tableView;
}

-(LSBottomButtonCell *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LSBottomButtonCell alloc] initWithFrame:CGRectZero];
        _bottomView.delegate = self;
        
        NSString* title = self.agendaModel.noId ? @"删除" : @"取消";
        UIColor* color = self.agendaModel.noId ? [UIColor redColor] : [UIColor darkTextColor];
        [_bottomView.leftButton setTitle:title forState:(UIControlStateNormal)];
        [_bottomView.leftButton setTitleColor:color forState:(UIControlStateNormal)];
        
        _bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bottomView.layer.borderWidth = 0.5;
        
    }
    
    return _bottomView;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
