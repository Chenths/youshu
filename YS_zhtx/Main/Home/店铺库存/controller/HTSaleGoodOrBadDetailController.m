//
//  HTSaleGoodOrBadDetailController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPruductDetailHistoryModel.h"
#import "HTSaleGoodOrBadDetailController.h"
#import "HTProductHistoryCell.h"
#import "HTGuiderSaleInfoCell.h"
#import "HTOrderDetailViewController.h"
#import "HTTurnListDescInfoController.h"
#import "HTTuneOutOrInController.h"
#import "HTStyleInventoryModel.h"

@interface HTSaleGoodOrBadDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) int page;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet UIButton *turnIn;
@property (weak, nonatomic) IBOutlet UIButton *turnOut;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HTPruductDetailHistoryModel *productModel;


@end

@implementation HTSaleGoodOrBadDetailController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self createTb];
    [self.tab.mj_header beginRefreshing];
    if (self.model) {
        self.title = [NSString stringWithFormat:@"%@ %@",self.model.styleCode,[HTHoldNullObj getValueWithUnCheakValue:self.model.color]];
    }
    if (self.barcode) {
        self.title = self.barcode;
    }
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTProductHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductHistoryCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.productModel;
        return cell;
    }else{
        HTGuiderSaleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTGuiderSaleInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = self.dataArray[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 :  20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSDictionary *dataDic = self.dataArray[indexPath.row];
        NSString *mesId = [dataDic getStringWithKey:@"messageId"];
        NSString *orderId = [dataDic getStringWithKey:@"orderId"];
        NSString *optType = [dataDic getStringWithKey:@"optType"];
        if (orderId.length > 0 ) {
            
            if ([[HTShareClass shareClass].loginModel.company[@"type"] isEqualToString:@"BOSS"] ||[[HTShareClass shareClass].loginModel.company[@"type"] isEqualToString:@"AGENT"]) {
                [MBProgressHUD showError:@"请登陆该店铺查看详情"];
                return;
            }
            HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
            vc.orderId = orderId;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (mesId.length > 0 && ![optType isEqualToString:@"12"]) {
            HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
            vc.noticeId = mesId;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else if(mesId.length > 0 && [optType isEqualToString:@"12"]){
            HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
            vc.noticeId = mesId;
            vc.title = @"盘点确认";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 :  self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.productModel.productInfo.allKeys.count == 0 ? 0 : 2;
}

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)turnOutClicked:(id)sender {
    
   
    HTTuneOutOrInController *vc = [[HTTuneOutOrInController alloc] init];
    vc.turnType = HTTurnOut;
    HTStyleInventoryModel *model = [HTStyleInventoryModel yy_modelWithJSON:self.productModel.productInfo];
    HTStockInfoModel *mmm = [model.stock firstObject];
    model.colorCode = mmm.colorCode;
    model.color = mmm.color;
    vc.sizeList = mmm.sizeList;
    vc.inventoryModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)turnInClicked:(id)sender {
    HTTuneOutOrInController *vc = [[HTTuneOutOrInController alloc] init];
    vc.turnType = HTTurnIn;
    HTStyleInventoryModel *model = [HTStyleInventoryModel yy_modelWithJSON:self.productModel.productInfo];
    HTStockInfoModel *mmm = [model.stock firstObject];
    model.colorCode = mmm.colorCode;
    model.color = mmm.color;
    vc.sizeList = mmm.sizeList;
    vc.inventoryModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -private methods
-(void)loadDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"companyId":self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                          @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.model.styleCode],
                          @"colorCode":[HTHoldNullObj getValueWithUnCheakValue:self.model.colorCode],
                          @"pageSize":@"10",
                          @"pageNo":@(page),
                          @"barCode": self.barcode.length == 0 ? @"" : self.barcode,
                          };
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl, self.barcode ?  @"admin/api/product_stock/load_all_stock_change_detail_4_app.html" : @"admin/api/product_stock/load_product_sale_cycle_detail_4_app.html"] params:dic success:^(id json) {
        [self.productModel setValuesForKeysWithDictionary:[json getDictionArrayWithKey:@"data"]];
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            [self.dataArray addObject:dic];
        }
        [self.tab reloadData];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        } error:^{
        [MBProgressHUD showError:SeverERRORSTRING];
        self.page = self.page == 1 ? 1 : self.page--;
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查你的网络"];
        self.page = self.page == 1 ? 1:self.page--;
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    }];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTProductHistoryCell" bundle:nil] forCellReuseIdentifier:@"HTProductHistoryCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTGuiderSaleInfoCell" bundle:nil] forCellReuseIdentifier:@"HTGuiderSaleInfoCell"];
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = vvv;
    self.tab.estimatedRowHeight = 300;
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDataWithPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDataWithPage:self.page];
    }];
}
#pragma mark - getters and setters
-(HTPruductDetailHistoryModel *)productModel{
    if (!_productModel) {
        _productModel = [[HTPruductDetailHistoryModel alloc] init];
    }
    return _productModel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
