//
//  HTBossCompareViewController.m
//  有术
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossCompareSelcetedCell.h"
#import "HTBossCompareViewController.h"
#import "HTMultierContrastHistoryCell.h"
#import "HTBossSelecteShopsController.h"
#import "HTBossSelecteTimeController.h"
#import "HTBossCompareDataModel.h"
#import "HTBossSaleReportCompareController.h"
#import "HTBossCustomerReportCompareController.h"
#import "HTCompareReportCenterController.h"
#import "UIBarButtonItem+Extension.h"
#import "HTCustomDefualAlertView.h"
@interface HTBossCompareViewController ()<UITableViewDelegate,UITableViewDataSource,HTMultierContrastHistoryCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (assign,nonatomic) HTSectedType sectedtype;
@property (weak, nonatomic) IBOutlet UIImageView *shopCompareImg;
@property (weak, nonatomic) IBOutlet UIImageView *timeCompareimg;

@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *shops;
@property (nonatomic,strong) NSMutableArray *dates;

@end

@implementation HTBossCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据对比";
    [self companyCompareClicked:nil];
    [self createTb];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCompanyListData];
}

#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HTBossCompareSelcetedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossCompareSelcetedCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.sectedtype == HTSectedTypeTime ? @"创建对比时间":@"创建对比店铺";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HTMultierContrastHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMultierContrastHistoryCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row - 1];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 80;
    }else{
        HTBossCompareDataModel *model =  self.dataArray[indexPath.row - 1];
        if (model.companys.length > 0) {
            return 120;
        }
        if (model.date.length > 0) {
            return 150;
        }
        return 130;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.sectedtype == HTSectedTypeShop) {
            HTBossSelecteShopsController *vc = [[HTBossSelecteShopsController alloc] init];
            vc.maxSelected = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (self.sectedtype == HTSectedTypeTime) {
            HTBossSelecteTimeController *vc = [[HTBossSelecteTimeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
          HTBossCompareDataModel *model1  = self.dataArray[indexPath.row - 1];
        for (HTBossCompareDataModel *model in self.dataArray) {
            if (model != model1) {
            model.isSelected = NO;
            }
        }
        model1.isSelected = !model1.isSelected;
        [self.dataTableView reloadData];
    }
}
#pragma mark -CustomDelegate
- (void)deleteClicked:(HTMultierContrastHistoryCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"确认删除吗?" btsArray:@[@"取消",@"确定"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        HTBossCompareDataModel *model = strongSelf.dataArray[index.row - 1];
        [strongSelf deleteHistoryWithId:model.modelId andIsAll:NO withModel:model];
    } cancelClicked:^{
    }];
    [alert show];
    
//    [[HTShareClass shareClass].alertManager showAlertWithTitle:@"确认删除吗？" msg:nil callbackBlock:^(NSUInteger btnIndex) {
//        if (btnIndex == 1) {
//            HTBossCompareDataModel *model = self.dataArray[index.row - 1];
//            [self deleteHistoryWithId:model.modelId andIsAll:NO withModel:model];
//        }
//    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}
#pragma mark -EventResponse
-(void)clearHisClicked:(UIButton *)sender{
    [self deleteHistoryWithId:nil andIsAll:YES withModel:nil];
}
- (IBAction)timeCompareClieck:(id)sender {
    self.sectedtype = HTSectedTypeTime;
    self.timeTitle.textColor = [UIColor colorWithHexString:@"#6A82FB"];
    self.companyTitle.textColor = [UIColor colorWithHexString:@"666666"];
    self.shopCompareImg.image = [UIImage imageNamed:@"店铺对比-未选中"];
    self.timeCompareimg.image  = [UIImage imageNamed:@"时间对比-选中"];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.dates];
    [self.dataTableView reloadData];

}
- (IBAction)companyCompareClicked:(id)sender {
    self.sectedtype = HTSectedTypeShop;
    self.companyTitle.textColor = [UIColor colorWithHexString:@"#6A82FB"];
    self.timeTitle.textColor = [UIColor colorWithHexString:@"666666"];
    self.shopCompareImg.image = [UIImage imageNamed:@"店铺对比-选中"];
    self.timeCompareimg.image  = [UIImage imageNamed:@"时间对比未选中"];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.shops];
    [self.dataTableView reloadData];
}
- (IBAction)beginCompareClicked:(id)sender {
    HTBossCompareDataModel *selectedModel = [[HTBossCompareDataModel alloc] init];
    for (HTBossCompareDataModel *model in self.dataArray) {
        if (model.isSelected ) {
            selectedModel = model;
        }
    }
    if (!selectedModel.isSelected) {
        [MBProgressHUD showError:@"请选择对比选项"];
        return;
    }
    if (self.sectedtype == HTSectedTypeShop) {
        NSArray *companys = [selectedModel.companys ArrayWithJsonString];
        NSMutableArray *ids = [NSMutableArray array];
        for (NSDictionary *dic in companys) {
            [ids addObject:[dic getStringWithKey:@"id"]];
        }
        HTCompareReportCenterController *vc = [[HTCompareReportCenterController alloc] init];
        vc.companys = companys;
        vc.ids = [ids componentsJoinedByString:@","];
        vc.sectedType = HTSectedTypeShop;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *dates1 = [selectedModel.date dictionaryWithJsonString];
        NSArray *dates = [dates1 getArrayWithKey:@"date"];
        NSMutableArray *strs = [NSMutableArray array];
        for (NSString *date in dates) {
            NSArray *d1 = [date componentsSeparatedByString:@"——"];
            NSString *d2 = [d1 componentsJoinedByString:@";"];
            [strs addObject:d2];
        }
        NSString *datess = [strs componentsJoinedByString:@","];
        HTCompareReportCenterController *vc = [[HTCompareReportCenterController alloc] init];
        vc.dates = datess;
        vc.shopId = [dates1 getStringWithKey:@"brandId"];
        vc.sectedType = HTSectedTypeTime;
        vc.selectedDates = dates;
        vc.shopName = [dates1 getStringWithKey:@"brandName"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)eascCompareClicked:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tuichu:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -private methods

-(void)deleteHistoryWithId:(NSString *) hisId andIsAll:(BOOL) isAll withModel:(HTBossCompareDataModel *) model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (isAll) {
        [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"id"];
    }else{
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:hisId] forKey:@"id"];
        [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    }
    [MBProgressHUD showMessage:@"请稍等..."];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,isAll ? @"remove_all_compare_company_id_4_app.html":@"remove_compare_company_id_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (isAll) {
      
            [self.shops removeAllObjects];
            [self.dates removeAllObjects];
            [self.dataArray removeAllObjects];
        }else{
            if (self.sectedtype == HTSectedTypeShop) {
                [self.shops removeObject:model];
            }else{
                [self.dates removeObject:model];
            }
            [self.dataArray removeObject:model];
        }
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
    
}

- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.dataTableView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossCompareSelcetedCell" bundle:nil] forCellReuseIdentifier:@"HTBossCompareSelcetedCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMultierContrastHistoryCell" bundle:nil] forCellReuseIdentifier:@"HTMultierContrastHistoryCell"];
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除历史" style:UIBarButtonItemStylePlain target:self action:@selector(clearHisClicked:)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"清除历史" target:self action:@selector(clearHisClicked:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#222222"];
}
-(void)loadCompanyListData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"type": self.sectedtype == HTSectedTypeShop ? @"1" : @"2"
                          };
    [MBProgressHUD showMessage:@"" ];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"load_children_id_4_app.html"] params:dic success:^(id json) {
        
        [self.dataArray removeAllObjects];
        [self.shops removeAllObjects];
        [self.dates removeAllObjects];
        for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
            HTBossCompareDataModel *model = [[HTBossCompareDataModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ( model.companys.length > 0) {
                [self.shops addObject:model];
            }
            if ( model.date.length > 0) {
                [self.dates addObject:model];
            }
        }
        if (self.sectedtype == HTSectedTypeShop) {
            [self.dataArray addObjectsFromArray:self.shops];
        }else{
            [self.dataArray addObjectsFromArray:self.dates];
        }
        [MBProgressHUD hideHUD];
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)dates{
    if (!_dates) {
        _dates = [NSMutableArray array];
    }
    return _dates;
}
- (NSMutableArray *)shops{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

@end
