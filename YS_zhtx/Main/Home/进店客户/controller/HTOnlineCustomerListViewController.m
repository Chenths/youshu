//
//  HTOnlineCustomerListViewController.m
//  有术
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTAddVipWithPhoneController.h"
#import "HTCustomerReportViewController.h"
#import "HTChargeViewController.h"
#import "HTOnlineCustomerListViewController.h"
#import "HTCustomerFaceInfoCell.h"
//#import "HTFaceVipModel.h"
#import "HTNewFaceVipModel.h"
//#import "HTFaceNotVipModel.h"
#import "HTNewFaceNoVipModel.h"
#import "MJRefresh.h"
#import "HTMenuModle.h"
#import "HTCustomerFaceVipTableViewCell.h"
#import "HTFaceComingAlertView.h"
#import "HTFastCashierViewController.h"
#import "HTChooseCustomerViewController.h"
@interface HTOnlineCustomerListViewController ()<UITableViewDelegate,UITableViewDataSource,HTCustomerFaceInfoCellDelegate, HTCustomerFaceVIPCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *datePickTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (nonatomic, copy) NSString *currentDate;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation HTOnlineCustomerListViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self.dataTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *dateStr = [user objectForKey:@"faceList"];
    if (dateStr == nil || [dateStr isEqualToString:@""]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"yyyy-MM-dd"];
        NSString *todayDateStr = [forMatter stringFromDate:date];
        self.currentDate = todayDateStr;
    }else{
        self.currentDate = dateStr;
    }
    [self getTodayDate];
//    [self loadData];
    [self.dataTableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.currentDate forKey:@"faceList"];
    [user synchronize];

}

- (void)getTodayDate{
    if (self.datePicker) {
        self.datePickTF.text = self.currentDate;
        return;
    }
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    //设置地区: zh-中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //时间字符串
    NSString *str = self.currentDate;
    //规定时间格式
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"zh"];
                        [formatter setTimeZone:zone];
                        //变回日期格式
                        NSDate *stringDate = [formatter dateFromString:str];
                        NSLog(@"stringDate = %@",stringDate);
                        
    // 设置当前显示时间
    [datePicker setDate:stringDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    
    //设置时间格式
    
    //监听DataPicker的滚动
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker = datePicker;
    
    //设置日期格式
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    //变为数字
    NSString* finialStr = [formatter1 stringFromDate:datePicker.date];
    NSLog(@"dateString = %@",finialStr);
    
    //设置时间输入框的键盘框样式为时间选择器
    self.datePickTF.inputView = datePicker;
    self.currentDate = finialStr;

    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barTintColor = [UIColor whiteColor];
    toolbar.frame = CGRectMake(0, 0, HMSCREENWIDTH, 44);
    
    UIButton *finishBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(HMSCREENWIDTH - 16 - 80, 0, 80, 44);
    [finishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(touchFinish) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    UIButton *temp1 =[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *temp2 =[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *temp3 =[UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:temp1];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:temp2];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:temp3];
    
    toolbar.items = @[item1, item2, item3, item];
    self.datePickTF.inputAccessoryView = toolbar;
    self.datePickTF.text = self.currentDate;
    NSLog(@"dateStr =  %@",self.currentDate);
}

- (void)touchFinish{
    [_datePickTF resignFirstResponder];
//    [self loadData];
    [self.dataTableView.mj_header beginRefreshing];
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    
    //设置时间输入框的键盘框样式为时间选择器
    self.datePickTF.inputView = datePicker;
    self.datePickTF.text = dateStr;
    self.currentDate = dateStr;
}


//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.usrType == HTUSRERVIP) {
        //VIP
        HTCustomerFaceVipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerFaceVipTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (self.dataArray.count > 0) {
            cell.vipModel = self.dataArray[indexPath.row];
            
        }
        return cell;
    }else{
        //非VIP
        HTCustomerFaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerFaceInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        HTNewFaceNoVipModel *model = self.dataArray[indexPath.row];
        model.userVipName = [NSString stringWithFormat:@"%@%ld",@"散客",indexPath.row + 1];
        if (_dataArray.count > 0) {
            cell.notVipModel = self.dataArray[indexPath.row];            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.usrType == HTUSRERVIP) {
        HTNewFaceVipModel *model = self.dataArray[indexPath.row];
//        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
//        HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
//        mmm.custId = model.customerId;
//        vc.customerType = HTCustomerReportTypeNomal;
//        vc.model = mmm;
//        [self.navigationController pushViewController:vc animated:YES];
        UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
        for (UIView *vvv in window.subviews) {
            if ([vvv isKindOfClass:[HTFaceComingAlertView class]]) {
                [vvv removeFromSuperview];
            }
        }
        [HTFaceComingAlertView showWithDatas:@[model] hiddenBottomBtn:YES isNew:NO];
    }else{
//        HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
//        HTNewFaceNoVipModel *model = self.dataArray[indexPath.row];
//        for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
//            if ([mmm.moduleName isEqualToString:@"customer"]) {
//                vc.moduleId = [mmm.moduleId stringValue];
//                break;
//            }
//        }
//        vc.faceModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
        HTNewFaceVipModel *model = self.dataArray[indexPath.row];
        UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
        for (UIView *vvv in window.subviews) {
            if ([vvv isKindOfClass:[HTFaceComingAlertView class]]) {
                [vvv removeFromSuperview];
            }
        }
        [HTFaceComingAlertView showWithDatas:@[model] hiddenBottomBtn:YES isNew:YES];
    }
}
#pragma mark -CustomDelegate
-(void)receptionCustmerWithCell:(HTCustomerFaceInfoCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceVipModel *model = self.dataArray[index.row];
    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
    HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
    mmm.custId = model.customerId;
    vc.customerType = HTCustomerReportTypeNomal;
    vc.model = mmm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)repitBuyWithCell:(HTCustomerFaceInfoCell *)cell{
    if ([HTShareClass shareClass].isProductActive) {
        HTChargeViewController *vc = [[HTChargeViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerId = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }else{
        HTFastCashierViewController *vc = [[HTFastCashierViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerid = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}

- (void)writeCutomerInfoWithCell:(HTCustomerFaceInfoCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceVipModel *model = self.dataArray[index.row];
    
    //1 是创建 新会员 2 编辑老会员
    [LPActionSheet showActionSheetWithTitle:@"请选择您的操作" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"创建新会员",@"编辑老会员"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
            NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
            HTNewFaceNoVipModel *model = self.dataArray[index.row];
            for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
                if ([mmm.moduleName isEqualToString:@"customer"]) {
                    vc.moduleId = [mmm.moduleId stringValue];
                    break;
                }
            }
            vc.faceModel = model;
            vc.path = model.snapPath;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {
            HTChooseCustomerViewController *vc = [[HTChooseCustomerViewController alloc] init];
            vc.isFromFace = YES;
            NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
            HTNewFaceNoVipModel *model = self.dataArray[index.row];
            vc.faceNoVipModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
}

#pragma mark -CustomDelegate
-(void)receptionCustmerVipWithCell:(HTCustomerFaceInfoCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceVipModel *model = self.dataArray[index.row];
    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
    HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
    mmm.custId = model.customerId;
    vc.customerType = HTCustomerReportTypeNomal;
    vc.model = mmm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)repitBuyVipWithCell:(HTCustomerFaceInfoCell *)cell{
    if ([HTShareClass shareClass].isProductActive) {
        HTChargeViewController *vc = [[HTChargeViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerId = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }else{
        HTFastCashierViewController *vc = [[HTFastCashierViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerid = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}

- (void)writeCutomerInfoVipWithCell:(HTCustomerFaceInfoCell *)cell{
    HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceNoVipModel *model = self.dataArray[index.row];
    for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
        if ([mmm.moduleName isEqualToString:@"customer"]) {
            vc.moduleId = [mmm.moduleId stringValue];
            break;
        }
    }
    vc.faceModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -EventResponse

#pragma mark -private methods
- (void)loadData{
    /*
    if (self.usrType == HTUSRERVIP) {
//        @property (nonatomic, copy) NSString * customerId;
//        @property (nonatomic, copy) NSString * customerName;
//        @property (nonatomic, copy) NSString * enterTime;
//        @property (nonatomic, copy) NSString * level;
//        //老图
//        @property (nonatomic, copy) NSString * libPath;
//        @property (nonatomic, copy) NSString * phone;
//        @property (nonatomic, copy) NSString * sex;
//        //新图
//        @property (nonatomic, copy) NSString * snapPath;
        NSArray *vip = @[@{@"customerId" : @"1",
                           @"customerName":@"老王",
                           @"enterTime":@"11:20:33",
                           @"level":@"白银会员",
                           @"libPath":@"",
                           @"phone":@"1821321312",
                           @"sex":@"男",
                           @"snapPath":@""}];
        for (NSDictionary *dic1 in vip) {
            HTNewFaceVipModel *model = [[HTNewFaceVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:model];
        }
    }else{
//        @property (nonatomic, copy) NSString *enterTime;
//        @property (nonatomic, copy) NSString *path;
//        @property (nonatomic, copy) NSString *userVipName;
        NSArray *notVip = @[@{@"enterTime" : @"11:20:33",
                              @"path":@"",
                              @"userVipName":@"傻逼白"}];
        for (NSDictionary *dic1 in notVip) {
            HTNewFaceNoVipModel *model = [[HTNewFaceNoVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:model];
        }
    }
    [self.dataTableView.mj_header endRefreshing];
    [self.dataTableView reloadData];
         
         */
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"dayTime": _currentDate
                          };
//    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFace,faceUserList] params:dic success:^(id json) {
//        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        if (self.usrType == HTUSRERVIP) {
            NSArray *vip = [json[@"data"] getArrayWithKey:@"vip"];
            if (vip.count == 0) {
                [MBProgressHUD showError:@"暂无数据"];
            }
            for (NSDictionary *dic1 in vip) {
                HTNewFaceVipModel *model = [[HTNewFaceVipModel alloc] init];
                [model setValuesForKeysWithDictionary:dic1];
                [self.dataArray addObject:model];
            }
        }else{
            NSArray *notVip = [json[@"data"] getArrayWithKey:@"individaul"];
            if (notVip.count == 0) {
                [MBProgressHUD showError:@"暂无数据"];
            }
            for (NSDictionary *dic1 in notVip) {
                    HTNewFaceNoVipModel *model = [[HTNewFaceNoVipModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [self.dataArray addObject:model];
            }
        }
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView reloadData];
    } error:^{
//        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"请检查你的网络" toView:self.view];
    }];
     
}
-(void)createTb{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTCustomerFaceInfoCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerFaceInfoCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTCustomerFaceVipTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerFaceVipTableViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    self.dataTableView.tableFooterView = v ;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    //设置预估行高
    _dataTableView.estimatedRowHeight = 98;
    _dataTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
