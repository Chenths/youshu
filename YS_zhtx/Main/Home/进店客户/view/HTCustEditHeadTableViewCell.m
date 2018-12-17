//
//  HTCustEditHeadTableViewCell.m
//  有术
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCustEditHeadTableViewCell.h"

@interface HTCustEditHeadTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UIButton *takePhoto;

@property (weak, nonatomic) IBOutlet UIButton *photosBt;

@property (weak, nonatomic) IBOutlet UIButton *sysBt;


@end

@implementation HTCustEditHeadTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.headImg.layer.masksToBounds = YES;
//    self.headImg.layer.cornerRadius = 40;
//    self.takePhoto.layer.masksToBounds = YES;
//    self.takePhoto.layer.cornerRadius = 15;
//    self.takePhoto.layer.borderColor = [UIColor colorWithHexString:@"#F26340"].CGColor;
//    self.takePhoto.layer.borderWidth = 1;
//    self.photosBt.layer.borderColor = [UIColor colorWithHexString:@"#F26340"].CGColor;
//    self.photosBt.layer.borderWidth = 1;
//    self.photosBt.layer.masksToBounds = YES;
//    self.photosBt.layer.cornerRadius = 15;
//    self.sysBt.layer.masksToBounds = YES;
//    self.sysBt.layer.cornerRadius = 15;
//    
//}
//- (void)setHeadUrl:(NSString *)headUrl{
//    _headUrl = headUrl;
//    [self.headImg sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"无数据头像"]];
//}
//- (void)setSeletedImg:(UIImage *)seletedImg{
//    _seletedImg = seletedImg;
//    self.headImg.image =  seletedImg;
//}
//- (IBAction)takePhoto:(id)sender {
//    if (self.delegate) {
//        [self.delegate takePhotoClicked];
//    }
//}
//
//- (IBAction)photos:(id)sender {
//    if (self.delegate) {
//        [self.delegate selectImgFormPhotos];
//    }
//}
//- (IBAction)sysclicked:(id)sender {
//    if (self.delegate) {
//        [self.delegate    selectImgFormSysPhotos];
//    }
//}


@end
