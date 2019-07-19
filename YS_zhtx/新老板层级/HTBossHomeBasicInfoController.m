//
//  HTBossHomeBasicInfoController.m
//  有术
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossHomeBasicInfoController.h"
#import "HTBossInfoHeaderCell.h"
#import "HTShopInfoCell.h"
#import "HTSingleShopDataModel.h"
#import "HTAgentStoreSectionHead.h"
#import "HTHomePageViewController.h"
//#import "HTSearchShopsController.h"
#import "MJRefresh.h"
#import "HTAgencyMainDataModel.h"
//#import "HTShopInfoViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HTRightNavBar.h"
//#import "HTTotleMessgeViewController.h"
#import "HTMsgCenterViewController.h"
#import "HTBossSaleDescViewController.h"
#import "HTBossSaleDescinfoCell.h"
#import "HTSearchTextHeadView.h"
#import "HTBossHomeHeaderSegmentTableViewCell.h"
@interface HTBossHomeBasicInfoController ()<UITableViewDelegate,UITableViewDataSource,HTSearchTextHeadViewDelegat, HTBossHomeSegmenDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *shopsArray;
@property (nonatomic,strong) HTAgencyMainDataModel *headModel;
@property (nonatomic,strong) HTRightNavBar *rightBt ;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger pageNo;
//1 本日 2 月 3年
@property (nonatomic,assign) NSInteger timeType;
@property (nonatomic, strong) UIButton *homeBtn;
@end

@implementation HTBossHomeBasicInfoController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self createRightNavBar];
    
    _pageNo = 1;
    _timeType = 1;
    [self.myTableView.mj_header beginRefreshing];
}

- (void)creatButton{
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _homeBtn.frame = CGRectMake(HMSCREENWIDTH - 48 - 16, HEIGHT - 150 - 48, 48, 48);
    [_homeBtn setImage:[UIImage imageNamed:@"bossHome"] forState:UIControlStateNormal];
    [_homeBtn addTarget:self action:@selector(sortAction) forControlEvents:UIControlEventTouchUpInside];
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:_homeBtn];
}

- (void)sortAction{
    NSLog(@"开始排序");
    //临时处理 因为已经干掉了筛选店铺功能
    self.shopsArray = [NSMutableArray arrayWithArray:self.dataArray];
    if (self.dataArray.count <= 0) {
        return;
    }
    
    for (int i = 0; i < _dataArray.count; i++) {
        for (int j = i+1; j < _dataArray.count; j++) {
            HTSingleShopDataModel *model1 = _dataArray[i];
            HTSingleShopDataModel *model2 = _dataArray[j];
            if ([model1.salesAmount intValue] < [model2.salesAmount intValue]) {
                [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    [_myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_homeBtn removeFromSuperview];
    _homeBtn = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = [HTShareClass shareClass].loginModel.company[@"fullname"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#6A82FB"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    self.navigationController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#ffffff"];
    [self laodNoRedNum];
    [self creatButton];
}
#pragma customDelegate
- (void)segmentControlValueChangedDelegate:(NSInteger)index
{
    _timeType = index;
    _pageNo = 1;
    [self loadHeaderData];
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HTBossHomeHeaderSegmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossHomeHeaderSegmentTableViewCell" forIndexPath:indexPath];
            if (_timeType == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (_timeType == 2){
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width,0,0);
            cell.delegate = self;
            return cell;
        }else{
            HTBossInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossInfoHeaderCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width,0,0);
            cell.timeType = self.timeType;
            if (self.headModel) {
                cell.model = self.headModel;
            }
            if (_timeType == 1) {
                cell.whiteArrowImv.hidden = YES;
            }else if (_timeType == 2){
                cell.whiteArrowImv.hidden = NO;
            }else{
                cell.whiteArrowImv.hidden = NO;
            }
            return cell;
        }
    
//        if (indexPath.row == 0) {
    
//        }else{
//            HTBossSaleDescinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleDescinfoCell" forIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (self.headModel) {
//                cell.title = indexPath.row == 1 ? @"本月" : @"本年";
//                cell.model = self.headModel;
//            }
//            cell.separatorInset = UIEdgeInsetsMake(0, 0, -1, 0);
//            return cell;
//        }
       
    }else{
        HTShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTShopInfoCell" forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  section == 0 ?  2 : self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
        UIView *v =  [[UIView alloc] init];
        v.backgroundColor = [UIColor clearColor];
        return  v;
//    }
//    HTSearchTextHeadView *sectionHead = [[HTSearchTextHeadView alloc] initWithSearchFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
//    sectionHead.delegate = self;
//    return  sectionHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return section == 0 ? 0.01f : 44;
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 70.0f: 140.0f;
    }else{
        return 136.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (_timeType == 1) {
                
            }else if (_timeType == 2){
                HTBossSaleDescViewController *vc = [[HTBossSaleDescViewController alloc] init];
                vc.rankState = HTRANKSTATEMONTH;
                vc.backImg = @"g-whiteback";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                HTBossSaleDescViewController *vc = [[HTBossSaleDescViewController alloc] init];
                vc.rankState = HTRANKSTATEYEAR;
                vc.backImg = @"g-whiteback";
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
    if (indexPath.section == 1) {
         HTHomePageViewController *vc = [[HTHomePageViewController alloc] init];
         HTSingleShopDataModel *model = self.dataArray[indexPath.row];
         vc.isBoss = YES;
         vc.backImg = @"g-back";
         vc.companyName = model.merchantName;
         vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:model.companyId];
         [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self loadShowCells];
}
#pragma mark -CustomDelegate
- (void)searchShopWithString:(NSString *)searchStr{
    if (searchStr.length == 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.shopsArray];
        [self.myTableView reloadData];
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (HTSingleShopDataModel *model in self.shopsArray) {
        if ([model.merchantName rangeOfString:searchStr].length != 0) {
            [arr addObject:model];
        }
    }
    if (arr.count == 0) {
        [MBProgressHUD showError:@"未查找到相关店铺" toView:self.view];
        return;
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arr];
        [self.myTableView reloadData];
    }
}
#pragma mark -EventResponse
- (void)rightBtClicked:(UIButton *)sender{
    [self.navigationController pushViewController:[[HTMsgCenterViewController alloc] init] animated:YES];
}
- (void)searchBtClick:(UIButton *)sender{
#warning 修改搜索
//    HTSearchShopsController *searchVc = [[HTSearchShopsController alloc] init];
//    [self.navigationController pushViewController:searchVc animated:YES];
}
#pragma mark -private methods
- (void)loadShowCells
{
    NSArray*array = [self.myTableView indexPathsForVisibleRows];//TableView中，想要什么，就以什么开头
    for(NSIndexPath*indexPath in array) {
        // 1.获取cell
        HTShopInfoCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        HTSingleShopDataModel *model = self.shopsArray[indexPath.row];
        [cell createCircleWithIp:model.up.intValue];
    }
    
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
            [strongSelf.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}
- (void)createRightNavBar{
    

    self.rightBt = [[[NSBundle mainBundle] loadNibNamed:@"HTRightNavBar" owner:nil options:nil]  lastObject];
    self.rightBt.imageName = @"消息-白";
    [self.rightBt baseInit];
    [self.rightBt sizeToFit];
    [self.rightBt addTarget:self action:@selector(rightBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
}

- (void)createTb{
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
//    UIView *footView = [[UIView alloc] init];
//    footView.backgroundColor = [UIColor clearColor];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTBossHomeHeaderSegmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossHomeHeaderSegmentTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTBossInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"HTBossInfoHeaderCell"];
     [self.myTableView registerNib:[UINib nibWithNibName:@"HTShopInfoCell" bundle:nil] forCellReuseIdentifier:@"HTShopInfoCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTBossSaleDescinfoCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleDescinfoCell"];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 1;
        [self loadData];
    }];
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNo ++;
        [self loadData];
    }];
    self.myTableView.contentInset = self.myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight + tar_height, 0);
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"术logo-白" highImageName:@"术logo-白" target:self action:nil];
    
}

- (void)loadHeaderData{
    NSDictionary *dic = @{
                          @"companyId" : [HTShareClass shareClass].loginModel.companyId,
                          @"type" : @(_timeType),
                          };
    __weak typeof(self) weakSelf =  self;
        [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleAgent,loadAgentHeader] params:dic success:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [strongSelf.headModel setValuesForKeysWithDictionary:[json getDictionArrayWithKey:@"data"]];
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [strongSelf.myTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络请求失败，请检查你的网络"];
    }];
    
}

- (void)loadData{
    NSDictionary *dic = @{
                          @"companyId" : [HTShareClass shareClass].loginModel.companyId,
                          @"pageNo" : @(_pageNo),
                          @"pageSize" : @"10"
                          };
    __weak typeof(self) weakSelf =  self;
        [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleAgent,loadAgentSaleDataReport] params:dic success:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        NSArray *dataArr = [json[@"data"] getArrayWithKey:@"merchants"];
        if (dataArr.count == 0 || dataArr == nil) {
            return;
        }
        if (strongSelf.pageNo == 1) {
//            [strongSelf.headModel setValuesForKeysWithDictionary:[json[@"data"] getDictionArrayWithKey:@"generalAgents"]];
            [self loadHeaderData];
            [strongSelf.shopsArray removeAllObjects];
            [strongSelf.dataArray removeAllObjects];
        }
    
//        __block CGFloat max = 0.0f;
//        __block CGFloat min = 0.0f;
//        __block NSString *maxStr = [NSString string];
//        __block NSString *minStr = [NSString string];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HTSingleShopDataModel *model = [[HTSingleShopDataModel alloc] init];
            [model setValuesForKeysWithDictionary:obj];
#if 0
            if (idx == 0) {
                max = model.profit.floatValue;
                min = model.profit.floatValue;
                maxStr = [HTHoldNullObj getValueWithUnCheakValue:model.profit];
                maxStr = [HTHoldNullObj getValueWithUnCheakValue:model.profit];
                minStr = [HTHoldNullObj getValueWithUnCheakValue:model.profit];
            }else{
            if (model.profit.floatValue >= max) {
                maxStr = [HTHoldNullObj getValueWithUnCheakValue:model.profit];
                max = model.profit.floatValue;
            }
            if (model.profit.floatValue <= min) {
                    min = model.profit.floatValue;
                    minStr = [HTHoldNullObj getValueWithUnCheakValue:model.profit];
             }
            }
            for (HTSingleShopDataModel *model in self.shopsArray) {
                model.max = maxStr;
                model.min = minStr;
            }
#endif
            [strongSelf.shopsArray addObject:model];
        }];
//        [strongSelf.dataArray addObjectsFromArray:strongSelf.shopsArray];
        strongSelf.dataArray = [NSMutableArray arrayWithArray:strongSelf.shopsArray];
        [strongSelf.myTableView.mj_header endRefreshing];
        [strongSelf.myTableView.mj_footer endRefreshing];
        [strongSelf.myTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
//        [MBProgressHUD showError:SeverERRORSTRING];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络请求失败，请检查你的网络"];
    }];
    
}
#pragma mark - getters and setters
- (NSMutableArray *)shopsArray{
    if (!_shopsArray) {
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}
- (HTAgencyMainDataModel *)headModel{
    if (!_headModel) {
        _headModel = [[HTAgencyMainDataModel alloc] init];
    }
    return _headModel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
