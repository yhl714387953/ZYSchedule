//
//  LSTextFieldCell.h
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSTextFieldCell;
@protocol LSTextFieldCellDelegate <NSObject>

@optional
-(void)textFieldCell:(LSTextFieldCell*)cell textChange:(NSString*)text;

@end

@interface LSTextFieldCell : UITableViewCell

/** <#description#> */
@property (nonatomic, weak) id<LSTextFieldCellDelegate> delegate;

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
/** 时报包含节假日 */
@property (nonatomic, strong) UIButton* button;

/** 指示按钮 */
@property (nonatomic, strong) UIButton* indicatorButton;

@end
