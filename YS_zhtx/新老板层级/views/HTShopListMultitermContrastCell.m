//
//  HTShopListMultitermContrastCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTShopListMultitermContrastCell.h"
@interface HTShopListMultitermContrastCell()
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
@implementation HTShopListMultitermContrastCell

- (void)awakeFromNib {
    [super awakeFromNib]; 
    // Initialization code
}

-(void)setModel:(HTCompanyListModel *)model{
    _model = model;
    self.companyName.text = model.name;
    if (!model.isSelected) {
        self.imgView.image = [UIImage imageNamed:@"单选-未选中"];
        self.companyName.textColor = [UIColor colorWithHexString:@"666666"];
    }else{
        self.imgView.image = [UIImage imageNamed:@"单选-选中"];
        self.companyName.textColor = [UIColor colorWithHexString:@"222222"];
    }
}

@end
