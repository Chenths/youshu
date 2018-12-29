//
//  HTTuneOutOrInController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTTurnInNumbersCell.h"
#import "HTProductInfoTableCell.h"
#import "HTTurnOutCompanyCell.h"
#import "HTTuneTypeTableViewCell.h"
#import "HTDescTextViewCell.h"
#import "HTTurnOutDiscountCell.h"
#import "HTTuneOutOrInController.h"
#import "HTTuneOutorInModel.h"
#import "HTLoginDataPersonModel.h"

@interface HTTuneOutOrInController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *turnInBt;

@property (weak, nonatomic) IBOutlet UIButton *turnOutBt;

@property (weak, nonatomic) IBOutlet UIButton *turnOutOkBt;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *typeDic;

@property (nonatomic,strong) NSMutableDictionary *dicountDic;

@property (nonatomic,strong) NSMutableDictionary *selcetedDic;

@property (nonatomic,strong) HTTuneOutOrInDescModel *descModel;

@property (nonatomic,strong) NSArray *companys;

@end

@implementation HTTuneOutOrInController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMenuAuthWithString:@"stockManager" Type:@"9" HaveRoot:^(BOOL ishave) {
    }];
    [self createTb];
    [self makeData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initSubs];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsName.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellsName[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTProductInfoTableCell"]) {
        HTProductInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductInfoTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.inventoryModel;
        return cell;
    }else if ([cellname isEqualToString:@"HTTurnInNumbersCell"]){
        HTTurnInNumbersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTurnInNumbersCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = self.turnType;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else if ([cellname isEqualToString:@"HTTuneTypeTableViewCell"]){
        HTTuneTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTuneTypeTableViewCell" forIndexPath:indexPath];
         cell.key = @"key";
        if (self.turnType == HTTurnIn) {
          cell.dataList = @[
                               @{
                                   @"key":@"进货",
                                   @"value":@"10"
                                   },
                               @{
                                   @"key":@"补货",
                                   @"value":@"11"
                                   },
                               ];
        }else{
            cell.dataList = @[
                               @{
                                   @"key":@"退货（厂家）",
                                   @"value":@"14"
                                   },
                               @{
                                   @"key":@"报损（厂家）",
                                   @"value":@"15"
                                   },
                               @{
                                   @"key":@"其他",
                                   @"value":@"16"
                                   },
                               ];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeDic = self.typeDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTTurnOutDiscountCell"]){
        HTTurnOutDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTurnOutDiscountCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.discount = self.dicountDic;
        return cell;
    }else if ([cellname isEqualToString:@"HTTurnOutCompanyCell"]){
        HTTurnOutCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTurnOutCompanyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedDic = self.selcetedDic;
        cell.companys = self.companys;
        return cell;
    }else{
        HTDescTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDescTextViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.descModel;
        return cell;
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)turnInClicked:(id)sender {
    NSMutableDictionary *updateBtchJsonDic = [[NSMutableDictionary alloc] init];
    NSMutableArray  *sizeGroup= [NSMutableArray array];
    for (HTTuneOutorInModel *model in self.dataArray) {
        if (model.numbers.floatValue  > 0) {
            [sizeGroup addObject:model.size];
            [updateBtchJsonDic setObject:model.numbers forKey:model.size];
        }
    }
    if (sizeGroup.count == 0) {
        [MBProgressHUD showError:@"请至少输入一条数据" toView:self.view];
        return;
    }
    if ([self.typeDic getStringWithKey:@"value"].length == 0) {
        [MBProgressHUD showError:@"请选择调货类型" toView:self.view];
        return;
    }
    
    
    if ([self.dicountDic getStringWithKey:@"discount"].length == 0  ||[self.dicountDic getStringWithKey:@"money"].length == 0) {
        
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调货折扣或成本价格未设置，是否继续？" btsArray:@[@"取消",@"确认"] okBtclicked:^{
             [self turnInNetWorkWithDic:updateBtchJsonDic WithArr:sizeGroup];
        }
                                                                               cancelClicked:^{
                                                                                   
                                                                                                                             }];
        [alert show];
        
        return;
//        [MBProgressHUD showError:@"请输入成本折扣或成本金额" toView:self.view];
//
//
//        return ;
    }
    if ([self.dicountDic getStringWithKey:@"discount"].length > 0) {
        if (  [self.dicountDic getFloatWithKey:@"discount"] >= 1 && [self.dicountDic getFloatWithKey:@"discount"]  <= 10) {
        }else{
            [MBProgressHUD showError:@"成本折扣应在0折到10折" toView:self.view];
            return;
        }
    }
    [self turnInNetWorkWithDic:updateBtchJsonDic WithArr:sizeGroup];
    
}

- (void)turnInNetWorkWithDic:(NSMutableDictionary *)updateBtchJsonDic WithArr:(NSMutableArray *)sizeGroup{
    [updateBtchJsonDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode] forKey:@"styleCode"];
    [updateBtchJsonDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.colorCode] forKey:@"colorCode"];
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode],
                          @"colorCode":[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode],
                          @"remarks":[HTHoldNullObj getValueWithUnCheakValue:self.descModel.desc],
                          @"updateBtchJson":[@[updateBtchJsonDic] arrayToJsonString],
                          @"sizeGroup":[sizeGroup componentsJoinedByString:@","],
                          @"loginName":[HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.person.name ],
                          @"swapType":[self.typeDic getStringWithKey:@"value"],
                          @"initDiscount":[self.dicountDic getStringWithKey:@"discount"].length == 0 ? @"" : [NSString stringWithFormat:@"%.1lf",[self.dicountDic getFloatWithKey:@"discount"]]
                          ,
                          @"initPrice":[self.dicountDic getStringWithKey:@"money"].length == 0 ? @"" : [self.dicountDic getStringWithKey:@"money"]
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,saveSwapProductStockIn] params: dic  success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调入成功" btTitle:@"确定" okBtclicked:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
        }else{
            [MBProgressHUD showError:[[json getStringWithKey:@"msg"] length] > 0 ? [json getStringWithKey:@"msg"] : @"调入失败" toView:self.view];
        }
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (IBAction)turnOutClicked:(id)sender {
    
    if (self.selcetedDic.allKeys.count == 0) {
        [MBProgressHUD showError:@"请选择调出店铺" toView:self.view];
        return ;
    }
    NSMutableDictionary *updateBtchJsonDic = [[NSMutableDictionary alloc] init];
    NSMutableArray  *sizeGroup= [NSMutableArray array];
    for (HTTuneOutorInModel *model in self.dataArray) {
        if (model.numbers.floatValue  > 0) {
            [sizeGroup addObject:model.size];
            [updateBtchJsonDic setObject:model.numbers forKey:model.size];
        }
    }
    if (sizeGroup.count == 0) {
        [MBProgressHUD showError:@"请至少输入一条数据" toView:self.view];
    }
    [updateBtchJsonDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode] forKey:@"styleCode"];
    [updateBtchJsonDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.colorCode] forKey:@"colorCode"];
    NSDictionary *dict = @{
                           @"companyId":[HTShareClass shareClass].loginModel.companyId,
                           @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode],
                           @"colorCode":[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode],
                           @"remarks":[HTHoldNullObj getValueWithUnCheakValue:self.descModel.desc],
                           @"updateBtchJson":[@[updateBtchJsonDic] arrayToJsonString],
                           @"sizeGroup":[sizeGroup componentsJoinedByString:@","],
                           @"loginName":[HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.person.name ],
                           @"targetCompanyId":[[self.selcetedDic getStringWithKey:@"childId"] isEqualToString:@"-1"] ? @"" :[self.selcetedDic getStringWithKey:@"childId"],
                           @"opMode":@"0",
                           @"swapType":[self.typeDic getStringWithKey:@"value"],
                           };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,saveSwapProductStockOut] params: dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调出成功" btTitle:@"确定" okBtclicked:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
        }else{
            [MBProgressHUD showError:[[json getStringWithKey:@"msg"] length] > 0 ? [json getStringWithKey:@"msg"] : @"调出失败" toView:self.view];
        }
        
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"检查你的网络"];
    }];
    
    
}
- (IBAction)turnOutOkClicked:(id)sender {
    
    if (self.selcetedDic.allKeys.count == 0) {
        [MBProgressHUD showError:@"请选择调出店铺" toView:self.view];
        return ;
    }
    NSMutableDictionary *updateBtchJsonDic = [[NSMutableDictionary alloc] init];
    NSMutableArray  *sizeGroup= [NSMutableArray array];
    for (HTTuneOutorInModel *model in self.dataArray) {
        if (model.numbers.floatValue  > 0) {
            [sizeGroup addObject:model.size];
            [updateBtchJsonDic setObject:model.numbers forKey:model.size];
        }
    }
    if (sizeGroup.count == 0) {
        [MBProgressHUD showError:@"请至少输入一条数据" toView:self.view];
        return;
    }
    if ([self.typeDic getStringWithKey:@"value"].length == 0) {
        [MBProgressHUD showError:@"请选择调货类型" toView:self.view];
        return;
    }
    
    [updateBtchJsonDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode] forKey:@"styleCode"];
    [updateBtchJsonDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.colorCode] forKey:@"colorCode"];
    
    NSDictionary *dict = @{
                           @"companyId":[HTShareClass shareClass].loginModel.companyId,
                           @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode],
                           @"colorCode":[HTHoldNullObj getValueWithUnCheakValue:self.inventoryModel.styleCode],
                           @"remarks":[HTHoldNullObj getValueWithUnCheakValue:self.descModel.desc],
                           @"updateBtchJson":[@[updateBtchJsonDic] arrayToJsonString],
                           @"sizeGroup":[sizeGroup componentsJoinedByString:@","],
                           @"loginName":[HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.person.name ],
                           @"targetCompanyId":[[self.selcetedDic getStringWithKey:@"childId"] isEqualToString:@"-1"] ? @"" :[self.selcetedDic getStringWithKey:@"childId"],
                           @"opMode":@"5",
                           @"swapType":[self.typeDic getStringWithKey:@"value"],
                           };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,saveSwapProductStockOut] params: dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调出成功" btTitle:@"确定" okBtclicked:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
        }else{
            [MBProgressHUD showError:[[json getStringWithKey:@"msg"] length] > 0 ? [json getStringWithKey:@"msg"] : @"调出失败" toView:self.view];
        }
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}

#pragma mark -private methods

-(void)loadCompanyInfo{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleHierarchy,loadAllChildCompany] params:dic success:^(id json) {
        self.companys = [json getArrayWithKey:@"data"];
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)makeData{
    if (self.sizeList.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.sizeList) {
            if (self.turnType == HTTurnOut ) {
                if ([dic getFloatWithKey:@"count"] > 0){
                    HTTuneOutorInModel *model = [[HTTuneOutorInModel alloc] init];
                    model.size = [dic getStringWithKey:@"size"];
                    model.maxCount = [dic getStringWithKey:@"count"];
                    [self.dataArray addObject:model];
                     [arr addObject:@"HTTurnInNumbersCell"];
                }
            }else{
                HTTuneOutorInModel *model = [[HTTuneOutorInModel alloc] init];
                model.size = [dic getStringWithKey:@"size"];
                model.maxCount = [dic getStringWithKey:@"count"];
                [self.dataArray addObject:model];
                 [arr addObject:@"HTTurnInNumbersCell"];
            }
           
        }
        [self.cellsName replaceObjectAtIndex:1 withObject:arr];
        [self.tab reloadData];
    }
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTProductInfoTableCell" bundle:nil] forCellReuseIdentifier:@"HTProductInfoTableCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTurnInNumbersCell" bundle:nil] forCellReuseIdentifier:@"HTTurnInNumbersCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTurnOutDiscountCell" bundle:nil] forCellReuseIdentifier:@"HTTurnOutDiscountCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTuneTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTuneTypeTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTDescTextViewCell" bundle:nil] forCellReuseIdentifier:@"HTDescTextViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTurnOutCompanyCell" bundle:nil] forCellReuseIdentifier:@"HTTurnOutCompanyCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
-(void)initSubs{
    if (self.turnType == HTTurnIn) {
        self.turnInBt.hidden = NO;
        self.turnOutBt.hidden = YES;
        self.turnOutOkBt.hidden = YES;
        self.tabBottomHeight.constant = 82 + SafeAreaBottomHeight;
        self.title = @"调入库存";
    }
    if (self.turnType == HTTurnOut) {
        self.turnInBt.hidden = YES;
        self.turnOutBt.hidden = NO;
        self.turnOutOkBt.hidden = NO;
        self.tabBottomHeight.constant = 48 + SafeAreaBottomHeight;
        [self loadCompanyInfo];
        self.title = @"调出库存";
    }
}
#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTProductInfoTableCell"]];
        [_cellsName addObject:@[]];
        if (self.turnType == HTTurnIn) {
          [_cellsName addObject:@[@"HTTuneTypeTableViewCell"]];
          [_cellsName addObject:@[@"HTTurnOutDiscountCell"]];
          [_cellsName addObject:@[@"HTDescTextViewCell"]];
        }
        if (self.turnType == HTTurnOut) {
            [_cellsName addObject:@[@"HTTurnOutCompanyCell",@"HTTuneTypeTableViewCell",@"HTDescTextViewCell"]];
        }
    }
    return _cellsName;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)typeDic{
    if (!_typeDic) {
        _typeDic = [NSMutableDictionary dictionary];
    }
    return _typeDic;
}
-(NSMutableDictionary *)dicountDic{
    if (!_dicountDic) {
        _dicountDic = [NSMutableDictionary dictionary];
    }
    return _dicountDic;
}
- (HTTuneOutOrInDescModel *)descModel{
    if (!_descModel) {
        _descModel = [[HTTuneOutOrInDescModel alloc] init];
    }
    return _descModel;
}
-(NSMutableDictionary *)selcetedDic{
    if (!_selcetedDic) {
        _selcetedDic = [NSMutableDictionary dictionary];
    }
    return _selcetedDic;
}
@end
