//
//  HTBuyHabitInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTBuyHabitInfoCollectionCell.h"
#import "HTBuyHabitInfoTableViewCell.h"
#import "HTCirclePeiDataDetailController.h"
@interface HTBuyHabitInfoTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *col;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colHeight;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HTBuyHabitInfoTableViewCell

#pragma mark -life cycel
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createCollecionView];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTBuyHabitInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTBuyHabitInfoCollectionCell" forIndexPath:indexPath];
    NSArray *colors = @[@"#4EB76C",@"#EB6580",@"#6178BA",@"#83CEC0"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.pieColor = [UIColor colorWithHexString:colors[indexPath.row]];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HTCirclePeiDataDetailController *vc = [[HTCirclePeiDataDetailController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createCollecionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake( (HMSCREENWIDTH - 32 - 12)  / 2 , 280 );
    layout.minimumInteritemSpacing = 12 ;
    layout.minimumLineSpacing = 12 ;
    //    设置collectionView的frame
    self.col.collectionViewLayout = layout;
    self.col.delegate = self;
    self.col.dataSource = self;
    self.col.scrollEnabled = NO;
    [self.col registerNib:[UINib nibWithNibName:@"HTBuyHabitInfoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTBuyHabitInfoCollectionCell"];
    self.col.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.colHeight.constant =( self.dataArray.count / 2 * 280 ) + 280 * ((self.dataArray.count % 2) > 0 ? 0 : 1) + (self.dataArray.count / 2) * 12;
}

#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)setModel:(HTCustomerReportModel *)model{
    _model = model;
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:model.sizeModel];
    [self.dataArray addObject:model.categoriesModel];
    [self.dataArray addObject:model.discountModel];
    [self.dataArray addObject:model.priceModel];
    self.colHeight.constant =( self.dataArray.count / 2 * 280 ) + 280 * ((self.dataArray.count % 2) > 0 ? 1 : 0) + (self.dataArray.count / 2) * 12;
    [self.col reloadData];
}
@end
