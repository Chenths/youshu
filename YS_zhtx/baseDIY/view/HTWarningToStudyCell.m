//
//  HTWarningToStudyCell.m
//  有术
//
//  Created by mac on 2017/7/21.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTWarningWebViewController.h"
#import "HTWarningToStudyCell.h"

@implementation HTWarningToStudyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.studyBt.layer.masksToBounds = YES;
    self.studyBt.layer.cornerRadius = 5;
}

-(void)setModel:(HTWarningModel *)model{
    _model = model;
    self.studyBt.hidden = NO;
    if ([_model.warningStr rangeOfString:@"折扣率"].length > 0) {
        
        NSRange range = [_model.warningStr rangeOfString:[HTShareClass shareClass].reportWarnStandard.zkl];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"连带率"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[HTShareClass shareClass].reportWarnStandard.ldl];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
        
    }else if([_model.warningStr rangeOfString:@"会员贡献率"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].reportWarnStandard.vipgxl,@"%"]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
        
    }else if([_model.warningStr rangeOfString:@"会员活跃"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].reportWarnStandard.hyvip,@"%"]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
        
    }else if([_model.warningStr rangeOfString:@"退货率"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].reportWarnStandard.thl,@"%"]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
        
    }else if([_model.warningStr rangeOfString:@"换货率"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@%@",[HTShareClass shareClass].reportWarnStandard.hhl,@"%"]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"新增会员数"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.AnewMonthVIPNum]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"老会员成交个数"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.MonthlyTurnover4OldVIPNum]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"月销售目标"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.monthTarget]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"销量"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.xl]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"单量"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.dl]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"回头率"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.hyhtl]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"店铺目标"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.monthTarget]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else if([_model.warningStr rangeOfString:@"客单价"].length > 0){
        NSRange range = [_model.warningStr rangeOfString:[NSString stringWithFormat:@"%@",[HTShareClass shareClass].reportWarnStandard.kdj]];
        NSMutableAttributedString *mabstring1 = [[NSMutableAttributedString alloc] initWithString:_model.warningStr];
        [mabstring1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:range];
        self.titleLabel.attributedText = mabstring1;
    }else{
        self.titleLabel.text = _model.warningStr;
        self.studyBt.hidden = YES;
    }
}
- (IBAction)studyClicked:(id)sender {
    NSString *key = @"";
    if ([self.model.warningStr rangeOfString:@"折扣率"].length > 0) {
        key = basezkl;
    }else if([self.model.warningStr rangeOfString:@"连带率"].length > 0){
        key = baseldl;
    }else if([self.model.warningStr rangeOfString:@"会员贡献率"].length > 0){
        key = basehygxl;
    }else if([self.model.warningStr rangeOfString:@"会员活跃"].length > 0){
        key = basehyhy;
    }else if([self.model.warningStr rangeOfString:@"换货率"].length > 0){
        key = basehhl;
    }else if([self.model.warningStr rangeOfString:@"退货率"].length > 0){
        key = basethl;
    }else if([self.model.warningStr rangeOfString:@"新增会员数"].length > 0){
        key = basexzhy;
    }else if([self.model.warningStr rangeOfString:@"老会员成交个数"].length > 0){
        key = @"lhycjs";
    }else if ([self.model.warningStr rangeOfString:@"月销售目标"].length > 0){
        key = @"yxs";
    }else if ([self.model.warningStr rangeOfString:@"客单价"].length > 0){
        key = @"kdj";
    }
    HTWarningWebViewController *vc = [[HTWarningWebViewController alloc] init];
    vc.finallUrl = key;
    [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    [KLCPopup dismissAllPopups];
}


@end
