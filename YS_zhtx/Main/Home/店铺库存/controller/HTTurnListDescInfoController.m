//
//  HTTurnListDescInfoController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTBaceNavigationController.h"
#import "HTProductInfoTableViewCell.h"
#import "HTTurnListDescInfoController.h"
#import "HTTurnListDetailModel.h"
#import "HTSaleGoodOrBadDetailController.h"
@interface HTTurnListDescInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (nonatomic,strong) NSMutableArray *cellsName;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (weak, nonatomic) IBOutlet UIButton *refuseBt;
@property (weak, nonatomic) IBOutlet UIButton *okbt;
@property (weak, nonatomic) IBOutlet UIButton *stateBt;

@property (nonatomic,strong) HTTurnListDetailModel *turnModel;


@property (nonatomic,strong) NSString *handleType;
@property (nonatomic,strong) NSString *signStatus;
@property (nonatomic,strong) NSString *swapStatus;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *noticeType;

@property (nonatomic,strong) NSMutableArray *firstSection;
@property (nonatomic,strong) NSMutableArray *thirdSection;


@end


@implementation HTTurnListDescInfoController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    HTBaceNavigationController *nv = (id)self.navigationController;
    nv.imageName = @"g-back";
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.turnModel ?  self.dataArray.count : 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return [arr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cee1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cee1"];
        }
        cell.textLabel.text = self.turnModel.batchno.length > 0 ? [NSString stringWithFormat:@"盘点批次号:%@",self.turnModel.batchno]:[NSString stringWithFormat:@"调货单号:%@",self.turnModel.swapProductOrderNo];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"222222"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
           NSDictionary *dic = self.firstSection[indexPath.row];
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cee2"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cee2"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [dic getStringWithKey:@"title"];
            cell.detailTextLabel.text = [dic getStringWithKey:@"value"].length == 0 ? @"暂无数据" : [dic getStringWithKey:@"value"];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            return cell;
     }else{
            HTProductInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductInfoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.thirdSection[indexPath.row];
            return cell;
     }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 48;
    }else if (indexPath.section == 1){
        return 30;
    }else{
        return 100;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 48.0f;
    }else{
        return 0.01f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 48)];
        vvv.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, HMSCREENWIDTH - 16, 48)];
        titleLabel.text = @"产品信息";
        [vvv addSubview:titleLabel];
        return vvv;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        HTSaleGoodOrBadDetailController *vc = [[HTSaleGoodOrBadDetailController alloc] init];
        HTTurnListDetailProductModel *model = self.thirdSection[indexPath.row];
        HTStackSaleProductModel *mmm = [[HTStackSaleProductModel alloc] init];
        mmm.styleCode = model.styleCode;
        mmm.colorCode = model.colorCode;
        vc.model = mmm;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)okCliceked:(id)sender {
    
    NSDictionary *dic = @{
                          @"noticeId":[HTHoldNullObj getValueWithUnCheakValue:self.noticeId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"opMode": @"1",
                          };
    [MBProgressHUD showMessage:@"正在处理"];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,NoticeHandle] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"操作成功"];
            if ([self.type isEqualToString:@"1"]||[self.type isEqualToString:@"14"]||[self.type isEqualToString:@"15"]||[self.type isEqualToString:@"16"]) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该发货单已确认" forState:UIControlStateNormal];
            }else if([self.type isEqualToString:@"2"]){
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该调货单已签收" forState:UIControlStateNormal];
            }
        }else{
            [MBProgressHUD showError:[json getStringWithKey:@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
    
}
- (IBAction)refuseClicked:(id)sender {
    
    NSDictionary *dic = @{
                          @"noticeId":[HTHoldNullObj getValueWithUnCheakValue:self.noticeId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"opMode": @"-1"
                          };
    [MBProgressHUD showMessage:@"正在处理"];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,NoticeHandle] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"操作成功"];
            if ([self.type isEqualToString:@"1"]||[self.type isEqualToString:@"14"]||[self.type isEqualToString:@"15"]||[self.type isEqualToString:@"16"]) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该发货单已被拒绝" forState:UIControlStateNormal];
            }else if([self.type isEqualToString:@"2"]){
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该调货单已拒签" forState:UIControlStateNormal];
            }
        }else{
            [MBProgressHUD showError:[json getStringWithKey:@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"%@",json);
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTProductInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTProductInfoTableViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = 48 + SafeAreaBottomHeight;
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDataWithPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDataWithPage:self.page];
    }];
}
-(void)loadDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"noticeId":[HTHoldNullObj getValueWithUnCheakValue:self.noticeId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"rows":@"10",
                          @"page":@(page)
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,noticeLoad4App] params:dic success:^(id json) {
        [self.dataArray removeAllObjects];
        [self.firstSection removeAllObjects];
        if (self.page == 1) {
            [self.thirdSection removeAllObjects];
        }
        self.turnModel = [HTTurnListDetailModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        self.handleType = [HTHoldNullObj getValueWithUnCheakValue: self.turnModel.handleType ];
        self.signStatus = [HTHoldNullObj getValueWithUnCheakValue: self.turnModel.signStatus ];
        self.swapStatus = [HTHoldNullObj getValueWithUnCheakValue: self.turnModel.swapStatus ];
        self.type = [HTHoldNullObj getValueWithUnCheakValue: self.turnModel.type];
        self.noticeType = [HTHoldNullObj getValueWithUnCheakValue:self.turnModel.noticeType];
        
        if([self.type isEqualToString:@"1"]||[self.type isEqualToString:@"14"]||[self.type isEqualToString:@"15"]||[self.type isEqualToString:@"16"]){
            if (self.title.length > 0) {
            }else{
                self.title = @"发货单详情";
            }
            if ([self.handleType isEqualToString:@"0"] && [self.swapStatus isEqualToString:@"1"]) {
                self.refuseBt.hidden = NO;
                self.okbt.hidden = NO;
                self.stateBt.hidden = YES;
                [self.refuseBt setTitle:@"拒绝" forState:UIControlStateNormal];
                [self.okbt setTitle:@"确认" forState:UIControlStateNormal];
            }
            if ([self.handleType isEqualToString:@"1"] && [self.swapStatus isEqualToString:@"2"]) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该发货单已确认" forState:UIControlStateNormal];
            }
            if ([self.handleType isEqualToString:@"-1"]) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该发货单已被拒绝" forState:UIControlStateNormal];
            }
        }
        if([self.type isEqualToString:@"2"]){
            if (self.title) {
            }else{
                self.title = @"收货单详情";
            }
            if ([self.handleType isEqualToString:@"0"] && [self.swapStatus isEqualToString:@"2"] && [self.signStatus isEqualToString:@"1"]) {
                self.refuseBt.hidden = NO;
                self.okbt.hidden = NO;
                self.stateBt.hidden = YES;
                [self.refuseBt setTitle:@"拒签" forState:UIControlStateNormal];
                [self.okbt setTitle:@"签收" forState:UIControlStateNormal];
            }
            
            if ([self.handleType isEqualToString:@"1"] && [self.swapStatus isEqualToString:@"2"]&& [self.signStatus isEqualToString:@"2"]) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该调货单已签收" forState:UIControlStateNormal];
            }
            if ([self.handleType isEqualToString:@"-1"] ) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该调货单已拒签" forState:UIControlStateNormal];
            }
        }
        if ([self.noticeType isEqualToString:@"STOCK_TAKING"]) {
            if (self.title) {
            }else{
                self.title = @"库存校准";
            }
            if ([self.handleType isEqualToString:@"0"] ) {
                self.refuseBt.hidden = NO;
                self.okbt.hidden = NO;
                self.stateBt.hidden = YES;
                [self.refuseBt setTitle:@"拒绝" forState:UIControlStateNormal];
                [self.okbt setTitle:@"确认" forState:UIControlStateNormal];
            }
            if ([self.handleType isEqualToString:@"1"] ) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该库存校准已确认" forState:UIControlStateNormal];
            }
            if ([self.handleType isEqualToString:@"-1"]) {
                self.refuseBt.hidden = YES;
                self.okbt.hidden = YES;
                self.stateBt.hidden = NO;
                [self.stateBt setTitle:@"该库存校准已被拒绝" forState:UIControlStateNormal];
            }
            self.refuseBt.hidden = YES;
            self.okbt.hidden = YES;
            self.stateBt.hidden = YES;
        }
        
        if ([self.type isEqualToString:@"4"]) {
            if (self.title) {
            }else{
                self.title = @"进货单详情";
            }
        }
        if ([self.type isEqualToString:@"5"]) {
            if (self.title) {
            }else{
                self.title = @"补货单详情";
            }
        }
        if ([self.type isEqualToString:@"6"]) {
            if (self.title) {
            }else{
                self.title = @"盘点单详情";
            }
        }
        if ([self.type isEqualToString:@"3"]) {
            if (self.title) {
            }else{
                self.title = @"调入单详情";
            }
        }
        
        [self.firstSection addObject:@{@"title":@"出货公司",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.swapCompanyName]}];
        NSArray *types = @[@"TUNE_MANIFEST_IN",@"TUNE_MANIFEST_OUT",@"TUNE_MANIFEST_OUT_SWAP_OTHER",@"TUNE_MANIFEST_OUT_RETURN_DAMAGE",@"TUNE_MANIFEST_OUT_RETURN_GOODS"];
        if ([types containsObject:self.noticeType]) {
            [self.firstSection addObject:@{@"title":@"目标公司",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.targetCompanyName]}];
            [self.firstSection addObject:@{@"title":@"出货确认人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.swapCheckUserName]}];
            [self.firstSection addObject:@{@"title":@"调货发起人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.swapUserName]}];
        }else if ([self.noticeType isEqualToString:@"TUNE_MANIFEST_FEEDBACK"]){
            [self.firstSection addObject:@{@"title":@"目标公司",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.targetCompanyName]}];
            [self.firstSection addObject:@{@"title":@"调货发起人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.swapUserName]}];
            [self.firstSection addObject:@{@"title":@"出货确认人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.swapCheckUserName]}];
            //签收状态
            NSString *state = [NSString string];
            if ([self.signStatus isEqualToString:@"1"]) {
                state = @"未签收";
            }else if ([self.signStatus isEqualToString:@"2"]){
                state = @"已签收";
            }else if ([self.signStatus isEqualToString:@"3"]){
                state = @"已拒收";
            }else{
                state = @"暂无数据";
            }
            [self.firstSection addObject:@{@"title":@"签收状态",@"value":[HTHoldNullObj getValueWithUnCheakValue:state]}];
            //签收操作人
            [self.firstSection addObject:@{@"title":@"签收操作人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.signUserName]}];
        }else if ([self.noticeType isEqualToString:@"STOCK_TAKING"]){
            [self.firstSection addObject:@{@"title":@"盘点发起人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.initiator]}];
            [self.firstSection addObject:@{@"title":@"校正标准",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.opType]}];
            [self.firstSection addObject:@{@"title":@"操作人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.editor]}];
        }else{
            //调货发起人
            [self.firstSection addObject:@{@"title":@"调货发起人",@"value":[HTHoldNullObj getValueWithUnCheakValue:self.turnModel.swapUserName]}];
        }
        [self.firstSection addObject:@{@"title":@"调货件数",@"value":[HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"%@件",self.turnModel.swapTotalCount]]}];
//        调货单号 第一组数据
        [self.dataArray addObject:@[@""]];
        [self.dataArray addObject:self.firstSection];
        [self.thirdSection addObjectsFromArray:self.turnModel.product];
        [self.dataArray addObject:self.thirdSection];
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        
        [_cellsName addObject:@[@"UITableViewCell"]];
        [_cellsName addObject:@[@"UITableViewCell",@"UITableViewCell",@"UITableViewCell",@"UITableViewCell",@"UITableViewCell",@"UITableViewCell"]];
        [_cellsName addObject:@[@"HTProductInfoTableViewCell",@"HTProductInfoTableViewCell",@"HTProductInfoTableViewCell",@"HTProductInfoTableViewCell"]];
    }
    return _cellsName;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)firstSection{
    if (!_firstSection) {
        _firstSection = [NSMutableArray array];
    }
    return _firstSection;
}
-(NSMutableArray *)thirdSection{
    if (!_thirdSection) {
        _thirdSection = [NSMutableArray array];
    }
    return _thirdSection;
}
@end
