//
//  HTShopInventoryInfoViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTShopInventorySeasonInfoCell.h"
#import "HTShopInventorybasicCell.h"
#import "HTShopInventoryTunesInfoCell.h"
#import "HTShopInventoryInfoViewController.h"
#import "HTInventoryYearInfoTableCell.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTSearchPrucutInventoryController.h"
#import "HTIndexesBox.h"
#import "HTIndexsModel.h"
#import "HTInventoryReportModel.h"
@interface HTShopInventoryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HTNewPieCellTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (strong,nonatomic) NSMutableArray *cellsName;
@property (nonatomic,strong) HTIndexesBox *indexBox;

@property (nonatomic,strong) HTInventoryReportModel *inventoryModel;
@end

@implementation HTShopInventoryInfoViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self initNav];
    [self loadData];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.inventoryModel ?  self.cellsName.count : 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellsName[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTShopInventorybasicCell"]) {
        HTShopInventorybasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTShopInventorybasicCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.inventoryModel;
        return cell;
    }else if ([cellname isEqualToString:@"HTShopInventoryTunesInfoCell"]) {
        HTShopInventoryTunesInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTShopInventoryTunesInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.companyId =  self.companyId ? self.companyId : [[HTShareClass shareClass].loginModel.companyId stringValue];
        return cell;
    }else if ([cellname isEqualToString:@"HTShopInventorySeasonInfoCell"]){
        HTShopInventorySeasonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTShopInventorySeasonInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.inventoryModel.seasonModel;
        return cell;
    }else if ([cellname isEqualToString:@"HTInventoryYearInfoTableCell"]){
        HTInventoryYearInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTInventoryYearInfoTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.inventoryModel.yearModel;
        return cell;
    }else{
        HTNewPieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPieCellTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray * arr1 = @[@"seasonModel",@"yearModel",@"categorieModel",@"customTypeModel",@"sizeModel"];
        NSArray *searchKey = @[@"season",@"year",@"categoriesName",@"customType",@"size",@"supplier"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:arr1];
        if (self.inventoryModel.supplierModel) {
            if (self.inventoryModel.supplierModel.data.count > 0) {
                [arr addObject:@"supplierModel"];
            }
        }
        cell.isFromInventoryInfo = YES;
        HTPiesModel *model = [self.inventoryModel valueForKey:arr[indexPath.section - 2]];
        model.searchKey = searchKey[indexPath.section - 2];
        cell.companyId = self.companyId;
        cell.model = model;
        cell.isBoos = self.inventoryModel.isboos;
        cell.delegate = self;
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.indexBox.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:section];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 10;
    }else{
        return 10;
    }
}

#pragma mark -CustomDelegate
-(void)seemoreClickedWithCell:(HTNewPieCellTableViewCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:5];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= 100) {
        if (self.indexBox.hidden) {
            self.indexBox.alpha = 0.0;
            self.indexBox.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.indexBox.alpha = 1;
            }];
        }
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.indexBox.alpha = 0;
        } completion:^(BOOL finished) {
            self.indexBox.hidden = YES;
        }];
    }
}
#pragma mark -EventResponse
//库存按钮点击
-(void)searchClick:(UIButton *)sender{
    if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
        [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
        return;
    }else{
        HTSearchPrucutInventoryController *vc = [[HTSearchPrucutInventoryController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -private methods
-(void)initNav{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-inventSearch" highImageName:@"g-inventSearch" target:self action:@selector(searchClick:)];
    self.title = @"库存";
}
-(void)createTb{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTShopInventorySeasonInfoCell" bundle:nil] forCellReuseIdentifier:@"HTShopInventorySeasonInfoCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTShopInventorybasicCell" bundle:nil] forCellReuseIdentifier:@"HTShopInventorybasicCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTShopInventoryTunesInfoCell" bundle:nil] forCellReuseIdentifier:@"HTShopInventoryTunesInfoCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTInventoryYearInfoTableCell" bundle:nil] forCellReuseIdentifier:@"HTInventoryYearInfoTableCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPieCellTableViewCell"];
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.estimatedRowHeight = 300;
}
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,loadCompanyStockReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.inventoryModel = [HTInventoryReportModel yy_modelWithJSON:json[@"data"]];
        if (self.inventoryModel.supplierModel) {
            if (self.inventoryModel.supplierModel.data.count > 0) {
                [self.cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
            }
        }
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
#pragma mark - getters and setters
-(HTIndexesBox *)indexBox{
    if (!_indexBox) {
        NSArray *tites = @[@"季节占比",@"年份占比",@"类别占比",@"品类占比",@"尺寸占比",@"供应商占比"];
        NSArray *indexs = @[[NSIndexPath indexPathForRow:0 inSection:2],[NSIndexPath indexPathForRow:0 inSection:3],[NSIndexPath indexPathForRow:0 inSection:4],[NSIndexPath indexPathForRow:0 inSection:5],[NSIndexPath indexPathForRow:0 inSection:6],[NSIndexPath indexPathForRow:0 inSection:7]];
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < tites.count;i++ ) {
            HTIndexsModel *model = [[HTIndexsModel alloc] init];
            model.titles = tites[i];
            model.indexpath = indexs[i];
            [datas addObject:model];
        }
        _indexBox = [[HTIndexesBox alloc] initWithBoxFrame:CGRectMake(0, 0, HMSCREENWIDTH, 48) ];
        _indexBox.backgroundColor = [UIColor whiteColor];
        _indexBox.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _indexBox.srollerToIndex = ^(NSIndexPath *index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.dataTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
        [_indexBox initSubviewswithDatas:datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_indexBox];
        });
    }
    return _indexBox;
}
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTShopInventorybasicCell"]];
        [_cellsName addObject:@[@"HTShopInventoryTunesInfoCell"]];
//        [_cellsName addObject:@[@"HTShopInventorySeasonInfoCell"]];
//        [_cellsName addObject:@[@"HTInventoryYearInfoTableCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
//        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
    }
    return _cellsName;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [[HTShareClass shareClass].loginModel.companyId stringValue];
    }
    return _companyId;
}
@end
