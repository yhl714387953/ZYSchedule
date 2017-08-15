//
//  LSPersonCell.m
//  LSchedule
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSPersonCell.h"
#import "Masonry.h"
#import "LSUtils.h"

@implementation LSPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //    NSLog(@"%@", persons);
        
        [self.collectionView registerClass:[PCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        [self setupSubViews];
    }

    return self;
}

-(void)setupSubViews{
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.tipImageView];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.height.mas_equalTo(@14);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(85);
        
        make.height.mas_equalTo(@(110));
        make.width.mas_equalTo(@(200));

    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(25);
        make.left.equalTo(self.collectionView.mas_left).offset(0);
        make.height.mas_equalTo(@14);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15).priority(999);
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).offset(-5);
        make.left.equalTo(self.tipLabel.mas_right).offset(2);

    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < self.leaders.count; i++) {
        LSLeader* leader = self.leaders[i];
        if ([self.selectPerson containsString:leader.name]) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
        }
    }

}


#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.leaders.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LSPerson* person = self.leaders[indexPath.item];
    [cell.button setTitle:person.name forState:(UIControlStateNormal)];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /* 如果支持全选功能，请开启
    if (indexPath.item == 0) {
        for (UICollectionViewCell* cell in collectionView.visibleCells) {
            [collectionView selectItemAtIndexPath:[collectionView indexPathForCell:cell] animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
        }
    }else if ([collectionView indexPathsForSelectedItems].count == [collectionView indexPathsForVisibleItems].count - 1){//当点击到非全选的时候，剩余一个全选，那么把全选按钮也选中
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
     */
    
    [self callDelegate];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    /* 如果支持全选功能，请开启
    if (indexPath.item == 0) {
        for (UICollectionViewCell* cell in collectionView.visibleCells) {
            [collectionView deselectItemAtIndexPath:[collectionView indexPathForCell:cell] animated:YES];
        }
    }else{//如果其他有未选中的，那么全选是未选中状态
        [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES];
    }
    */
    
    [self callDelegate];
    
}

-(void)callDelegate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personCell:selectLeaderChange:)]) {
        
        NSArray<NSIndexPath*>* indexPathes = [self.collectionView indexPathsForSelectedItems];
        NSMutableArray* persons = [NSMutableArray array];
        for (NSIndexPath* indexPath in indexPathes) {
            [persons addObject:[self.leaders objectAtIndex:indexPath.item]];
        }
        
        [persons sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
            LSLeader* leader1 = (LSLeader*)obj1;
            LSLeader* leader2 = (LSLeader*)obj2;
            
            return [leader1.sort compare:leader2.sort];
        }];
        
        [self.delegate personCell:self selectLeaderChange:persons];
    }
}



#pragma mark -
#pragma mark - getter
-(NSMutableArray<LSLeader *> *)leaders{
    if (_leaders) {
        return _leaders;
    }
    
    
    _leaders = [LSLeader queryLeaders];
    
    
    /* 如果支持全选功能，请开启
    if (_leaders.count > 0) {
        //添加一个全选的对象
        LSLeader* leader = [[LSLeader alloc] init];
        leader.name = @"全选";
        [_leaders insertObject:leader atIndex:0];
    }
     */
    
    return _leaders;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textAlignment = NSTextAlignmentRight;
        _label.textColor = [UIColor colorWithHex:kLSLightTitleColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.text = @"人员";
        
    }
    
    return _label;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(90, 25);
        
        _collectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.scrollEnabled = NO;
    
    }
    
    return _collectionView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.textColor = [UIColor colorWithHex:kLSLightTitleColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.text = @"若人员待定此项可不选择";
        
    }
    
    return _tipLabel;
}

-(UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hint"]];
    }

    return _tipImageView;
}

@end


@implementation PCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.button setImage:[UIImage imageNamed:@"checkbox"] forState:(UIControlStateNormal)];
        [self.button setImage:[UIImage imageNamed:@"checked"] forState:(UIControlStateSelected)];
        [self.button setTitle:@"张三" forState:(UIControlStateNormal)];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.button setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
        [self.button setTitleColor:[UIColor colorWithHex:kLSSelectTitleColor] forState:(UIControlStateSelected)];

        self.button.userInteractionEnabled = NO;
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        [self.contentView addSubview:self.button];
        
        //        UIView* view = [[UIView alloc] initWithFrame:self.bounds];
        //        view.backgroundColor = [UIColor lightGrayColor];
        //        self.selectedBackgroundView = view;
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.button.frame = self.contentView.bounds;
    CGFloat space = 16;
    //    [self.button setImageEdgeInsets:UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0)];
    [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0)];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];//父类得方法一定要调用
    self.button.selected = selected;
}



@end
