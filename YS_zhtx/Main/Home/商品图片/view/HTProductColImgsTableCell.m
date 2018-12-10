//
//  HTProductColImgsTableCell.m
//  有术
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HTProductColImgsTableCell.h"
#import "HTEditPruductImgCollectionCell.h"

@interface HTProductColImgsTableCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *col;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colHeight;

@property (nonatomic,assign) CGFloat defaulWidth;

@property (nonatomic,assign) CGFloat defaulHeight;



@end

@implementation HTProductColImgsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createCol];
    self.defaulWidth = (HMSCREENWIDTH - 32 - 20) / 5;
    self.defaulHeight = (HMSCREENWIDTH - 32 - 20) / 5 * 4 / 3;
}
-(void)createCol{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5 ;
    layout.minimumLineSpacing = 5 ;
    //    设置collectionView的frame
    self.col.collectionViewLayout = layout;
    self.col.delegate = self;
    self.col.dataSource = self;
    self.col.scrollEnabled = NO;
    [self.col registerNib:[UINib nibWithNibName:@"HTEditPruductImgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTEditPruductImgCollectionCell"];
    self.col.backgroundColor = [UIColor clearColor];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTEditPruductImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTEditPruductImgCollectionCell" forIndexPath:indexPath];
    cell.isEdit = self.isEdit;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.isEdit ? CGSizeMake(self.defaulWidth, self.defaulHeight + 32) : CGSizeMake(self.defaulWidth, self.defaulHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEdit) {
         HTPostImageModel *model = self.dataArray[indexPath.row];
        if (self.delegate) {
            [self.delegate selectedTopImgWithModel:model];
        }
    }else{
        NSMutableArray *photos = [NSMutableArray array];
        
        HTPostImageModel *model = self.dataArray[indexPath.row];
        MJPhoto *photo = [[MJPhoto alloc] init];
        if (model.image) {
            photo.image = model.image;
        }else{
            if (model.imageSeverUrl.length > 0 ) {
                photo.url = [NSURL URLWithString: model.imageSeverUrl];
            }else{
                photo.image = [UIImage imageNamed:@"相机"];
            }
        }
        
        [photos addObject:photo];
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    CGFloat cellheigt = self.isEdit ? self.defaulHeight + 32 : self.defaulHeight ;
    self.colHeight.constant = self.dataArray.count % 5 == 0 ? (self.dataArray.count / 5 * (cellheigt + 5)) - 5: (((self.dataArray.count / 5) + 1) * (cellheigt + 5))- 5;
    [self.col reloadData];
}



@end
