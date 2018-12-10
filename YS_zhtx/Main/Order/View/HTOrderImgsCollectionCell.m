//
//  HTOrderImgsCollectionCell.m
//  有术
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTOrderImgsCollectionCell.h"
#import "HTOrederProductImgCollectionViewCell.h"

@interface HTOrderImgsCollectionCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;


@end
@implementation HTOrderImgsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake( 49, 87);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.dataCollectionView.showsHorizontalScrollIndicator = NO;
    self.dataCollectionView.showsVerticalScrollIndicator = NO;
    self.dataCollectionView.collectionViewLayout = layout;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.dataSource = self;
    self.dataCollectionView.backgroundColor = [UIColor clearColor];
    self.dataCollectionView.userInteractionEnabled = NO;
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTOrederProductImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HTOrederProductImgCollectionViewCell"];
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    NSArray *imgs = model.orderimage;
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *url in imgs) {
        [arr addObject:@{
                         @"fullPath":url
                         }];
    }
    self.dataArr = arr;
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.dataCollectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTOrederProductImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTOrederProductImgCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.imgPath = [dic getStringWithKey:@"fullPath"];
    return cell;
}


@end
