//
//  HTBossSaleCompareListInfoTableCell.m
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossSaleCompareDataInfoCell.h"
#import "HTBossSaleCompareListInfoTableCell.h"

@interface HTBossSaleCompareListInfoTableCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *rankImg;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;

@property (nonatomic,strong) NSArray *dataAar;
@end
@implementation HTBossSaleCompareListInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake(HMSCREENWIDTH / 4, 143);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.dataCollectionView.showsHorizontalScrollIndicator = NO;
    self.dataCollectionView.showsVerticalScrollIndicator = NO;
    self.dataCollectionView.collectionViewLayout = layout;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.dataSource = self;
    self.dataCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTBossSaleCompareDataInfoCell" bundle:nil] forCellWithReuseIdentifier:@"HTBossSaleCompareDataInfoCell"];
}
-(void)setModel:(HTBossRankReportDataModel *)model{
    _model = model;
    if (model.index.row < 3) {
        self.rankImg.hidden = NO;
        self.rankLabel.hidden = YES;

        self.rankImg.image = [UIImage imageNamed:model.index.row == 0 ? @"rankFirst" : model.index.row == 1 ? @"rankSecond" : @"rankThird"];
    }else{
        self.rankImg.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.index.row + 1];
    }
    NSDictionary *tittleDic = model.title;
    self.shopName.text = [tittleDic getStringWithKey:@"name"];
    self.saleNumLabel.text = [NSString stringWithFormat:@"%@销量：%@单%@件",self.title,[tittleDic getStringWithKey:@"ordercount"],[tittleDic getStringWithKey:@"salevolunme"]];
    self.saleMoneyLabel.text = [NSString stringWithFormat:@"营业额:%@",[tittleDic getStringWithKey:@"price"]];
    self.dataAar = model.datalist;
    [self.dataCollectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAar.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTBossSaleCompareDataInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTBossSaleCompareDataInfoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.dataDic = self.dataAar[indexPath.row];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.dataCollectionView) {
        if (self.returnOFFset) {
            self.returnOFFset(scrollView.contentOffset);
        }
    }
}
-(NSArray *)dataAar{
    if (!_dataAar) {
        _dataAar = [NSArray array];
    }
    return _dataAar;
}
@end
