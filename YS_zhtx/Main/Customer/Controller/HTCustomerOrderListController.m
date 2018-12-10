//
//  HTCustomerOrderListController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomerOrderInfoCell.h"
#import "HTCustomerOrderListController.h"
#import "HTOrderListModel.h"
#import "HTMenuModle.h"
#import "HTOrderDetailViewController.h"
#import "HTHoldOrderEventManager.h"
@interface HTCustomerOrderListController ()<UITableViewDelegate,UITableViewDataSource,HTCustomerOrderInfoCellDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSString *moduleId;

@end

@implementation HTCustomerOrderListController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, -nav_height, HMSCREENWIDTH, nav_height)];
    vv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vv];
}

#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTCustomerOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerOrderInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTOrderListModel *model = self.dataArray[indexPath.row];
    HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
    vc.orderId = [HTHoldNullObj getValueWithUnCheakValue:model.orderId];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate
-(void)moreClickedWithCell:(HTCustomerOrderInfoCell *)cell{
    NSIndexPath *indexPath = [self.tab indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    NSMutableArray *tapArr = [NSMutableArray array];
    [tapArr addObject:@"详情"];
    [tapArr addObject:@"上传照片"];
    [tapArr addObject:@"退换货"];
    [tapArr addObject:@"定时提醒"];
    [tapArr addObject:@"打印小票"];
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:tapArr handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 0 ) {
        }else{
            NSString *title = tapArr[index - 1];
            if ([title isEqualToString:@"详情"]) {
                [HTHoldOrderEventManager seeOrderDetailWithOrderId:model.orderId];
            }
            if ([title isEqualToString:@"退换货"]) {
                [HTHoldOrderEventManager exchangeOrReturnOrderWithOrderId:model.orderId];
            }
            if ([title isEqualToString:@"定时提醒"]) {
                [HTHoldOrderEventManager addTimerForOrderWithOrderId:model.orderId];
            }
            if ([title isEqualToString:@"打印小票"]) {
                [HTHoldOrderEventManager printOrderInfoWithOrderId:model.orderId];
            }
            if ([title isEqualToString:@"上传照片"]) {
                [HTHoldOrderEventManager postImgsForOrderWithOrderId:model.orderId];
            }
        }
    }
     ];
    
}
-(void)timeClickedWithCell:(HTCustomerOrderInfoCell *)cell{
    NSIndexPath *indexPath = [self.tab indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    [HTHoldOrderEventManager addTimerForOrderWithOrderId:model.orderId];
}
-(void)exchangeClickedWithCell:(HTCustomerOrderInfoCell *)cell{
    NSIndexPath *indexPath = [self.tab indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    [HTHoldOrderEventManager exchangeOrReturnOrderWithOrderId:model.orderId];
}
-(void)printClickedWithCell:(HTCustomerOrderInfoCell *)cell{
    NSIndexPath *indexPath = [self.tab indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    [HTHoldOrderEventManager printOrderInfoWithOrderId:model.orderId];
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTCustomerOrderInfoCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerOrderInfoCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDataWithPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDataWithPage:self.page];
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    titleLabel.text = @"订单列表";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

-(void)loadDataWithPage:(int) page{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(page) forKey:@"pageNo"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.moduleId] forKey:@"moduleId"];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.custId] forKey:@"model.customerid"];
    [dic setObject:@"2" forKey:@"model.orderstatus"];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValuesForKeysWithDictionary:dic];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadOrderList] params:postDic success:^(id json) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTOrderListModel *model = [HTOrderListModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [self.tab reloadData];
    } error:^{
        self.page--;
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSString *)moduleId{
    if (!_moduleId) {
        for (HTMenuModle *model in [HTShareClass shareClass].menuArray) {
            if ([model.moduleName isEqualToString:@"order"]) {
                _moduleId = [model.moduleId stringValue];
            }
        }
    }
    return _moduleId;
}

@end
