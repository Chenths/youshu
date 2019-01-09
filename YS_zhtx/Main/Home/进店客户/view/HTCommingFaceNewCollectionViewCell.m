//
//  HTCommingFaceNewCollectionViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTCommingFaceNewCollectionViewCell.h"
@interface HTCommingFaceNewCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *commingHeaderImv;

@end

@implementation HTCommingFaceNewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commingHeaderImv.layer.cornerRadius = 125;
    self.commingHeaderImv.clipsToBounds = YES;
}

-(void)setModel:(HTNewFaceNoVipModel *)model{
    _model = model;
    [self.commingHeaderImv sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
}

@end
