//
//  HTBossSelecteTimeController.m
//  有术
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossSelectedTimeModel.h"
#import "HTBossSelecteTimeController.h"
#import "HTBossSelecteShopsController.h"
#import "HcdDateTimePickerView.h"
@interface HTBossSelecteTimeController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HTBossSelecteTimeController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择对比时间";
    [self createTb];
    [self createData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}
- (BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HTBossSelectedTimeModel *model = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"222222"];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    if (model.companyName.length > 0) {
        cell.detailTextLabel.text = model.companyName;
    }else if (model.beginTime.length > 0 && model.endTime.length > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",model.beginTime,model.endTime];
    }else{
        cell.detailTextLabel.text =@"未选择";
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       HTBossSelectedTimeModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        HTBossSelecteShopsController *vc = [[HTBossSelecteShopsController alloc] init];
        vc.maxSelected = 1;
        __weak typeof(self)  weakSelf = self;
        vc.selectedCompany = ^(HTCompanyListModel *model1) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            model.isCompany = YES;
            model.companyId = model1.companyId;
            model.companyName = model1.name;
            [strongSelf.dataTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self)  weakSelf = self;
        dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            model.beginTime = beginTime;
            model.endTime = endTime;
            model.isCompany = NO;
            [strongSelf.dataTableView reloadData];
        } ;
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)compareCliked:(id)sender {
//    if (self.selectedArray.count == 1) {
//        [MBProgressHUD showError:@"请选择至少两家店铺进行对比"];
//        return;
//    }
    NSMutableArray *arr = [NSMutableArray array];
//    for (HTCompanyListModel *model in self.selectedArray) {
//        NSDictionary *dic = @{
//                              @"id":[HTHoldNullObj getValueWithUnCheakValue:model.companyId],
//                              @"name":[HTHoldNullObj getValueWithUnCheakValue:model.name]
//                              };
//        [arr addObject:dic];
//    }
    HTBossSelectedTimeModel *model1 = [self.dataArray firstObject];
    if (model1.companyName.length == 0) {
        [MBProgressHUD showError:@"请选择对比店铺"];
        return;
    }
    int selectedTime = 0;
    NSMutableDictionary *dateDic = [NSMutableDictionary dictionary];
    NSMutableArray *dateArr= [NSMutableArray array];
    for (int i = 1; i < self.dataArray.count; i++) {
        HTBossSelectedTimeModel *model = self.dataArray[i];
        if (model.beginTime.length > 0 && model.endTime.length > 0) {
            selectedTime++;
            [dateArr addObject:[NSString stringWithFormat:@"%@——%@",model.beginTime,model.endTime]];
        }
    }
    if (selectedTime < 2) {
        [MBProgressHUD showError:@"请选择至少两个时间段"];
        return;
    }
    if (self.selectedTimes.count > 0) {
        if (self.changeselectedTime) {
            self.changeselectedTime(model1.companyName, model1.companyId, dateArr);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [dateDic setObject:dateArr forKey:@"date"];
    [dateDic setObject:model1.companyName forKey:@"brandName"];
    [dateDic setObject:[HTHoldNullObj getValueWithUnCheakValue:model1.companyId] forKey:@"brandId"];
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"type":@"2",
                          @"date":[dateDic jsonStringWithDic]
                          };
    [MBProgressHUD showMessage:@"请稍等..."];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"save_compare_company_id_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];

}
#pragma mark -private methods
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle =  UITableViewCellAccessoryNone;
}
-(void)createData{
    NSArray *titles = @[@"对比店铺",@"对比时间1",@"对比时间2",@"对比时间3"];
    
    for (int i = 0 ; i < titles.count; i++) {
         HTBossSelectedTimeModel *model = [[HTBossSelectedTimeModel alloc] init];
        
        if (i == 0) {
            model.isCompany = YES;
            if (self.selectedTimes.count > 0 && self.selectedTimes.count >= i + 1) {
                HTBossSelectedTimeModel *model1 = self.selectedTimes[i];
                model.companyName = model1.companyName;
                model.companyId = model1.companyId;
            }
        }else{
            if (self.selectedTimes.count > 0 && self.selectedTimes.count >= i + 1) {
                HTBossSelectedTimeModel *model1 = self.selectedTimes[i];
                model.beginTime = model1.beginTime;
                model.endTime = model1.endTime;
            }
        }
        model.title = titles[i];
        
         [self.dataArray addObject:model];
    }
    [self.dataTableView reloadData];
}
#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
