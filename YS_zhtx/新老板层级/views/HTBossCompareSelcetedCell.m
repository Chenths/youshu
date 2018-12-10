//
//  HTBossCompareSelcetedCell.m
//  有术
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossCompareSelcetedCell.h"
@interface HTBossCompareSelcetedCell()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation HTBossCompareSelcetedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor  = [UIColor colorWithHexString:@"#6A82FB"].CGColor;
}



@end
