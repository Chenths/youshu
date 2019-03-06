//
//  HTDataPropressLineCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTHorizontalReportDataModel.h"
#import "HTSinglePropresslineCell.h"
#import "HTDataPropressLineCell.h"
#import "HTCustomerViewController.h"
@interface HTDataPropressLineCell()<UITableViewDataSource,UITableViewDelegate, SinglePropressDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeight;
@property (nonatomic,strong) NSString *max;

@end
@implementation HTDataPropressLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createTb];
}
#pragma mark -life cycel
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titlelabel.text = [HTHoldNullObj getValueWithUnCheakValue:title];
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    CGFloat max = 1.0f;
    for (HTHorizontalReportDataModel *model in dataArray) {
        if (model.val.floatValue >= max) {
            max = model.val.floatValue;
        }
    }
    self.max = [NSString stringWithFormat:@"%lf",max];
    self.tabHeight.constant = 80 * dataArray.count;
    [self.tab reloadData];
}

-(void)setSecondArray:(NSArray *)secondArray{
    _secondArray = secondArray;
    CGFloat max = 1.0f;
    for (HTHorizontalReportDataModel *model in secondArray) {
        if (model.val.floatValue >= max) {
            max = model.val.floatValue;
        }
    }
    self.max = [NSString stringWithFormat:@"%lf",max];
    self.tabHeight.constant = 80 * secondArray.count;
    [self.tab reloadData];
}

#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTSinglePropresslineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSinglePropresslineCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    HTHorizontalReportDataModel *model =  self.dataArray[indexPath.row];
    model.color = [UIColor colorWithHexString:@"#614DB6"];
    model.max = self.max;
    cell.model = model;
    HTHorizontalReportDataModel *secondModel =  self.secondArray[indexPath.row];
    secondModel.color = [UIColor colorWithHexString:@"#FC5C7D"];
    secondModel.max = self.max;
    cell.indexPath = indexPath;
    cell.secondModel = secondModel;
    return cell;
}

- (void)selectBtnWithIfTopBtn:(BOOL)isTop WithIndexRow:(NSInteger)row{
    if (isTop) {
        HTHorizontalReportDataModel *model =  self.dataArray[row];
        HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
        vc.backImg = @"g-back";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.beginTime] forKey:@"beginDate"];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.endTime] forKey:@"endDate"];
        if ([self.title isEqualToString:@"频次分布"]) {
            [dic setObject:@(row + 1) forKey:@"rate"];
            vc.title = [NSString stringWithFormat:@"%@次",@(row + 1)];
        }else{
            [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.start] forKey:@"beginMoney"];
            [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.end] forKey:@"endMoney"];
            vc.title = model.key;
        }
        vc.sendDic = dic;
        vc.companyId = self.companyId;
        if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
            [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
            return;
        }else{
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
    }else{
        HTHorizontalReportDataModel *model =  self.secondArray[row];
        HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
        vc.backImg = @"g-back";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.secBeginTime] forKey:@"beginDate"];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.secEndTime] forKey:@"endDate"];
        if ([self.title isEqualToString:@"频次分布"]) {
            [dic setObject:@(row + 1) forKey:@"rate"];
            vc.title = [NSString stringWithFormat:@"%@次",@(row + 1)];
        }else{
            [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.start] forKey:@"beginMoney"];
            [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.end] forKey:@"endMoney"];
            vc.title = model.key;
        }
        vc.sendDic = dic;
        vc.companyId = self.companyId;
        if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
            [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
            return;
        }else{
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    HTHorizontalReportDataModel *model =  self.dataArray[indexPath.row];
    HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
    vc.backImg = @"g-back";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.beginTime] forKey:@"beginDate"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.endTime] forKey:@"endDate"];
    if ([self.title isEqualToString:@"频次分布"]) {
        [dic setObject:@(indexPath.row + 1) forKey:@"rate"];
        vc.title = [NSString stringWithFormat:@"%@次",@(indexPath.row + 1)];
    }else{
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.start] forKey:@"beginMoney"];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.end] forKey:@"endMoney"];
        vc.title = model.key;
    }
    vc.sendDic = dic;
    vc.companyId = self.companyId;
     if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
         [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
         return;
     }else{
       [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
     }
     */
    
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTSinglePropresslineCell" bundle:nil] forCellReuseIdentifier:@"HTSinglePropresslineCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.scrollEnabled = NO;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabHeight.constant = 80 * 6;
}
#pragma mark - getters and setters

@end
