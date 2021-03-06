//
//  HTCustomerReportViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTTagsTableViewCell.h"
#import "HTNewVipBaseInfoCell.h"
#import "HTNew1SingVipSaleBaceInfoCell.h"
#import "HTCustomerReportViewController.h"
#import "HTOffOrColseTableViewCell.h"
#import "HTBuyHabitInfoTableViewCell.h"
#import "HTCustomerTitleView.h"
#import "HTTagsCloseTableViewCell.h"
#import "HTNewVipHeadCell.h"
#import "HTLineDataReportTableViewCell.h"
#import "HTDefaulTitleHeadView.h"
#import "HTIndexesBox.h"
#import "HTIndexsModel.h"
#import "HTCustomerOrderListController.h"
#import "HTCustomerProductListController.h"
#import "HTCustomerReportModel.h"
#import "HTYearsSaleinfoLineReportCell.h"
#import "HTNewTagsModel.h"
#import "HTAddTagsViewController.h"
#import "HTCustomerTapMoreController.h"
#import "Poper.h"
#import "HTContinueBackModel.h"
#import "HTEditVipContinueBackListCell.h"
#import "HTMenuModle.h"
#import "HTHoldCustomerEventManger.h"
#import "HTChargeViewController.h"
@interface HTCustomerReportViewController ()<UITableViewDelegate,UITableViewDataSource,HTNewSingVipSaleBaceInfoCellDelegate,HTTagsCloseTableViewCellDelegate,HTTagsTableViewCellDelegate,HTCustomerTapMoreControllerDelegate,HTEditVipContinueBackListCellDelegate>{
    Poper *poper;
}
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (nonatomic,strong) NSMutableArray *cellsName;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) HTIndexesBox *indexBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstain;
@property (nonatomic,strong) HTCustomerReportModel *reportModel;

@property (nonatomic,strong)  NSMutableArray *finallTagsArray;

@property (nonatomic,strong)  NSMutableArray *tagsArray;

@property (nonatomic,assign) BOOL isSeeMore;

@property (nonatomic,strong) NSMutableArray *backLists;

@property (nonatomic,strong) NSString *moduleId;

@property (nonatomic,assign) int page;

@end

@implementation HTCustomerReportViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAuth];
    [self createTb];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    if (self.customerType == HTCustomerReportTypeFacePush) {
        self.topConstain.constant = 0;
    }else{
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        self.topConstain.constant = -nav_height;
       [self setNavHidden];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.customerType == HTCustomerReportTypeNomal) {
        self.navigationController.navigationBar.clipsToBounds = YES;
    };
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellName = cells[indexPath.row];
    if ([cellName isEqualToString:@"HTTagsTableViewCell"]) {
        HTTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTagsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isSeeMore = self.isSeeMore;
        if (self.finallTagsArray.count > 0) {
          cell.model = self.finallTagsArray[self.customerType == HTCustomerReportTypeNomal ? (indexPath.row - 2) : indexPath.row];
        }
       
        cell.delegate = self;
        return cell;
    }else if ([cellName isEqualToString:@"HTNewVipBaseInfoCell"]){
        HTNewVipBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewVipBaseInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel.baseMessage;
        return cell;
    }else if ([cellName isEqualToString:@"HTOffOrColseTableViewCell"]){
        HTOffOrColseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOffOrColseTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isSeemore = self.isSeeMore;
        return cell;
    }else if([cellName isEqualToString:@"HTNew1SingVipSaleBaceInfoCell"]){
        HTNew1SingVipSaleBaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNew1SingVipSaleBaceInfoCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.reportModel.baseMessage;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([cellName isEqualToString:@"HTNewVipHeadCell"]){
        HTNewVipHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewVipHeadCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel.baseMessage;
        return cell;
    }else if([cellName isEqualToString:@"HTTagsCloseTableViewCell"]){
        HTTagsCloseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTagsCloseTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.finallTagsArray[indexPath.row - 2];
        cell.delegate = self;
        return cell;
    }else if([cellName isEqualToString:@"HTYearsSaleinfoLineReportCell"]){
        HTYearsSaleinfoLineReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTYearsSaleinfoLineReportCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        cell.dataArray = @[self.reportModel.yearOfMonth,self.reportModel.lastYearOfMonth];
        return cell;
        
    }else if ([cellName isEqualToString:@"HTEditVipContinueBackListCell"]){
        HTEditVipContinueBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTEditVipContinueBackListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.backLists[indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        HTBuyHabitInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBuyHabitInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel;
        return cell;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reportModel.colorModel ? (section >= self.cellsName.count ? 0 : [(NSArray *)self.cellsName[section] count]) : 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reportModel.colorModel ? self.sectionArray.count : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *header = self.sectionArray[section];
    if (header.length == 0) {
        return 0.001f;
    }else{
        return 48;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.indexBox.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:section];
    NSString *header =  self.sectionArray[section];
    if (header.length == 0) {
        return nil;
    }else{
        HTDefaulTitleHeadView *head = [[NSBundle mainBundle] loadNibNamed:@"HTDefaulTitleHeadView" owner:nil options:nil].lastObject;
        head.title = self.sectionArray[section];
        return head;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTOffOrColseTableViewCell class]]) {
        self.isSeeMore = !self.isSeeMore;
        [self configCells];
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:5];
    }
}
#pragma mark -CustomDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.customerType == HTCustomerReportTypeNomal) {
        UIColor *color = [UIColor whiteColor];
        if (scrollView.contentOffset.y <= 10) {
            self.backImg = @"g-whiteback";
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
            self.navigationController.navigationBar.clipsToBounds = YES;
        }else{
            self.backImg = @"g-back";
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
            self.navigationController.navigationBar.clipsToBounds = NO;
        }
        UIImage *image = [self imageWithColor:[color colorWithAlphaComponent: scrollView.contentOffset.y  / 100]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = image;
        [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
        self.title = @"客户详情";
    }
    if (scrollView.contentOffset.y >= 50) {
        if (self.indexBox.hidden) {
            self.indexBox.alpha = 0.0;
            self.indexBox.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.indexBox.alpha = 1;
            }];
        }
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.indexBox.alpha = 0;
        } completion:^(BOOL finished) {
            self.indexBox.hidden = YES;
        }];
    }
}
-(void)buyNumsClicked{
    HTCustomerOrderListController *vc = [[HTCustomerOrderListController alloc] init];
    vc.custId = [HTHoldNullObj getValueWithUnCheakValue:self.model.custId];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)buyProductNumsClicked{
    HTCustomerProductListController *vc = [[HTCustomerProductListController alloc] init];
    vc.custId = [HTHoldNullObj getValueWithUnCheakValue:self.model.custId];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)nomorlTypeAddTag{
    [self addTagClicked];
}
-(void)addTagClicked{
//    添加标签
    HTAddTagsViewController *vc = [[HTAddTagsViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.addText = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadData];
    };
    vc.modelId = self.model.custId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)faceTypeSeemoreClickedWithCell:(HTTagsTableViewCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    [self.tab reloadRowsAtIndexPaths:@[index] withRowAnimation:5];
}
-(void)nomoalTypeClicekedWithCell:(HTTagsCloseTableViewCell *)cell{
    self.isSeeMore = YES;
    [self configCells];
    [self.tab reloadData];
//    [self.tab reloadSections:set withRowAnimation:5];
}
- (void) didTapWithString:(NSString *)tapKey andIndex:(NSInteger) index{
    
    if ([tapKey isEqualToString:@"充值"]) {
        [HTHoldCustomerEventManger storedForCustomerWithCustomerPhone:[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.baseMessage.phone]];
    }else if ([tapKey isEqualToString:@"扣除"]) {
        [HTHoldCustomerEventManger deduedForCustomerWithCustomerPhone:[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.baseMessage.phone]];
    }else if ([tapKey isEqualToString:@"编辑"]) {
        [HTHoldCustomerEventManger editCustomerWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:self.model.custId]];
    }else if ([tapKey isEqualToString:@"定时提醒"]) {
        [HTHoldCustomerEventManger addTimerForCustomerWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:self.model.custId]];
        
    }else if ([tapKey isEqualToString:@"账单"]){
        HTCustModel *model1 = [[HTCustModel alloc] init];
        model1.nickname = self.reportModel.baseMessage.name;
        model1.headImg = self.reportModel.baseMessage.headimg;
        [HTHoldCustomerEventManger lookCustomerBillListWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:self.model.custId] andCustModel:model1];
    }else if ([tapKey isEqualToString:@"聊天"]){
        [HTHoldCustomerEventManger chatWithCustomerWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:self.model.custId] customerName:self.model.name andOpenId:[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.baseMessage.openid]];
    }else if ([tapKey isEqualToString:@"快速下单"]){
        HTChargeViewController *vc = [[HTChargeViewController alloc] init];
        vc.phone = self.model.phone_cust;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)deleteContinueBackWithCell:(HTEditVipContinueBackListCell *)cell{
    //    请求网络删除
    if (self.backLists.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否删除此跟进记录" btsArray:@[@"取消",@"确认"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSIndexPath *index = [strongSelf.tab indexPathForCell:cell];
        HTContinueBackModel *model = strongSelf.backLists[index.row];
        [MBProgressHUD showMessage:@""];
        NSDictionary *dic = @{
                              @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.customerFollowRecordId],
                              @"modelId":[HTHoldNullObj getValueWithUnCheakValue:model.modelId],
                              @"model.is_del":@"1"
                              };
        
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,remove4app] params:dic success:^(id json) {
            self.page = 1;
            [strongSelf loadBackListWithPage:self.page];
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    } cancelClicked:^{
    }];
    [alert show];
    //    [self.backLists removeObjectAtIndex:index.row];
    //    [self configBacksList];
}
#pragma mark -EventResponse
-(void)moreBtClicked:(UIButton *)sender{
   
 
    NSMutableArray  *tapArr = [NSMutableArray array];
    [tapArr addObject:@"电话"];
    if ([HTHoldNullObj getValueWithUnCheakValue:self.model.openid].length > 0) {
        [tapArr addObject:@"聊天"];
    }
    if ([[HTHoldNullObj getValueWithUnCheakValue:self.model.isedit] isEqualToString:@"1"] && self.authModel.edit) {
        [tapArr addObject:@"编辑"];
    }
    if (self.authModel.topUp) {
        [tapArr  addObject:@"充值"];
    }
    if (self.authModel.deduct) {
        [tapArr  addObject:@"扣除"];
    }
    [tapArr addObject:@"账单"];
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
    vc.index = 0;
    vc.delegate = self;
    vc.model = self.model;
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark -private methods
- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
   
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(0, -nav_height, HMSCREENWIDTH, nav_height)];
    vvv.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:vvv];
    [self.view insertSubview:vvv atIndex:0];
}
-(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}
-(void)initNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-more" highImageName:@"g-more" target:self action:@selector(moreBtClicked:)];
    HTCustomerTitleView *headView = [[NSBundle mainBundle] loadNibNamed:@"HTCustomerTitleView" owner:nil options:nil].lastObject;
    headView.backgroundColor = [UIColor clearColor];
    headView.model = self.reportModel;
    self.navigationItem.titleView = headView;
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTTagsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTagsTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewVipBaseInfoCell" bundle:nil] forCellReuseIdentifier:@"HTNewVipBaseInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTNew1SingVipSaleBaceInfoCell" bundle:nil] forCellReuseIdentifier:@"HTNew1SingVipSaleBaceInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTOffOrColseTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTOffOrColseTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTBuyHabitInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBuyHabitInfoTableViewCell"];
  
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewVipHeadCell" bundle:nil] forCellReuseIdentifier:@"HTNewVipHeadCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTagsCloseTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTagsCloseTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTYearsSaleinfoLineReportCell" bundle:nil] forCellReuseIdentifier:@"HTYearsSaleinfoLineReportCell"];
     [self.tab registerNib:[UINib nibWithNibName:@"HTEditVipContinueBackListCell" bundle:nil] forCellReuseIdentifier:@"HTEditVipContinueBackListCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    if (self.customerType == HTCustomerReportTypeNomal) {
      self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-more" highImageName:@"g-more" target:self action:@selector(moreBtClicked:)];
    }
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadBackListWithPage:self.page];
    }];
}
-(void)loadData{
    NSDictionary *dic = @{
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.model.custId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCusRepott,loadCustomerPersonalReport4App] params:dic success:^(id json) {
       
        self.reportModel = [HTCustomerReportModel yy_modelWithJSON:json[@"data"]];
        self.model.birthday_cust = self.reportModel.baseMessage.birthday;
        self.model.sex_cust = self.reportModel.baseMessage.sex;
        self.model.phone_cust = self.reportModel.baseMessage.phone;
        self.model.headimg = self.reportModel.baseMessage.headimg;
        self.model.name = self.reportModel.baseMessage.name;
        self.model.isdel = self.reportModel.baseMessage.isdel;
        self.model.isedit = self.reportModel.baseMessage.isedit;
        self.model.openid = self.reportModel.baseMessage.openid;
        NSArray *keys = @[@"stickTag",@"companyTag",@"platformTag"];
        [self.tagsArray removeAllObjects];
        [self.finallTagsArray removeAllObjects];
        for(int i = 0 ;i<keys.count ;i++){
            NSString *key = keys[i];
            HTNewTagsModel *model = [[HTNewTagsModel alloc] init];
            model.tagsArray = [json[@"data"][@"tags"] getArrayWithKey:key];
            model.tageType = i + 1;
            model.tageState = HTTAGStateDEATL;
            if (model.tagsArray.count > 0) {
                [self.tagsArray addObject:model];
            }
            if ( model.tageType == HTTAGShop && model.tagsArray.count == 0 ) {
                [self.tagsArray addObject:model];
            }
        }
        [self configCells];
        if (self.customerType == HTCustomerReportTypeFacePush) {
           [self initNav];
        }
        [self.tab reloadData];
        self.page = 1;
        [self loadBackListWithPage:self.page];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
/**
 请求回访记录
 
 @param page 页数
 */
-(void)loadBackListWithPage:(int)page{
    NSDictionary *dic = @{
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.customerFollowRecordId],
                          @"model.customerId":[HTHoldNullObj getValueWithUnCheakValue:self.model.custId],
                          @"page":@(page),
                          @"rows":@"10"
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadList4App] params:dic success:^(id json) {
        if (self.page == 1) {
            [self.backLists removeAllObjects];
        }
        if ([[json[@"data"] getArrayWithKey:@"rows"] count] == 0 && self.page != 1) {
            [MBProgressHUD hideHUD];
            [self.tab.mj_footer endRefreshing];
            self.page--;
            return ;
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTContinueBackModel *model = [HTContinueBackModel yy_modelWithJSON:dic];
            [self.backLists addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self configBacksList];
    } error:^{
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD  showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD  showError:NETERRORSTRING];
        
    }];
}
-(void)loadAuth{
    NSDictionary *dic = @{
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleId]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadModuleAuth] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.authModel = [HTCustomerAuth yy_modelWithJSON:[json[@"data"] getDictionArrayWithKey:@"moduleAuthorityRule"]];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
-(void)configCells{
    [self.cellsName removeAllObjects];
    if (self.customerType == HTCustomerReportTypeFacePush) {
        if (self.tagsArray.count <= 1) {
            [self.finallTagsArray removeAllObjects];
            [self.finallTagsArray addObjectsFromArray:self.tagsArray];
            [_cellsName addObject:@[@"HTTagsTableViewCell",@"HTNewVipBaseInfoCell"]];
        }else{
            if (self.isSeeMore) {
                [self.finallTagsArray removeAllObjects];
                [self.finallTagsArray addObjectsFromArray:self.tagsArray];
                NSMutableArray * arr = [NSMutableArray array];
                for (int i = 0;i < self.finallTagsArray.count ; i++) {
                    [arr addObject:@"HTTagsTableViewCell"];
                }
                [arr addObject:@"HTOffOrColseTableViewCell"];
                [arr addObject:@"HTNewVipBaseInfoCell"];
                [_cellsName addObject:arr];
            }else{
                [self.finallTagsArray removeAllObjects];
                if (self.tagsArray.count  > 0) {
                    [self.finallTagsArray addObject:[self.tagsArray firstObject]];
                }
                [_cellsName addObject:@[@"HTTagsTableViewCell",@"HTOffOrColseTableViewCell",@"HTNewVipBaseInfoCell"]];
            }
        }
        [_cellsName addObject:@[@"HTNew1SingVipSaleBaceInfoCell"]];
        [_cellsName addObject:@[@"HTBuyHabitInfoTableViewCell"]];
        [_cellsName addObject:@[@"HTYearsSaleinfoLineReportCell"]];
    }
    if (self.customerType == HTCustomerReportTypeNomal) {
        if (self.isSeeMore) {
            [self.finallTagsArray removeAllObjects];
            [self.finallTagsArray addObjectsFromArray:self.tagsArray];
            NSMutableArray * arr = [NSMutableArray array];
            [arr addObject:@"HTNewVipHeadCell"];
            [arr addObject:@"HTNewVipBaseInfoCell"];
            for (int i = 0;i < self.finallTagsArray.count ; i++) {
                [arr addObject:@"HTTagsTableViewCell"];
            }
            if (self.finallTagsArray.count > 1) {
                [arr addObject:@"HTOffOrColseTableViewCell"];
            }
            [self.cellsName addObject:arr];
        }else{
            [self.finallTagsArray removeAllObjects];
            if (self.tagsArray.count  > 0) {
                [self.finallTagsArray addObject:[self.tagsArray firstObject]];
            }
            [_cellsName addObject:@[@"HTNewVipHeadCell",@"HTNewVipBaseInfoCell",@"HTTagsCloseTableViewCell"]];
        }
        [_cellsName addObject:@[@"HTNew1SingVipSaleBaceInfoCell"]];
        [_cellsName addObject:@[@"HTBuyHabitInfoTableViewCell"]];
        [_cellsName addObject:@[@"HTYearsSaleinfoLineReportCell"]];
    }
}
-(void)configBacksList{
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < self.backLists.count; i++) {
        [cells addObject:@"HTEditVipContinueBackListCell"];
    }
    if (self.cellsName.count >= 5 ) {
        [self.cellsName replaceObjectAtIndex:4 withObject:cells];
    }else{
        [self.cellsName addObject:cells];
    }
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:5];
}

#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
    _cellsName = [NSMutableArray array];
    if (self.customerType == HTCustomerReportTypeFacePush) {
        [_cellsName addObject:@[@"HTTagsTableViewCell",@"HTOffOrColseTableViewCell",@"HTNewVipBaseInfoCell"]];
        [_cellsName addObject:@[@"HTNew1SingVipSaleBaceInfoCell"]];
        [_cellsName addObject:@[@"HTBuyHabitInfoTableViewCell"]];
        [_cellsName addObject:@[@"HTYearsSaleinfoLineReportCell"]];
    }
    if (self.customerType == HTCustomerReportTypeNomal) {
        [_cellsName addObject:@[@"HTNewVipHeadCell",@"HTNewVipBaseInfoCell",@"HTTagsCloseTableViewCell"]];
        [_cellsName addObject:@[@"HTNew1SingVipSaleBaceInfoCell"]];
        [_cellsName addObject:@[@"HTBuyHabitInfoTableViewCell"]];
        [_cellsName addObject:@[@"HTYearsSaleinfoLineReportCell"]];
    }
  }
    return _cellsName;
}
-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
        [_sectionArray addObject:@""];
        [_sectionArray addObject:@"会员信息"];
        [_sectionArray addObject:@"消费习惯"];
        [_sectionArray addObject:@"消费频率"];
        [_sectionArray addObject:@"回访记录"];
    }
    return _sectionArray;
}
-(HTIndexesBox *)indexBox{
    if (!_indexBox) {
        NSArray *tites = @[@"会员信息",@"消费习惯",@"消费频率",@"回访记录"];
        
        NSArray *indexs = @[[NSIndexPath indexPathForRow:0 inSection:1],[NSIndexPath indexPathForRow:0 inSection:2],[NSIndexPath indexPathForRow:0 inSection:3],[NSIndexPath indexPathForRow:0 inSection:4]];
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < tites.count;i++ ) {
            HTIndexsModel *model = [[HTIndexsModel alloc] init];
            model.titles = tites[i];
            model.indexpath = indexs[i];
            [datas addObject:model];
        }
        _indexBox = [[HTIndexesBox alloc] initWithBoxFrame:CGRectMake(0, 0 + (self.customerType == HTCustomerReportTypeNomal ? 0 : 0) , HMSCREENWIDTH, 48) ];
        _indexBox.backgroundColor = [UIColor whiteColor];
        _indexBox.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _indexBox.srollerToIndex = ^(NSIndexPath *index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (self.backLists.count == 0 && index.section == 4) {
                return ;
            }
            [strongSelf.tab scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
        [_indexBox initSubviewswithDatas:datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_indexBox];
        });
    }
    return _indexBox;
}
-(HTCustomerReportModel *)reportModel{
    if (!_reportModel) {
        _reportModel = [[HTCustomerReportModel  alloc] init];
    }
    return _reportModel;
}
-(NSMutableArray *)tagsArray{
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}
-(NSMutableArray *)finallTagsArray{
    if (!_finallTagsArray) {
        _finallTagsArray = [NSMutableArray array];
    }
    return _finallTagsArray;
}
-(NSString *)customerFollowRecordId{
    if (!_customerFollowRecordId) {
        for (HTMenuModle *model in [HTShareClass shareClass].menuArray) {
            if ([model.moduleName isEqualToString:@"customerFollowRecord"]) {
                _customerFollowRecordId = [model.moduleId stringValue];
            }
        }
    }
    return _customerFollowRecordId;
}
-(NSString *)moduleId{
    if (!_moduleId) {
        for (HTMenuModle *model in [HTShareClass shareClass].menuArray) {
            if ([model.moduleName isEqualToString:@"customer"]) {
                _moduleId = [model.moduleId stringValue];
            }
        }
    }
    return _moduleId;
}
-(NSMutableArray *)backLists{
    if (!_backLists) {
        _backLists = [NSMutableArray array];
    }
    return _backLists;
}
@end
