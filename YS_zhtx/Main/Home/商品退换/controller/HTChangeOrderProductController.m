//
//  HTChangeProductViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTNewCustomerBaceInfoCell.h"
#import "HTReturnOrderInfoCell.h"
#import "HTDefaulProductViewCell.h"
#import "HTChangeOrderProductController.h"
#import "HTReturnChargeViewController.h"
#import "HTOrderDetailModel.h"
#import "HTCustomerReportViewController.h"
#import "HTChangeSettleViewController.h"
#import "HTReturnSettleViewController.h"
#import "HTCustModel.h"
#import "HTChangeFastCashierViewController.h"
#import "HTNewReturnAndChangeViewController.h"
#define SELECTEDIMG @"singleSelected"
#define NOSELECTEDIMG @"singleUnselected"

@interface HTChangeOrderProductController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *cellsArray;
@property (nonatomic,strong) HTOrderDetailModel *orderModel;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *nomorArray;

@property (nonatomic,strong) NSMutableArray *selctedArray;

@property (nonatomic,strong) UIButton *rightBt;

@property (nonatomic,assign) BOOL isAllSelected;


@end

@implementation HTChangeOrderProductController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isAllSelected = NO;
    [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
    [self loadData];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellsArray[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderModel ?   self.cellsArray.count : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsArray[indexPath.section];
    NSString *name = cells[indexPath.row];
    if ([name isEqualToString:@"HTDefaulProductViewCell"]) {
        HTDefaulProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDefaulProductViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.excOrReProductModel = self.dataArray[indexPath.row];
        return cell;
    }else if ([name isEqualToString:@"HTNewCustomerBaceInfoCell"]){
        HTNewCustomerBaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewCustomerBaceInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
    }else{
        HTReturnOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTReturnOrderInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001f;
    }else if (section == 1){
        return 8.0f;
    }else{
        return 8.0f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    return vvv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTDefaulProductViewCell class]]) {
        HTOrderDetailProductModel *model = self.dataArray[indexPath.row];
        if ([self.nomorArray containsObject:model]) {
            model.isSelected = !model.isSelected;
            if (model.isSelected) {
                [self.selctedArray addObject:model];
            }else{
                if ([self.selctedArray containsObject:model]) {
                    [self.selctedArray removeObject:model];
                }
            }
            if (self.selctedArray.count == 0) {
                [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
            }
            if (self.selctedArray.count == self.nomorArray.count) {
                [self.rightBt setImage:[UIImage imageNamed:SELECTEDIMG] forState:UIControlStateNormal];
            }
            [self.tab reloadData];
        }
    }
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTNewCustomerBaceInfoCell class]]) {
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
        model.custId = self.orderModel.customer.customerid;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)exchangeClicked:(id)sender {

    for (int i = 0; i < self.dataArray.count; i++) {
        HTOrderDetailProductModel *model = self.dataArray[i];
        model.discount = [NSString stringWithFormat:@"%.2f", [model.discount floatValue] / 1];
        [self.dataArray replaceObjectAtIndex:i withObject:model];
    }
    
    if (self.selctedArray.count == 0) {
        [MBProgressHUD showError:@"请选择退货商品"];
        return;
    }
    if ([HTHoldNullObj getValueWithUnCheakValue:self.orderModel.customer.phone].length > 0) {
        [MBProgressHUD showMessage:@""];
        NSDictionary *dic = @{
                              @"id":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.customer.customerid],
                              @"companyId":[HTShareClass shareClass].loginModel.companyId
                              };
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,laodCust4App] params:dic success:^(id json) {
            [MBProgressHUD hideHUD];
            HTCustModel *custModel = [HTCustModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
            
            
            
            if ([HTShareClass shareClass].isProductActive) {
                HTReturnChargeViewController *vc = [[HTReturnChargeViewController alloc] init];
                vc.exchangeArray = self.selctedArray;
                vc.custModel = custModel;
                vc.orderModel = self.orderModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                HTChangeFastCashierViewController *vc = [[HTChangeFastCashierViewController alloc] init];
                vc.exchangeArray = self.selctedArray;
                vc.custModel = custModel;
                vc.orderModel = self.orderModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }  error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    }else{
        if ([HTShareClass shareClass].isProductActive) {
            HTReturnChargeViewController *vc = [[HTReturnChargeViewController alloc] init];
            vc.exchangeArray = self.selctedArray;
            vc.orderModel = self.orderModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HTChangeFastCashierViewController *vc = [[HTChangeFastCashierViewController alloc] init];
            vc.exchangeArray = self.selctedArray;
            vc.orderModel = self.orderModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
 
}
- (IBAction)returnClicked:(id)sender {
    
    
    if (self.selctedArray.count == 0) {
        [MBProgressHUD showError:@"请选择退货商品"];
        return;
    }
    if ([HTHoldNullObj getValueWithUnCheakValue:self.orderModel.customer.phone].length > 0) {
        [MBProgressHUD showMessage:@""];
        NSDictionary *dic = @{
                              @"id":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.customer.customerid],
                              @"companyId":[HTShareClass shareClass].loginModel.companyId
                              };
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,laodCust4App] params:dic success:^(id json) {
            [MBProgressHUD hideHUD];
            HTCustModel *custModel = [HTCustModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
//后台不支持 暂时回滚
            HTReturnSettleViewController *vc = [[HTReturnSettleViewController alloc] init];

//            HTNewReturnAndChangeViewController *vc = [[HTNewReturnAndChangeViewController alloc] init];
            vc.custModel = custModel;
            vc.orderId = [HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId];
            vc.isReturnAll = self.selctedArray.count == self.nomorArray.count ? YES : NO;
            
            for (int i = 0; i < self.dataArray.count; i++) {
                HTOrderDetailProductModel *model = self.dataArray[i];
                model.discount = [NSString stringWithFormat:@"%.2f", [model.discount floatValue] / 1];
                [self.dataArray replaceObjectAtIndex:i withObject:model];
            }
            vc.returnProducts = self.selctedArray;
            vc.orderModel = self.orderModel;
            [self.navigationController pushViewController:vc animated:YES];
        }  error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    }else{
        //后台不支持 暂时回滚
        HTReturnSettleViewController *vc = [[HTReturnSettleViewController alloc] init];

//        HTNewReturnAndChangeViewController *vc = [[HTNewReturnAndChangeViewController alloc] init];
        for (int i = 0; i < self.dataArray.count; i++) {
            HTOrderDetailProductModel *model = self.dataArray[i];
            model.discount = [NSString stringWithFormat:@"%.2f", [model.discount floatValue] / 1];
            [self.dataArray replaceObjectAtIndex:i withObject:model];
        }
        vc.returnProducts = self.selctedArray;
        vc.orderId = [HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId];
        vc.isReturnAll = self.selctedArray.count == self.nomorArray.count ? YES : NO;
        vc.orderModel = self.orderModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)allSlectedClicked:(id)sender {
    if (!self.isAllSelected) {
        [self.selctedArray removeAllObjects];
        for (HTCahargeProductModel *model in self.nomorArray) {
            model.isSelected = YES;
        }
        [self.selctedArray addObjectsFromArray:self.nomorArray];
        [self.rightBt setImage:[UIImage imageNamed:SELECTEDIMG] forState:UIControlStateNormal];
        self.isAllSelected = YES;
    }else{
        for (HTCahargeProductModel *model in self.nomorArray) {
            model.isSelected = NO;
        }
        [self.selctedArray removeAllObjects];
        self.isAllSelected = NO;
        [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
    }
    [self.tab reloadData];
}

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewCustomerBaceInfoCell" bundle:nil] forCellReuseIdentifier:@"HTNewCustomerBaceInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTReturnOrderInfoCell" bundle:nil] forCellReuseIdentifier:@"HTReturnOrderInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTDefaulProductViewCell" bundle:nil] forCellReuseIdentifier:@"HTDefaulProductViewCell"];
    
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
    
    
    self.rightBt = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.rightBt setTitle:@"全选" forState:UIControlStateNormal];
    [self.rightBt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    self.rightBt.titleLabel.font = [UIFont systemFontOfSize:13];
    self.rightBt.frame = CGRectMake(HMSCREENWIDTH - 65, 0, 60, nav_height);
    [self.rightBt addTarget:self action:@selector(allSlectedClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBt.imageEdgeInsets =UIEdgeInsetsMake(self.rightBt.imageEdgeInsets.top, self.rightBt.imageEdgeInsets.left, self.rightBt.imageEdgeInsets.bottom,8);
    [self.rightBt setImage:[UIImage imageNamed:NOSELECTEDIMG] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
    
}


-(void)loadData{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,loadOrderDetail] params:dic success:^(id json) {
        //        清除布局数据
        [self.cellsArray removeAllObjects];
        [self.dataArray removeAllObjects];
        [self.selctedArray removeAllObjects];
        [self.nomorArray removeAllObjects];
        self.orderModel = [HTOrderDetailModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        if (self.orderModel.customer) {
            [self.cellsArray addObject:@[@"HTNewCustomerBaceInfoCell"]];
        }
        [self.cellsArray addObject:@[@"HTReturnOrderInfoCell"]];
        NSMutableArray *nomorls =  [NSMutableArray array];
        for (int i = 0; i < self.orderModel.product.count; i++) {
            [nomorls addObject:@"HTDefaulProductViewCell"];
            [self.dataArray addObject:self.orderModel.product[i]];
            [self.nomorArray addObject:self.orderModel.product[i]];
        }
        for (HTOrderDetailExchangesModel *model in self.orderModel.returnandexchangeproduct) {
            for (int i = 0; i < model.data.count; i++) {
                [nomorls addObject:@"HTDefaulProductViewCell"];
                [self.dataArray addObject:model.data[i]];
            }
        }
        [self.cellsArray addObject:nomorls];
        [self.tab reloadData];
        [MBProgressHUD hideHUD];
    }  error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)cellsArray{
    if (!_cellsArray) {
        _cellsArray = [NSMutableArray array];
        [_cellsArray addObject:@[@"HTNewCustomerBaceInfoCell"]];
        [_cellsArray addObject:@[@"HTReturnOrderInfoCell"]];
        [_cellsArray addObject:@[@"HTDefaulProductViewCell",@"HTDefaulProductViewCell",@"HTDefaulProductViewCell"]];
    }
    return _cellsArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)nomorArray{
    if (!_nomorArray) {
        _nomorArray = [NSMutableArray array];
    }
    return _nomorArray;
}
-(NSMutableArray *)selctedArray{
    if (!_selctedArray) {
        _selctedArray = [NSMutableArray array];
    }
    return _selctedArray;
}
@end
