//
//  HTGuiderDateSaleSurveyCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderDateSaleSurveyCell.h"
@interface HTGuiderDateSaleSurveyCell()

@property (weak, nonatomic) IBOutlet UILabel *saleMoney;

@property (weak, nonatomic) IBOutlet UILabel *orderAndProductCount;

@property (weak, nonatomic) IBOutlet UIButton *descBt;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HTGuiderDateSaleSurveyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.descBt changeCornerRadiusWithRadius:self.descBt.height * 0.5];
    [self.descBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
}
-(void)setModel:(HTDateSaleDescModel *)model{
    _model = model;
    if (model.dataType == HTSaleDataDescTypeDay) {
        self.titleLabel.text = @"今日营业额";
        self.saleMoney.font = [UIFont systemFontOfSize:24];
    }
    if (model.dataType == HTSaleDataDescTypeMonth) {
        self.titleLabel.text = @"本月营业额";
        self.saleMoney.font = [UIFont systemFontOfSize:15];
    }
    if (model.dataType == HTSaleDataDescTypeYear) {
        self.titleLabel.text = @"本年营业额";
        self.saleMoney.font = [UIFont systemFontOfSize:15];
    }
}
-(void)setGuideModel:(HTGuiderReportModel *)guideModel{
    _guideModel = guideModel;
    if (self.model.dataType == HTSaleDataDescTypeDay) {
        HTGuiderDateSaleModel *model = guideModel.todaySale;
        self.saleMoney.text = [HTHoldNullObj getValueWithBigDecmalObj:model.amount];
        self.orderAndProductCount.text = [NSString stringWithFormat:@"%@单%@件",model.ordercount,model.salevolume];
    }
    if (self.model.dataType == HTSaleDataDescTypeMonth) {
        HTGuiderDateSaleModel *model = guideModel.monthSale;
        self.saleMoney.text = [HTHoldNullObj getValueWithBigDecmalObj:model.amount];
        self.orderAndProductCount.text = [NSString stringWithFormat:@"%@单%@件",model.ordercount,model.salevolume];
    }
    if (self.model.dataType == HTSaleDataDescTypeYear) {
        HTGuiderDateSaleModel *model = guideModel.yearSale;
        self.saleMoney.text = [HTHoldNullObj getValueWithBigDecmalObj:model.amount];
        self.orderAndProductCount.text = [NSString stringWithFormat:@"%@单%@件",model.ordercount,model.salevolume];
    }
}
@end
