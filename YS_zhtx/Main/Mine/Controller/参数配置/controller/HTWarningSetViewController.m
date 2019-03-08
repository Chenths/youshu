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
@property (nonatomic, strong) NSMutableArray *headerArray;
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
    NSArray *tempArr = _dataArray[indexPath.section];
    cell.model = tempArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, HMSCREENWIDTH, 40);
    headerView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(16, 11, 100, 18);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.headerArray[section];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = _dataArray[section];
    return tempArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTEarlyWarningModel *model = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
                          @"companyId": self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId
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
                          @"companyId":self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId
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
        for (int i = 0; i < self.dataArray.count; i++) {
            NSArray *tempArr = self.dataArray[i];
            for (int j = 0 ; j < tempArr.count; j++) {
                HTEarlyWarningModel *model = tempArr[j];
                model.keyValue = [valueDic getStringWithKey:model.key];
            }
        }
//        for (HTEarlyWarningModel *model in self.dataArray) {
//            model.keyValue = [valueDic getStringWithKey:model.key];
//        }
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
- (NSMutableArray *)headerArray
{
    if (!_headerArray) {
        self.headerArray = [NSMutableArray arrayWithArray:@[@"销售月指标", @"VIP月指标", @"库存指标"]];
    }
    return _headerArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        /*
        NSArray *titles = @[@"店铺目标", @"新增VIP数量", @"老VIP月成交数", @"连带率",@"折扣率",@"VIP贡献率",@"活跃会员占比",@"销售换货率",@"销售退货率",@"剩余库存"];
        NSArray *keys = @[basedpyxse, basevipyxzs, baselvipycjs, baseldl,basezkl,basehygxl,basehyhy,basehhl,basethl,basekcbz];
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
         */
        NSArray *titles = @[@[@"店铺目标", @"折扣率", @"单量", @"连带率", @"销量", @"客单价"], @[@"新增VIP数量", @"老VIP成交数",@"VIP贡献率", @"VIP回头率", @"活跃会员占比"], @[@"剩余库存"]];
        NSArray *keys = @[@[basedpyxse,basezkl, basedl, baseldl, basexl, basekdj],@[basevipyxzs, baselvipycjs,basehygxl, basehyhtl, basehyhy],@[basekcbz]];
        NSArray *units = @[@[@"", @"", @"单", @"",@"件",@""],@[@"人",@"人",@"%",@"%",@"%"], @[@"件"]];
        NSArray *preArr = @[@[@"¥", @"", @"", @"",@"",@"¥"],@[@"",@"",@"",@"",@""], @[@""]];
        NSArray *baseKeys = @[@[@"低于", @"低于", @"低于", @"低于",@"低于",@"低于"],@[@"低于",@"低于",@"低于",@"低于",@"低于"], @[@"低于"]];
        NSArray *mostNums = @[@[@"100000000", @"10", @"10000", @"1000",@"1000000",@"1000000"],@[@"100000",@"100000",@"100",@"100",@"100"], @[@"1000"]];

        for (int i = 0; i < titles.count; i ++) {
            NSArray *tempTitle = titles[i];
            NSArray *tempKey = keys[i];
            NSArray *tempUnit = units[i];
            NSArray *tempPreArr = preArr[i];
            NSArray *tempBaseKey = baseKeys[i];
            NSArray *tempMostNum = mostNums[i];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int j = 0; j < tempTitle.count; j++) {
                HTEarlyWarningModel *model = [[HTEarlyWarningModel alloc] init];
                model.title = tempTitle[j];
                model.key = tempKey[j];
                model.keyUnit = tempUnit[j];
                model.bacekey = tempBaseKey[j];
                model.mostNum = tempMostNum[j];
                model.preStr = tempPreArr[j];
                [tempArr addObject:model];
            }
            [self.dataArray addObject:tempArr];
        }
    }
    return _dataArray;
}

@end
