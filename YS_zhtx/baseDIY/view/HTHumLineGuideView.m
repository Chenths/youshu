//
//  HTHumLineGuideView.m
//  24小助理
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTHumLineGuideView.h"

@implementation HTHumLineGuideView

-(void)setModel:(HTHumanTraModel *)model{
    
    _model = model;
    
    _dateLabel.text = model.dataTime;
    _numberLabel.text = [NSString stringWithFormat:@"%@:%@",@"值",model.countIn];
    
}

@end
