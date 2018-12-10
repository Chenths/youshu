//
//  HTOrderInfoViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderOrProductState.h"
#import "HTOrderInfoViewCell.h"
#import "HTOrderProductInfoCollectionCell.h"
@interface HTOrderInfoViewCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *printBt;

@property (weak, nonatomic) IBOutlet UIButton *exchangeBt;

@property (weak, nonatomic) IBOutlet UIButton *noticeBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colloctionHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCollectionheight;

@property (weak, nonatomic) IBOutlet UICollectionView *col;


@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIImageView *orderStateImg;

@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *guideLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colLeading;


@end

@implementation HTOrderInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.printBt changeCornerRadiusWithRadius:3];
    [self.exchangeBt changeCornerRadiusWithRadius:3];
    [self.noticeBt changeCornerRadiusWithRadius:3];
    [self.noticeBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.printBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.levelLabel changeCornerRadiusWithRadius:7.5];
    [self.levelLabel changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
   
    self.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    [self creatCol];
}
-(void)creatCol{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.itemSize = CGSizeMake( 53, 53);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.col.showsHorizontalScrollIndicator = NO;
    self.col.showsVerticalScrollIndicator = NO;
    self.col.collectionViewLayout = layout;
    self.col.delegate = self;
    self.col.dataSource = self;
    self.col.backgroundColor = [UIColor clearColor];
//    self.col.userInteractionEnabled = NO;
    [self.col registerNib:[UINib nibWithNibName:@"HTOrderProductInfoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTOrderProductInfoCollectionCell"];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTOrderProductInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTOrderProductInfoCollectionCell" forIndexPath:indexPath];
    cell.model = self.model.orderDetails[indexPath.row];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.orderDetails.count;
}
-(void)setShowImg:(BOOL)showImg{
    _showImg = showImg;
    if (showImg) {
        self.colloctionHeight.constant = 53.0f;
        self.topCollectionheight.constant = 18.0f;
    }else{
        self.colloctionHeight.constant = 0.0f;
        self.topCollectionheight.constant = 0.0f;
    }
}
-(void)setModel:(HTOrderListModel *)model{
    _model = model;
    self.orderNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.customer].length == 0 ? @"散客" : [HTHoldNullObj getValueWithUnCheakValue:model.customer];
    self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.custLevel];
    if ([HTHoldNullObj getValueWithUnCheakValue:model.custLevel].length == 0) {
        self.levelLabel.hidden = YES;
    }else{
        self.levelLabel.hidden = NO;
    }
    
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalPrice]];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalPrice]];
    self.productCount.text = [NSString stringWithFormat:@"共%ld件商品",model.orderDetails.count];
    self.createTime.text = [NSString stringWithFormat:@"创建时间：%@",[HTHoldNullObj getValueWithUnCheakValue:model.createDate]];
    self.guideLabel.text = [NSString stringWithFormat:@"导购：%@",[HTHoldNullObj getValueWithUnCheakValue:model.creator]];
    self.colLeading.constant = ( HMSCREENWIDTH - 16 - (53 * self.model.orderDetails.count + 5 * (self.model.orderDetails.count - 1))) > 80 ? ( HMSCREENWIDTH - 16 - (53 * self.model.orderDetails.count + 5 * (self.model.orderDetails.count - 1))) : 80;
    

    if ([[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus] isEqualToString:@"UNPAID"] || [[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus] isEqualToString:@"PAID"] ) {
        self.orderStateImg.hidden = YES;
        self.orderStateLabel.hidden = NO;
        if ([[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus] isEqualToString:@"UNPAID"]) {
            self.exchangeBt.enabled = NO;
            self.exchangeBt.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"eeeeee"] withWidth:1];
        }else{
             self.exchangeBt.enabled = YES;
             self.exchangeBt.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        }
       
        self.orderStateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderStatus];
    }else{
        self.orderStateImg.hidden = NO;
        self.orderStateLabel.hidden = YES;
        self.orderStateImg.image = [UIImage imageNamed:[HTOrderOrProductState getOrderStateFormOrderString:model.orderStatus]];
        self.exchangeBt.enabled = NO;
        self.exchangeBt.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.exchangeBt changeBorderStyleColor:[UIColor colorWithHexString:@"eeeeee"] withWidth:1];
    }
    [self.col reloadData];
}

#pragma -mark event

- (IBAction)moreBtClicked:(id)sender {
    if (self.delegate) {
        [self.delegate moreClickedWithCell:self];
    }
}
- (IBAction)timeCliceked:(id)sender {
    if (self.delegate) {
        [self.delegate timeClickedWithCell:self];
    }
}
- (IBAction)exchangeClicked:(id)sender {
    if (self.delegate) {
        [self.delegate exchangeClickedWithCell:self];
    }
}
- (IBAction)printClicked:(id)sender {
    if (self.delegate) {
        [self.delegate printClickedWithCell:self];
    }
}




@end
