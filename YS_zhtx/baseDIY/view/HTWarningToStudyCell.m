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
    }
    HTWarningWebViewController *vc = [[HTWarningWebViewController alloc] init];
    vc.finallUrl = key;
    [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    [KLCPopup dismissAllPopups];
}


@end
