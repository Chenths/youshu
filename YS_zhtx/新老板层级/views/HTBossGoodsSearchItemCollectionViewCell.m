//
//  HTBossGoodsSearchItemCollectionViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossGoodsSearchItemCollectionViewCell.h"

@implementation HTBossGoodsSearchItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelHeight.constant = (HMSCREENWIDTH - 5 * 13) / 4;
}

@end
