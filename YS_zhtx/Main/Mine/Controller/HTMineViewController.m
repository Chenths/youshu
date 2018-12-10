//
//  YHMineViewController.m
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
#import "HTMeGoalsTableViewCell.h"
#import "HTMESaleInfoTableViewCell.h"
#import "HTMeBaceInfoTableViewCell.h"
#import "HTMineViewController.h"
#import "HTGoalsDescModel.h"
#import "HTMonthOrYearGoalsDescCell.h"
#import "HTParameterSetsCenterController.h"
#import "HTVersionsIntroduceController.h"
#import "HTTotleExplainViewController.h"
#import "HTMineSetViewController.h"
#import "HTPrinterViewController.h"
#import "MainTabBarViewController.h"
#import "HTBindWechatController.h"
#import "HTContactUsViewController.h"
#import "HTLineDataReportTableViewCell.h"
#import "HTMineModel.h"

@interface HTMineViewController ()<UITableViewDelegate,UITableViewDataSource,HTMeGoalsTableViewCellDelegate,UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) HTGoalsDescModel *goalsDescmodel;

@property (nonatomic,strong) NSArray *titls;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataBottomHeight;

@property (nonatomic,strong) HTMineModel *mineModel;


@end

@implementation HTMineViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    [self createTb];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self laodNoRedNum];
    [self loadData];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.cellsName[section];
    return [arr count];
 }
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsName.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 11;
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSArray *names = self.cellsName[indexPath.section];
    NSString *cellname = names[indexPath.row];
    if ([cellname isEqualToString:@"HTMeBaceInfoTableViewCell"]) {
        HTMeBaceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMeBaceInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.mineModel;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }else if ([cellname isEqualToString:@"HTMeGoalsTableViewCell"]){
        HTMeGoalsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMeGoalsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.descM = self.goalsDescmodel;
        cell.model = self.mineModel;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.delegate = self;
        return cell;
    }else if ([cellname isEqualToString:@"HTMonthOrYearGoalsDescCell"]){
        HTMonthOrYearGoalsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMonthOrYearGoalsDescCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.descM = self.goalsDescmodel;
        cell.model = self.mineModel;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }else if ([cellname isEqualToString:@"HTMESaleInfoTableViewCell"]){
        HTMESaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMESaleInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.mineModel;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }else if ([cellname isEqualToString:@"HTLineDataReportTableViewCell"]){
        HTLineDataReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLineDataReportTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isDefual = YES;
        cell.dataArray = self.mineModel.amountList;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ceeee"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ceeee"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.titls[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        cell.imageView.image = [UIImage imageNamed:self.titls[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        NSString *str = self.titls[indexPath.row];
        if ([str isEqualToString:@"参数配置"]) {
            HTParameterSetsCenterController *vc = [[HTParameterSetsCenterController alloc] init];
            vc.title = @"参数配置";
            [self.navigationController pushViewController:vc animated:YES];
        }else if( [str isEqualToString:@"版本介绍"]){
            HTVersionsIntroduceController *vc = [[HTVersionsIntroduceController alloc] init];
            vc.title = @"版本介绍";
            [self.navigationController pushViewController:vc animated:YES];
        }else if( [str isEqualToString:@"使用说明"]){
            HTTotleExplainViewController *vc = [[HTTotleExplainViewController alloc] init];
            vc.title = @"使用说明";
            [self.navigationController pushViewController:vc animated:YES];
        }else if( [str isEqualToString:@"设置"]){
            HTMineSetViewController *vc = [[HTMineSetViewController alloc] init];
            vc.title = @"使用说明";
            [self.navigationController pushViewController:vc animated:YES];
        }else if( [str isEqualToString:@"打印设备管理"]){
            HTPrinterViewController *vc = [[HTPrinterViewController alloc] init];
            vc.title = @"打印设备管理";
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([str isEqualToString:@"售后服务"]){
            HTContactUsViewController *vc = [[HTContactUsViewController alloc] init];
            vc.title = @"售后服务";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -CustomDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    UINavigationController *nav = (id)viewController;
//    if ([nav.topViewController isKindOfClass:[self class]]) {
//        [self loadData];
//    }
}
-(void)todayGoalClicked{
    if (self.goalsDescmodel.selectedGoalstype == HTSelectedGoalsTypeToday && self.goalsDescmodel.isOpen == YES) {
        self.goalsDescmodel.isOpen = NO;
        self.goalsDescmodel.selectedGoalstype = HTSelectedGoalsTypeNomal;
        [self.cellsName replaceObjectAtIndex:0 withObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell"]];
    }else{
        self.goalsDescmodel.isOpen = YES;
        self.goalsDescmodel.selectedGoalstype = HTSelectedGoalsTypeToday;
        [self.cellsName replaceObjectAtIndex:0 withObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell",@"HTLineDataReportTableViewCell"]];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
    [self.dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)monthGoalClicked{
//    月目标完成情况点击判断
    if (self.goalsDescmodel.selectedGoalstype == HTSelectedGoalsTypeMonth && self.goalsDescmodel.isOpen == YES) {
        self.goalsDescmodel.isOpen = NO;
        self.goalsDescmodel.selectedGoalstype = HTSelectedGoalsTypeNomal;
        [self.cellsName replaceObjectAtIndex:0 withObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell"]];
    }else{
        self.goalsDescmodel.isOpen = YES;
        self.goalsDescmodel.selectedGoalstype = HTSelectedGoalsTypeMonth;
        [self.cellsName replaceObjectAtIndex:0 withObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell",@"HTMonthOrYearGoalsDescCell"]];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
    [self.dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)yaerGoalClicked{
    if (self.goalsDescmodel.selectedGoalstype == HTSelectedGoalsTypeYear && self.goalsDescmodel.isOpen == YES) {
        self.goalsDescmodel.isOpen = NO;
        self.goalsDescmodel.selectedGoalstype = HTSelectedGoalsTypeNomal;
        [self.cellsName replaceObjectAtIndex:0 withObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell"]];
    }else{
        self.goalsDescmodel.isOpen = YES;
        self.goalsDescmodel.selectedGoalstype = HTSelectedGoalsTypeYear;
        [self.cellsName replaceObjectAtIndex:0 withObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell",@"HTMonthOrYearGoalsDescCell"]];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
    [self.dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)loadData{

    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,LoadPersonOwnReport] params:@{@"companyId":[HTShareClass shareClass].loginModel.companyId} success:^(id json) {
        [MBProgressHUD hideHUD];
        self.mineModel = [HTMineModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
- (void)createTb{
    
    self.backImg = @"";
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMeGoalsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTMeGoalsTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMESaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTMESaleInfoTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMeBaceInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTMeBaceInfoTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMonthOrYearGoalsDescCell" bundle:nil] forCellReuseIdentifier:@"HTMonthOrYearGoalsDescCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTLineDataReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTLineDataReportTableViewCell"];
    
    self.dataTableView.backgroundColor = [UIColor clearColor];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    self.dataTableView.estimatedRowHeight = 300;
        self.dataBottomHeight.constant = tar_height + SafeAreaBottomHeight;
}
- (void)laodNoRedNum{
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        if (json[@"data"][@"count"]) {
            MainTabBarViewController *tab = (id)[[UIApplication sharedApplication].delegate window].rootViewController;
            [tab.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}
#pragma mark - getters and setters
-(HTGoalsDescModel *)goalsDescmodel{
    if (!_goalsDescmodel) {
        _goalsDescmodel = [[HTGoalsDescModel alloc] init];
    }
    return _goalsDescmodel;
}
- (NSArray *)titls{
    if (!_titls) {
        _titls = @[@"参数配置",@"打印设备管理",@"使用说明",@"版本介绍",@"售后服务",@"设置"];
    }
    return _titls;
}
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTMeBaceInfoTableViewCell",@"HTMeGoalsTableViewCell"]];
        [_cellsName addObject:@[@"HTMESaleInfoTableViewCell"]];
         [_cellsName addObject:@[@"UITableViewCell",@"UITableViewCell",@"UITableViewCell",@"UITableViewCell",@"UITableViewCell",@"UITableViewCell"]];
    }
    return _cellsName;
}
-(HTMineModel *)mineModel{
    if (!_mineModel) {
        _mineModel = [[HTMineModel alloc] init];
    }
    return _mineModel;
}
@end
