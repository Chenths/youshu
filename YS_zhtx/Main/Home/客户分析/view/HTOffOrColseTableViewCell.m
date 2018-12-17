//
//  HTOffOrColseTableViewCell.m
//  有术
//
//  Created by mac on 2017/11/2.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTOffOrColseTableViewCell.h"
@interface HTOffOrColseTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *topImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HTOffOrColseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setIsSeemore:(BOOL)isSeemore{
    _isSeemore = isSeemore;
    if (isSeemore) {
        self.topImg.image = [UIImage imageNamed:@"收起"];
        self.titleLabel.text = @"收起";
        
    }else{
        self.topImg.image = [UIImage imageNamed:@"下拉"];
        self.titleLabel.text = @"展开";
    }
}
@end
