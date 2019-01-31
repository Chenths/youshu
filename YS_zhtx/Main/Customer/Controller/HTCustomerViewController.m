

//
//  YHInventoryViewController.m
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
#import "HTCustomerViewController.h"
#import "HTCustomerFiltrateBoxView.h"
#import "HTFiltrateNodeModel.h"
#import "HTFiltrateHeaderModel.h"
#import "HTNewCustomCustomerCell.h"
#import "HTCustomSearchView.h"
#import "HTCustomerTapMoreController.h"
#import "HTCustomerReportViewController.h"
#import "HTStoreMoneyViewController.h"
#import "Poper.h"
#import "HTMenuModle.h"
#import "HTCustomerListModel.h"
#import "HTCustomerAuth.h"
#import "HTAddVipWithPhoneController.h"
#import "HTEditVipViewController.h"
#import "HTNoticeCenterViewController.h"
#import "HTHoldCustomerEventManger.h"
#import "MainTabBarViewController.h"
#import "HTChargeViewController.h"
#import "HTFastCashierViewController.h"
@interface HTCustomerViewController()<HTCustomerFiltrateBoxViewDelegate,UITableViewDelegate,UITableViewDataSource,HTCustomSearchViewDelegate,HTNewCustomCustomerCellDelegate,HTCustomerTapMoreControllerDelegate,UITabBarControllerDelegate>{
    Poper  *poper;
    NSMutableArray * tapArr;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table;

@property (nonatomic,strong) HTMenuModle *moduleModel;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) HTCustomerAuth *authModel;

@property (nonatomic,strong) NSString *sortType;

@property (nonatomic,strong) NSMutableDictionary *requstDic;

@property (nonatomic,strong)  HTCustomerFiltrateBoxView *FiltrateBoxView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTabHeight;




@property (assign,nonatomic) BOOL isselected;

@end

@implementation HTCustomerViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    [self createTb];
    [self createBox];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[MainTabBarViewController class]]) {
        [self  laodNoRedNum];
    }
    if (self.backImg.length > 0) {
        UIView *headVvv = [[UIView alloc] initWithFrame:CGRectMake(0, -nav_height, HMSCREENWIDTH, nav_height)];
        headVvv.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headVvv];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_FiltrateBoxView tapCoverView];
    if (!self.isselected) {
        if (self.searchCustItme) {
            self.searchCustItme([[HTCustomerListModel alloc] init]);
        }
    }
   
}
#pragma mark -UITabelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HTNewCustomCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewCustomCustomerCell" forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchCustItme) {
        self.isselected = YES;
        self.searchCustItme(self.dataArray[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        vc.customerType = HTCustomerReportTypeNomal;
        vc.model = self.dataArray[indexPath.row];
        vc.authModel = self.authModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -CustomDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav = (id)viewController;
    if ([nav.topViewController isKindOfClass:[self class]]) {
        if (self.FiltrateBoxView) {
            [self.FiltrateBoxView removeFromSuperview];
            [self createBox];
            self.requstDic = nil;
            self.sortType = nil;
        }
    }
}
-(void)searchOkBtClicked{
    [self.dataTableView.mj_header beginRefreshing];
}
-(void)FiltrateBoxDidSelectedInSection:(NSInteger)section andRow:(NSInteger)row withHeadModel:(HTFiltrateHeaderModel *)model{
    HTFiltrateNodeModel *node = model.titles[row];
    if (section == 0) {
        self.sortType = node.sortType;
    }else{
        [self.requstDic setObject:node.searchValue forKey:node.searchKey];
    }
    [self.dataTableView.mj_header beginRefreshing];
}
-(void)searchBtClicked{
    [HTCustomSearchView showSearchViewInViewDelegate:self andSearchDic:self.requstDic];
}
-(void)moreClickedOrderWithCell:(HTNewCustomCustomerCell *)cell{
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    if (!tapArr) {
        tapArr = [NSMutableArray array];
    }else{
        [tapArr removeAllObjects];
    }
    HTCustomerListModel *model = self.dataArray[indexPath.row];
    
    if (![HTShareClass shareClass].hideVIPPhone) {
        [tapArr addObject:@"电话"];
    }
    
    [tapArr addObject:@"账单"];
    
    if ([HTHoldNullObj getValueWithUnCheakValue:model.openid].length > 0) {
       [tapArr addObject:@"聊天"];
    }
    if ([[HTHoldNullObj getValueWithUnCheakValue:model.isedit] isEqualToString:@"1"] && self.authModel.edit) {
        [tapArr addObject:@"编辑"];
    }
    
    if (self.authModel.topUp) {
       [tapArr  addObject:@"充值"];
    }
    if (self.authModel.deduct) {
      [tapArr  addObject:@"扣除"];
    }
    if (self.authModel.timer) {
      [tapArr addObject:@"定时提醒"];
    }
    
    [tapArr addObject:@"快速下单"];
    
    NSInteger i = tapArr.count % 3 > 0 ? tapArr.count / 3 + 1 : tapArr.count / 3;
    CGFloat height = 90 + (HMSCREENWIDTH / 3) * i;
    poper                     = [[Poper alloc] init];
    poper.frame               = CGRectMake(0 , HEIGHT - height, HMSCREENWIDTH,height);
    //点击蒙板时的操作
    HTCustomerTapMoreController *vc  = [[HTCustomerTapMoreController alloc] init];
    vc.transitioningDelegate  = poper;
    vc.modalPresentationStyle =  UIModalPresentationCustom;
    vc.view.frame = CGRectMake(0 , HEIGHT - height, HMSCREENWIDTH,height);
    vc.dataArray = tapArr;
    vc.index  = indexPath.row;
    vc.delegate = self;
    vc.model = model;
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)didTapWithString:(NSString *)tapKey andIndex:(NSInteger)index{
    HTCustomerListModel *model = self.dataArray[index];
    if ([tapKey isEqualToString:@"充值"]) {
        [HTHoldCustomerEventManger storedForCustomerWithCustomerPhone:[HTHoldNullObj getValueWithUnCheakValue:model.phone_cust]];
    }else if ([tapKey isEqualToString:@"扣除"]) {
        [HTHoldCustomerEventManger deduedForCustomerWithCustomerPhone:[HTHoldNullObj getValueWithUnCheakValue:model.phone_cust]];
    }else if ([tapKey isEqualToString:@"编辑"]) {
        [HTHoldCustomerEventManger editCustomerWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:model.custId]];
    }else if ([tapKey isEqualToString:@"定时提醒"]) {
        [HTHoldCustomerEventManger addTimerForCustomerWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:model.custId]];
    }else if ([tapKey isEqualToString:@"账单"]){
        HTCustModel *model1 = [[HTCustModel alloc] init];
        model1.nickname = model.name;
        model1.headImg = model.headimg;
        [HTHoldCustomerEventManger lookCustomerBillListWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:model.custId] andCustModel:model1];
    }else if ([tapKey isEqualToString:@"聊天"]){
        [HTHoldCustomerEventManger chatWithCustomerWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:model.custId] customerName:model.name  andOpenId:[HTHoldNullObj getValueWithUnCheakValue:model.openid]];
    }else if ([tapKey isEqualToString:@"快速下单"]){
        if ([HTShareClass shareClass].isProductActive) {
            HTChargeViewController *vc = [[HTChargeViewController alloc] init];
            vc.customerId = model.custId;
            vc.phone = model.phone_cust;
            [self.navigationController  pushViewController:vc animated:YES];
        }else{
            HTFastCashierViewController *vc = [[HTFastCashierViewController alloc] init];
            vc.customerid = model.custId;
            vc.phone = model.phone_cust;
            [self.navigationController  pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -EventResponse
-(void)addVipClicked:(UIButton *)sender{
    HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
    vc.moduleId = [HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -private methods

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

-(void)getModlueId{
    if ([HTShareClass shareClass].menuArray.count > 0) {
        for (HTMenuModle *model in [HTShareClass shareClass].menuArray) {
            if ([model.moduleName isEqualToString:@"customer"]) {
                self.moduleModel = model;
                break;
            }
        }
        [self loadAuth];
    }else{
        NSDictionary *dic = @{
                              @"companyId" : self.companyId
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
-(void)loadRequsetDataWithPage:(int) page{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.sendDic.allKeys.count > 0) {
      [dic setValuesForKeysWithDictionary:self.sendDic];
    }
    [dic setObject:@(page) forKey:@"pageNo"];
    [dic setObject:@(10) forKey:@"pageSize"];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCusRepott,loadCustomerCriteriaReport] params:dic success:^(id json) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
            HTCustomerListModel *model = [HTCustomerListModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        [self.dataTableView reloadData];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
    } error:^{
        self.page--;
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD showError:NETERRORSTRING];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
    }];
}

-(void)loadDataWithPage:(int )page{
    NSDictionary *dic = @{
                          @"sortType":self.sortType,
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleModel.moduleId],
                          @"pageNo":@(page),
                          @"pageSize":@"10",
                          @"companyId":self.companyId
                          };
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValuesForKeysWithDictionary:dic];
    [postDic setValuesForKeysWithDictionary:self.requstDic];
   
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadCustomerList] params:postDic success:^(id json) {
        if (json[@"data"][@"isShare"]) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"isShare"] forKey:@"isShare"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTCustomerListModel *model = [HTCustomerListModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        self.navigationItem.title = [NSString stringWithFormat:@"客户(%@位)",[json[@"data"] getStringWithKey:@"total"]];
        [self.dataTableView reloadData];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
    } error:^{
        self.page--;
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD showError:NETERRORSTRING];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
    }];
}
- (void)createTb{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    if (self.backImg.length == 0) {
      self.backImg = @"";
    }
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewCustomCustomerCell" bundle:nil] forCellReuseIdentifier:@"HTNewCustomCustomerCell"];
    self.dataTableView.backgroundColor = [UIColor clearColor];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    if ([HTShareClass shareClass].getCurrentNavController.viewControllers.count > 1) {
        self.table.constant =  SafeAreaBottomHeight;
    }else{
        self.table.constant =  tar_height + SafeAreaBottomHeight;
    }
    
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        if (self.sendDic.allKeys.count > 0) {
          [self loadRequsetDataWithPage:self.page];
        }else{
          [self loadDataWithPage:self.page];
        }
    }];
    self.dataTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        if (self.sendDic.allKeys.count > 0) {
            [self loadRequsetDataWithPage:self.page];
        }else{
            [self loadDataWithPage:self.page];
        }
    }];
    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[MainTabBarViewController class]]) {
        MainTabBarViewController *tab = (id)[[UIApplication sharedApplication].delegate window].rootViewController;
      self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:tab.rightBt],[UIBarButtonItem itemWithImageName:@"g-goodsAdd" highImageName:@"g-goodsAdd" target:self action:@selector(addVipClicked:)]];
    }else{
       self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-goodsAdd" highImageName:@"g-goodsAdd" target:self action:@selector(addVipClicked:)];
    }
}
-(void)createBox{
    if (self.sendDic.allKeys.count > 0) {
        self.topTabHeight.constant = 0.0f;
        self.FiltrateBoxView.hidden = YES;
        [self getModlueId];
        return;
    }else{
        self.topTabHeight.constant = 48.0f;
        self.FiltrateBoxView.hidden = NO;
    }
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadCompanyCustLevel] params:@{@"companyId":[HTShareClass shareClass].loginModel.companyId} success:^(id json) {
        
        self.FiltrateBoxView = [[HTCustomerFiltrateBoxView alloc] initWithBoxFrame:CGRectMake(0, 0, HMSCREENWIDTH, 48)];
        self.FiltrateBoxView.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.FiltrateBoxView];
        });
        
        HTFiltrateHeaderModel *m = [[HTFiltrateHeaderModel alloc] init];
        NSArray *title = @[@"生日日期升序",@"创建日期降序",@"创建日期升序"];
        NSArray *sortTypes = @[@"1",@"3",@"2"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < title.count; i++) {
            HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
            model.isSelected = i == 0 ? YES : NO;
            model.title = title[i];
            model.sortType = sortTypes[i];
            [arr addObject:model];
        }
        m.titles = arr;
        m.filtrateStyle = HTFiltrateStyleTableview;
        
        HTFiltrateHeaderModel *m1 = [[HTFiltrateHeaderModel alloc] init];
        NSArray *title1 = @[@"全部",@"男",@"女"];
        NSArray *values = @[@"",@"1",@"0"];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i < title1.count; i++) {
            HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
            model.isSelected = i == 0 ? YES : NO;
            model.title = title1[i];
            model.searchKey = @"model.sex_cust";
            model.searchValue = values[i];
            [arr1 addObject:model];
        }
        m1.titles = arr1;
        m1.filtrateStyle = HTFiltrateStyleCollection;
        
        HTFiltrateHeaderModel *m2 = [[HTFiltrateHeaderModel alloc] init];
        NSMutableArray *title2 = [NSMutableArray array];
        NSMutableArray *valuess = [NSMutableArray array];
        [title2 addObject:@"全部"];
        [valuess addObject:@""];
        for (NSDictionary *dddd in json[@"data"]) {
            [title2 addObject:[dddd getStringWithKey:@"name"]];
            [valuess addObject:[dddd getStringWithKey:@"id"]];
        }
        NSMutableArray *arr2 = [NSMutableArray array];
        for (int i = 0; i < title2.count; i++) {
            HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
            model.isSelected = i == 0 ? YES : NO;
            model.title = title2[i];
            model.searchKey = @"custLevel";
            model.searchValue = valuess[i];
            [arr2 addObject:model];
        }
        m2.titles = arr2;
        m2.filtrateStyle = HTFiltrateStyleCollection;
        self.FiltrateBoxView.dataArray = @[m,m1,m2];
        [self getModlueId];
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
- (void)laodNoRedNum{
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":self.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSString *)sortType{
    if (_sortType.length == 0) {
        return @"3";
    }
    return _sortType;
}
-(NSMutableDictionary *)requstDic{
    if (!_requstDic) {
        _requstDic = [NSMutableDictionary dictionary];
    }
    return _requstDic;
}
-(NSDictionary *)sendDic{
    if (!_sendDic) {
        _sendDic = [NSDictionary dictionary];
    }
    return _sendDic;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}
@end
