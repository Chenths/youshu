//
//  HTProductStyleReertoyDetailCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define space 16
#import "HTProductStyleReertoyDetailCell.h"

@interface HTProductStyleReertoyDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *backScorllerView;
@property (nonatomic,strong) NSArray *sizeList;

@end

@implementation HTProductStyleReertoyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backScorllerView.showsHorizontalScrollIndicator = NO;
    self.backScorllerView.showsVerticalScrollIndicator = NO;
}
-(void)setModel:(HTStockInfoModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.color];
    [self setSizeList:model.sizeList];
}

- (void)setSizeList:(NSArray *)sizeList{
    _sizeList = sizeList;
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
        sizeLabel.font = [UIFont systemFontOfSize:14];
        sizeLabel.textAlignment = NSTextAlignmentCenter;
        sizeLabel.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [sizeLabel changeCornerRadiusWithRadius:3];
        [itmeView addSubview:sizeLabel];
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = nums[i];
        numLabel.textColor = [UIColor colorWithHexString:@"6e6e6e"];
        numLabel.font = [UIFont systemFontOfSize:14];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [itmeView addSubview:numLabel];
        
        [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itmeView.mas_top).offset(12);
            make.leading.mas_equalTo(itmeView.mas_leading).offset(15);
            make.width.offset(itemWidth);
        }];
        
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(itmeView.mas_bottom).offset(-12);
            make.leading.mas_equalTo(itmeView.mas_leading).offset(15);
            make.width.offset(itemWidth);
        }];
        
        contentWidth += itemWidth + space;
    }
    
    self.backScorllerView.contentSize = CGSizeMake(contentWidth + 20, self.backScorllerView.height);
}

@end
