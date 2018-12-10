//
//  HTProductHistoryCell.m
//  有术
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTProductHistoryCell.h"

@interface HTProductHistoryCell()

@property (weak, nonatomic) IBOutlet UILabel *saleInfo;

@property (weak, nonatomic) IBOutlet UILabel *tuneInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *backScorllerView;

@end

@implementation HTProductHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setModel:(HTPruductDetailHistoryModel *)model{
    _model = model;
    NSDictionary  *everyTypeStokTotal = model.everyTypeStokTotal;
    NSDictionary *productInfo = model.productInfo;
    
    self.tuneInfo.text = [NSString stringWithFormat:@"调货情况：调入%@件，调出%@件",[everyTypeStokTotal getStringWithKey:@"inTotal"],[everyTypeStokTotal getStringWithKey:@"outTotal"]];
    self.saleInfo.text = [NSString stringWithFormat:@"销售情况：售出%@件",[everyTypeStokTotal getStringWithKey:@"saleTotal"]];
    [self setSizeList:[[productInfo getArrayWithKey:@"stock"][0] getArrayWithKey:@"sizeList"]];
}

- (void)setSizeList:(NSArray *)sizeList{

    NSMutableArray *sizes = [NSMutableArray array];
    NSMutableArray *nums = [NSMutableArray array];
    
    for (NSDictionary *dic in sizeList) {
        [sizes addObject:[dic getStringWithKey:@"size"]];
        [nums addObject:[dic getStringWithKey:@"count"]];
    }
    for (UIView *subV in self.backScorllerView.subviews) {
        [subV removeFromSuperview];
    }
    CGFloat contentWidth = 0.0f;
    for (int i = 0; i < sizes.count;i++ ) {
        NSString *size = sizes[i];
        NSString *num = nums[i];
        CGFloat itemWidth = 0.0f;
        CGFloat sizeWidth = [size boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 15;
        CGFloat numWidth = [num boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 15;
        itemWidth = sizeWidth > numWidth ? sizeWidth : numWidth;
        
        UIView *itmeView = [[UIView alloc] initWithFrame:CGRectMake(contentWidth, 0, itemWidth, self.backScorllerView.height)];
        [self.backScorllerView addSubview:itmeView];
        UILabel *sizeLabel = [[UILabel alloc] init];
        sizeLabel.text = sizes[i];
        sizeLabel.textColor = [UIColor colorWithHexString:@"6e6e6e"];
        sizeLabel.font = [UIFont systemFontOfSize:15];
        sizeLabel.textAlignment = NSTextAlignmentCenter;
        [itmeView addSubview:sizeLabel];
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = nums[i];
        numLabel.textColor = [UIColor colorWithHexString:@"6e6e6e"];
        numLabel.font = [UIFont systemFontOfSize:15];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [itmeView addSubview:numLabel];
        
        [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itmeView.mas_top).offset(5);
            make.leading.mas_equalTo(itmeView.mas_leading).offset(15);
            make.width.offset(itemWidth);
        }];
        
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(itmeView.mas_bottom).offset(-5);
            make.leading.mas_equalTo(itmeView.mas_leading).offset(15);
            make.width.offset(itemWidth);
        }];
        
        contentWidth += itemWidth;
    }
    
    self.backScorllerView.contentSize = CGSizeMake(contentWidth + 20, self.backScorllerView.height);
}


@end
