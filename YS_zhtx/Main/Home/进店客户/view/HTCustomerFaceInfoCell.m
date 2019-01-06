 //
//  HTCustomerFaceInfoCell.m
//  有术
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCustomerFaceInfoCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@interface HTCustomerFaceInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *vipImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *comeDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *receptionBt;

@property (weak, nonatomic) IBOutlet UIButton *deleteLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
@implementation HTCustomerFaceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.vipImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    
    [self.vipImg addGestureRecognizer:tap];
    [self.receptionBt changeCornerRadiusWithRadius:3];
    [self.receptionBt changeBorderStyleColor:[UIColor colorWithHexString:@"333333"] withWidth:1];
    
    [self.levelLabel changeCornerRadiusWithRadius:8.5];
    [self.levelLabel changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];

    [self.vipImg changeCornerRadiusWithRadius:self.vipImg.height/2];
    
}

//- (void)setVipModel:(HTNewFaceNoVipModel *)vipModel{
//    _vipModel = vipModel;
//    [self.vipImg sd_setImageWithURL:[NSURL URLWithString:vipModel.path] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
//    self.comeDateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:vipModel.create_time];
//    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:vipModel.nickname_cust];
//    self.sexImg.hidden = NO;
//    self.sexImg.image = [UIImage imageNamed: vipModel.sex_cust ? @"g-man" : @"g-woman"];
//    NSDictionary *cust_level = vipModel.cust_level;
//    self.levelLabel.hidden = NO;;
//    self.levelLabel.text = [cust_level getStringWithKey:@"name"];
//    if (vipModel.hasbuy) {
//    self.descLabel.hidden = NO;
////        [self.receptionBt setBackgroundImage:[UIImage imageNamed:@"再购背景"] forState:UIControlStateNormal];
//        [self.receptionBt setTitleColor:[UIColor colorWithHexString:@"#060000"]forState:UIControlStateNormal];
//        [self.receptionBt setBackgroundColor:[UIColor colorWithHexString:@"#F9F9FA"]];
//        [self.receptionBt changeBorderStyleColor:[UIColor colorWithHexString:@"#060000"] withWidth:1];
//        self.receptionBt.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.receptionBt setTitle:@"再购" forState:UIControlStateNormal];
//    }else{
////        [self.receptionBt setBackgroundImage:[UIImage imageNamed:@"接待背景"] forState:UIControlStateNormal];
//        [self.receptionBt setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"]forState:UIControlStateNormal];
//        [self.receptionBt setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
//        [self.receptionBt changeBorderStyleColor:[UIColor colorWithHexString:@"#333333"] withWidth:1];
//        self.receptionBt.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.receptionBt setTitle:@"接待" forState:UIControlStateNormal];
//        self.descLabel.hidden = YES;
//    }
//    if (vipModel.isPush) {
//    self.deleteLabel.hidden = NO;
//    }else{
//        self.deleteLabel.hidden = YES;
//    }
//}

-(void)setNotVipModel:(HTNewFaceNoVipModel *)notVipModel{
    _notVipModel = notVipModel;
    [self.vipImg sd_setImageWithURL:[NSURL URLWithString:notVipModel.path] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    self.comeDateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:notVipModel.enterTime];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:notVipModel.userVipName];
    self.sexImg.hidden = YES;
    self.levelLabel.hidden = YES;
    self.descLabel.hidden = YES;
    self.deleteLabel.hidden = YES;
    self.receptionBt.layer.masksToBounds = YES;
    self.receptionBt.layer.cornerRadius = 15;
    
    [self.receptionBt setBackgroundImage:nil forState:UIControlStateNormal];
    [self.receptionBt setTitle:@"录入资料" forState:UIControlStateNormal];
    self.receptionBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.receptionBt setTitleColor:[UIColor colorWithHexString:@"#222222"]forState:UIControlStateNormal];
    [self.receptionBt setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    [self.receptionBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    
}



- (IBAction)receptionBtClicked:(id)sender {
    UIButton *bt = sender;
    if ([bt.titleLabel.text isEqualToString:@"接待"]) {
        if (self.delegate ) {
            [self.delegate receptionCustmerWithCell:self];
        }
    }else if ([bt.titleLabel.text isEqualToString:@"再购"]){
        if (self.delegate ) {
            [self.delegate repitBuyWithCell:self];
        }
    }else if ([bt.titleLabel.text isEqualToString:@"录入资料"]){
        if (self.delegate ) {
            [self.delegate writeCutomerInfoWithCell:self];
        }
    }
}
- (IBAction)deleteBtClicked:(id)sender {
    if (self.delegate ) {
//        [self.delegate deleleItemeWithCell:self];
    }
}
-(void)tapClicked:(UITapGestureRecognizer *)sender{
    /*
    NSMutableArray *photos = [NSMutableArray array];
    if (self.vipModel.imgs.count > 0) {
        for (NSString *url in self.vipModel.imgs) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url];
            [photos addObject:photo];
        }
    }
    if (self.notVipModel.imgs.count > 0) {
        for (NSString *url in self.notVipModel.imgs) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url];
            [photos addObject:photo];
        }
    }

    if (photos.count == 0) {
        return;
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
     */
}


@end
