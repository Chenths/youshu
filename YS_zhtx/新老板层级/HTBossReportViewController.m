//
//  HTBossReportViewController.m
//  有术
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossSaleBasicInfoCell.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTBossDayRankListCell.h"
#import "HTStaffSaleRankListCell.h"
#import "HTBossReportViewController.h"
#import "HTBossSelectedShopView.h"
#import "HTBossSectionReportView.h"
#import "HTBossReportBasciModel.h"
#import "HTDaySaleRankModel.h"
#import "HTStaffSaleRankListModel.h"
#import "HTSectionOpenModel.h"
#import "HTBossLineReportCell.h"
#import "HcdDateTimePickerView.h"
#import "NSDate+Manager.h"
#import "HTCompanyListModel.h"
#import "HTBossCompareViewController.h"
#import "NSDate+Manager.h"
#import "HTPiesModel.h"
@interface HTBossReportViewController ()<UITableViewDataSource,UITableViewDelegate,HTBossSelectedShopViewDelegate,HTNewPieCellTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *sectionTitleArray;

@property (nonatomic,strong) NSString *ids;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomHeight;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;

@property (nonatomic,strong) HTBossSelectedShopView *selectedShopView;
//第一组数据
@property (nonatomic,strong) NSMutableArray *firstSectionArray;
//第2组数据
@property (nonatomic,strong) NSMutableArray *secondSectionArray;
////第3组数据
@property (nonatomic,strong) NSMutableArray *thirdSectionArray;
////第4组数据
@property (nonatomic,strong) NSMutableArray *fourthSectionArray;
//第5组数据
@property (nonatomic,strong) NSMutableArray *fifthSectionArray;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,strong) NSMutableArray *companys;

@property (nonatomic,strong) UIView *tapView;

@property (nonatomic,strong) UITableView *alertTableView;

@property (nonatomic,strong) NSArray *alertArr;

@property (nonatomic,strong) NSArray *dateArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BtbottomConstains;

@end

@implementation HTBossReportViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ids = @"";
    [self loadCompanyListData];
    [self createTime];
    [self createTapView];
    [self createTb];
}
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.alertTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.frame = CGRectMake(0, 0, HMSCREENWIDTH, 48);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = self.alertArr[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        return cell;
    }else{
    switch (indexPath.section) {
        case 0:
            {
                HTBossSaleBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleBasicInfoCell" forIndexPath:indexPath];
                cell.model = self.dataArray[indexPath.section][indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                return cell;
            }
            break;
        case 2:
        {
            HTNewPieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPieCellTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.dataDic = self.thirdSectionArray[indexPath.row];
            cell.delegate = self;
            cell.model = self.thirdSectionArray[indexPath.row];
            return cell;
            
        }
            break;
        case 3:
        {
            HTBossDayRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossDayRankListCell" forIndexPath:indexPath];
            HTDaySaleRankModel *model = self.dataArray[indexPath.section][indexPath.row];
            model.index = indexPath.row;
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 4:
        {
            HTStaffSaleRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTStaffSaleRankListCell" forIndexPath:indexPath];
            cell.model = self.fifthSectionArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor whiteColor];
            }else{
                cell.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            HTBossLineReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossLineReportCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataArr = self.secondSectionArray[indexPath.row];
            return cell;
        }
            break;
        default:{
            UITableViewCell *cell = [[UITableViewCell alloc ] init];
            return cell;
        }
            break;
    }
    }
    UITableViewCell *cell = [[UITableViewCell alloc ] init];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HTSectionOpenModel *model = self.sectionTitleArray[section];
    return tableView == self.alertTableView ? self.alertArr.count :  model.isOpen ?  [self.dataArray[section] count] : 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tableView == self.alertTableView ? 1 : self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HTBossSectionReportView *sectionView = [[HTBossSectionReportView alloc] initWithSectionFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    HTSectionOpenModel *model = self.sectionTitleArray[section];
    
    sectionView.titleLabel.text = model.title;
    sectionView.model = self.sectionTitleArray[section] ;
    sectionView.sectionOpenBt.tag = 500 + section;
    [sectionView.sectionOpenBt addTarget:self action:@selector(sectionOpenBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (section % 2 == 0) {
        sectionView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    }else{
        sectionView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    }
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView == self.alertTableView ? 0 : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.alertTableView) {
        return 48;
    }
    switch (indexPath.section) {
        case 0:
            {
                return 100;
            }
            break;
        case 1:
        {
            return 260;
        }
            break;
        case 2:
        {
            HTPiesModel *model = self.thirdSectionArray[indexPath.row];
            return  (model.isSeemore ?  (model.data.count  + 1)* 48 : 6 * 48 ) + 220;
        }
            break;
        case 3:
        {
          return 48;
        }
            break;
        case 4:
        {
            return 48;
        }
            break;
            
        default:
            break;
    }
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.alertTableView) {
        if ([self.alertArr[indexPath.row] isEqualToString:@"自定义"]) {
                HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
                dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
                __weak typeof(self)  weakSelf = self;
                  dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.beginTime = beginTime;
                    strongSelf.endTime = endTime;
                    for (HTSectionOpenModel *model in strongSelf.sectionTitleArray) {
                        model.isOpen = NO;
                    }
                      strongSelf.timeNameLabel.text = [NSString stringWithFormat:@"%@ - %@",strongSelf.beginTime,strongSelf.endTime];
                    [strongSelf tapBackView];
                    [strongSelf.dataTableView reloadData];
                } ;
                [self.view addSubview:dateTimePickerView];
                [dateTimePickerView showHcdDateTimePicker];
        }else{
            NSArray *date = self.dateArray[indexPath.row];
            self.beginTime = date[0];
            self.endTime = date[1];
            for (HTSectionOpenModel *model in self.sectionTitleArray) {
                model.isOpen = NO;
            }
            self.timeNameLabel.text = [NSString stringWithFormat:@"%@ - %@",self.beginTime,self.endTime];
            [self tapBackView];
            [self.dataTableView reloadData];
        }
    }
}
#pragma mark -CustomDelegate
-(void)seemoreClickedWithCell:(HTNewPieCellTableViewCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:5];
}
- (void)selectedShopOkBtClicked{
    NSMutableArray *idsarr = [NSMutableArray array];
    for (HTCompanyListModel *model in self.companys) {
        if (model.isSelected) {
            [idsarr addObject:model.companyId];
        }
    }
    self.ids = [idsarr componentsJoinedByString:@","];
    for (HTSectionOpenModel *model in self.sectionTitleArray) {
        model.isOpen = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedShopView.frame = CGRectMake(0, 44, HMSCREENWIDTH,  0);
        [self.selectedShopView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.selectedShopView.hidden = YES;
    }];
    self.shopNameLabel.text = [NSString stringWithFormat:@"店铺（%ld）",idsarr.count];
    [self.dataTableView reloadData];
}
#pragma mark -EventResponse
- (IBAction)timeClicked:(id)sender {
    if (!self.tapView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alertTableView.frame = CGRectMake(0, 44 , HMSCREENWIDTH, 0);
            [self.alertTableView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.tapView.hidden = YES;
            self.alertTableView.hidden = YES;
        }];
    }else{
        self.tapView.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alertTableView.hidden = NO;
            self.alertTableView.frame = CGRectMake(0, 44 , HMSCREENWIDTH, 48 * 5);
            [self.alertTableView reloadData];
            [self.alertTableView layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }

}
-(void)tapBackView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertTableView.frame = CGRectMake(0, 44 , HMSCREENWIDTH, 0);
        [self.alertTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.tapView.hidden = YES;
        self.alertTableView.hidden = YES;
    }];
}
- (IBAction)shopClicked:(id)sender {
    if (self.selectedShopView.height > 50) {
        [UIView animateWithDuration:0.3 animations:^{
            self.selectedShopView.frame = CGRectMake(0, -44, HMSCREENWIDTH,  0);
            [self.selectedShopView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.selectedShopView.hidden = YES;
        }];
  
    }else{
       
        if (self.companys.count > 0) {
            self.selectedShopView.dataArray = self.companys;
             self.selectedShopView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.selectedShopView.frame = CGRectMake(0, 44, HMSCREENWIDTH,  HEIGHT - nav_height - tar_height - SafeAreaBottomHeight - 44);
                [self.selectedShopView layoutIfNeeded];
            }];
        }else{
            NSDictionary *dic = @{
                                  @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                  @"type":@"0"
                                  };
            [MBProgressHUD showMessage:@"" toView:self.view];
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"load_children_id_4_app.html"] params:dic success:^(id json) {
                [MBProgressHUD hideHUDForView:self.view];
                NSArray *companys = [json getArrayWithKey:@"data"];
                for (NSDictionary *dic  in companys) {
                    HTCompanyListModel *model = [[HTCompanyListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.companys addObject:model];
                }
                self.selectedShopView.dataArray = self.companys;
                self.selectedShopView.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    self.selectedShopView.frame = CGRectMake(0, 44, HMSCREENWIDTH,  HEIGHT - nav_height - tar_height - SafeAreaBottomHeight - 44);
                    [self.selectedShopView layoutIfNeeded];
                }];
            } error:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"请检查你的网络"];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"请检查你的网络"];
            }];
        }
       
    }
 
}
-(void)sectionOpenBtClicked:(UIButton *)sender{
  
    int tag = (int)sender.tag - 500;
    HTSectionOpenModel *model = self.sectionTitleArray[tag];
    NSMutableArray *arr = self.dataArray[tag];
    if (arr.count > 0 && model.isOpen) {
        model.isOpen = !model.isOpen;
        [self.dataTableView reloadData];
    }else{
    [self loadDataWithTag:tag];
    }
    
}
- (IBAction)compareClicked:(id)sender {
    HTBossCompareViewController *vc = [[HTBossCompareViewController alloc] init];
    if (self.pushVc) {
        self.pushVc(vc);
    }
}

#pragma mark -private methods
-(void)createTapView{
    self.tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 , HMSCREENWIDTH, HEIGHT - nav_height - tar_height - SafeAreaBottomHeight - 44)];
    self.tapView.backgroundColor = [UIColor blackColor];
    self.tapView.alpha = 0.5;
    self.tapView.hidden = YES;
    self.tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
    [self.tapView addGestureRecognizer:tap];
}

- (void)createTime{
    NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
    [yearF1 setDateFormat:@"YYYY-MM-dd"];
    NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
    [yearF2 setDateFormat:@"dd"];
    NSString *whichDay = [yearF2 stringFromDate:[NSDate date]];
    NSString *thisMonth = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-1 * (whichDay.integerValue - 1)]];
    NSString *today    = [yearF1 stringFromDate:[NSDate date]];
    self.beginTime = thisMonth;
    self.endTime = today;
}
- (void)createTb{
 
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    self.alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, HMSCREENWIDTH, 0) style:UITableViewStylePlain];
    self.alertTableView.dataSource = self;
    self.alertTableView.delegate = self;
    [self.view addSubview:self.tapView];
    [self.view addSubview:self.alertTableView];
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossSaleBasicInfoCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleBasicInfoCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPieCellTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossDayRankListCell" bundle:nil] forCellReuseIdentifier:@"HTBossDayRankListCell"];
     [self.dataTableView registerNib:[UINib nibWithNibName:@"HTStaffSaleRankListCell" bundle:nil] forCellReuseIdentifier:@"HTStaffSaleRankListCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossLineReportCell" bundle:nil] forCellReuseIdentifier:@"HTBossLineReportCell"];
    self.dataTableView.tableFooterView = footView;
    self.alertTableView.tableFooterView = footView;
}
-(void)loadDataWithTag:(int) tag{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"beginDate":[HTHoldNullObj getValueWithUnCheakValue:self.beginTime],
                          @"endDate":[HTHoldNullObj getValueWithUnCheakValue:self.endTime],
                          @"ids":self.ids,
                          @"reportType":[NSString stringWithFormat:@"%d",tag]
                          };
    [MBProgressHUD showMessage:@"" ];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleMonthReport,@"load_boss_sale_report_4_app.html"] params:dic success:^(id json) {
        
        HTSectionOpenModel *sectionmodel = self.sectionTitleArray[tag];
        if (tag == 0) {
            [self.firstSectionArray removeAllObjects];
            NSArray *titles1 = @[@"利润",@"销量",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费"];
             NSArray *titles2 = @[@"营业额",@"换货数量",@"VIP销售占比",@"退货率",@"客单价",@"新增标签",@"支付宝支付"];
             NSArray *titles3 = @[@"退换差额",@"退货数量",@"折扣",@"换货率",@"件单价",@"新增储值",@"微信支付"];
            NSArray *keys1 = @[@"profit",@"orderProducts",@"orderCount",@"related",@"flowCountIn",@"backUpRate",@"consumeStore"];
            NSArray *keys2 = @[@"saleAmount",@"exchangeProducts",@"vipSaleScale",@"returnRate",@"customerTransaction",@"tagCount",@"aliPay"];
            NSArray *keys3 = @[@"exchangeAndReturnAmount",@"returnProducts",@"discount",@"exchangeRate",@"piecePrice",@"store",@"weChat"];
            NSArray *prefix1 = @[@"￥",@"",@"",@"",@"",@"",@"￥"];
            NSArray *prefix2 = @[@"￥",@"",@"",@"",@"￥",@"",@"￥"];
            NSArray *prefix3 = @[@"￥",@"",@"",@"",@"￥",@"￥",@"￥"];
            NSArray *suffix1  = @[@"",@"件",@"单",@"",@"人",@"%",@""];
            NSArray *suffix2  = @[@"",@"件",@"%",@"%",@"",@"",@""];
            NSArray *suffix3  = @[@"",@"件",@"折",@"%",@"",@"",@""];
            NSArray *imageName  = @[@"利润",@"矢量智能对象5",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费"];
            for (int  i = 0; i < titles1.count; i++) {
                HTBossReportBasciModel *model = [[HTBossReportBasciModel alloc] init];
                model.title1 = titles1[i];
                model.title2 = titles2[i];
                model.title3 = titles3[i];
                model.value1 = [json[@"data"] getStringWithKey:keys1[i]];
                model.value2 = [json[@"data"] getStringWithKey:keys2[i]];
                model.value3 = [json[@"data"] getStringWithKey:keys3[i]];
                model.suffix1 = suffix1[i];
                model.suffix2 = suffix2[i];
                model.suffix3 = suffix3[i];
                model.prefix1 = prefix1[i];
                model.prefix2 = prefix2[i];
                model.prefix3 = prefix3[i];
                model.imgName = imageName[i];
                [self.firstSectionArray addObject:model];
            }
            sectionmodel.isOpen = YES;
        }
        if (tag == 1) {
            [self.secondSectionArray removeAllObjects];
            NSArray *dic = [json getArrayWithKey:@"data"];
            [self.secondSectionArray addObject:dic];
            sectionmodel.isOpen = YES;
        }
        if (tag == 3) {
            [self.fourthSectionArray removeAllObjects];
            for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
                HTDaySaleRankModel *model = [[HTDaySaleRankModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray[tag] addObject:model];
            }
              sectionmodel.isOpen = YES;
        }
        if (tag == 4) {
            [self.fifthSectionArray removeAllObjects];
            HTStaffSaleRankListModel  *model = [[HTStaffSaleRankListModel alloc] init];
            model.name = @"姓名";
            model.orderNumCurrent = @"单量";
            model.totalCurrent = @"销量";
            model.moneyCurrent = @"总金额";
            model.orderNumRe = @"退换货";
            [self.fifthSectionArray  addObject:model];
            for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
                HTStaffSaleRankListModel *model = [[HTStaffSaleRankListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.fifthSectionArray addObject:model];
            }
            sectionmodel.isOpen = YES;
        }
        if (tag == 2) {
            [self.thirdSectionArray removeAllObjects];
            HTPiesModel *mm = [HTPiesModel yy_modelWithJSON:json[@"data"]];
            [self.thirdSectionArray addObject:mm];
            sectionmodel.isOpen = YES;
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:tag];
        [self.dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}
-(void)loadCompanyListData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"type":@"0"
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"load_children_id_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        NSArray *companys = [json getArrayWithKey:@"data"];
        for (NSDictionary *dic  in companys) {
            HTCompanyListModel *model = [[HTCompanyListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.companys addObject:model];
        }
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
#pragma mark - getters and setters
- (HTBossSelectedShopView *)selectedShopView{
    if (!_selectedShopView) {
        _selectedShopView = [[HTBossSelectedShopView alloc] initWithAlertFrame:CGRectMake(0, -44, HMSCREENWIDTH,  0)];
        _selectedShopView.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_selectedShopView];
        });
    }
    return _selectedShopView;
}
- (NSMutableArray *)firstSectionArray{
    if (!_firstSectionArray) {
        _firstSectionArray = [NSMutableArray array];
    }
    return _firstSectionArray;
}
- (NSMutableArray *)secondSectionArray{
    if (!_secondSectionArray) {
        _secondSectionArray = [NSMutableArray array];
    }
    return  _secondSectionArray;
}
-(NSMutableArray *)thirdSectionArray{
    if (!_thirdSectionArray) {
        _thirdSectionArray = [NSMutableArray array];
    }
    return _thirdSectionArray;
}
- (NSMutableArray *)fourthSectionArray{
    if (!_fourthSectionArray) {
        _fourthSectionArray = [NSMutableArray array];
    }
    return _fourthSectionArray;
}
- (NSMutableArray *)fifthSectionArray{
    if (!_fifthSectionArray) {
        _fifthSectionArray = [NSMutableArray array];
    }
    return _fifthSectionArray;
}
- (NSMutableArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        NSArray *arr =  @[@"基本概况",@"营业趋势",@"销售品类占比",@"大单排行榜",@"员工销售排行榜"];
        _sectionTitleArray = [NSMutableArray array];
        for (int i = 0 ; i < arr.count; i++ ) {
            HTSectionOpenModel *model = [[HTSectionOpenModel alloc] init];
            model.title = arr[i];
            model.isOpen = NO;
            [_sectionTitleArray addObject:model];
        }
      
    }
    return _sectionTitleArray;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[self.firstSectionArray,self.secondSectionArray,self.thirdSectionArray,self.fourthSectionArray,self.fifthSectionArray];
    }
    return _dataArray;
}
- (NSMutableArray *)companys{
    if (!_companys) {
        _companys = [NSMutableArray array];
    }
     return  _companys;
}
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
