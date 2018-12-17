//
//  HTCustEditHeadCollectionReusableView.m
//  有术
//
//  Created by mac on 2018/1/30.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTCustEditHeadCollectionReusableView.h"

@interface HTCustEditHeadCollectionReusableView()



@property (weak, nonatomic) IBOutlet UIButton *takePoto;


@property (weak, nonatomic) IBOutlet UIButton *photosBt;

@property (weak, nonatomic) IBOutlet UIButton *sysBt;

@end

@implementation HTCustEditHeadCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 40;
    [self.takePoto changeCornerRadiusWithRadius:3];
    [self.photosBt changeCornerRadiusWithRadius:3];
    [self.sysBt changeCornerRadiusWithRadius:3];
//    self.takePoto.layer.masksToBounds = YES;
//    self.takePoto.layer.cornerRadius = 15;
//    self.takePoto.layer.borderColor = [UIColor colorWithHexString:@"#F26340"].CGColor;
//    self.takePoto.layer.borderWidth = 1;
//    self.photosBt.layer.borderColor = [UIColor colorWithHexString:@"#F26340"].CGColor;
//    self.photosBt.layer.borderWidth = 1;
//    self.photosBt.layer.masksToBounds = YES;
//    self.photosBt.layer.cornerRadius = 15;
//    self.sysBt.layer.masksToBounds = YES;
//    self.sysBt.layer.cornerRadius = 15;
//
}
- (void)setHeadUrl:(NSString *)headUrl{
    _headUrl = headUrl;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
}
- (void)setSeletedImg:(UIImage *)seletedImg{
    _seletedImg = seletedImg;
    self.headImg.image =  seletedImg;
}
- (IBAction)takePhoto:(id)sender {
    if (self.delegate) {
        [self.delegate takePhotoClicked];
    }
}

- (IBAction)photos:(id)sender {
    if (self.delegate) {
        [self.delegate selectImgFormPhotos];
    }
}
- (IBAction)sysclicked:(id)sender {
    if (self.delegate) {
        [self.delegate    selectImgFormSysPhotos];
    }
}

@end
