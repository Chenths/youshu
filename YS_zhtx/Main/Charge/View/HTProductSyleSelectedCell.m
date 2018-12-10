//
//  HTProductSyleSelectedCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTProductSyleSelectedCell.h"

//按钮间竖直间距
#define VSPACE 10
//按钮件水平间距
#define SPACE 10
//按钮宽度
#define BtWidth 50
//按钮高度
#define BtHeight 30

@interface HTProductSyleSelectedCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation HTProductSyleSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    // bt的x坐标
    CGFloat btX = SPACE;
    // bt的y坐标
    CGFloat btY = 0 ;

    for (int i = 0 ; i < dataArray.count; i++) {
        NSDictionary *dic = dataArray[i];
        NSString *key = [self.key isEqualToString:@"color"] ? @"color":@"size";
        NSString *keycode = [self.key isEqualToString:@"color"] ? @"colorcode":@"sizecode";
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"%@/%@",[dic getStringWithKey:key],[dic getStringWithKey:keycode]];
        [bt  setTitle:title forState:UIControlStateNormal];
        HTChargeProductInfoModel *slcMM = self.model.selectedModel;
        NSString *holdTitl  = [NSString stringWithFormat:@"%@/%@",[HTHoldNullObj getValueWithUnCheakValue:[slcMM valueForKey:key]],[HTHoldNullObj getValueWithUnCheakValue:[slcMM valueForKey:keycode]]];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        if ([title isEqualToString:holdTitl]) {
            bt.backgroundColor = [UIColor whiteColor];
            [bt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:0.5];
        }else{
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"f1f1f1"] withWidth:0.5];
        }
         bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt addTarget:self action:@selector(styleBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 100 + i ;
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius  = 3;
        //       需要设置选中的颜色差图片
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 15;
        titleWidth =   titleWidth >= 40 ? titleWidth : 40;
        if ((btX + titleWidth) > HMSCREENWIDTH ) {
            bt.frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            btY = btY + (VSPACE + BtHeight);
            btX = SPACE + titleWidth + SPACE;
        }else{
            bt.frame =    CGRectMake(btX , btY , titleWidth,BtHeight );
            btX = btX + titleWidth + SPACE;
        }
        [self.backView addSubview:bt];
    }
    self.backHeight.constant = btY + SPACE + BtHeight;
}

- (void)styleBtClicked:(UIButton *) sender{
    
    for (UIButton *bt in _backView.subviews) {
        bt.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"f1f1f1"] withWidth:1];
    }
    sender.backgroundColor = [UIColor whiteColor];
    [sender changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    int  index = (int)sender.tag - 100;
    NSDictionary *dic = self.dataArray[index];
    if ([self.key isEqualToString:@"color"]) {
        self.model.selecedColorCode = [dic getStringWithKey:@"colorcode"];
    }
    if ([self.key isEqualToString:@"size"]) {
        self.model.selecedSizeCode = [dic getStringWithKey:@"sizecode"];
    }
    if (self.choose) {
        self.choose();
    }
}
@end
