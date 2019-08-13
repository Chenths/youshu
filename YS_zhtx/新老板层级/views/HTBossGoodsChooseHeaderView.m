//
//  HTBossGoodsChooseHeaderView.m
//  YS_zhtx
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossGoodsChooseHeaderView.h"
#import "HTBossGoodsSearchItemCollectionViewCell.h"
@interface HTBossGoodsChooseHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@end
@implementation HTBossGoodsChooseHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    // Initialization code
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake((HMSCREENWIDTH - 15 * 5) / 4, 45);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.cv.showsHorizontalScrollIndicator = NO;
    self.cv.showsVerticalScrollIndicator = NO;
    self.cv.collectionViewLayout = layout;
    self.cv.backgroundColor = [UIColor whiteColor];
    self.cv.delegate = self;
    self.cv.dataSource = self;
    [self.cv registerNib:[UINib nibWithNibName:@"HTBossGoodsSearchItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HTBossGoodsSearchItemCollectionViewCell"];
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 0);//分别为上、左、下、右}
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HTBossGoodsSearchItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTBossGoodsSearchItemCollectionViewCell" forIndexPath:indexPath];
    
    if (_currentType == 1) {
        cell.titleLabel.text = _itemsColorArray[indexPath.row];
        if (_currentSelectedColor == indexPath.row) {
            cell.titleLabel.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.layer.borderWidth = 0.5;
            cell.titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#313131"].CGColor;
        }
    }else{
        cell.titleLabel.text = _itemsStatusArray[indexPath.row];
        if (_currentSelectedStatus == indexPath.row) {
            cell.titleLabel.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.layer.borderWidth = 0.5;
            cell.titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#313131"].CGColor;
        }
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_currentType == 1) {
        return _itemsColorArray.count;
    }else if (_currentType == 2){
        return _itemsStatusArray.count;
    }else{
        return 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:nil];
    [self touchActionWithDelegate:indexPath.row];
}

- (IBAction)leftTouchAction:(id)sender {
    [self touchActionWithDelegate:100];
}

- (IBAction)rightTouchAction:(id)sender {
    [self touchActionWithDelegate:101];
}
- (void)setItemsColorArray:(NSMutableArray *)itemsColorArray
{
    _itemsColorArray = itemsColorArray;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _topLeftLabel.text = _itemsColorArray[_currentSelectedColor];
    _topRightLabel.text = _itemsStatusArray[_currentSelectedStatus];
    if (_currentType == 0) {
        _totalHeight.constant = 45;
        _topLeftLabel.textColor = [UIColor colorWithHexString:@"#898888"];
        _topLeftImv.image = [UIImage imageNamed:@"grayDown"];
        _topRightLabel.textColor = [UIColor colorWithHexString:@"#898888"];
        _topRightImv.image = [UIImage imageNamed:@"grayDown"];
    }else if (_currentType == 1){
        if (_itemsColorArray.count < 5) {
            _totalHeight.constant = 90;
        }else if(_itemsColorArray.count < 9){
            _totalHeight.constant = 135;
        }else{
            _totalHeight.constant = 180;
        }
        _topLeftLabel.textColor = [UIColor colorWithHexString:@"#252625"];
        _topLeftImv.image = [UIImage imageNamed:@"darkDown"];
        _topRightLabel.textColor = [UIColor colorWithHexString:@"#898888"];
        _topRightImv.image = [UIImage imageNamed:@"grayDown"];
    }else{
        if (_itemsColorArray.count < 5) {
            _totalHeight.constant = 90;
        }else if(_itemsColorArray.count < 9){
            _totalHeight.constant = 135;
        }else{
            _totalHeight.constant = 180;
        }
        _topLeftLabel.textColor = [UIColor colorWithHexString:@"#898888"];
        _topLeftImv.image = [UIImage imageNamed:@"grayDown"];
        _topRightLabel.textColor = [UIColor colorWithHexString:@"#252625"];
        _topRightImv.image = [UIImage imageNamed:@"darkDown"];
    }
}

- (void)touchActionWithDelegate:(NSInteger)tag{
    if (self.delegate) {
        [self.delegate bossChooseBtnDelegateAction:tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
