//
//  HTChangeTypeTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChangeTypeTableCell.h"
@interface HTChangeTypeTableCell()

@property (weak, nonatomic) IBOutlet UIButton *saleTypeBt;

@property (weak, nonatomic) IBOutlet UIButton *exchangeTypeBt;

@end
@implementation HTChangeTypeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.saleTypeBt.selected = YES;
}
- (IBAction)nomorClicked:(id)sender {
    self.saleTypeBt.selected = YES;
    self.exchangeTypeBt.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomorlClick)]) {
        [self.delegate nomorlClick];
    }
}

- (IBAction)exchangeClicked:(id)sender {
    self.saleTypeBt.selected = NO;
    self.exchangeTypeBt.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeClick)]) {
        [self.delegate changeClick];
    }
}


@end
