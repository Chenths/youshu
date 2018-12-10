//
//  HTGuideSaleDescItemCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuideSaleDescCollectionCell.h"
#import "HTGuideSaleDescItemCell.h"
@interface HTGuideSaleDescItemCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumAndCountLabel;



@end
@implementation HTGuideSaleDescItemCell


#pragma mark -life cycel
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createCol];
}
-(void)createCol{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake(HMSCREENWIDTH / 4, 143);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.col.showsHorizontalScrollIndicator = NO;
    self.col.showsVerticalScrollIndicator = NO;
    self.col.collectionViewLayout = layout;
    self.col.delegate = self;
    self.col.dataSource = self;
    self.col.backgroundColor = [UIColor clearColor];
    
    [self.col registerNib:[UINib nibWithNibName:@"HTGuideSaleDescCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTGuideSaleDescCollectionCell"];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAar.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTGuideSaleDescCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTGuideSaleDescCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.model = self.dataAar[indexPath.row];
    cell.dataModel = self.model;
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.col) {
        if (self.returnOFFset) {
            self.returnOFFset(scrollView.contentOffset);
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTGuideDescModel *model =  self.dataAar[indexPath.row];
    return CGSizeMake( model.colWidth , 100);
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods

#pragma mark - getters and setters
-(void)setModel:(HTGuideSaleInfoModel *)model{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.index.row + 1];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.orderNumAndCountLabel.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.finalordercount],[HTHoldNullObj getValueWithUnCheakValue:model.finalsalevolume]];
    self.descLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalfinalprice]];
    [self.col reloadData];
}

@end
