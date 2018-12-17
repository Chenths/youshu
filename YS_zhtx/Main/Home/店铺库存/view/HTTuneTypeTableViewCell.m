//
//  HTTuneTypeTableViewCell.m
//  有术
//
//  Created by mac on 2017/12/26.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
//按钮间竖直间距
#define VSPACE 10
//按钮件水平间距
#define SPACE 10
//按钮宽度
#define BtWidth 50
//按钮高度
#define BtHeight 30
#import "HTTuneTypeTableViewCell.h"
@interface HTTuneTypeTableViewCell()

@property (nonatomic,strong) NSMutableArray *btArray;
@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;



@end

@implementation HTTuneTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    CGFloat cellHeight = 0.0f;
    
    NSArray *dataArr = dataList;
    // bt的x坐标
    CGFloat btX = SPACE;
    // bt的y坐标
    CGFloat btY = 7.5 ;
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt  setTitle:[dic getStringWithKey:self.key] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        if ([[dic getStringWithKey:self.key] isEqualToString:self.typeDic[self.key]]) {
            [bt setBackgroundColor:[UIColor whiteColor]];
            [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
            [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        }else{
            [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
            [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
            [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#F1F1F1"] withWidth:1];
        }
        [bt addTarget:self action:@selector(selcteBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 100 + i ;
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius  = 3;
        //       需要设置选中的颜色差图片
        
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 50;
        titleWidth =   titleWidth >= 40 ? titleWidth : 40;
        if ((btX + titleWidth) > HMSCREENWIDTH ) {
            bt.frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            btY = btY + (VSPACE + BtHeight);
            btX = SPACE + titleWidth + SPACE;
        }else{
            bt.frame =    CGRectMake(btX , btY , titleWidth,BtHeight );
            btX = btX + titleWidth + SPACE;
        }
        [self.contentBack addSubview:bt];
        [self.btArray addObject:bt];
    }
    cellHeight = dataArr.count == 0 ? 0 : btY + BtHeight  ;
    
    cellHeight = cellHeight == 0 ? 0 : cellHeight + VSPACE ;
    self.contentHeight.constant = cellHeight;
}
- (void)selcteBtClicked:(UIButton *)sender{
    
    for (UIButton *bt in self.btArray) {
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#F1F1F1"] withWidth:1];
    }
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    [sender changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];

    NSInteger index = sender.tag - 100;
    NSDictionary *dic = self.dataList[index];
    [self.typeDic removeAllObjects];
    [self.typeDic setValuesForKeysWithDictionary:dic]; ;
}
- (NSMutableArray *)btArray{
    if (!_btArray) {
        _btArray = [NSMutableArray array];
    }
    return _btArray;
}
@end
