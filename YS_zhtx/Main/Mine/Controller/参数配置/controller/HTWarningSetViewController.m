//
//  HTWarningSetViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTWarningDefaulTableCell.h"
#import "HTWarningSetViewController.h"
#import "HTSetWarningAlertView.h"
#import "HTEarlyWarningModel.h"
@interface HTWarningSetViewController ()<UITableViewDataSource,UITableViewDelegate,HTSetWarningAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HTWarningSetViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createTb];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTWarningDefaulTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTWarningDefaulTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTEarlyWarningModel *model = self.dataArray[indexPath.row];
    HTSetWarningAlertView *alert = [[HTSetWarningAlertView alloc] initWithAlert];
    alert.model = model;
    alert.delegate = self;
    [alert show];
}
#pragma mark -CustomDelegate
-(void)okClickedWithModel:(HTEarlyWarningModel *)model{
    NSDictionary *dic = @{
                          @"key":model.key,
                          @"value":model.keyValue,
                          @"defau":@"1",
                          @"companyId": self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleConfig,updateConfig4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([json getStringWithKey:@"state"]) {
            [self.tab reloadData];
        }
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleConfig,loadCompanyConfig4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataArr = [json getDictionArrayWithKey:@"data"];
        NSString *valuestr = [dataArr getStringWithKey:@"value"];
        self.editTime = [[dataArr getStringWithKey:@"editDateStr"] length] > 11 ? [[dataArr getStringWithKey:@"editDateStr"] substringWithRange:NSMakeRange(0, 11)] : [dataArr getStringWithKey:@"editDateStr"];
        self.editName = [[dataArr getStringWithKey:@"editorName"] isNull] ? @"老板层级" : [dataArr getStringWithKey:@"editorName"];
        self.descLabel.text = [NSString stringWithFormat:@"最近修改 %@ %@",self.editTime,self.editName];
        NSDictionary *valueDic = [valuestr dictionaryWithJsonString];
        for (HTEarlyWarningModel *model in self.dataArray) {
            model.keyValue = [valueDic getStringWithKey:model.key];
        }
        [self.tab reloadData];
    } error:^{
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
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTWarningDefaulTableCell" bundle:nil] forCellReuseIdentifier:@"HTWarningDefaulTableCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *titles = @[@"店铺月销售额", @"VIP月新增数", @"老VIP月成交数", @"连带率",@"折扣率",@"老VIP贡献率",@"活跃会员比例",@"销售换货率",@"销售退货率",@"剩余库存"];
        NSArray *keys   = @[basedpyxse, basevipyxzs, baselvipycjs, baseldl,basezkl,basehygxl,basehyhy,basehhl,basethl,basekcbz];
        NSArray *units = @[@"", @"", @"", @"",@"",@"%",@"%",@"%",@"%",@"件"];
        NSArray *baseKeys = @[@"低于", @"低于", @"低于", @"低于",@"低于",@"低于",@"低于",@"高于",@"高于",@"低于"];
        NSArray *mostNums = @[@(100000000), @(1000000), @(1000000), @(10),@(10),@(100),@(100),@(100),@(100),@"1000000"];
        for (int i = 0; i < titles.count; i ++) {
            HTEarlyWarningModel *model = [[HTEarlyWarningModel alloc] init];
            model.title = titles[i];
            model.key = keys[i];
            model.keyUnit = units[i];
            model.bacekey = baseKeys[i];
            model.mostNum = mostNums[i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

@end
