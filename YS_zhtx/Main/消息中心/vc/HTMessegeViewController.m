//
//  HTMessegeViewController.m
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTJumpTools.h"
#import "HTMessgeModel.h"
#import "HTMessgeTableViewCell.h"
#import "HTMessegeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MJRefresh.h"
@interface HTMessegeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int page;
    NSIndexPath *index;
}
@property (weak, nonatomic) IBOutlet UITableView *messgeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@end



@implementation HTMessegeViewController
@synthesize dataArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1 ;
    self.title = @"通知中心";
    [self createMessgeTb];
   [self.messgeTableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (index && (self.dataArray.count - 1) >= index.row) {
        
        if ([self.type isEqualToString:@"BILL_MANIFEST"]) {
            [self.messgeTableView.mj_header beginRefreshing];
        }else{
           [self.messgeTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void)loadDadaWithPage:(int) page1{
    
    if (!dataArray) {
        dataArray = [NSMutableArray array];
    }
    NSDictionary *dic = @{
                          @"type" :self.type,
                          @"state":[self.state length] > 0 ? self.state : @"",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"rows" :@"10",
                          @"page" : [NSString stringWithFormat:@"%d",page1]
                          };
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeList4App] params:dic success:^(id json) {
        
        if (page1 == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *dataArr = json[@"data"][@"rows"];
        for (NSDictionary *dic in dataArr) {
            HTMessgeModel *model = [[HTMessgeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ([self.state isEqualToString:@"WILL"]) {
                model.isWill = YES;
            }
            model.showState = self.showState;
            [self->dataArray addObject:model];
        }
        
        
        [self.messgeTableView reloadData];
        [self.messgeTableView.mj_footer endRefreshing];
        [self.messgeTableView.mj_header endRefreshing];
        
        
    } error:^{
        self->page--;
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.messgeTableView.mj_footer endRefreshing];
        [self.messgeTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        self->page--;
        [MBProgressHUD showError:@"网络异常，请稍后再试"];
        [self.messgeTableView.mj_footer endRefreshing];
        [self.messgeTableView.mj_header endRefreshing];
    }];
    
}
- (void)createMessgeTb{
    _messgeTableView.tableFooterView = [UIView new];
    _messgeTableView.delegate = self ;
    _messgeTableView.dataSource = self;
    
    [_messgeTableView registerNib:[UINib nibWithNibName:@"HTMessgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellll"];
    _messgeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self loadDadaWithPage:self->page];
    }];
    _messgeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page++;
        [self loadDadaWithPage:self->page];
        
    }];
    _messgeTableView.rowHeight = UITableViewAutomaticDimension;
    _messgeTableView.estimatedRowHeight = 300;
    self.tabBottomHeight.constant =  SafeAreaBottomHeight ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTMessgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellll" forIndexPath:indexPath];
    cell.model = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HTMessgeModel *model = dataArray[indexPath.row];
    NSString *type = model.noticeType;
    index = indexPath;
    if (model.isRead.intValue == 0) {
        [HTShareClass shareClass].badge = [NSString stringWithFormat:@"%ld", [[HTShareClass shareClass].badge integerValue] - 1 ];
    }
   
    if (![self.state isEqualToString:@"WILL"] && !( [type isEqualToString:@"TUNE_MANIFEST_OUT"] ||[type isEqualToString:@"TUNE_MANIFEST_IN"]||[type isEqualToString:@"STOCK_TAKING"])) {
          model.isRead = @"1";
        NSDictionary *dic = @{
                              @"id":model.messgeId,
                              @"companyId":[HTShareClass shareClass].loginModel.companyId
                              };
        
        [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,userReadNotice4App] params:dic success:^(id json) {
        } error:^{
        } failure:^(NSError *error) {
        }];
    }
    [HTJumpTools jumpWithStr:type withDic:@{
                                            @"modelId":[HTHoldNullObj getValueWithUnCheakValue:model.modelId],
                                            @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:model.moduleId],
                                            @"date": [HTHoldNullObj getValueWithUnCheakValue:model.noticeAt],
                                            @"noticeId":[HTHoldNullObj getValueWithUnCheakValue:model.messgeId],
                                            @"noticeParams" :[HTHoldNullObj getValueWithUnCheakValue: model.noticeParams]
                                          }];
}
- (NSString *)retun {
    return @"";
}



@end
