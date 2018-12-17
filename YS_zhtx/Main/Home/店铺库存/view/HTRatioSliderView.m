//
//  HTRatioSliderView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTRatioSliderView.h"

@implementation HTRatioSliderView

- (instancetype)initWithFrame:(CGRect)frame withDatas:(NSArray *)data andColors:(NSArray *)datacolors;
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arr = data;
        NSArray *colors = datacolors;
        CGFloat total = 0.0f;
        for (NSString *item in arr) {
            total += item.floatValue;
        }
        CGFloat width = frame.size.width;
        CGFloat xWidth = frame.size.width;
        
        for (int i = (int)arr.count - 1; i>=0 ;i--) {
            NSString *ratio = arr[i];
            if (ratio.length == 0) {
                continue;
            }
            UIView *partView = [[UIView alloc] initWithFrame:CGRectMake(xWidth -( width * ratio.floatValue / total + (i == 0 ? 0 : frame.size.height * 0.5 + 1))  , 0, width * ratio.floatValue / total + (i == 0 ? 0 : frame.size.height * 0.5 + 1)  , frame.size.height)];
            partView.backgroundColor = [UIColor colorWithHexString:colors[i]];
            [partView changeCornerRadiusWithRadius:frame.size.height * 0.5];
            [self addSubview:partView];
            xWidth -= width * ratio.floatValue / total;
        }
    }
    return self;
}


@end
