//
//  HTBossSelecteTimeController.m
//  有术
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "NSDate+Manager.h"
#import "HcdDateTimePickerView.h"
#import "HTBossSelecteCompareTimeController.h"

@interface HTBossSelecteCompareTimeController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *alertTableView;

@property (nonatomic,strong) NSArray *alertArr;

@property (nonatomic,strong) NSArray *dateArray;

@end

@implementation HTBossSelecteCompareTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择时间";
    [self createTb];
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
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.frame = CGRectMake(0, 0, HMSCREENWIDTH, 48);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = self.alertArr[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        return cell;
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.alertArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.alertTableView) {
        if ([self.alertArr[indexPath.row] isEqualToString:@"自定义"]) {
            HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
            dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
            __weak typeof(self)  weakSelf = self;
            dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.sendTime(beginTime, endTime);
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } ;
             [self.view addSubview:dateTimePickerView];
            [dateTimePickerView showHcdDateTimePicker];
        }else{
            NSArray *date = self.dateArray[indexPath.row];
            self.sendTime(date[0], date[1]);
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.alertTableView.dataSource = self;
    self.alertTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.alertTableView.tableFooterView = footView;
}
#pragma mark - getters and setters
- (NSArray *)alertArr{
    if (!_alertArr) {
        _alertArr = @[@"今日",@"最近七天",@"本月",@"本年",@"自定义"];
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        
        NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
        [yearF2 setDateFormat:@"dd"];
        
        NSDateFormatter * yearF3 = [[NSDateFormatter alloc] init];
        [yearF3 setDateFormat:@"YYYY"];
        
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        NSString *whichDay = [yearF2 stringFromDate:[NSDate date]];
        NSString *last7day = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-6]];
        NSString *thisMonth = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-1 * (whichDay.integerValue - 1)]];
        NSString *thisYear =  [yearF3 stringFromDate:[NSDate date] ];
        _dateArray = @[@[today,today],@[last7day,today],@[thisMonth,today],@[[NSString stringWithFormat:@"%@-01-01",thisYear],today],@[]];
    }
    return _alertArr;
}
@end
