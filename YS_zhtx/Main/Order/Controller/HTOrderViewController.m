//
//  YHOrderViewController.m
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
#import "HTOrderDetailViewController.h"
#import "HTOrderInfoViewCell.h"
#import "HTOrderViewController.h"
#import "HTOrderListModel.h"
#import "HTMenuModle.h"
#import "HTCustomerAuth.h"
#import "LPActionSheet.h"
#import "HTOrderSearchView.h"
#import "HTNoticeCenterViewController.h"
#import "HTHoldOrderEventManager.h"
#import "MainTabBarViewController.h"
#import "HTOnlineOrderInfoViewCell.h"
#import "HTOnlineOrderListModel.h"
#import "LPActionSheet.h"
#import "HTCustomTextAlertView.h"
#import "HTCheakOnlineOrderViewController.h"
@interface HTOrderViewController ()<UITableViewDelegate,UITableViewDataSource,HTOrderInfoViewCellDelegate,HTOrderSearchViewDelegate,HTOnlineOrderInfoViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataBottomHeight;
@property (nonatomic,assign) BOOL showImg;
@property (nonatomic,strong) HTMenuModle *moduleModel;

@property (nonatomic,strong) HTCustomerAuth *authModel;

@property (nonatomic,strong) NSString *sortType;

@property (nonatomic,strong) NSString *orderType;

@property (nonatomic,strong) NSString *onlinOrderState;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *searchDic;

@property (strong, nonatomic)  UISegmentedControl *topSegView;


@end

@implementation HTOrderViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSub];
    [self createHead];
    [self createTopSeg];
    [self createTb];
    [self getModlueId];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataTableView.mj_header beginRefreshing];
    [self laodNoRedNum];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.orderType isEqualToString:@"3"]) {
        HTOnlineOrderInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOnlineOrderInfoViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
        cell.delegate = self;
        cell.orderState = self.onlinOrderState;
        cell.onlineModel = self.dataArray[indexPath.row];
        return cell;
    }else{
    HTOrderInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderInfoViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showImg = self.showImg;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.orderType isEqualToString:@"3"]) {
        HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
        HTOnlineOrderListModel *model = self.dataArray[indexPath.row];
        vc.orderId = model.orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    vc.orderId = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -CustomDelegate

-(void)cancelOrderClick:(HTOnlineOrderInfoViewCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    HTOnlineOrderListModel *model = self.dataArray[indexPath.row];
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"缺货",@"店铺交易",@"其他"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            [self cancelUnliceOrderWithStr:@"缺货" andOrderId:[HTHoldNullObj getValueWithUnCheakValue:model.orderId]];
        }else if (index == 2){
            [self cancelUnliceOrderWithStr:@"店铺交易" andOrderId:[HTHoldNullObj getValueWithUnCheakValue:model.orderId]];
        }else if (index == 3){
            [HTCustomTextAlertView showAlertWithTitle:@"其他原因" holdTitle:@"请备注其他原因" orTextString:nil okBtclicked:^(NSString *text) {
                [self cancelUnliceOrderWithStr:[HTHoldNullObj getValueWithUnCheakValue:text] andOrderId:[HTHoldNullObj getValueWithUnCheakValue:model.orderId]];
            } andCancleBtClicked:^{
            }];
        }
    }];
}
-(void)startSendOrderClick:(HTOnlineOrderInfoViewCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    HTOnlineOrderListModel *model = self.dataArray[indexPath.row];
    HTCheakOnlineOrderViewController *vc = [[HTCheakOnlineOrderViewController alloc] init];
    vc.orderId = [HTHoldNullObj getValueWithUnCheakValue:model.orderId];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)moreClickedWithCell:(HTOrderInfoViewCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    NSMutableArray *tapArr = [NSMutableArray array];
    [tapArr addObject:@"详情"];
    [tapArr addObject:@"上传照片"];
    if (self.authModel.timer) {
        [tapArr addObject:@"定时提醒"];
    }
    [tapArr addObject:@"打印小票"];
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:tapArr handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 0 ) {
        }else{
            NSString *title = tapArr[index - 1];
            if ([title isEqualToString:@"详情"]) {
                [HTHoldOrderEventManager seeOrderDetailWithOrderId:model.orderId];
            }
            if ([title isEqualToString:@"退换货"]) {
                if ([model.paytype isEqualToString:@"组合支付"]) {
                    [MBProgressHUD showError:@"APP端暂不支付组合支付的退换货，\n请到PC进行组合支付的退换"];
                    return;
                }
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
-(void)timeClickedWithCell:(HTOrderInfoViewCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    [HTHoldOrderEventManager addTimerForOrderWithOrderId:model.orderId];
}
-(void)exchangeClickedWithCell:(HTOrderInfoViewCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    if ([model.paytype isEqualToString:@"组合支付"]) {
        [MBProgressHUD showError:@"APP端暂不支付组合支付的退换货，\n请到PC进行组合支付的退换"];
        return;
    }
    [HTHoldOrderEventManager exchangeOrReturnOrderWithOrderId:model.orderId];
}
-(void)printClickedWithCell:(HTOrderInfoViewCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    HTOrderListModel *model = self.dataArray[indexPath.row];
    [HTHoldOrderEventManager printOrderInfoWithOrderId:model.orderId];
}
-(void)searchOkBtClicked{
    [self.dataTableView.mj_header beginRefreshing];
}
#pragma mark -EventResponse
-(void)topSegmentChange:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        self.onlinOrderState = @"0";
    }else if (sender.selectedSegmentIndex == 1){
        self.onlinOrderState = @"3";
    }else if (sender.selectedSegmentIndex == 2){
        self.onlinOrderState = @"1";
    }
    self.orderType = @"3";
}
-(void)segmentChange:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
         self.topSegView.hidden = YES;
        self.orderType = @"1";
    }else if (sender.selectedSegmentIndex == 1){
        self.topSegView.hidden = YES;
        self.orderType = @"2";
    }else if (sender.selectedSegmentIndex == 2){
        self.topSegView.hidden = NO;
        self.orderType = @"3";
        if (self.onlinOrderState.length == 0) {
          self.onlinOrderState = @"0";
        }
    }
}
- (IBAction)topBtClicked:(id)sender {
    UIButton *bt = (UIButton *)sender;
    NSArray * nomorlImg =  @[@"g-orderDown",@"g-orderDown",@"g-orderImg",@"order_saixuan"];
    NSArray * nomorlSelectedImg =  @[ @"g-orderUpSelected",@"g-orderUpSelected",@"g-orderImgselected",@"order_saixuan"];
    UIImageView *imgeView = [self.view viewWithTag:bt.tag + 100];
    
    if (bt.tag == 503) {
        [HTOrderSearchView showSearchViewInViewDelegate:self andSearchDic:self.searchDic];
        return;
    }
    if (bt.tag == 502) {
        bt.selected = !bt.selected;
        self.showImg = bt.selected;
        if (bt.selected) {
            imgeView.image = [UIImage imageNamed:nomorlSelectedImg[bt.tag - 500]];
        }else{
            imgeView.image = [UIImage imageNamed:nomorlImg[bt.tag - 500]];
        }
        [self.dataTableView reloadData];
      
    }
    if (bt.tag == 500) {
        UIButton *bt1 = [self.view viewWithTag:501];
        bt1.selected = NO;
        UIImageView *btimg = (id)[self.view viewWithTag:601];
        btimg.image = [UIImage imageNamed:nomorlImg[1]];
        UIImageView *img1 = [self.view viewWithTag:600];
        if (bt.selected) {
//            时间选中状态 来调整 降序或升序
            if ([self.sortType isEqualToString:@"1"]) {
//                当前状态为降序，改为升序
                img1.image = [UIImage imageNamed:@"g-orderUpSelected"];
                self.sortType = @"2";
            }else if ([self.sortType isEqualToString:@"2"]) {
//                当前状态为升序，改为降序
                img1.image = [UIImage imageNamed:@"g-orderDownSelected"];
                self.sortType = @"1";
            }
        }else{
            bt.selected = YES;
            img1.image = [UIImage imageNamed:@"g-orderDownSelected"];
            self.sortType = @"1";
        }
    }
    if (bt.tag == 501) {
        UIButton *bt1 = [self.view viewWithTag:500];
        bt1.selected = NO;
        UIImageView *btimg = (id)[self.view viewWithTag:600];
        btimg.image = [UIImage imageNamed:nomorlImg[0]];
        UIImageView *img1 = [self.view viewWithTag:601];
        if (bt.selected) {
        //            金额选中状态 来调整 降序或升序
        if ([self.sortType isEqualToString:@"3"]) {
            //                当前状态为降序，改为升序
            img1.image = [UIImage imageNamed:@"g-orderUpSelected"];
            self.sortType = @"4";
        }else if ([self.sortType isEqualToString:@"4"]) {
            //                当前状态为升序，改为降序
            img1.image = [UIImage imageNamed:@"g-orderDownSelected"];
            self.sortType = @"3";
        }
    }else{
        bt.selected = YES;
        img1.image = [UIImage imageNamed:@"g-orderDownSelected"];
        self.sortType = @"3";
      }
    }
}
#pragma mark -private methods
-(void)cancelUnliceOrderWithStr:(NSString *)reson andOrderId:(NSString *)orderId{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:orderId],
                          @"reason":[HTHoldNullObj getValueWithUnCheakValue:reson],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,apiStoreOrder,orderRefundWechate4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"0"]) {
            [MBProgressHUD showError:[json getStringWithKey:@"msg"]];
        }else{
            [MBProgressHUD showSuccess:@"取消成功"];
            [self.dataTableView.mj_header beginRefreshing];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)createSub{
    self.showImg = YES;
    UIButton *imgBt = [self.view viewWithTag:502];
    imgBt.selected = YES;
    UIImageView *imgeView = [self.view viewWithTag:imgBt.tag + 100];
    imgeView.image = [UIImage imageNamed:@"g-orderImgselected"];
    
    UIButton *timeBt = [self.view viewWithTag:500];
    timeBt.selected = YES;
    timeBt.selected = YES;
    self.sortType = @"1";
    UIImageView *imgeView1 = [self.view viewWithTag:timeBt.tag + 100];
    imgeView1.image = [UIImage imageNamed:@"g-orderDownSelected"];
}
- (void)createTb{
    self.backImg = @"";
    
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTOrderInfoViewCell" bundle:nil] forCellReuseIdentifier:@"HTOrderInfoViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTOnlineOrderInfoViewCell" bundle:nil] forCellReuseIdentifier:@"HTOnlineOrderInfoViewCell"];
    
    self.dataTableView.backgroundColor = [UIColor clearColor];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    self.dataBottomHeight.constant = SafeAreaBottomHeight + tar_height;
    self.dataTableView.estimatedRowHeight = 300;
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        if ([self.orderType isEqualToString:@"3"]) {
         [self loadOnlineDataWithPage:self.page];
        }else{
         [self loadDataWithPage:self.page];
        }
    }];
    self.dataTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        if ([self.orderType isEqualToString:@"3"]) {
          [self loadOnlineDataWithPage:self.page];
        }else{
          [self loadDataWithPage:self.page];
        }
    }];
}
-(void)createHead{
    NSArray * segArr = @[@"订单列表",@"退货订单",@"在线订单"];
    UISegmentedControl *titleSegment = [[UISegmentedControl alloc] initWithItems:segArr];
    titleSegment.frame = CGRectMake(0, 0,HMSCREENWIDTH *3 /4  , 44);
    titleSegment.selectedSegmentIndex = 0 ;
    titleSegment.tintColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"222222"],
                         NSForegroundColorAttributeName,
                         [UIFont systemFontOfSize:16],
                         NSFontAttributeName,nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#999999"],
                          NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:14],
                          NSFontAttributeName,nil];
    [ titleSegment setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    [ titleSegment setTitleTextAttributes:dic forState:UIControlStateSelected];
    [titleSegment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    bv.backgroundColor = [UIColor clearColor];
    [bv addSubview:titleSegment];
    self.navigationItem.titleView = bv;
}
-(void)createTopSeg{
    NSArray * segArr = @[@"未发货订单",@"已取消订单",@"已发货订单"];
    UISegmentedControl *titleSegment = [[UISegmentedControl alloc] initWithItems:segArr];
    titleSegment.frame = CGRectMake(0, 0, HMSCREENWIDTH  , 48);
    titleSegment.selectedSegmentIndex = 0 ;
    titleSegment.tintColor = [UIColor whiteColor];
    titleSegment.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"222222"],
                         NSForegroundColorAttributeName,
                         [UIFont systemFontOfSize:16],
                         NSFontAttributeName,nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#999999"],
                          NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:14],
                          NSFontAttributeName,nil];
    [ titleSegment setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    [ titleSegment setTitleTextAttributes:dic forState:UIControlStateSelected];
    [titleSegment addTarget:self action:@selector(topSegmentChange:) forControlEvents:UIControlEventValueChanged];
    self.topSegView = titleSegment;
    [self.view addSubview:self.topSegView];
    self.topSegView.hidden = YES;
}

-(void)loadOnlineDataWithPage:(int)page{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(page) forKey:@"pageNo"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setObject:@"2" forKey:@"orderType"];
    if (![self.onlinOrderState isEqualToString:@"3"]) {
       [dic setObject:self.onlinOrderState forKey:@"isDelivery"];
    }else{
       [dic setObject:@"5,3" forKey:@"orderStatus"];
    }

    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,loadOnlineOrdersByTypeDelivery] params:dic success:^(id json) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTOnlineOrderListModel *model = [HTOnlineOrderListModel yy_modelWithJSON:dic];
            
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_footer endRefreshing];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView reloadData];
    } error:^{
        self.page--;
        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_footer endRefreshing];
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_footer endRefreshing];
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)loadDataWithPage:(int) page{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(page) forKey:@"pageNo"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId] forKey:@"moduleId"];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setObject:self.sortType.length == 0 ? @"1" : self.sortType forKey:@"sortType"];
    [dic setObject:self.orderType.length == 0 ? @"1" : self.orderType forKey:@"orderType"];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValuesForKeysWithDictionary:dic];
    [postDic setValuesForKeysWithDictionary:self.searchDic];
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadOrderList] params:postDic success:^(id json) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTOrderListModel *model = [HTOrderListModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_footer endRefreshing];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView reloadData];
    } error:^{
        self.page--;
        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_footer endRefreshing];
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_footer endRefreshing];
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)getModlueId{
    if ([HTShareClass shareClass].menuArray.count > 0) {
        for (HTMenuModle *model in [HTShareClass shareClass].menuArray) {
            if ([model.moduleName isEqualToString:@"order"]) {
                self.moduleModel = model;
                break;
            }
        }
        [self loadAuth];
    }else{
        NSDictionary *dic = @{
                              @"companyId" : [HTShareClass shareClass].loginModel.companyId
                              };
        NSMutableArray *_dataArray = [NSMutableArray array];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadMenu] params:dic success:^(id json) {
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSDictionary *dic in json[@"data"][@"menu"]) {
                
                HTMenuModle *model = [[HTMenuModle alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
                [_dataArray addObject:model];
            }
            [HTShareClass shareClass].menuArray = arr;
            [self getModlueId];
        } error:^{
        } failure:^(NSError *error) {
        }];
    }
}
-(void)loadAuth{
    NSDictionary *dic = @{
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadModuleAuth] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.authModel = [HTCustomerAuth yy_modelWithJSON:[json[@"data"] getDictionArrayWithKey:@"moduleAuthorityRule"]];
        [self.dataTableView.mj_header beginRefreshing];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
- (void)laodNoRedNum{
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    __weak typeof(self) weakSelf = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        __weak typeof(weakSelf) strongSelf  = weakSelf;
        if (json[@"data"][@"count"]) {
            MainTabBarViewController *tab = (id)[[UIApplication sharedApplication].delegate window].rootViewController;
            [tab.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}

#pragma mark - getters and setters
-(void)setSortType:(NSString *)sortType{
    _sortType = sortType;
    [self.dataTableView.mj_header beginRefreshing];
}
-(void)setOrderType:(NSString *)orderType{
    _orderType = orderType;
    [self.dataTableView.mj_header beginRefreshing];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)searchDic{
    if (!_searchDic) {
        _searchDic = [NSMutableDictionary dictionary];
    }
    return _searchDic;
}


@end
