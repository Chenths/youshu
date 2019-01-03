//
//  HTEditVipTipCell.m
//  YS_zhtx
//
//  Created by mac on 2019/1/2.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTEditVipTipCell.h"

@implementation HTEditVipTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setRequestDic:(NSMutableDictionary *)requestDic{
    _requestDic = requestDic;
    _tipTextView.text = [requestDic objectForKey:@"remark"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
