//
//  HTSetterExchangePruductDetailView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTSetterExchangeProductDetailCell.h"
#import "HTSetterExchangePruductDetailView.h"
#import "HTOrderDetailProductModel.h"
#import "HTChargeProductInfoModel.h"
@interface HTSetterExchangePruductDetailView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *upBt;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;

@end


@implementation HTSetterExchangePruductDetailView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    [self changeCornerRadiusWithRadius:5];
    [self createTb];
}

- (instancetype)initWithDetailFrame:(CGRect)frame
{
    HTSetterExchangePruductDetailView *detailView = [[NSBundle mainBundle] loadNibNamed:@"HTSetterExchangePruductDetailView" owner:nil options:nil].lastObject;
    [detailView setFrame:frame];
    return  detailView;
}
- (IBAction)upBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(coloseBtClicekd)]) {
        [self.delegate coloseBtClicekd];
    }
}
-(void)setReturnProducts:(NSArray *)returnProducts{
    _returnProducts = returnProducts;
    CGFloat total = 0.0f;
    for (HTOrderDetailProductModel *model in returnProducts) {
        model.productState = HTProductStateReturn;
        total += model.finalprice.floatValue;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",total];
    self.tabBottomHeight.constant = 150;
    [self.tab reloadData];
}
-(void)setOrderPrice:(NSString *)orderPrice{
    _orderPrice = orderPrice;
    if (orderPrice.floatValue < 0) {
        self.holdLabel.text = @"应退金额";
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",fabsf(orderPrice.floatValue)];
    }else{
        self.holdLabel.text = @"应收金额";
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",fabsf(orderPrice.floatValue)];
    }
}
-(void)setChangeProducts:(NSArray *)changeProducts{
    _changeProducts = changeProducts;
    if (self.returnProducts.count > 0) {
        self.tabBottomHeight.constant = 300;
    }
    for (HTOrderDetailProductModel *model in self.returnProducts) {
        model.productState = HTProductStateChange;
    }
    [self.tab reloadData];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTSetterExchangeProductDetailCell" bundle:nil] forCellReuseIdentifier:@"HTSetterExchangeProductDetailCell"];
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    self.tab.estimatedRowHeight = 300;
    self.tab.scrollEnabled = NO;
    self.tabBottomHeight.constant = 1 * 150;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.returnProducts.count > 0  ?  (self.changeProducts.count > 0 ?   2 : 1 ): 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTSetterExchangeProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSetterExchangeProductDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    if (indexPath.row == 0) {
     cell.returnArray = self.returnProducts;
     cell.isReturn = YES;
    }
    if (indexPath.row == 1) {
     cell.returnArray = self.changeProducts;
     cell.isReturn = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
@end
