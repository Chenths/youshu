//
//  HTChangePriceViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTChangePriceProductInfoCell.h"
#import "HTChangePriceViewController.h"
#import "HTChangePriceCustomerInfoCell.h"
#import "HTChangePriceAlertView.h"
#import "HTChangePriceAlertView.h"
#import "NSNumber+FourGoFiveIn.h"
#import "SecurityUtil.h"
#import "HTCustomDefualAlertView.h"
#define SELECTEDIMG @"singleSelected"
#define NOSELECTEDIMG @"singleUnselected"
@interface HTChangePriceViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,HTChangePriceAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *finallPrice;

@property (weak, nonatomic) IBOutlet UILabel *productCount;

@property (weak, nonatomic) IBOutlet UILabel *tatolPrice;

@property (weak, nonatomic) IBOutlet UILabel *selectedChangeNum;

@property (weak, nonatomic) IBOutlet UIButton *changePriceBt;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomheight;

@property (nonatomic,strong) NSMutableArray *selectedArray;

@property (nonatomic,strong) UIButton *rightBt;

@property (nonatomic,assign) BOOL isAllSelected;

@end

@implementation HTChangePriceViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"改价";
    self.isAllSelected = NO;
    [self createTb];
    [self createBottom];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, -nav_height, HMSCREENWIDTH, nav_height)];
    vv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vv];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.custModel.custId.length > 0) {
        if (indexPath.section == 0) {
            HTChangePriceCustomerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChangePriceCustomerInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cust = self.custModel;
            return cell;
        }else{
            HTChangePriceProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChangePriceProductInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chargeModel = self.dataArray[indexPath.row];
            cell.index = indexPath;
            return cell;
        }
    }else{
        HTChangePriceProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChangePriceProductInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.chargeModel = self.dataArray[indexPath.row];
        cell.index = indexPath;
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.custModel.custId.length > 0 ? ( section == 0 ? 1 : self.dataArray.count) : self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.custModel.custId.length > 0 ? 2 : 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTChangePriceProductInfoCell class]]) {
            HTCahargeProductModel *model = self.dataArray[indexPath.row];
            model.isSelected = !model.isSelected;
            if (model.isSelected) {
                [self.selectedArray addObject:model];
            }else{
                if ([self.selectedArray containsObject:model]) {
                    [self.selectedArray removeObject:model];
                }
            }
            [self.tab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.selectedChangeNum.text = [NSString stringWithFormat:@"%ld",self.selectedArray.count];
            if (self.selectedArray.count == 0) {
                [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
            }
            if (self.selectedArray.count == self.dataArray.count) {
                [self.rightBt setImage:[UIImage imageNamed:SELECTEDIMG] forState:UIControlStateNormal];
            }
        }
}
-(void)createBottom{
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",self.orderModel.encodeFinal];
    self.tatolPrice.text = [NSString stringWithFormat:@"¥%@",self.orderModel.encodeTotal];
    self.productCount.text = [NSString stringWithFormat:@"共%ld件商品",self.dataArray.count];
}
-(void)sumTotle{
    CGFloat finall = 0;
    for (HTCahargeProductModel *model in self.dataArray) {
        finall += model.selectedModel.finalprice.floatValue;
    }
    self.finallPrice.text = [NSString stringWithFormat:@"¥%.0lf",finall];
}
#pragma mark -CustomDelegate
-(void)hasChangePriceWithFinalPrice:(NSString *)finallPrice{
    if (self.selectedArray.count == 1) {
        HTCahargeProductModel *model = [self.selectedArray firstObject];
        model.isSelected = NO;
        model.isChangePrice = YES;
        model.isChange = YES;
        model.selectedModel.finalprice = finallPrice;
        if (model.selectedModel.finalprice.intValue == model.selectedModel.price.intValue) {
            model.selectedModel.discount = @"1";
        }else{
            model.selectedModel.discount = @"-10";
        }
    }
    [self.selectedArray removeAllObjects];
    [self.tab reloadData];
    [self sumTotle];
}
-(void)hasChangePriceWithDiscount:(NSString *)discount{
    
    for (HTCahargeProductModel *model in self.selectedArray) {
        model.selectedModel.discount = discount;
        model.selectedModel.finalprice = [NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:model.selectedModel.price.floatValue] setDiscountWithCount: [NSString stringWithFormat:@"%.1lf",discount.floatValue * 10]]];
        model.isSelected = NO;
        model.isChangePrice = NO;
        model.isChange = YES;
    }
    [self.selectedArray removeAllObjects];
    [self.tab reloadData];
    [self sumTotle];
}
#pragma mark -EventResponse
- (void)allSlectedClicked:(id)sender {
    if (!self.isAllSelected) {
        [self.selectedArray removeAllObjects];
        for (HTCahargeProductModel *model in self.dataArray) {
            model.isSelected = YES;
        }
        [self.selectedArray addObjectsFromArray:self.dataArray];
        [self.rightBt setImage:[UIImage imageNamed:SELECTEDIMG] forState:UIControlStateNormal];
        self.isAllSelected = YES;
    }else{
        for (HTCahargeProductModel *model in self.dataArray) {
            model.isSelected = NO;
        }
        [self.selectedArray removeAllObjects];
        self.isAllSelected = NO;
        [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
    }
    self.selectedChangeNum.text = [NSString stringWithFormat:@"%ld",self.selectedArray.count];
    [self.tab reloadData];
}
- (IBAction)finshClicked:(id)sender {
    if (_isReturn) {
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        __block CGFloat totlePrice = 0.0f;
        __weak typeof(self) weakSelf =  self;
        [self.dataArray enumerateObjectsUsingBlock:^(HTCahargeProductModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            HTChargeProductInfoModel *changeModel = obj.selectedModel;
            if (obj.isChange) {
                for (HTCahargeProductModel *mmm in strongSelf.oldDataArray) {
                    HTChargeProductInfoModel *mod = mmm.selectedModel;
                    if ([changeModel.primaryKey isEqualToString:mod.primaryKey]) {
                        if (changeModel.finalprice.intValue != mod.finalprice.intValue || ![[NSString stringWithFormat:@"%@",changeModel.discount] isEqualToString:[NSString stringWithFormat:@"%@",mod.discount]]|| obj.hasGivePoint.length > 0) {
                            NSDictionary *valueDic  = @{
                                                        @"finalPrice":[SecurityUtil encryptAESData: [NSString stringWithFormat:@"%@",changeModel.finalprice]],
                                                        @"discount": changeModel.discount,
                                                        @"hasGivePoint":[HTHoldNullObj getValueWithUnCheakValue:obj.hasGivePoint],
                                                        };
                            [dataDic setObject:valueDic forKey:changeModel.primaryKey];
                        }
                        break;
                    }
                }
            }
            totlePrice += changeModel.finalprice.floatValue;
        }];
        if (dataDic.allKeys.count == 0) {
            __weak typeof(self) weakSelf = self;
            HTCustomDefualAlertView *alert =  [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"当前订单未进行修改，是否退出改价" btsArray:@[@"不退出",@"退出改价"] okBtclicked:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } cancelClicked:^{
            }];
            [alert show];
            return;
        }
        if (self.isReturn) {
            NSDictionary *dic = @{
                                  @"orderId":self.orderModel.orderId,
                                  @"orderJsonStr":[dataDic jsonStringWithDic],
                                  @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                  @"productCount":@(self.dataArray.count),
                                  @"exchangeProductPrice":[HTHoldNullObj getValueWithUnCheakValue:self.changePrice],
                                  };
            [MBProgressHUD showMessage:@""];
            __weak typeof(self) weakSelf = self;
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,repalceProductModifyPrice] params:dic success:^(id json) {
                [MBProgressHUD hideHUD];
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.didChange(strongSelf.dataArray, [json[@"data"] getStringWithKey:@"wechatPayOrderId"], [json[@"data"] getStringWithKey:@"finalPrice"], [json[@"data"] getStringWithKey:@"payCode"]);
                [strongSelf.navigationController popViewControllerAnimated:YES];
                [strongSelf.dataArray enumerateObjectsUsingBlock:^(HTCahargeProductModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.isChange = NO;
                    obj.isSelected = NO;
                    obj.isChangePrice = NO;
                }];
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:SeverERRORSTRING];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:NETERRORSTRING];
            }];
        }
    }else{
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        __block CGFloat totlePrice = 0.0f;
        __weak typeof(self) weakSelf =  self;
        //    [self.dataArray enumerateObjectsUsingBlock:^(HTCahargeProductModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL ifChange = 0;
        for (HTCahargeProductModel *obj in self.dataArray) {
            HTChargeProductInfoModel *changeModel = obj.selectedModel;
            if (obj.isChange) {
                for (HTCahargeProductModel *mmm in strongSelf.oldDataArray) {
                    HTChargeProductInfoModel *mod = mmm.selectedModel;
                    //                if ([changeModel.primaryKey isEqualToString:mod.primaryKey]) {
                    if (changeModel.finalprice.intValue != mod.finalprice.intValue || ![[NSString stringWithFormat:@"%@",changeModel.discount] isEqualToString:[NSString stringWithFormat:@"%@",mod.discount]]|| obj.hasGivePoint.length > 0) {
                        //                        NSDictionary *valueDic  = @{
                        //                                                    @"finalPrice":[SecurityUtil encryptAESData: [NSString stringWithFormat:@"%@",changeModel.finalprice]],
                        //                                                    @"discount": changeModel.discount,
                        //                                                    @"hasGivePoint":[HTHoldNullObj getValueWithUnCheakValue:obj.hasGivePoint],
                        //                                                    };
                        //                        [dataDic setObject:changeModel.finalprice forKey:@"finalPrice"];
                        ifChange = 1;
                    }
                    break;
                    //                }
                }
            }
            totlePrice += changeModel.finalprice.floatValue;
        }
        //    }];
        if (!ifChange) {
            __weak typeof(self) weakSelf = self;
            HTCustomDefualAlertView *alert =  [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"当前订单未进行修改，是否退出改价" btsArray:@[@"不退出",@"退出改价"] okBtclicked:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } cancelClicked:^{
                
            }];
            [alert show];
            return;
        }else{
            self.didChange(strongSelf.dataArray, @"", [NSString stringWithFormat:@"%.2f", totlePrice], @"");
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        //    if (self.isReturn) {
        //        NSDictionary *dic = @{
        //                              @"orderId":self.orderModel.orderId,
        //                              @"orderJsonStr":[dataDic jsonStringWithDic],
        //                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
        //                              @"productCount":@(self.dataArray.count),
        //                              @"exchangeProductPrice":[HTHoldNullObj getValueWithUnCheakValue:self.changePrice],
        //                              };
        //        [MBProgressHUD showMessage:@""];
        //        __weak typeof(self) weakSelf = self;
        //        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,repalceProductModifyPrice] params:dic success:^(id json) {
        //            [MBProgressHUD hideHUD];
        //            __strong typeof(weakSelf) strongSelf = weakSelf;
        //            strongSelf.didChange(strongSelf.dataArray, [json[@"data"] getStringWithKey:@"wechatPayOrderId"], [json[@"data"] getStringWithKey:@"finalPrice"], [json[@"data"] getStringWithKey:@"payCode"]);
        //            [strongSelf.navigationController popViewControllerAnimated:YES];
        //            [strongSelf.dataArray enumerateObjectsUsingBlock:^(HTCahargeProductModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                obj.isChange = NO;
        //                obj.isSelected = NO;
        //                obj.isChangePrice = NO;
        //            }];
        //        } error:^{
        //            [MBProgressHUD hideHUD];
        //            [MBProgressHUD showError:SeverERRORSTRING];
        //        } failure:^(NSError *error) {
        //            [MBProgressHUD hideHUD];
        //            [MBProgressHUD showError:NETERRORSTRING];
        //        }];
        //    }else{
        //请求订单状态是否为以支付
        //        NSDictionary *dict = @{
        //                               @"orderId"    :  self.orderModel.orderId,
        //                               @"companyId"  :[HTShareClass shareClass].loginModel.companyId
        //                               };
        //        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryOrderState] params:dict success:^(id json) {
        //
        //            if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"2"]) {
        //                [MBProgressHUD hideHUD];
        //                [MBProgressHUD showSuccess:@"该订单已支付成功，不能进行该操作"];
        //                [self dismissViewControllerAnimated:YES completion:nil];
        //                if (self.didpay) {
        //                    self.didpay();
        //                }
        //                return ;
        //            }else{
        //        NSDictionary *dic = @{
        //                              @"orderId":self.orderModel.orderId,
        //                              @"orderJsonStr":[dataDic jsonStringWithDic],
        //                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
        //                              @"productCount":@(self.dataArray.count)
        //                              };
        //        [MBProgressHUD showMessage:@""];
        //        __weak typeof(self) weakSelf = self;
        //        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,modifyOrderPrice4App] params:dic success:^(id json) {
        //            [MBProgressHUD hideHUD];
        //            __strong typeof(weakSelf) strongSelf = weakSelf;
        //            strongSelf.didChange(strongSelf.dataArray, [json[@"data"] getStringWithKey:@"wechatPayOrderId"], [json[@"data"] getStringWithKey:@"finalPrice"], [json[@"data"] getStringWithKey:@"payCode"]);
        //            [strongSelf.navigationController popViewControllerAnimated:YES];
        //            [strongSelf.dataArray enumerateObjectsUsingBlock:^(HTCahargeProductModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                obj.isChange = NO;
        //                obj.isSelected = NO;
        //                obj.isChangePrice = NO;
        //            }];
        //        } error:^{
        //            [MBProgressHUD hideHUD];
        //            [MBProgressHUD showError:SeverERRORSTRING];
        //        } failure:^(NSError *error) {
        //            [MBProgressHUD hideHUD];
        //            [MBProgressHUD showError:NETERRORSTRING];
        //        }];
        //            }
        //      } error:^{
        //          [MBProgressHUD hideHUD];
        //          [MBProgressHUD showError:SeverERRORSTRING];
        //      } failure:^(NSError *error) {
        //          [MBProgressHUD hideHUD];
        //          [MBProgressHUD showError:NETERRORSTRING];
        //      }];
        //    }
    }
}
- (IBAction)changePriceClicked:(id)sender {
    if (self.selectedArray.count == 0) {
        [MBProgressHUD showError:@"请选择改价商品"];
        return;
    }
    if (self.selectedArray.count == 1) {
        [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"修改价格",@"设置折扣"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index == 1) {
                HTChangePriceAlertView *alert = [[HTChangePriceAlertView alloc] initWithChangePriceAlertWithType:HTChangePrice];
                alert.selectedArray = self.selectedArray;
                alert.delegate = self;
                [alert show];
            }
            if (index == 2) {
                HTChangePriceAlertView *alert = [[HTChangePriceAlertView alloc] initWithChangePriceAlertWithType:HTChangeDiscount];
                alert.selectedArray = self.selectedArray;
                alert.delegate = self;
                [alert show];
            }
        }];
    }else{
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"设置折扣"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            HTChangePriceAlertView *alert = [[HTChangePriceAlertView alloc] initWithChangePriceAlertWithType:HTChangeDiscount];
            alert.selectedArray = self.selectedArray;
            alert.delegate = self;
            [alert show];
        }
    }];
    }
}
#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTChangePriceProductInfoCell" bundle:nil] forCellReuseIdentifier:@"HTChangePriceProductInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTChangePriceCustomerInfoCell" bundle:nil] forCellReuseIdentifier:@"HTChangePriceCustomerInfoCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomheight.constant = 61 + SafeAreaBottomHeight;
    
//    右键
    self.rightBt = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.rightBt setTitle:@"全选" forState:UIControlStateNormal];
    [self.rightBt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    self.rightBt.titleLabel.font = [UIFont systemFontOfSize:13];
    self.rightBt.frame = CGRectMake(HMSCREENWIDTH - 65, 0, 60, nav_height);
    [self.rightBt addTarget:self action:@selector(allSlectedClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBt.imageEdgeInsets =UIEdgeInsetsMake(self.rightBt.imageEdgeInsets.top, self.rightBt.imageEdgeInsets.left, self.rightBt.imageEdgeInsets.bottom,8);
    [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-back" highImageName: @"g-back" target:self action:@selector(finshClicked:)];
}
#pragma mark - getters and setters
-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


@end
