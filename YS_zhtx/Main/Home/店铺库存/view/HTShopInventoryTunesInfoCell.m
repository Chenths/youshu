//
//  HTShopInventoryTunesInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTTurnListTypeDescViewController.h"
#import "HTSaleGoodOrBadCenterController.h"
#import "HTShopInventoryTunesInfoCell.h"

@implementation HTShopInventoryTunesInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)saleGoodOrBadClicked:(id)sender {
    
    HTSaleGoodOrBadCenterController *vc = [[HTSaleGoodOrBadCenterController alloc] init];
    vc.companyId = self.companyId;
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    
}
- (IBAction)turnReportListClicked:(id)sender {
    HTTurnListTypeDescViewController *vc = [[HTTurnListTypeDescViewController alloc] init];
    vc.companyId = self.companyId;
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}



@end
