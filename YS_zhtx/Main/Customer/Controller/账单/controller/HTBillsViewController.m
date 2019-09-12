//
//  HTBillsViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTBillFiltrateBoxView.h"
#import "HTBillsViewController.h"
#import "HTFiltrateNodeModel.h"
#import "HTFiltrateHeaderModel.h"
#import "HTBillInfoTableViewCell.h"
#import "HTBillSectionModel.h"
#import "HTDefaulTitleHeadView.h"
#import "HTBillInfoModel.h"
#import "HTCashierCustomerTitleView.h"
@interface HTBillsViewController ()<UITableViewDelegate,UITableViewDataSource,HTBillFiltrateBoxViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *accountTypeBt;

@property (weak, nonatomic) IBOutlet UIButton *billTypeBt;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableDictionary *requsetDic;

@end

@implementation HTBillsViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configHeadBt];
    [self createTb];
    [self createBox];
    [self.tab.mj_header beginRefreshing];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HTBillSectionModel *model = self.dataArray[section];
    return model.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTBillSectionModel *model = self.dataArray[indexPath.section];
    HTBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBillInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model.datas[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HTBillSectionModel *header =  self.dataArray[section];
    HTDefaulTitleHeadView*head = [[NSBundle mainBundle] loadNibNamed:@"HTDefaulTitleHeadView" owner:nil options:nil].lastObject;
    head.title = header.sectionTile;
    return head;
}
#pragma mark -CustomDelegate
-(void)FiltrateBoxDidSelectedInSection:(NSInteger) section andRow:(NSInteger) row withHeadModel:(HTFiltrateHeaderModel *)model{
    HTFiltrateNodeModel *node = model.titles[row];
    [self.requsetDic setObject:node.searchValue forKey:node.searchKey];
    [self.tab.mj_header beginRefreshing];
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTBillInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBillInfoTableViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page =  1;
        [self loadDataWithPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDataWithPage:self.page];
    }];
    
    HTCashierCustomerTitleView *headView = [[NSBundle mainBundle] loadNibNamed:@"HTCashierCustomerTitleView" owner:nil options:nil].lastObject;
    headView.backgroundColor = [UIColor clearColor];
    headView.model = self.cust;
    self.navigationItem.titleView = headView;
    
}
-(void)configHeadBt{
    [self.accountTypeBt setTitle:@"账户类型" forState:UIControlStateNormal];
    self.accountTypeBt.imageEdgeInsets =UIEdgeInsetsMake(self.accountTypeBt.imageEdgeInsets.top, self.accountTypeBt.imageEdgeInsets.left, self.accountTypeBt.imageEdgeInsets.bottom,8);
    [self.accountTypeBt setImage:[UIImage imageNamed:@"g-mineDown"] forState:UIControlStateNormal];
    
    [self.billTypeBt setTitle:@"账户类型" forState:UIControlStateNormal];
    self.billTypeBt.imageEdgeInsets =UIEdgeInsetsMake(self.billTypeBt.imageEdgeInsets.top, self.billTypeBt.imageEdgeInsets.left, self.billTypeBt.imageEdgeInsets.bottom,8);
    [self.billTypeBt setImage:[UIImage imageNamed:@"g-mineDown"] forState:UIControlStateNormal];
    
}
-(void)createBox{
    HTBillFiltrateBoxView *box = [[HTBillFiltrateBoxView alloc] initWithBoxFrame:CGRectMake(0, 0, HMSCREENWIDTH, 48)];
    box.delegate = self;
    [box chooseType:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:box];
    });
    
    HTFiltrateHeaderModel *m0 = [[HTFiltrateHeaderModel alloc] init];
    NSArray *title0 = @[@"全部",@"本店"];
    NSArray *valuess0 = @[@"0",@"1"];
    NSMutableArray *arr0 = [NSMutableArray array];
    for (int i = 0; i < title0.count; i++) {
        HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
        model.isSelected = i == 0 ? YES : NO;
        model.title = title0[i];
        model.searchKey = @"isAll";
        model.searchValue = valuess0[i];
        [arr0 addObject:model];
    }
    m0.titles = arr0;
    m0.filtrateStyle = HTFiltrateStyleCollection;
    
    HTFiltrateHeaderModel *m = [[HTFiltrateHeaderModel alloc] init];
    NSArray *title = @[@"全部",@"储值",@"储值赠送",@"积分"];
    NSArray *valuess = @[@"",@"1",@"3",@"2"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < title.count; i++) {
        HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
        model.isSelected = i == 0 ? YES : NO;
        model.title = title[i];
        model.searchKey = @"accountType";
        model.searchValue = valuess[i];
        [arr addObject:model];
    }
    m.titles = arr;
    m.filtrateStyle = HTFiltrateStyleCollection;
    
    HTFiltrateHeaderModel *m1 = [[HTFiltrateHeaderModel alloc] init];
    NSArray *title1 = @[@"全部",@"充值",@"赠送",@"转入",@"转出",@"消费",@"扣除",@"批量充值",@"批量扣除",@"退款",@"批量赠送"];
    NSArray *values = @[@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i < title1.count; i++) {
        HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
        model.isSelected = i == 0 ? YES : NO;
        model.title = title1[i];
        model.searchKey = @"flowType";
        model.searchValue = values[i];
        [arr1 addObject:model];
    }
    m1.titles = arr1;
    m1.filtrateStyle = HTFiltrateStyleCollection;
    box.dataArray = @[m0,m,m1];
    
}
-(void)loadDataWithPage:(int) page{

    NSDictionary *dic = @{
                          @"accountType":[self.requsetDic getStringWithKey:@"accountType"],
                          @"flowType":[self.requsetDic getStringWithKey:@"flowType"],
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.custId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"rows":@"10",
                          @"page":@(page),
                          @"isAll":[self.requsetDic getStringWithKey:@"isAll"]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleAccflow,loadBillList] params:dic success:^(id json) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json getArrayWithKey:@"rows"]) {
            if (self.dataArray.count > 0) {
//                为同月分为一组，不同月在建一组
                if ([dic getStringWithKey:@"createdate"].length >= 7) {
                    HTBillSectionModel *model = [self.dataArray lastObject];
                    if ([model.holdStr isEqualToString:[[dic getStringWithKey:@"createdate"] substringWithRange:NSMakeRange(0, 7)]]) {
                        [model.datas addObject:[HTBillInfoModel yy_modelWithJSON:dic]];
                    }else{
                        HTBillSectionModel *secModel = [[HTBillSectionModel alloc] init];
                        HTBillInfoModel *mmm = [HTBillInfoModel yy_modelWithJSON:dic];
                        if (mmm.createdate.length >= 7) {
                            [secModel.datas addObject:mmm];
                            secModel.holdStr = [mmm.createdate substringWithRange:NSMakeRange(0, 7)];
                            secModel.sectionTile = [NSString stringWithFormat:@"%@年%@月",mmm.year,mmm.month];
                            [self.dataArray addObject:secModel];
                        }
                    }
                }
                
            }else{
//未添加组数据
                HTBillSectionModel *model = [[HTBillSectionModel alloc] init];
                HTBillInfoModel *mmm = [HTBillInfoModel yy_modelWithJSON:dic];
                if (mmm.createdate.length >= 7) {
                  [model.datas addObject:mmm];
                  model.holdStr = [mmm.createdate substringWithRange:NSMakeRange(0, 7)];
                  model.sectionTile = [NSString stringWithFormat:@"%@年%@月",mmm.year,mmm.month];
                  [self.dataArray addObject:model];
                }
            }
        }
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [self.tab reloadData];
    } error:^{
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
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
-(NSMutableDictionary *)requsetDic{
    if (!_requsetDic) {
        _requsetDic = [NSMutableDictionary dictionary];
    }
    return _requsetDic;
}
@end
