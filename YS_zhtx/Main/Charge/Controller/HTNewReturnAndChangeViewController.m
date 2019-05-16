//
//  HTNewReturnAndChangeViewController.m
//  YS_zhtx
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTNewReturnAndChangeViewController.h"
#import "HTNewPayHeaderTableViewCell.h"
#import "HTNewPayGoodsHeaderTableViewCell.h"
#import "HTNewPayGoodsTableViewCell.h"
#import "HTNewPayGoodsFooterTableViewCell.h"
#import "HTNewPayWriteOrderTipsTableViewCell.h"
#import "HTNewPaySellerHeaderTableViewCell.h"
#import "HTNewPaySellerTableViewCell.h"
#import "HTNewPayPayHeaderTableViewCell.h"
#import "HTNewPayPayNormalKindTableViewCell.h"
#import "HTNewPayMixPayKindTableViewCell.h"
#import "HTCahargeProductModel.h"
#import "HTChargeMaskViewController.h"
#import "HTSellerListModel.h"
#import "HTLoginDataModel.h"
#import "HTLoginDataPersonModel.h"
#import "HTChangePriceViewController.h"
#import "HTPrinterTool.h"
#import <MessageUI/MessageUI.h>
#import "HTEditVipViewController.h"
#import "HTTelMsgAlertView.h"
#import "HTCustomTextAlertView.h"
#import "HTPrinterTool.h"
#import "HTHoldOrderEventManager.h"
#import "HTShowImg.h"
@interface HTNewReturnAndChangeViewController()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, paypayNormalDelegate, chooseSellerBackDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate>{
    BOOL isNormalPayKind;
    NSMutableArray *biliTFArr;
    NSMutableArray *priceTFArr;
    //当前支付种类
    NSInteger currentNormalPayKind;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (nonatomic, strong) NSMutableArray *totalDataArr;
@property (nonatomic, strong) UIImageView *mixHeaderImv;//混合支付头部按钮图片
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbBottomToView;
@property (nonatomic, strong) NSMutableArray *biliArr;//混合销售中分配比例
@property (nonatomic, strong) NSMutableArray *paySellerArr;//混合销售中分配金额
@property (nonatomic, strong) NSMutableArray *payKindMoneyArr;//混合支付金额
@property (nonatomic, strong) NSMutableArray *selectSellerArr;
//混合销售键盘头
@property (nonatomic, strong) UIToolbar *mixSellHeaderView;
@property (nonatomic, strong) UILabel *mixSellHeaderLabel;
@property (nonatomic, strong) UIButton *mixSellHeaderBtn;
//混合支付键盘头
@property (nonatomic, strong) UIToolbar *mixPayHeaderView;
@property (nonatomic, strong) UILabel *mixPayHeaderLabel;
@property (nonatomic, strong) UIButton *mixPayHeaderBtn;
//组合支付提示金额
@property (nonatomic, assign) CGFloat mixRemainPayNum;
//组合销售提示金额
@property (nonatomic, assign) CGFloat mixRemainSellNum;
//已选赠送积分
@property (nonatomic, strong) NSMutableArray *noGiveScoreArr;
@property (nonatomic, strong) UITextView *tipTextView;
@property (nonatomic, strong) HTPrinterTool *printerManager;
@property (nonatomic, strong) NSString *tipStr;


@end

@implementation HTNewReturnAndChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mixRemainPayNum = [_orderModel.finalprice floatValue];
    biliTFArr = [NSMutableArray array];
    priceTFArr = [NSMutableArray array];
    self.noGiveScoreArr = [NSMutableArray array];
    self.mixSellHeaderView = [self buildSellKeyBoardHeader];
    self.mixPayHeaderView = [self buildPayKeyBoardHeader];
    
    self.title = @"结算";
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-goodsAdd" highImageName:@"g-goodsAdd" target:self action:@selector(cancelAction)] ;
    isNormalPayKind = 1;
    self.selectSellerArr = [NSMutableArray array];
    [self dealMixData];
    [self dealPayKindData];
    [self dealSellerData];
    [self createTb];
    [self creatBottomView];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 3000) {
        if ([_custModel.custId isEqualToString:@""] || _custModel.custId == nil) {
            [MBProgressHUD showError:@"非会员不可以使用"];
            return NO;
        }
    }else if (textField.tag == 3001){
        if ([_custModel.custId isEqualToString:@""] || _custModel.custId == nil) {
            [MBProgressHUD showError:@"非会员不可以使用"];
            return NO;
        }else if(![HTShareClass shareClass].isPlatformOnlinePayActive){
            [MBProgressHUD showError:@"当前店铺不可使用"];
            return NO;
        }
    }else{
        
    }
    
    if (textField.tag >= 3000 && textField.tag < 4000) {
        _mixRemainPayNum = [_orderModel.finalprice floatValue];
        for (NSString * tempStr in _payKindMoneyArr) {
            _mixRemainPayNum -= [tempStr floatValue];
        }
        if (_mixRemainPayNum < 0.001 && _mixRemainPayNum > -0.001) {
            _mixPayHeaderLabel.text = @"已完成分配";
            _mixPayHeaderBtn.hidden = YES;
        }else{
            _mixPayHeaderLabel.text = [NSString stringWithFormat:@"还有%.2f元未分配", _mixRemainPayNum];
            _mixPayHeaderBtn.hidden = NO;
        }
    }else if (textField.tag >= 4000 && textField.tag < 5000){
        _mixRemainSellNum = [_orderModel.finalprice floatValue];
        for (NSString * tempStr in _paySellerArr) {
            _mixRemainSellNum -= [tempStr floatValue];
        }
        CGFloat tempTotalBili = 100;
        for (NSString * tempStr in _biliArr) {
            tempTotalBili -= [tempStr floatValue];
        }
        if (_mixRemainSellNum < 0.001 && _mixRemainSellNum > -0.001) {
            _mixSellHeaderLabel.text = @"已完成分配";
            _mixSellHeaderBtn.hidden = YES;
        }else{
            _mixSellHeaderLabel.text = [NSString stringWithFormat:@"还有%.2f元/%.2f%%未分配", _mixRemainSellNum, tempTotalBili];
            _mixSellHeaderBtn.hidden = NO;
        }
        
    }else if (textField.tag >= 5000 && textField.tag < 6000){
        _mixRemainSellNum = [_orderModel.finalprice floatValue];
        for (NSString * tempStr in _paySellerArr) {
            _mixRemainSellNum -= [tempStr floatValue];
        }
        CGFloat tempTotalBili = 100;
        for (NSString * tempStr in _biliArr) {
            tempTotalBili -= [tempStr floatValue];
        }
        if (_mixRemainSellNum < 0.001 && _mixRemainSellNum > -0.001) {
            _mixSellHeaderLabel.text = @"已完成分配";
            _mixSellHeaderBtn.hidden = YES;
        }else{
            _mixSellHeaderLabel.text = [NSString stringWithFormat:@"还有%.2f元/%.2f%%未分配", _mixRemainSellNum, tempTotalBili];
            _mixSellHeaderBtn.hidden = NO;
        }
    }else{
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
    if ([textField.text floatValue] == 0) {
        textField.text = @"";
    }
    if (textField.tag >= 3000 && textField.tag < 4000) {
        //组合支付输入框
        NSInteger current = textField.tag - 3000;
        [_payKindMoneyArr replaceObjectAtIndex:current withObject:textField.text];
        [_dataTableView reloadData];
    }else if(textField.tag >= 4000 && textField.tag < 5000){
        //组合销售比例输入框
        NSInteger current = textField.tag - 4000;
        [_biliArr replaceObjectAtIndex:current withObject:textField.text];
        CGFloat tempFloat = [textField.text floatValue] * [_orderModel.finalprice floatValue] / 100.0;
        NSString *tempStr = [NSString stringWithFormat:@"%.2f", tempFloat];
        [_paySellerArr replaceObjectAtIndex:current withObject:tempStr];
        
        //最后一个输入框自动补齐
        int noDataNum = 0;
        for (NSString *tempStr in _paySellerArr) {
            if ([tempStr isEqualToString:@""]) {
                noDataNum += 1;
            }
        }
        NSInteger tempIndexBili = 0;
        CGFloat tempRemainBili = 100.0;
        NSInteger tempIndexPrice = 0;
        CGFloat tempRemainPrice = [_orderModel.finalprice floatValue];
        if (noDataNum == 1) {
            for (int i = 0; i < _biliArr.count; i++) {
                if ([_biliArr[i] isEqualToString:@""]) {
                    tempIndexBili = i;
                }else{
                    tempRemainBili -= [_biliArr[i] floatValue];
                }
            }
            
            if (tempRemainBili < 0.001 && tempRemainBili > -0.001) {
                [_biliArr replaceObjectAtIndex:tempIndexBili withObject:@""];
            }else{
                [_biliArr replaceObjectAtIndex:tempIndexBili withObject:[NSString stringWithFormat:@"%.2f", tempRemainBili]];
            }
            
            
            for (int i = 0; i < _paySellerArr.count; i++) {
                if ([_paySellerArr[i] isEqualToString:@""]) {
                    tempIndexPrice = i;
                }else{
                    tempRemainPrice -= [_paySellerArr[i] floatValue];
                }
            }
            if (tempRemainPrice < 0.001 && tempRemainPrice > -0.001) {
                [_paySellerArr replaceObjectAtIndex:tempIndexPrice withObject:@""];
            }else{
                [_paySellerArr replaceObjectAtIndex:tempIndexPrice withObject:[NSString stringWithFormat:@"%.2f", tempRemainPrice]];
            }
            
        }
        
        
        
        [_dataTableView reloadData];
        
    }else if(textField.tag >= 5000 && textField.tag < 6000){
        //组合销售 金额输入框
        NSInteger current = textField.tag - 5000;
        [_paySellerArr replaceObjectAtIndex:current withObject:textField.text];
        CGFloat tempFloat = [textField.text floatValue] / [_orderModel.finalprice floatValue] * 100.0;
        NSString *tempStr = [NSString stringWithFormat:@"%.2f", tempFloat];
        if (tempFloat == 0) {
            [_biliArr replaceObjectAtIndex:current withObject:@""];
        }else{
            [_biliArr replaceObjectAtIndex:current withObject:tempStr];
        }
        
        //最后一个输入框自动补齐
        int noDataNum = 0;
        for (NSString *tempStr in _paySellerArr) {
            if ([tempStr isEqualToString:@""]) {
                noDataNum += 1;
            }
        }
        NSInteger tempIndexBili = 0;
        CGFloat tempRemainBili = 100.0;
        NSInteger tempIndexPrice = 0;
        CGFloat tempRemainPrice = [_orderModel.finalprice floatValue];
        if (noDataNum == 1) {
            for (int i = 0; i < _biliArr.count; i++) {
                if ([_biliArr[i] isEqualToString:@""]) {
                    tempIndexBili = i;
                }else{
                    tempRemainBili -= [_biliArr[i] floatValue];
                }
            }
            if (tempRemainBili < 0.001 && tempRemainBili > -0.001) {
                [_biliArr replaceObjectAtIndex:tempIndexBili withObject:@""];
            }else{
                [_biliArr replaceObjectAtIndex:tempIndexBili withObject:[NSString stringWithFormat:@"%.2f", tempRemainBili]];
            }
            
            for (int i = 0; i < _paySellerArr.count; i++) {
                if ([_paySellerArr[i] isEqualToString:@""]) {
                    tempIndexPrice = i;
                }else{
                    tempRemainPrice -= [_paySellerArr[i] floatValue];
                }
            }
            
            if (tempRemainPrice < 0.001 && tempRemainPrice > -0.001) {
                [_paySellerArr replaceObjectAtIndex:tempIndexPrice withObject:@""];
            }else{
                [_paySellerArr replaceObjectAtIndex:tempIndexPrice withObject:[NSString stringWithFormat:@"%.2f", tempRemainPrice]];
            }
        }
        [_dataTableView reloadData];
    }else{
        
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断是否 是 组合销售分配的输入框 如果是 判断 是否按得是删除 如果是 判断是否分配完 如果是 清空组合销售 所有框内容
    if (textField.tag >= 3000 && textField.tag < 4000) {
        
    }else if (textField.tag >= 4000 && textField.tag < 5000){
        if ([string isEqualToString:@""]) {
            CGFloat ifTotal;
            for (NSString *tempBili in _biliArr) {
                ifTotal += [tempBili floatValue];
            }
            if (ifTotal - 100 < 0.001 && 100 - ifTotal < 0.001) {
                for (UITextField *tempTF in biliTFArr) {
                    tempTF.text = @"";
                    
                }
                for (UITextField *tempTF in priceTFArr) {
                    tempTF.text = @"";
                    
                }
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int i = 0 ; i < _paySellerArr.count; i++) {
                    [tempArr addObject:@""];
                }
                _paySellerArr = [NSMutableArray arrayWithArray:tempArr];
                _biliArr = [NSMutableArray arrayWithArray:tempArr];
                return NO;
            }
        }else{
            
        }
    }else if (textField.tag >= 5000 && textField.tag < 6000){
        if ([string isEqualToString:@""]) {
            CGFloat ifTotal;
            for (NSString *tempBili in _biliArr) {
                ifTotal += [tempBili floatValue];
            }
            if (ifTotal - 100 < 0.001 && 100 - ifTotal < 0.001) {
                for (UITextField *tempTF in biliTFArr) {
                    tempTF.text = @"";
                    
                }
                for (UITextField *tempTF in priceTFArr) {
                    tempTF.text = @"";
                    
                }
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int i = 0 ; i < _paySellerArr.count; i++) {
                    [tempArr addObject:@""];
                }
                _paySellerArr = [NSMutableArray arrayWithArray:tempArr];
                _biliArr = [NSMutableArray arrayWithArray:tempArr];
                return NO;
            }
        }else{
            
        }
    }else{
        
    }
    
    
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    [MBProgressHUD showError:@"数据格式有误"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [MBProgressHUD showError:@"数据格式有误"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location <= ran.location + 2) {
                        //                        return YES;
                        return [self checkPayIfCanThisEditWithTextField:textField WithStr:string];
                    }else{
                        [MBProgressHUD showError:@"最多输入两位小数"];
                        return NO;
                    }
                }else{
                    //                    return YES;
                    return [self checkPayIfCanThisEditWithTextField:textField WithStr:string];
                }
            }
        }else{//输入的数据格式不正确
            [MBProgressHUD showError:@"数据格式有误"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }else{
        return YES;
    }
}


- (UIToolbar *)buildSellKeyBoardHeader{
    self.mixSellHeaderView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 60)];
    [_mixSellHeaderView setBarStyle:UIBarStyleDefault];
    _mixSellHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.mixSellHeaderLabel = [[UILabel alloc] init];
    _mixSellHeaderLabel.frame = CGRectMake(17, 20, HMSCREENWIDTH - 140, 20);
    _mixSellHeaderLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    _mixSellHeaderLabel.font = [UIFont systemFontOfSize:15.0];
    [_mixSellHeaderView addSubview:_mixSellHeaderLabel];
    
    self.mixSellHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mixSellHeaderBtn.frame = CGRectMake(HMSCREENWIDTH - 17 - 100, 20, 100, 20);
    _mixSellHeaderBtn.layer.borderWidth = 0.5;
    _mixSellHeaderBtn.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
    [_mixSellHeaderBtn setTitle:@"点击使用" forState:UIControlStateNormal];
    [_mixSellHeaderBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    _mixSellHeaderBtn.layer.cornerRadius = 10;
    _mixSellHeaderBtn.clipsToBounds = YES;
    [_mixSellHeaderBtn addTarget:self action:@selector(selectMixSell) forControlEvents:UIControlEventTouchUpInside];
    _mixSellHeaderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_mixSellHeaderView addSubview:_mixSellHeaderBtn];
    
    [_mixSellHeaderView layoutIfNeeded];
    NSArray * subViewArray = [_mixSellHeaderView subviews];
    for (id view in subViewArray) {
        if ([view isKindOfClass:NSClassFromString(@"_UIToolbarContentView")]) {
            UIView *testView = view;
            testView.userInteractionEnabled = NO;
        }
    }
    return _mixSellHeaderView;
}

- (UIToolbar *)buildPayKeyBoardHeader{
    self.mixPayHeaderView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 60)];
    [_mixPayHeaderView setBarStyle:UIBarStyleDefault];
    _mixPayHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.mixPayHeaderLabel = [[UILabel alloc] init];
    _mixPayHeaderLabel.frame = CGRectMake(17, 20, HMSCREENWIDTH - 140, 20);
    _mixPayHeaderLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    _mixPayHeaderLabel.font = [UIFont systemFontOfSize:15.0];
    [_mixPayHeaderView addSubview:_mixPayHeaderLabel];
    
    self.mixPayHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mixPayHeaderBtn.frame = CGRectMake(HMSCREENWIDTH - 17 - 100, 20, 100, 20);
    _mixPayHeaderBtn.layer.borderWidth = 0.5;
    _mixPayHeaderBtn.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
    [_mixPayHeaderBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    [_mixPayHeaderBtn setTitle:@"点击使用" forState:UIControlStateNormal];
    _mixPayHeaderBtn.layer.cornerRadius = 10;
    _mixPayHeaderBtn.clipsToBounds = YES;
    [_mixPayHeaderBtn addTarget:self action:@selector(selectMixPay) forControlEvents:UIControlEventTouchUpInside];
    _mixPayHeaderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_mixPayHeaderView addSubview:_mixPayHeaderBtn];
    
    [_mixPayHeaderView layoutIfNeeded];
    NSArray * subViewArray = [_mixPayHeaderView subviews];
    for (id view in subViewArray) {
        if ([view isKindOfClass:NSClassFromString(@"_UIToolbarContentView")]) {
            UIView *testView = view;
            testView.userInteractionEnabled = NO;
        }
    }
    return _mixPayHeaderView;
}

- (void)selectMixSell{
    NSLog(@"组合销售键盘头");
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (firstResponder.tag >= 4000 && firstResponder.tag < 5000) {
        firstResponder.text = [NSString stringWithFormat:@"%.2f", _mixRemainSellNum / [_orderModel.finalprice floatValue] * 100];
    }else{
        firstResponder.text = [NSString stringWithFormat:@"%.2f", _mixRemainSellNum];
    }
    
    [firstResponder resignFirstResponder];
}

- (void)selectMixPay{
    NSLog(@"组合支付键盘头");
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    firstResponder.text = [NSString stringWithFormat:@"%.2f", _mixRemainPayNum];
    [firstResponder resignFirstResponder];
}

- (void)dealMixData{
    HTSellerListModel *model = [[HTSellerListModel alloc] init];
    model.sellerId = [NSString stringWithFormat:@"%@", [HTShareClass shareClass].loginModel.person.hTLoginDataPersonModelId];
    model.loginName = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.loginName]];
    model.name = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.name]];
    model.roleId = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.roleId]];
    model.roleName = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.roleName]];
    [_selectSellerArr addObject:model];
}

- (void)dealPayKindData{
    _payKindMoneyArr = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @""]];
}

- (void)dealSellerData{
    self.biliArr = [NSMutableArray array];
    self.paySellerArr = [NSMutableArray array];
    CGFloat totalBili = 100.0;
    CGFloat everyBili = [[NSString stringWithFormat:@"%.2f", totalBili / self.selectSellerArr.count] floatValue];
    
    CGFloat totalPrice = [_orderModel.finalprice floatValue];
    CGFloat everyPrice = [[NSString stringWithFormat:@"%.2f", everyBili * totalPrice / 100.0] floatValue];
    NSString *everyBiliNum = [NSString stringWithFormat:@"%.2f", everyBili];
    NSString *everyPriceNum = [NSString stringWithFormat:@"%.2f", everyPrice];
    
    for (int i = 0; i < self.selectSellerArr.count; i++) {
        if (i !=  self.selectSellerArr.count - 1) {
            [_biliArr addObject:everyBiliNum];
            [_paySellerArr addObject:everyPriceNum];
            totalBili -= everyBili;
            totalPrice -= everyPrice;
        }else{
            [_biliArr addObject:[NSString stringWithFormat:@"%.2f", totalBili]];
            [_paySellerArr addObject:[NSString stringWithFormat:@"%.2f", totalPrice]];
        }
    }
}

- (void)creatBottomView{
//    self.tbBottomToView.constant = SafeAreaBottomHeight + 62;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:_orderModel.finalprice]];
    //中划线
//    NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:_orderModel.encodeTotal]];
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr attributes:attribtDic];
//    // 赋值
//    self.oldPriceLabel.attributedText = attribtStr;
}

- (NSString *)buildbcProductJsonStr{
    if (_isFromFast) {
        return self.bcProductStr;
    }
    NSMutableArray *firstArr = [NSMutableArray array];
    //创建 bcProductJsonStr
    
    NSInteger tempCount = 0;
    for (HTCahargeProductModel *model in _products) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setObject:model.selectedModel.productId forKey:@"productId"];
        if (model.isChange) {
            [tempDic setObject:@"true" forKey:@"isChangePrice"];
            [tempDic setObject:model.selectedModel.finalprice forKey:@"changedPrice"];
        }else{
            [tempDic setObject:model.selectedModel.discount forKey:@"discount"];
        }
        
        //判断是否赠送积分
        BOOL isGivenScore = 0;
        for (NSIndexPath *index in _noGiveScoreArr) {
            if (index.row == tempCount) {
                isGivenScore = 1;
            }
        }
        if (isGivenScore) {
            [tempDic setObject:@(1) forKey:@"hasGivePoint"];
        }else{
            [tempDic setObject:@(0) forKey:@"hasGivePoint"];
        }
        [firstArr addObject:tempDic];
        tempCount++;
        
    }
    return [firstArr arrayToJsonString];
}

- (NSInteger)dealPayType{
    //是否常规
    if (isNormalPayKind) {
        switch (currentNormalPayKind) {
            case 1:
                return 2;
                break;
            case 2:
                return 4;
                break;
            case 3:
                return 1;
                break;
            case 4:
                return 1;
                break;
            case 5:
                return 3;
                break;
            case 6:
                return 3;
                break;
            default:
                break;
        }
    }else{
        return 6;
    }
    return 0;
}

- (NSString *)dealGuideJson{
    NSMutableArray *secondArr = [NSMutableArray array];
    for (int i = 0; i < _biliArr.count; i++) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        HTSellerListModel *model = _selectSellerArr[i];
        [tempDic setObject:@([model.sellerId integerValue]) forKey:@"guide"];
        [tempDic setObject:model.name forKey:@"name"];
        if ([_biliArr[i] isEqualToString:@""] || _biliArr[i] == nil) {
            [tempDic setObject:[NSDecimalNumber decimalNumberWithString:@"0"] forKey:@"ratio"];
        }else{
            [tempDic setObject:[NSDecimalNumber decimalNumberWithString:_biliArr[i]] forKey:@"ratio"];
        }
        [secondArr addObject:tempDic];
    }
    return [secondArr arrayToJsonString];
}

- (NSString *)dealMPaymentType{
    if (isNormalPayKind) {
        if (currentNormalPayKind == 3) {
            return @"1";
        }else if (currentNormalPayKind == 4){
            return @"2";
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

- (NSString *)dealPos{
    if (isNormalPayKind) {
        if (currentNormalPayKind == 6) {
            return @"1";
        }else{
            return @"0";
        }
    }else{
        if ([_payKindMoneyArr[5] isEqualToString:@""] || [_payKindMoneyArr[5] isEqualToString:@"0"]) {
            return @"0";
        }else{
            return @"1";
        }
    }
}

- (NSString *)dealAccountId{
    if (isNormalPayKind) {
        if (currentNormalPayKind == 1) {
            return [HTHoldNullObj getValueWithUnCheakValue:_custModel.account.stored.accoutId];
        }else if (currentNormalPayKind == 2){
            return [HTHoldNullObj getValueWithUnCheakValue:_custModel.account.storedPresented.accoutId];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
    
}

- (NSString *)dealGroupPayData{
    NSMutableArray *thirdArr = [NSMutableArray array];
    if (isNormalPayKind) {
        return @"";
    }
    for (int i = 0; i < _payKindMoneyArr.count; i++) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        NSString *tempStr = _payKindMoneyArr[i];
        switch (i) {
            case 0:
                if (![tempStr isEqualToString:@""] && ![tempStr isEqualToString:@"0"]) {
                    [tempDic setObject:@"1" forKey:@"type"];
                    [tempDic setObject:tempStr forKey:@"money"];
                    [tempDic setObject:[HTHoldNullObj getValueWithUnCheakValue:_custModel.account.stored.accoutId] forKey:@"accountId"];
                    [thirdArr addObject:tempDic];
                }
                break;
            case 1:
                if (![tempStr isEqualToString:@""] && ![tempStr isEqualToString:@"0"]) {
                    [tempDic setObject:@"2" forKey:@"type"];
                    [tempDic setObject:tempStr forKey:@"money"];
                    [tempDic setObject:[HTHoldNullObj getValueWithUnCheakValue:_custModel.account.storedPresented.accoutId] forKey:@"accountId"];
                    [thirdArr addObject:tempDic];
                }
                break;
            case 2:
                if (![tempStr isEqualToString:@""] && ![tempStr isEqualToString:@"0"]) {
                    [tempDic setObject:@"4" forKey:@"type"];
                    [tempDic setObject:tempStr forKey:@"money"];
                    [thirdArr addObject:tempDic];
                }
                break;
            case 3:
                if (![tempStr isEqualToString:@""] && ![tempStr isEqualToString:@"0"]) {
                    [tempDic setObject:@"3" forKey:@"type"];
                    [tempDic setObject:tempStr forKey:@"money"];
                    [thirdArr addObject:tempDic];
                }
                break;
            case 4:
                if (![tempStr isEqualToString:@""] && ![tempStr isEqualToString:@"0"]) {
                    [tempDic setObject:@"5" forKey:@"type"];
                    [tempDic setObject:tempStr forKey:@"money"];
                    [thirdArr addObject:tempDic];
                }
                break;
            case 5:
                if (![tempStr isEqualToString:@""] && ![tempStr isEqualToString:@"0"]) {
                    [tempDic setObject:@"6" forKey:@"type"];
                    [tempDic setObject:tempStr forKey:@"money"];
                    [thirdArr addObject:tempDic];
                }
                break;
            default:
                break;
        }
    }
    return [thirdArr arrayToJsonString];
}

- (IBAction)sureToPayAction:(id)sender {
    if (!isNormalPayKind) {
        //是否组合支付分配完成
        CGFloat total = 0;
        for (NSString *tempStr in _payKindMoneyArr) {
            total += [tempStr floatValue];
        }
        if (fabsf(total - [_orderModel.finalprice floatValue]) >= 0.01) {
            [MBProgressHUD showError:@"组合支付金额未选择完成"];
            return;
        }
    }else{
        //是否选择常规支付
        if (currentNormalPayKind == 0) {
            [MBProgressHUD showError:@"请选择支付方式"];
            return;
        }
    }
    //是否组合销售完成
    CGFloat tempBili = 0;
    for (NSString *tempStr in _biliArr) {
        tempBili += [tempStr floatValue];
    }
    if (fabsf(tempBili - 100) >= 0.01) {
        [MBProgressHUD showError:@"组合销售金额未选择完成"];
        return;
    }
    
    NSLog(@"确认支付");
    
    NSString *orderStr;
    if ([_tipTextView.text isEqualToString:@"请输入订单备注内容"]) {
        orderStr = @"";
    }else{
        orderStr = _tipTextView.text;
    }
    NSLog(@"%@", _orderModel);
    NSLog(@"%@", _products);
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{
                          @"bcProductJsonStr" : [self buildbcProductJsonStr],
                          @"payType" : @([self dealPayType]),
                          @"companyId" : [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId],
                          @"guideJson" : [self dealGuideJson],
                          @"mPaymentType" : [self dealMPaymentType],
                          @"isPos" : [self dealPos],
                          @"customerId" : [HTHoldNullObj getValueWithUnCheakValue: _custModel.custId],
                          @"accountId" : [self dealAccountId],
                          @"groupPayData" : [self dealGroupPayData],
                          @"remark" : [HTHoldNullObj getValueWithUnCheakValue:orderStr]
                          };
    [MBProgressHUD showMessage:@""];
    NSString *url;
    if (_isFromFast) {
        url = creatFastOrder;
    }else{
        url = creatOrderAndPay;
    }
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,url] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = self;
        NSDictionary *dataDic = [json getDictionArrayWithKey:@"data"];
        if ([json[@"isSuccess"] boolValue]) {
            if ([[dataDic objectForKey:@"state"] boolValue]) {
                //                if (!self.isFromFast) {
                [strongSelf.orderModel setValuesForKeysWithDictionary:[dataDic objectForKey:@"order"]];
                //                }
                if (isNormalPayKind) {
                    switch (currentNormalPayKind) {
                        case 1:
                            [HTShareClass shareClass].printerModel.paytype = storedType;
                            [HTShareClass shareClass].printerModel.storeValue = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"order"] objectForKey:@"finalprice"]];
                            break;
                        case 2:
                            [HTShareClass shareClass].printerModel.paytype = storedSendType;
                            [HTShareClass shareClass].printerModel.freeStoreValue = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"order"] objectForKey:@"finalprice"]];
                            break;
                        case 3:
                            [HTShareClass shareClass].printerModel.paytype = wetchatType;
                            break;
                        case 4:
                            [HTShareClass shareClass].printerModel.paytype = alipayType;
                            break;
                        case 5:
                            [HTShareClass shareClass].printerModel.paytype = cashType;
                            break;
                        case 6:
                            [HTShareClass shareClass].printerModel.paytype = posType;
                            break;
                            
                        default:
                            break;
                    }
                }else{
                    [HTShareClass shareClass].printerModel.paytype = mixType;
                    [HTShareClass shareClass].printerModel.storeValue = [NSString stringWithFormat:@"%@",self.payKindMoneyArr[0]];
                    [HTShareClass shareClass].printerModel.freeStoreValue = [NSString stringWithFormat:@"%@",self.payKindMoneyArr[1]];
                }
                
                [strongSelf settleSuccessWithMsg:[dataDic objectForKey:@"sms"]];
                [strongSelf print];
            }else{
                [MBProgressHUD showError:dataDic[@"msg"]];
            }
            
        }else{
            [MBProgressHUD showError:dataDic[@"msg"]];
        }
        
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (void)createTb{
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //头部
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayHeaderTableViewCell"];
    
    //商品头
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayGoodsHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayGoodsHeaderTableViewCell"];
    
    //商品
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayGoodsTableViewCell"];
    
    //商品尾
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayGoodsFooterTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayGoodsFooterTableViewCell"];
    
    //备注
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayWriteOrderTipsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayWriteOrderTipsTableViewCell"];
    
    //导购头
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPaySellerHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPaySellerHeaderTableViewCell"];
    
    //导购
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPaySellerTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPaySellerTableViewCell"];
    
    //组合头
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayPayHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayPayHeaderTableViewCell"];
    
    //常规支付
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayPayNormalKindTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayPayNormalKindTableViewCell"];
    
    //组合支付
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPayMixPayKindTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPayMixPayKindTableViewCell"];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        HTNewPayHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayHeaderTableViewCell" forIndexPath:indexPath];
        [cell.headerImv sd_setImageWithURL:[NSURL URLWithString:_custModel.headImg] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
        cell.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:_custModel.nickname];
        cell.sexImv.image = [UIImage imageNamed: [_custModel.sex isEqualToString:@"1"] ? @"g-man" : @"g-woman"];
        cell.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:_custModel.custlevel];
        cell.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:_custModel.phone];
        cell.czLabel.text = [HTHoldNullObj getValueWithUnCheakValue:_custModel.account.stored.balance];
        cell.czzsLabel.text = [HTHoldNullObj getValueWithUnCheakValue:_custModel.account.storedPresented.balance];
        cell.jfLabel.text = [HTHoldNullObj getValueWithUnCheakValue:_custModel.account.integral.balance];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[HTHoldNullObj getValueWithUnCheakValue:_custModel.phone] isEqualToString:@""]) {
            cell.hidden = YES;
        }
        return cell;
    }else if (indexPath.section == 1){
        HTNewPayGoodsHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayGoodsHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        HTNewPayGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayGoodsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        HTCahargeProductModel * model = _products[indexPath.row];
        
        [cell.goodsHeaderImv sd_setImageWithURL:[NSURL URLWithString:[HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.productimage]] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
        cell.goodsHeaderImv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        cell.goodsHeaderImv.tag = 20000 + indexPath.row;
        [cell.goodsHeaderImv addGestureRecognizer:tap];
        
        
        if (_isFromFast) {
            cell.goodsName.text = [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.barcode];
        }else{
            cell.goodsName.text = [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.name];
        }
        cell.goodsDetail.text = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.customtype], [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.color], [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.size], [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.year], [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.season]];
        cell.price.text = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.finalprice]];
        
        //中划线
        NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.price]];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr attributes:attribtDic];
        // 赋值
        cell.oldPrice.attributedText = attribtStr;
        cell.saleLabel.text = [NSString stringWithFormat:@"%.1f折", [model.selectedModel.finalprice floatValue] / [model.selectedModel.price floatValue] * 10];
        
        if ([_noGiveScoreArr containsObject:indexPath]) {
            cell.chooseImv.image = [UIImage imageNamed:@"singleUnselected"];
            NSString *oldPriceStr = @"赠送积分";
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr attributes:attribtDic];
            cell.chooseLabel.attributedText = attribtStr;
        }else{
            cell.chooseImv.image = [UIImage imageNamed:@"singleSelected"];
            cell.chooseLabel.text = @"赠送积分";
        }
        
        return cell;
    }else if (indexPath.section == 3){
        HTNewPayGoodsFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayGoodsFooterTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //中划线
        NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:_orderModel.totalprice]];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr attributes:attribtDic];
        // 赋值
        cell.oldPrice.attributedText = attribtStr;
        
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:_orderModel.finalprice]];
        cell.numLabel.text = [NSString stringWithFormat:@"共%@件小计: ", [HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"%ld", _products.count]]];
        return cell;
    }else if (indexPath.section == 4){
        HTNewPayWriteOrderTipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayWriteOrderTipsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tipLabel.delegate = self;
        if ([self.tipStr isEqualToString:@""] || self.tipStr == nil) {
            cell.tipLabel.text = @"请输入订单备注内容";
        }else{
            cell.tipLabel.text = self.tipStr;
        }
        cell.tipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.tipTextView = cell.tipLabel;
        return cell;
    }else if(indexPath.section == 5){
        HTNewPaySellerHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPaySellerHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTSellerListModel *model = _selectSellerArr[indexPath.row];
        switch (_selectSellerArr.count) {
            case 1:
                cell.sellerNameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
                cell.sellerNameLabelWidth.constant = 54;
                [cell.sellerImv1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                cell.sellerImv1.hidden = NO;
                cell.sellerImv2.hidden = YES;
                cell.sellerImv3.hidden = YES;
                cell.sellerImv4.hidden = YES;
                cell.sellerImv5.hidden = YES;
                break;
            case 2:
                cell.sellerNameLabel.text = @"";
                cell.sellerNameLabelWidth.constant = 0;
                [cell.sellerImv1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                cell.sellerImv1.hidden = NO;
                cell.sellerImv2.hidden = NO;
                cell.sellerImv3.hidden = YES;
                cell.sellerImv4.hidden = YES;
                cell.sellerImv5.hidden = YES;
                break;
            case 3:
                cell.sellerNameLabel.text = @"";
                cell.sellerNameLabelWidth.constant = 0;
                [cell.sellerImv1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv3 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                cell.sellerImv1.hidden = NO;
                cell.sellerImv2.hidden = NO;
                cell.sellerImv3.hidden = NO;
                cell.sellerImv4.hidden = YES;
                cell.sellerImv5.hidden = YES;
                break;
            case 4:
                cell.sellerNameLabel.text = @"";
                cell.sellerNameLabelWidth.constant = 0;
                [cell.sellerImv1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv3 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv4 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                cell.sellerImv1.hidden = NO;
                cell.sellerImv2.hidden = NO;
                cell.sellerImv3.hidden = NO;
                cell.sellerImv4.hidden = NO;
                cell.sellerImv5.hidden = YES;
                break;
            case 5:
                cell.sellerNameLabel.text = @"";
                cell.sellerNameLabelWidth.constant = 0;
                [cell.sellerImv1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv3 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv4 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                [cell.sellerImv5 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
                cell.sellerImv1.hidden = NO;
                cell.sellerImv2.hidden = NO;
                cell.sellerImv3.hidden = NO;
                cell.sellerImv4.hidden = NO;
                cell.sellerImv5.hidden = NO;
                break;
            default:
                break;
        }
        
        return cell;
    }else if(indexPath.section == 6){
        HTNewPaySellerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPaySellerTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTSellerListModel *model = _selectSellerArr[indexPath.row];
        [cell.headerImv sd_setImageWithURL:[NSURL URLWithString:[HTHoldNullObj getValueWithUnCheakValue:@""]] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
        cell.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
        cell.priceTF.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue: _paySellerArr[indexPath.row]]];
        cell.biliTF.text = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:_biliArr[indexPath.row]]];
        cell.headerImvLeft.constant = 17;
        [cell.biliTF setInputAccessoryView:_mixSellHeaderView];
        [cell.priceTF setInputAccessoryView:_mixSellHeaderView];
        cell.biliTF.tag = 4000 + indexPath.row;
        cell.priceTF.tag = 5000 + indexPath.row;
        [biliTFArr addObject:cell.biliTF];
        [priceTFArr addObject:cell.priceTF];
        cell.biliTF.delegate = self;
        cell.priceTF.delegate = self;
        return cell;
    }else if(indexPath.section == 7){
        HTNewPayPayHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayPayHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.payHeaderLeft addTarget:self action:@selector(payHeaderLeftAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.payHeaderRight addTarget:self action:@selector(payHeaderRightAction) forControlEvents:UIControlEventTouchUpInside];
        self.mixHeaderImv = cell.imv;
        return cell;
    }else{
        if (isNormalPayKind) {
            HTNewPayPayNormalKindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayPayNormalKindTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([_custModel.custId isEqualToString:@""] || _custModel.custId == nil) {
                cell.type = 3;
            }else if(![HTShareClass shareClass].isPlatformOnlinePayActive){
                cell.type = 2;
            }else{
                cell.type = 1;
            }
            cell.delegate = self;
            return cell;
        }else{
            HTNewPayMixPayKindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPayMixPayKindTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([_payKindMoneyArr[indexPath.row] isEqualToString:@""] || [_payKindMoneyArr[indexPath.row] floatValue] == 0) {
                cell.headerImv.image = [UIImage imageNamed:[NSString stringWithFormat:@"payIcon%ldn", indexPath.row + 1]];
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
                cell.moneyTF.text = @"";
            }else{
                cell.headerImv.image = [UIImage imageNamed:[NSString stringWithFormat:@"payIcon%ld", indexPath.row + 1]];
                cell.titleLabel.text = @"#222222";
                cell.moneyTF.text = _payKindMoneyArr[indexPath.row];
            }
            cell.moneyTF.delegate = self;
            switch (indexPath.row) {
                case 0:
                    cell.titleLabel.text = @"储值支付";
                    break;
                case 1:
                    cell.titleLabel.text = @"储赠支付";
                    break;
                case 2:
                    cell.titleLabel.text = @"微信支付";
                    break;
                case 3:
                    cell.titleLabel.text = @"支付宝支付";
                    break;
                case 4:
                    cell.titleLabel.text = @"现金支付";
                    break;
                case 5:
                    cell.titleLabel.text = @"刷卡支付";
                    break;
                default:
                    break;
            }
            cell.moneyTF.tag = 3000 + indexPath.row;
            [cell.moneyTF setInputAccessoryView:_mixPayHeaderView];
            
            return cell;
        }
    }
    
}

- (void)tapAction:(id)sender{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger index = singleTap.view.tag - 20000;
    HTCahargeProductModel * model = _products[index];
    if ([model.selectedModel.productimage isEqualToString:@""] || model.selectedModel.productimage == nil) {
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:[[model.product firstObject] productimage]];
    }else{
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:model.selectedModel.productimage];
    }
    
}


- (BOOL)checkPayIfCanThisEditWithTextField:(UITextField *)textField WithStr:(NSString *)str{
    NSInteger tag = textField.tag;
    if (tag >= 3000 && tag < 4000) {
        //组合支付输入框
        NSInteger current = tag - 3000;
        CGFloat currentTFNum =  [textField.text floatValue] * 10 + str.floatValue;
        CGFloat totalNum;
        for (int i = 0; i < _payKindMoneyArr.count; i++) {
            if (i != current) {
                totalNum += [_payKindMoneyArr[i] floatValue];
            }
        }
        totalNum += currentTFNum;
        if ([_orderModel.finalprice floatValue] >= totalNum) {
            //            _mixPayHeaderLabel.text = [NSString stringWithFormat:@"还有%.2f元未分配", [_orderModel.encodeFinal floatValue] - totalNum];
            return YES;
        }else{
            return NO;
        }
    }else if(tag >= 4000 && tag < 5000){
        //组合销售比例输入框
        NSInteger current = tag - 4000;
        
        CGFloat currentTFNum =  [textField.text floatValue] * 10 + str.floatValue;
        CGFloat totalNum;
        for (int i = 0; i < _biliArr.count; i++) {
            if (i != current) {
                totalNum += [_biliArr[i] floatValue];
            }
        }
        totalNum += currentTFNum;
        if (100 >= totalNum) {
            
            return YES;
        }else{
            return NO;
        }
        
    }else if(tag >= 5000 && tag < 6000){
        //组合销售 金额输入框
        NSInteger current = tag - 5000;
        
        CGFloat currentTFNum =  [textField.text floatValue] * 10 + str.floatValue;
        CGFloat totalNum;
        for (int i = 0; i < _paySellerArr.count; i++) {
            if (i != current) {
                totalNum += [_paySellerArr[i] floatValue];
            }
        }
        totalNum += currentTFNum;
        if ([_orderModel.finalprice floatValue] >= totalNum) {
            
            return YES;
        }else{
            return NO;
        }
        
    }else{
        
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"当前行:%ld 列:%ld", indexPath.section, indexPath.row);
    if (indexPath.section == 1) {
        HTChangePriceViewController *vc = [[HTChangePriceViewController alloc] init];
        vc.oldDataArray = self.products;
        vc.orderModel = self.orderModel;
        NSMutableArray *copyArray = [NSMutableArray array];
        for (HTCahargeProductModel *model in self.products) {
            NSDictionary *dic = [model yy_modelToJSONObject];
            HTCahargeProductModel *mm = [HTCahargeProductModel yy_modelWithJSON:dic];
            [copyArray addObject:mm];
        }
        vc.dataArray = copyArray;
        vc.custModel = self.custModel;
        __weak typeof(self) weakSelf = self;
        vc.didChange = ^(NSArray *backArray, NSString *wechatPayOrderId, NSString *finalPrice, NSString *payCode) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.products = backArray;
            strongSelf.orderModel.finalprice = finalPrice;
            
            //            strongSelf.payCode = payCode;
            //            strongSelf.wechatPayOrderId = wechatPayOrderId;
            strongSelf.priceLabel.text = finalPrice;
            NSMutableArray *tempSell = [NSMutableArray array];
            for (int i = 0; i < strongSelf.paySellerArr.count; i++) {
                [tempSell addObject:@""];
            }
            strongSelf.paySellerArr = [NSMutableArray arrayWithArray:tempSell];
            
            NSMutableArray *tempBili = [NSMutableArray array];
            for (int i = 0; i < strongSelf.biliArr.count; i++) {
                [tempBili addObject:@""];
            }
            strongSelf.biliArr = [NSMutableArray arrayWithArray:tempBili];
            
            NSMutableArray *tempPayKind = [NSMutableArray array];
            for (int i = 0; i < strongSelf.payKindMoneyArr.count; i++) {
                [tempPayKind addObject:@""];
            }
            strongSelf.payKindMoneyArr = [NSMutableArray arrayWithArray:tempPayKind];
            
            [strongSelf.dataTableView reloadData];
        };
        //        vc.didpay = ^{
        //            __strong typeof(weakSelf) strongSelf = weakSelf;
        //            strongSelf.printerManager.pushNext = ^{
        //                __strong typeof(weakSelf) strongsSelf = weakSelf;
        //                [strongsSelf print];
        //                [strongsSelf.navigationController popToRootViewControllerAnimated:YES];
        //            };
        //        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2){
        if ([_noGiveScoreArr containsObject:indexPath]) {
            [_noGiveScoreArr removeObject:indexPath];
        }else{
            [_noGiveScoreArr addObject:indexPath];
        }
        [_dataTableView reloadData];
    } else if (indexPath.section == 5) {
        HTChargeMaskViewController *choose = [[HTChargeMaskViewController alloc] init];
        choose.delegate = self;
        choose.selectArr = [NSMutableArray arrayWithArray:_selectSellerArr];
        [self.navigationController pushViewController:choose animated:YES];
    }else{
        
    }
}

- (void)chooseSellerBack:(NSMutableArray *)sellerArr{
    NSLog(@"%@", sellerArr);
    _selectSellerArr = [NSMutableArray arrayWithArray:sellerArr];
    [self dealSellerData];
    [_dataTableView reloadData];
}

- (void)clickBtn:(NSString *)payKind{
    NSLog(@"当前支付种类:%@", payKind);
    currentNormalPayKind = [payKind integerValue];
}

- (void)payHeaderLeftAction{
    NSLog(@"常规支付");
    self.mixHeaderImv.image = [UIImage imageNamed:@"npzhleft"];
    if (isNormalPayKind == 1) {
        
    }else{
        isNormalPayKind = 1;
        [_dataTableView reloadData];
    }
}

- (void)payHeaderRightAction{
    NSLog(@"组合支付");
    self.mixHeaderImv.image = [UIImage imageNamed:@"npzhright"];
    if (isNormalPayKind == 0) {
        
    }else{
        isNormalPayKind = 0;
        [_dataTableView reloadData];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]){
        textView.text = @"请输入订单备注内容";
        textView.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    self.tipStr = textView.text;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入订单备注内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //头部包含储值等
    if (indexPath.section == 0) {
        if ([[HTHoldNullObj getValueWithUnCheakValue:_custModel.phone] isEqualToString:@""]) {
            return 0.1;
        }else{
            return 160;
        }
    }else if (indexPath.section == 1){
        //商品头
        return 44;
    }else if (indexPath.section == 2){
        //商品
        return 107;
    }else if (indexPath.section == 3){
        //商品尾
        return 52;
    }else if (indexPath.section == 4){
        //备注
        return 93;
    }else if (indexPath.section == 5){
        //导购头
        return 44;
    }else if (indexPath.section == 6){
        //导购
        return 71;
    }else if(indexPath.section == 7){
        //组合头
        return 120;
    }else{
        //组合
        if (isNormalPayKind) {
            //常规
            return 277;
        }else{
            //组合
            return 69;
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 6) {
        
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, HMSCREENWIDTH, 44);
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(17, 10, HMSCREENWIDTH, 14);
        label.textColor = [UIColor colorWithHexString:@"#F53434"];
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        
        _mixRemainSellNum = [_orderModel.finalprice floatValue];
        for (NSString * tempStr in _paySellerArr) {
            _mixRemainSellNum -= [tempStr floatValue];
        }
        CGFloat tempTotalBili = 100;
        for (NSString * tempStr in _biliArr) {
            tempTotalBili -= [tempStr floatValue];
        }
        if (_mixRemainSellNum < 0.001 && _mixRemainSellNum > -0.001) {
            label.text = @"已完成分配";
        }else{
            label.text = [NSString stringWithFormat:@"还有%.2f元/%.2f%%未分配", _mixRemainSellNum, tempTotalBili];
        }
        return headerView;
    }else if (section == 8 && !isNormalPayKind){
        
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, HMSCREENWIDTH, 44);
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(17, 10, HMSCREENWIDTH, 14);
        label.textColor = [UIColor colorWithHexString:@"#F53434"];
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        
        _mixRemainPayNum = [_orderModel.finalprice floatValue];
        for (NSString * tempStr in _payKindMoneyArr) {
            _mixRemainPayNum -= [tempStr floatValue];
        }
        if (_mixRemainPayNum < 0.001 && _mixRemainPayNum > -0.001) {
            label.text = @"已完成分配";
        }else{
            label.text = [NSString stringWithFormat:@"还有%.2f元未分配", _mixRemainPayNum];
        }
        
        return headerView;
        
        
    }else{
        return [[UIView alloc] init];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 6) {
        return 44;
    }else if (section == 8){
        if (isNormalPayKind) {
            return 0.01;
        }else{
            return 44;
        }
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0.01;
    }else if (section == 1) {
        return 10;
    }else if(section == 2){
        return 0.01;
    }else if(section == 3){
        return 0.01;
    }else if(section == 4){
        return 10;
    }else if(section == 5){
        return 10;
    }else if(section == 6){
        return 0.01;
    }else if (section == 7){
        return 10;
    }
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _products.count;
    }else if (section == 6){
        return _selectSellerArr.count;
    }else if (section == 8){
        if (isNormalPayKind) {
            return 1;
        }else{
            return 6;
        }
    }else{
        return 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 以前逻辑
/**
 下单成功后的统一操作
 
 @param msg 发送短信内容
 */
- (void)settleSuccessWithMsg:(NSString *)msg{
    [self clearCache];
    if (self.custModel.custId.length > 0 && self.custModel.phone.length > 0 && msg.length > 0) {
        __weak typeof(self) weakSelf = self;
        self.printerManager.pushNext = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf sendMessegeWithPhone:[HTHoldNullObj getValueWithUnCheakValue:strongSelf.custModel.phone] andMsg:msg];
        };
    }else{
        __weak typeof(self) weakSelf = self;
        self.printerManager.pushNext = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
}

/**
 清除缓存
 */
-(void)clearCache{
    NSDictionary *dic = [NSDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:STROREUNFINSHORDER];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:STROREUNFINSHORDERTIME];
}
//打印
-(void)print{
    //构造打印数据
    [HTShareClass shareClass].printerModel.orderTotalPrize = self.orderModel.totalprice;
    [HTShareClass shareClass].printerModel.orderFinalPrize = self.orderModel.finalprice;
    [HTShareClass shareClass].printerModel.orderId = self.orderModel.orderId;
    [HTShareClass shareClass].printerModel.orderNo = self.orderModel.ordernum;
    [HTShareClass shareClass].printerModel.telPhone = self.custModel.phone;
    [HTShareClass shareClass].printerModel.salerName = self.orderModel.creator;
    [self.products enumerateObjectsUsingBlock:^(HTCahargeProductModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
        HTChargeProductInfoModel *md = obj.selectedModel ;
        [printDic setObject:[NSString stringWithFormat:@"%@",md.barcode] forKey:@"productCode"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.size] forKey:@"size"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.color] forKey:@"colorNum"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.price] forKey:@"singlePrice"];
        [printDic setObject: [[NSString stringWithFormat:@"%@", md.discount] isEqualToString:@"0.0"]  ?  @"1" : [NSString stringWithFormat:@"%@", md.discount].length == 0 ? @"-10.0" : [NSString stringWithFormat:@"%@", md.discount] forKey:@"discount"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.finalprice ]forKey:@"salePrice"];
        [printDic setObject:@"1" forKey:@"count"];
        [[HTShareClass shareClass].printerModel.goodsList addObject:printDic];
    }];
    [HTShareClass shareClass].printerModel.orderDesc = self.tipTextView.text;
    //    发送打印请求
    //    [HTHoldOrderEventManager printOrderInfoWithOrderId:self.orderModel.orderId];
    [self.printerManager print];
}
/**
 *  发送消息
 *
 *  @param tel 电话
 *  @param msg 消息内容
 */
- (void)sendMessegeWithPhone:(NSString *) tel andMsg:(NSString *) msg{
    [self showMessageView:@[tel] title:@"新消息" body:msg];
}
/**
 *  发送短息 url
 *
 *  @param phones 电话号码
 *  @param title  标题
 *  @param body   内容
 */
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    __weak typeof(self ) weakSelf = self;
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        controller.body = body;
        controller.messageComposeDelegate = weakSelf;
        
        for (UIView *obj in controller.view.subviews) {
            if ([[obj class] isSubclassOfClass:[UITextField class]]) {
                UITextField *textFied =  (UITextField *)obj;
                textFied.enabled      = NO;
            }
        }
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
        vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
        for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
            if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                vc.customerFollowRecordId = [mode.moduleId stringValue];
            }
            if ([mode.moduleName isEqualToString:@"customer"]) {
                vc.moduleModel = mode;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        
    }
}
//短信发送成功回调
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            //            push到客户编辑页面
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
            break;
            
        case MessageComposeResultFailed:
            //信息传送失败
        {
            
            //            push到客户编辑页面
            
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
            break;
        case MessageComposeResultCancelled:
        {
            //信息被用户取消传送
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - getters and setters
-(HTPrinterTool *)printerManager{
    if (!_printerManager) {
        _printerManager = [[HTPrinterTool alloc] init];
    }
    return _printerManager;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
