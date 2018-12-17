//
//  HTFiltrateTableStyleCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTFiltrateTableStyleCell.h"

@interface HTFiltrateTableStyleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabe;
@property (weak, nonatomic) IBOutlet UIImageView *holdImg;

@end

@implementation HTFiltrateTableStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.holdImg.hidden = NO;
}
- (void)setModel:(HTFiltrateNodeModel *)model{
    _model = model;
    if (model.isSelected) {
        self.titleLabe.textColor = [UIColor colorWithHexString:@"#222222"];
        self.holdImg.hidden = NO;
    }else{
        self.titleLabe.textColor = [UIColor colorWithHexString:@"#999999"];
        self.holdImg.hidden = YES;
    }
    self.titleLabe.text = model.title;
}
-(void)setIndexModel:(HTIndexsModel *)indexModel{
    _indexModel = indexModel;
    self.titleLabe.textColor = [UIColor colorWithHexString:@"#999999"];
    self.holdImg.hidden = YES;
    self.titleLabe.text = indexModel.titles;
}
@end
