//
//  LSPersonFilterCell.m
//  LSchedule
//
//  Created by 3dprint on 2017/6/22.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSPersonFilterCell.h"
#import "Masonry.h"
#import "LSUtils.h"

@implementation LSPersonFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.collectionView registerClass:[PCollectionFilterCell class] forCellWithReuseIdentifier:@"cell"];
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    [self.contentView addSubview:self.collectionView];
    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.collectionView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        
        make.height.mas_equalTo(@(120));
        make.width.mas_equalTo(@(210));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < self.leaders.count; i++) {
        LSLeader* leader = self.leaders[i];
        if ([self.selectPerson containsString:leader.userId]) {
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
    PCollectionFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LSLeader* leader = self.leaders[indexPath.item];
    [cell.button setTitle:leader.name forState:(UIControlStateNormal)];
    
    cell.colorMarkLayer.backgroundColor = [[UIColor colorWithStr:leader.color] CGColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self callDelegate];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{

    [self callDelegate];
}

-(void)callDelegate{

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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(personFilterCell:didSelectLeaders:)]) {
        [self.delegate personFilterCell:self didSelectLeaders:persons];
    }

}
#pragma mark -
#pragma mark - setter

#pragma mark -
#pragma mark - getter
-(NSMutableArray<LSLeader *> *)leaders{
    if (_leaders) {
        return _leaders;
    }
    
    _leaders = [LSLeader queryLeaders];
    
    return _leaders;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(100, 25);
        
        _collectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

@end

@implementation PCollectionFilterCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.button setImage:[UIImage imageNamed:@"checkbox"] forState:(UIControlStateNormal)];
        [self.button setImage:[UIImage imageNamed:@"checked"] forState:(UIControlStateSelected)];
        [self.button setTitle:@"张三" forState:(UIControlStateNormal)];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.button setTitleColor:[[UIColor darkTextColor] colorWithAlphaComponent:0.7] forState:(UIControlStateNormal)];
        [self.button setTitleColor:[UIColor colorWithStr:kLSSelectTitleColor] forState:(UIControlStateSelected)];
        
        self.button.userInteractionEnabled = NO;
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        CAShapeLayer *mlayer = [CAShapeLayer layer];
//        mlayer.borderWidth = 0.3;
//        mlayer.borderColor = [UIColor blackColor].CGColor;
        self.colorMarkLayer = mlayer;
        mlayer.hidden = NO;
        mlayer.frame = CGRectMake(85, 3, 5, 18);
        [self.button.layer addSublayer:self.colorMarkLayer];
        
        [self.contentView addSubview:self.button];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.button.frame = self.contentView.bounds;
    CGFloat space = 10;
    //    [self.button setImageEdgeInsets:UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0)];
    [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0)];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];//父类得方法一定要调用
    self.button.selected = selected;
}

@end
