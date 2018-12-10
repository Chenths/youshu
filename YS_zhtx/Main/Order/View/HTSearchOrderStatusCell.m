//
//  HTSearchOrderStatusCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
//按钮间竖直间距
#define VSPACE 8
//按钮件水平间距
#define SPACE 8
//按钮宽度
//按钮高度
#define BtHeight 30
#import "HTSearchOrderStatusCell.h"
@interface HTSearchOrderStatusCell()

@property (weak, nonatomic) IBOutlet UIView *statusBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (nonatomic,strong) NSMutableArray *bts;

@end
@implementation HTSearchOrderStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    CGFloat btX = 15;
    // bt的y坐标
    CGFloat btY = 0 ;
    NSArray *listArray = @[@"全部",@"未支付",@"已支付",@"已取消",@"已关闭",@"已退货"];
    
    CGFloat btWidd = (HMSCREENWIDTH - 80 - 30 - 16) / 3;
    for (int i = 0 ; i < listArray.count; i++) {
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt  setTitle:listArray[i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"f1f1f1"] withWidth:1];
        [bt addTarget:self action:@selector(stutasBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 100 + i ;
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius  = 5;
        //       需要设置选中的颜色差图片
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 15;
        titleWidth =   btWidd;
        if ((btX + titleWidth) > (HMSCREENWIDTH - 80) ) {
            bt.frame = CGRectMake(15 + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            btY = btY + (VSPACE + BtHeight);
            btX = 15 + titleWidth + SPACE;
        }else{
            
            bt.frame = CGRectMake(btX , btY , titleWidth,BtHeight );
            btX = btX + titleWidth + SPACE;
        }
        [self.bts addObject:bt];
        [self.statusBack addSubview:bt];
    }
    self.backHeight.constant = btY + BtHeight + 10;
}
-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    for (UIButton *bt in self.bts) {
        bt.selected = NO;
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"f1f1f1"] withWidth:1];
    }
    if ([searchDic getStringWithKey:@"model.orderstatus"].length == 0) {
        UIButton *bt = [self.bts firstObject];
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#222222"]];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        bt.selected = YES;
    }else{
        UIButton *bt = self.bts[[searchDic getStringWithKey:@"model.orderstatus"].integerValue];
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#222222"]];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        bt.selected = YES;
    }
}
-(void)stutasBtClicked:(UIButton *)sender{
    for (UIButton *bt in self.bts) {
        bt.selected = NO;
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"f1f1f1"] withWidth:1];
    }
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#222222"]];
    [sender changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    sender.selected = YES;
    [self.searchDic setObject:(sender.tag - 100) == 0 ? @"" : [NSString stringWithFormat:@"%ld",sender.tag - 100] forKey:@"model.orderstatus"];
}
-(NSMutableArray *)bts{
    if (!_bts) {
        _bts = [NSMutableArray array];
    }
    return _bts;
}

@end
