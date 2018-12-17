//
//  HTBossMeClickedTableViewCell.m
//  有术
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossMeClickedTableViewCell.h"

@implementation HTBossMeClickedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)shopCliceked:(id)sender {
    if (self.delegate) {
        [self.delegate shopClicked];
    }
}
- (IBAction)inventoryListclicked:(id)sender {
    if (self.delegate) {
        [self.delegate inventeroyListClicked];
    }
}

@end
