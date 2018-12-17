//
//  HTTagsTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTagsTableViewCell.h"
//按钮间竖直间距
#define VSPACE 10
//按钮件水平间距
#define SPACE 10
//按钮宽度
#define BtWidth 50
//按钮高度
#define BtHeight 30
#import "HTCustomerButton.h"
@interface HTTagsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *holdImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerheight;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *colseImg;

@property (weak, nonatomic) IBOutlet UIButton *colosBt;

@property (nonatomic,strong) NSArray *colors;

@end

@implementation HTTagsTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setModel:(HTNewTagsModel *)model{
    _model = model;
    if (self.isSeeMore) {
        self.headerheight.constant = 48;
        self.headView.hidden = NO;
    }else{
        self.headerheight.constant = 0;
        self.headView.hidden = YES;
    }
    self.holdImg.image =  model.tageType == HTTAGTop ? [UIImage imageNamed:@"g-topTag"] : model.tageType == HTTAGPlatform?  [UIImage imageNamed:@"g-ptTag"] :  [UIImage imageNamed:@"g-shopTag"];
    self.titleLabel.text = model.tageType == HTTAGTop ? @"置顶标签" : model.tageType == HTTAGPlatform?  @"平台标签" : @"店铺标签";
    self.colseImg.image = model.isSeemore ?  [UIImage imageNamed:@"g-tagsColse"] :  [UIImage imageNamed:@"g-tagsOpen"];
    for (UIView *sub in self.backView.subviews) {
        [sub removeFromSuperview];
    }
    NSMutableArray *arrs = [model.tagsArray mutableCopy];
    if (model.tageType == HTTAGShop ) {
        [arrs addObject:@{
                          @"tagname":@" + ",
                          }];
    }
    CGFloat btY = 8 ;
    CGFloat btX = SPACE;
    int j = 1;
    BOOL isreturn = NO;
    for (int i = 0; i < arrs.count; i++) {
        NSDictionary *dataDic = arrs[i];
        NSString *name = [dataDic  getStringWithKey:@"tagname"];
        CGFloat titleWidth = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20 + 16;
        titleWidth =   titleWidth >= BtWidth ? titleWidth : 40;
        CGRect frame = CGRectZero;
        CGRect imgFrame = CGRectZero;
        if ((btX + titleWidth) > HMSCREENWIDTH ) {
            frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            imgFrame = CGRectMake(SPACE + 0 + titleWidth - 8, btY + (VSPACE + BtHeight) - 8,16, 16);
            btY = btY + (VSPACE + BtHeight);
            btX = SPACE + titleWidth + SPACE;
            if (j == 3 && !model.isSeemore && model.tageState == HTTAGStateDEATL ) {
                if (i < arrs.count  ) {
                    isreturn = YES;
                }
                return ;
            }
        }else{
            frame =  CGRectMake(btX , btY , titleWidth,BtHeight );
            imgFrame = CGRectMake(btX + titleWidth - 8, btY - 8,16, 16);
            btX = btX + titleWidth + SPACE;
        }
        HTCustomerButton *bt = [[HTCustomerButton alloc] initCustomerWithFrame:frame andColor:[UIColor colorWithHexString:self.colors[i % self.colors.count]]];
        [bt setTitle:name forState:UIControlStateNormal];
        bt.tag = 300 + i;
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        if ([bt.titleLabel.text isEqualToString:@" + "]) {
            [bt addTarget:self action:@selector(addtag:) forControlEvents:UIControlEventTouchUpInside];
             bt.titleLabel.font = [UIFont systemFontOfSize:17];
        }else{
            if ((model.tageState == HTTAGStateEDIT ||model.tageState == HTTAGStateADD)&& model.tageType == HTTAGTop) {
                [bt addTarget:self action:@selector(topCancelEditTags:) forControlEvents:UIControlEventTouchUpInside];
            }else if((model.tageState == HTTAGStateEDIT ||model.tageState == HTTAGStateADD) && model.tageType == HTTAGShop){
                [bt addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self.backView addSubview:bt];
        if (model.tageState == HTTAGStateEDIT||model.tageState == HTTAGStateADD) {
            if ([self.titleLabel.text isEqualToString:@"店铺标签"] && arrs.count - 1 == i) {
            }else{
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"g-tagEdit"]];
                img.frame = imgFrame;
                [self.backView addSubview:img];
            }
        }
    }
    if (isreturn) {
        [self downImgEnable];
    }else{
        [self downImgHidden];
    }
    self.backHeight.constant = btY + BtHeight + 15;
}
-(void)downImgEnable{
    self.colseImg.hidden = NO;
    self.colosBt.hidden = NO;
}
-(void)downImgHidden{
    self.colseImg.hidden = YES;
    self.colosBt.hidden = YES;
}
-(void)topCancelEditTags:(UIButton *)sender{
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"请您的选择操作" btsArray:@[@"取消",@"取消置顶"] okBtclicked:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(editTagCancelTopClickedWithDataDic:)]) {
            NSDictionary *dic = self.model.tagsArray[sender.tag - 300];
            [self.delegate editTagCancelTopClickedWithDataDic:dic];
        }
    } cancelClicked:^{
    }];
    [alert show];
}
-(void)editTags:(UIButton *)sender{
    NSDictionary *dic = self.model.tagsArray[sender.tag - 300];
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"请选择你的操作" btsArray:@[@"删除",@"置顶"] okBtclicked:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(editTagClickedWithDataDic:)]) {
            [self.delegate editTagClickedWithDataDic:dic];
        }
    } cancelClicked:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(delteTagClickedWithDataDic:)]) {
            [self.delegate delteTagClickedWithDataDic:dic];
        }
    }];
    [alert show];
}
- (IBAction)seeMoreClicked:(id)sender {
    self.model.isSeemore = !self.model.isSeemore;
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceTypeSeemoreClickedWithCell:)]) {
        [self.delegate faceTypeSeemoreClickedWithCell:self];
    }
}
- (NSArray *)colors{
    if (!_colors) {
        _colors = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    }
    return _colors;
}
-(void)addtag:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addTagClicked)]) {
        [self.delegate addTagClicked];
    }
}

@end
