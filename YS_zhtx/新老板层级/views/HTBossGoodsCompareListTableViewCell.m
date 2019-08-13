//
//  HTBossGoodsCompareListTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossGoodsCompareListTableViewCell.h"
#import "HTBossGoodsCollectionViewCell.h"
@interface HTBossGoodsCompareListTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *tempDic;
@end
@implementation HTBossGoodsCompareListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake(120, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.cv.showsHorizontalScrollIndicator = NO;
    self.cv.showsVerticalScrollIndicator = NO;
    self.cv.collectionViewLayout = layout;
    self.cv.backgroundColor = [UIColor whiteColor];
    self.cv.delegate = self;
    self.cv.dataSource = self;
    [self.cv registerNib:[UINib nibWithNibName:@"HTBossGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HTBossGoodsCollectionViewCell"];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTBossGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTBossGoodsCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.topLabel.text = self.titleArray[indexPath.row];
    if ([self.titleArray[indexPath.row] isEqualToString:@"上货日期"]) {
        cell.bottomLabel.text = [_tempDic objectForKey:@"ruhuodate"];
    }else if([self.titleArray[indexPath.row] isEqualToString:@"最近调入日期"]){
        cell.bottomLabel.text = [_tempDic objectForKey:@"diaorudate"];
    }else if([self.titleArray[indexPath.row] isEqualToString:@"最近调出日期"]){
        cell.bottomLabel.text = [_tempDic objectForKey:@"diaochudate"];
    }else{
        if ([self.detailStr isEqualToString:@"可用"]) {
            cell.bottomLabel.text = [NSString stringWithFormat:@"%@", [self.detailArray[indexPath.row] objectForKey:@"normal"]];
        }else if([self.detailStr isEqualToString:@"在途"]){
            cell.bottomLabel.text = [NSString stringWithFormat:@"%@", [self.detailArray[indexPath.row] objectForKey:@"enroute"]];
        }else if([self.detailStr isEqualToString:@"历史"]){
            cell.bottomLabel.text = [NSString stringWithFormat:@"%@", [self.detailArray[indexPath.row] objectForKey:@"history"]];
        }else{
            cell.bottomLabel.text = [NSString stringWithFormat:@"%@", [self.detailArray[indexPath.row] objectForKey:@"sell"]];
        }
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.cv) {
        if (self.returnOFFset) {
            self.returnOFFset(scrollView.contentOffset);
        }
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.tempDic = [NSMutableDictionary dictionaryWithDictionary:[dataDic objectForKey:@"datemodel"]];
    NSArray *tempKeys = [_tempDic allKeys];
    for (NSString *tempStr in tempKeys) {
        if ([[_tempDic objectForKey:tempStr] isEqualToString:@""] || [_tempDic objectForKey:tempStr] == nil) {
            [_tempDic setObject:@"--" forKey:tempStr];
        }
    }
    _titleArray = [NSMutableArray arrayWithArray:[_dataDic objectForKey:@"size_head"]];
    [_titleArray addObject:@"上货日期"];
    [_titleArray addObject:@"最近调入日期"];
    [_titleArray addObject:@"最近调出日期"];
    _detailArray = [NSMutableArray arrayWithArray:[_dataDic objectForKey:@"stock"]];
    _nameLabel.text = [_tempDic objectForKey:@"companyname"];
    [_cv reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
