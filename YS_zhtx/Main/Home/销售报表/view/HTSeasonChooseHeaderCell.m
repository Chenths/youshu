//
//  HTSeasonChooseHeaderCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSeasonChooseHeaderCell.h"

@implementation HTSeasonChooseHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton *bt = [self viewWithTag:500 + 0];
    bt.selected = YES;
}

- (IBAction)seasonBtClicked:(id)sender {
    
    for (int i = 0; i < 5; i++) {
        UIButton *bt = [self viewWithTag:500 + i ];
        bt.selected = NO;
    }
   
    UIButton *sBt = sender;
    if (self.delegate) {
        [self.delegate selectedSeasonWithIndex:sBt.tag - 500];
    }
    sBt.selected = YES;
}
-(void)setModel:(HTShopSaleReportModel *)model{
    _model = model;
    for (int i = 0; i < 5; i++) {
        UIButton *bt = [self viewWithTag:500 + i ];
        bt.selected = NO;
    }
    UIButton *bt = [self viewWithTag:500 + model.season.integerValue];
    bt.selected = YES;
}

@end
