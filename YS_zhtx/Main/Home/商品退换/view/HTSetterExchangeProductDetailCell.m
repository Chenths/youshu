//
//  HTSetterExchangeProductDetailCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTProductImgCollectionViewCell.h"
#import "HTSetterExchangeProductDetailCell.h"
#import "HTCahargeProductModel.h"
@interface HTSetterExchangeProductDetailCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *col;


@end

@implementation HTSetterExchangeProductDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createCol];
}
-(void)createCol{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 110);
    layout.minimumInteritemSpacing = 8 ;
    layout.minimumLineSpacing = 8.0f ;
    //    设置collectionView的frame
    self.col.collectionViewLayout = layout;
    self.col.delegate = self;
    self.col.dataSource = self;
    self.col.showsVerticalScrollIndicator = NO;
    self.col.showsHorizontalScrollIndicator = NO;
    [self.col registerNib:[UINib nibWithNibName:@"HTProductImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HTProductImgCollectionViewCell"];
    self.col.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
}
-(void)setIsReturn:(BOOL)isReturn{
    _isReturn = isReturn;
    if (self.isReturn ) {
        if (self.returnArray.count > 0) {
            HTOrderDetailProductModel *model = [self.returnArray firstObject];
            if (model.productState == HTProductStateReturn) {
             self.titleLabel.text =  [NSString stringWithFormat:@"退货商品(%ld)",self.returnArray.count];
            }else if (model.productState == HTProductStateChange){
             self.titleLabel.text =  [NSString stringWithFormat:@"被换商品(%ld)",self.returnArray.count];
            }
        }
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"换选商品(%ld)",self.returnArray.count];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.returnArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTProductImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTProductImgCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    cell.isReturn = self.isReturn;
    if (self.isReturn) {
      cell.model = self.returnArray[indexPath.row];
    }else{
        HTCahargeProductModel *mm = self.returnArray[indexPath.row];
        cell.productModel = mm.selectedModel;
    }
    return cell;
}


@end
