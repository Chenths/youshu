//
//  HTOrderDetailViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTFastOrderDetailInfoViewCell.h"
#import "HTDefaulProductViewCell.h"
#import "HTNewCustomerBaceInfoCell.h"
#import "HTOrderRemarkTableViewCell.h"
#import "HTOrderInfoDetailTableCell.h"
#import "HTOrderImgsCollectionCell.h"
#import "HTFastOrderStaueDetailCell.h"
#import "HTOrderDetailViewController.h"
#import "HTOrderDetailModel.h"
#import "HTDefaulTitleHeadView.h"
#import "HTHoldOrderEventManager.h"
#import "HTOrderOrProductState.h"
#import "HTCustomerReportViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface HTOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *BottomBackView;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableArray *sectionTitle;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) HTOrderDetailModel *orderModel;


@end

@implementation HTOrderDetailViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self createTb];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"OrderDetailNotifi" object:nil];
}

#pragma mark -UITabelViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsName.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellsName[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *names = self.cellsName[indexPath.section];
    NSString *cellname = names[indexPath.row];
    
    if ([cellname isEqualToString:@"HTFastOrderDetailInfoViewCell"]) {
        HTFastOrderDetailInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTFastOrderDetailInfoViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
        
    }else if ([cellname isEqualToString:@"HTNewCustomerBaceInfoCell"]){
        HTNewCustomerBaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewCustomerBaceInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
        
    }else if ([cellname isEqualToString:@"HTFastOrderStaueDetailCell"]){
        HTFastOrderStaueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTFastOrderStaueDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
        
    }else if ([cellname isEqualToString:@"HTOrderImgsCollectionCell"]){
        HTOrderImgsCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderImgsCollectionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
    }else if ([cellname isEqualToString:@"HTOrderInfoDetailTableCell"]){
        HTOrderInfoDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderInfoDetailTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
        
    }else if ([cellname isEqualToString:@"HTDefaulProductViewCell"]){
        HTDefaulProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDefaulProductViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTOrderDetailProductModel *model = self.dataArray[indexPath.section][indexPath.row];
        cell.orderProductModel = model;
        return cell;
    }else{
        HTOrderRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderRemarkTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderModel;
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = self.sectionTitle[section];
    if (title.length > 0) {
        HTDefaulTitleHeadView *titleView = [[NSBundle mainBundle] loadNibNamed:@"HTDefaulTitleHeadView" owner:nil options:nil].lastObject;
        titleView.title = title;
        titleView.backgroundColor = [UIColor whiteColor];
        titleView.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        return titleView;
    }else{
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    return vvv;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *title = self.sectionTitle[section];
    if (title.length > 0) {
        return 48;
    }else{
        return 0.001f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSArray *cells = self.cellsName[section];
    NSString *cellname = [cells firstObject];
    if ([cellname isEqualToString:@"HTFastOrderDetailInfoViewCell"]) {
        return 1;
    }else{
        return 8;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTNewCustomerBaceInfoCell class]]) {
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
        model.custId = self.orderModel.customer.customerid;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTOrderImgsCollectionCell class]]){
        NSMutableArray *photos = [NSMutableArray array];
        for (NSString *url in self.orderModel.orderimage) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url];
            [photos addObject:photo];
        }
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

#pragma mark -CustomDelegate

#pragma mark -EventResponse
-(void)bottomClicked:(UIButton *)sender{
    
    int index = (int)sender.tag - 500;
    switch (index) {
        case 0:
        {
            [HTHoldOrderEventManager addTimerForOrderWithOrderId:self.orderId];
        }
            break;
        case 1:
        {
            [HTHoldOrderEventManager exchangeOrReturnOrderWithOrderId:self.orderId];
        }
            break;
        case 2:
        {
            [HTHoldOrderEventManager printOrderInfoWithOrderId:self.orderId];
        }
            break;
        case 3:
        {
            [HTHoldOrderEventManager postImgsForOrderWithOrderId:self.orderId];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark -private methods
-(void)loadData{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,loadOrderDetail] params:dic success:^(id json) {
//        清除布局数据
        [self.cellsName removeAllObjects];
        [self.sectionTitle removeAllObjects];
        [self.dataArray removeAllObjects];
        self.orderModel = [HTOrderDetailModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        if (self.orderModel.customer) {
           [self.cellsName addObject:@[@"HTFastOrderStaueDetailCell",@"HTNewCustomerBaceInfoCell"]];
        }else{
           [self.cellsName addObject:@[@"HTFastOrderStaueDetailCell"]];
        }
        
        [self.sectionTitle addObject:@""];
        [self.dataArray addObject:@[]];
        NSMutableArray *nomorls =  [NSMutableArray array];
        for (int i = 0; i < self.orderModel.product.count; i++) {
            [nomorls addObject:@"HTDefaulProductViewCell"];
        }
        [self.cellsName addObject:nomorls];
        [self.dataArray addObject:self.orderModel.product];
        [self.sectionTitle addObject:@""];
        for (HTOrderDetailExchangesModel *model in self.orderModel.returnandexchangeproduct) {
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < model.data.count; i++) {
                [arr addObject:@"HTDefaulProductViewCell"];
            }
            [self.cellsName addObject:arr];
            [self.dataArray addObject:model.data];
            [self.sectionTitle addObject:[NSString stringWithFormat:@"退换时间：%@",[HTHoldNullObj getValueWithUnCheakValue:model.createdate]]];
        }
        
        [self.cellsName addObject:@[@"HTOrderRemarkTableViewCell"]];
        [self.sectionTitle addObject:@""];
        [self.dataArray addObject:@[]];
        if (self.orderModel.orderimage.count > 0) {
            [self.cellsName addObject:@[@"HTOrderImgsCollectionCell"]];
            [self.sectionTitle addObject:@""];
            [self.dataArray addObject:@[]];
        }
        [self.cellsName addObject:@[@"HTFastOrderDetailInfoViewCell"]];
        [self.sectionTitle addObject:@""];
        [self.dataArray addObject:@[]];
        [self.cellsName addObject:@[@"HTOrderInfoDetailTableCell"]];
        [self.sectionTitle addObject:@""];
        [self.dataArray addObject:@[]];
        [self.tab reloadData];
        [self configBottom];
        [MBProgressHUD hideHUD];
    }  error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTFastOrderStaueDetailCell" bundle:nil] forCellReuseIdentifier:@"HTFastOrderStaueDetailCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewCustomerBaceInfoCell" bundle:nil] forCellReuseIdentifier:@"HTNewCustomerBaceInfoCell"];
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTDefaulProductViewCell" bundle:nil] forCellReuseIdentifier:@"HTDefaulProductViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTOrderRemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTOrderRemarkTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTOrderImgsCollectionCell" bundle:nil] forCellReuseIdentifier:@"HTOrderImgsCollectionCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTFastOrderDetailInfoViewCell" bundle:nil] forCellReuseIdentifier:@"HTFastOrderDetailInfoViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTOrderInfoDetailTableCell" bundle:nil] forCellReuseIdentifier:@"HTOrderInfoDetailTableCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F9F9FA"];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight + 60;
    
   
    
}
-(void)configBottom{
    NSArray *titles = @[@"定时提醒",@"退换货",@"打印小票",@"上传图片"];
    CGFloat bth = 32.0f;
    CGFloat btw = 72.0f;
    CGFloat contentW = 0.0f;
    for (int i = 0 ; i < titles.count; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitle:titles[i] forState:UIControlStateNormal];
        
        
        [bt  setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [bt changeCornerRadiusWithRadius:3];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        if (i == 1 &&![[HTOrderOrProductState getOrderStateFormOrderString:self.orderModel.orderstatus] isEqualToString:@"PAID"]) {
            [bt  setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
            [bt setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
            [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#eeeeee"] withWidth:1];
            bt.enabled = NO;
        }
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        bt.frame = CGRectMake(15 + (btw + 15) * i, 8, btw, bth);
        contentW = 15 + (btw + 15) * i;
        bt.tag = 500 + i;
        [bt addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.BottomBackView addSubview:bt];
    }
    self.BottomBackView.contentSize = CGSizeMake(contentW + btw, 48);
}
#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
    }
    return _cellsName;
}
-(NSMutableArray *)sectionTitle{
    if (!_sectionTitle) {
        _sectionTitle = [NSMutableArray array];
    }
    return _sectionTitle;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
