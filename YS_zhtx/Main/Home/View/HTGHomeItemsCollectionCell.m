//
//  HTGHomeItemsCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomersInfoReportController.h"
#import "HTGSaleReportViewController.h"
#import "HTUnderstockListAlertView.h"
#import "HTGHomeItemsCollectionCell.h"

@interface HTGHomeItemsCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *holdImg;

@property (weak, nonatomic) IBOutlet UILabel *warningCount;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningWidth;

@property (weak, nonatomic) IBOutlet UIView *warningBack;

@property (weak, nonatomic) IBOutlet UIButton *warningBt;

@end

@implementation HTGHomeItemsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.warningBack changeCornerRadiusWithRadius:8];
    self.warningBack.userInteractionEnabled = YES;
    UITapGestureRecognizer *rap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(warningClicked:)];
    [self.warningBack addGestureRecognizer:rap];
}
-(void)setModel:(HTHomeItemsModel *)model{
    _model = model;
    self.holdImg.image = [UIImage imageNamed:model.imgStr];
    self.titleLabel.text = model.title;
}
-(void)setWarningArr:(NSArray *)warningArr{
    _warningArr = warningArr;
    [self setNumber:warningArr.count];
}
- (void)setNumber:(NSInteger)number{
    
    if (number != 0) {
        self.warningBack.hidden = NO;
        self.warningBt.hidden  = NO;
        self.warningCount.text = number > 99 ?  @"99+" : [NSString stringWithFormat:@"%ld",number];
        CGFloat width = [self.warningCount.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:10]} context:nil].size.width  + 10;
        self.warningWidth.constant = width > 16 ? width : 16;
        [self.warningBack layoutIfNeeded];
        [self.warningBack changeCornerRadiusWithRadius:8];
    }else{
        self.warningBack.hidden = YES;
        self.warningBt.hidden  = YES;
    }
}
- (IBAction)warningBtClicked:(id)sender {
    [HTUnderstockListAlertView  showAlertWithWarningArray:self.warningArr tilte:@"该模块中存在下列预警" btsArray:@[@"取消",@"确定"] okBtclicked:^{
    } cancelClicked:^{
    } andInClick:^(NSIndexPath *index) {
        if ([self.model.title isEqualToString:@"销售报表"]) {
            HTGSaleReportViewController *vc = [[HTGSaleReportViewController alloc] init];
            vc.companyId = self.companyId;
            vc.warningArr = self.warningArr;
            vc.selectdWarning = self.warningArr[index.row];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }else if ([self.model.title isEqualToString:@"客群分析"]){
            HTCustomersInfoReportController *vc = [[HTCustomersInfoReportController alloc] init];
            vc.companyId = self.companyId;
            vc.warningArr = self.warningArr;
            vc.selectdWarning = self.warningArr[index.row];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
    }];
}


-(void)warningClicked:(UITapGestureRecognizer *)tap{
    
    [HTUnderstockListAlertView  showAlertWithWarningArray:self.warningArr tilte:@"该模块中存在下列预警" btsArray:@[@"取消",@"确定"] okBtclicked:^{
    } cancelClicked:^{
    } andInClick:^(NSIndexPath *index) {
        if ([self.model.title isEqualToString:@"销售报表"]) {
            HTGSaleReportViewController *vc = [[HTGSaleReportViewController alloc] init];
            vc.companyId = self.companyId;
            vc.warningArr = self.warningArr;
            vc.selectdWarning = self.warningArr[index.row];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }else if ([self.model.title isEqualToString:@"客群分析"]){
            HTCustomersInfoReportController *vc = [[HTCustomersInfoReportController alloc] init];
            vc.companyId = self.companyId;
            vc.warningArr = self.warningArr;
            vc.selectdWarning = self.warningArr[index.row];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
    }];
    
}
@end
