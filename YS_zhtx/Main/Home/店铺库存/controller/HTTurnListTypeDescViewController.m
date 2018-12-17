//
//  HTTurnListTypeDescViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTTurnListTpyeOutViewCell.h"
#import "HTTurnListTpyeInViewCell.h"
#import "HTIndexesBox.h"
#import "HTIndexsModel.h"
#import "HTTurnListTypeDescViewController.h"
#import "HTBaceNavigationController.h"
#import "HTTurnListDescInfoController.h"
#import "HTTurnListItemsModel.h"
#import "HTIndexBoxDescViewController.h"
#import "HTIndexsModel.h"
@interface HTTurnListTypeDescViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *headView;
}

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (weak, nonatomic) IBOutlet UIButton *notClickBt;

@property (weak, nonatomic) IBOutlet UIButton *checkBt;

@property (weak, nonatomic) IBOutlet UIButton *refuseBt;

@property (nonatomic,strong) NSMutableArray *btsArray;

@property (nonatomic,strong) NSMutableArray *headsArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *state;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (nonatomic,strong) NSArray *types;

@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation HTTurnListTypeDescViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self createTb];
    [self initHeadView];
    self.state = @"1";
    self.type = @"1";
    [self.tab.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNav];
    [self initNav];
    self.navigationItem.titleView.hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.titleView.hidden = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#ffffff"]];
}
#pragma mark -UITabelViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"16"]) {
        HTTurnListTpyeOutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTurnListTpyeOutViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
        HTTurnListTpyeInViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTurnListTpyeInViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTTurnListItemsModel *model = self.dataArray[indexPath.row];
    HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
    vc.noticeId = model.noticeId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate

#pragma EventResponse
-(void)stateBtClicked:(UIButton *)sender{
    for (UIButton *bt in self.headsArray) {
        bt.selected = NO;
        bt.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    sender.selected = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:17];
    self.state = [NSString stringWithFormat:@"%ld",(sender.tag - 600) + 1];
    [self.tab.mj_header beginRefreshing];
}
-(void)createNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#222222"]];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.backImg = @"g-whiteback";
    
}
-(void)btClicked:(UIButton *)sender{

    for (UIButton *bt in self.btsArray) {
        bt.selected = NO;
    }
    sender.selected = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:17];
    int tag = (int)sender.tag - 500;
    self.type = self.types[tag];
    if ([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"16"] ) {
        self.topView.hidden = NO;
        self.state = @"1";
        self.notClickBt.titleLabel.font = [UIFont systemFontOfSize:17];
        self.notClickBt.selected = YES;
        self.checkBt.titleLabel.font = [UIFont systemFontOfSize:15];
        self.checkBt.selected = NO;
        self.refuseBt.titleLabel.font = [UIFont systemFontOfSize:15];
        self.refuseBt.selected = NO;
        self.topViewHeight.constant = 48;
    }else{
        self.topView.hidden = YES;
        self.state = @"";
        self.topViewHeight.constant = 0.0f;
    }
    headView.contentOffset = CGPointMake(sender.x, 0);
    [self.tab.mj_header beginRefreshing];
}
-(void)rightBtClicked:(UIButton *)sender{
    
    HTIndexBoxDescViewController *vc = [[HTIndexBoxDescViewController alloc] init];
    NSArray *arr =  @[@"调出单（出）",@"调出单（入）",@"调入单（入）",@"进货单（入）",@"补货单（入）",@"库存盘点（入）",@"调出单（退货厂家）",@"调出单（报损厂家）",@"调出单（其他）"];
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSString *str  in arr ) {
        HTIndexsModel *model = [[HTIndexsModel alloc] init];
        model.titles = str;
        [indexs addObject:model];
    }
    vc.dataArray = indexs;
    __weak typeof(self) weakSelf = self;
    vc.selectedIndex = ^(NSUInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIButton *sender = [self->headView viewWithTag:(500 + index)];
        [strongSelf btClicked:sender];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma private methods
-(void)initNav{
    if (!headView) {
        UIView *vvv  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
        headView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
        headView.showsVerticalScrollIndicator = NO;
        headView.showsHorizontalScrollIndicator = NO;
        NSArray *titles = @[@"调出单（出）",@"调出单（入）",@"调入单（入）",@"进货单（入）",@"补货单（入）",@"库存盘点（入）",@"调出单（退货厂家）",@"调出单（报损厂家）",@"调出单（其他）"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *title in titles) {
            HTIndexsModel *model = [[HTIndexsModel alloc] init];
            model.titles = title;
            [arr addObject:model];
        }
        CGFloat btx = 0;
        for (int i = 0; i < arr.count; i++) {
            HTIndexsModel *model = arr[i];
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
            [bt setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [bt setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
            [bt setTitle:[HTHoldNullObj getValueWithUnCheakValue:model.titles] forState:UIControlStateNormal];
            bt.titleLabel.font = [UIFont systemFontOfSize:14];
            [bt addTarget:self action:@selector(btClicked:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
            bt.frame = CGRectMake(btx, 0, titleWidth , 44);
            btx += titleWidth;
            bt.tag = 500 + i;
            if (i == 0) {
                bt.selected = YES;
                bt.titleLabel.font = [UIFont systemFontOfSize:17];
            }
            [headView addSubview:bt];
            [self.btsArray addObject:bt];
        }
        headView.contentSize = CGSizeMake(btx + HMSCREENWIDTH * 0.5, 44);
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(HMSCREENWIDTH - 44 - 5 - 44 * (24 /21), 0, 44 * (24 /21), 44)];
        [bt setBackgroundImage:[UIImage imageNamed:@"g-indexblackBack"] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(rightBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vvv addSubview:headView];
        [vvv addSubview:bt];
        [vvv bringSubviewToFront:bt];
        self.navigationItem.titleView = vvv;
        self.notClickBt.selected = YES;
        self.notClickBt.titleLabel.font = [UIFont systemFontOfSize:17];
    }
}
-(void)initHeadView{
    UIScrollView  *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 48)];
    topView.showsVerticalScrollIndicator = NO;
    topView.showsHorizontalScrollIndicator = NO;
    NSArray *titles = @[@"未签收 ",@"已签收",@"拒绝签收",@"未确认",@"已确认",@"拒绝出货"];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *title in titles) {
        HTIndexsModel *model = [[HTIndexsModel alloc] init];
        model.titles = title;
        [arr addObject:model];
    }
    CGFloat btx = 0;
    for (int i = 0; i < arr.count; i++) {
        HTIndexsModel *model = arr[i];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateSelected];
        [bt setTitle:[HTHoldNullObj getValueWithUnCheakValue:model.titles] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:15];
        [bt addTarget:self action:@selector(stateBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
        bt.frame = CGRectMake(btx, 0, titleWidth , 48);
        btx += titleWidth;
        bt.tag = 600 + i;
        if (i == 0) {
            bt.selected = YES;
            bt.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [topView addSubview:bt];
        [self.headsArray addObject:bt];
    }
    topView.contentSize = CGSizeMake(btx + 48, 48);
    [self.topView addSubview:topView];
}

-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;

    [self.tab registerNib:[UINib nibWithNibName:@"HTTurnListTpyeOutViewCell" bundle:nil] forCellReuseIdentifier:@"HTTurnListTpyeOutViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTurnListTpyeInViewCell" bundle:nil] forCellReuseIdentifier:@"HTTurnListTpyeInViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDataWithType:self.type state:self.state andPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadDataWithType:self.type state:self.state andPage:self.page];
    }];
}
-(void)loadDataWithType:(NSString *) turnType state:(NSString *) turnState andPage:(int ) page{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (turnState.integerValue >= 4) {
        NSDictionary *dic = @{
                              @"swapStatus":@(turnState.integerValue - 3),
                              @"type": turnType,
                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
                              @"page":@(page),
                              @"rows":@"10"
                              };
        [dict setValuesForKeysWithDictionary:dic];
    }else{
        NSDictionary *dic = @{
                              @"signStatus":turnState,
                              @"type": turnType,
                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
                              @"page":@(page),
                              @"rows":@"10"
                              };
        [dict setValuesForKeysWithDictionary:dic];
    }
   
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,loadSwapWayBillList] params:dict success:^(id json) {
        [MBProgressHUD hideHUD];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            [self.dataArray addObject:[HTTurnListItemsModel yy_modelWithJSON:dic]];
        }
        [self.tab reloadData];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)btsArray{
    if (!_btsArray) {
        _btsArray = [NSMutableArray array];
    }
    return _btsArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)headsArray{
    if (!_headsArray) {
        _headsArray = [NSMutableArray array];
    }
    return _headsArray;
}
-(NSArray *)types{
    if (!_types) {
        _types = @[@"1",@"2",@"3",@"4",@"5",@"6",@"14",@"15",@"16"];
    }
    return _types;
}
@end
