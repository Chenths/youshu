//
//  HTNoticeListViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTMessgeModel.h"
#import "HTNoticeListViewController.h"
#import "HTMessgeTableViewCell.h"
@interface HTNoticeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@end

@implementation HTNoticeListViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时提醒列表";
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}

#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTMessgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMessgeTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.readView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
- (void)loadDadaWithPage:(int) page1{
 
    NSDictionary *dic = @{
                          @"moduleId" :[HTHoldNullObj getValueWithUnCheakValue:self.moduleId],
                          @"modelId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                          @"pageSize" :@"10",
                          @"pageNo" : [NSString stringWithFormat:@"%d",page1]
                          };
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,NoticeListLoad] params:dic success:^(id json) {
        
        if (page1 == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *dataArr = json[@"data"][@"rows"];
        for (NSDictionary *dic in dataArr) {
            HTMessgeModel *model = [[HTMessgeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.isRead = dic[@"isNotice"];
            [self.dataArray addObject:model];
        }
        [self.tab reloadData];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    } error:^{
        
        [MBProgressHUD showError:SeverERRORSTRING];
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:NETERRORSTRING];
        self.page--;
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
    }];
    
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTMessgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTMessgeTableViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDadaWithPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDadaWithPage:self.page];
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
