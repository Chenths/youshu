//
//  HTProductInventoryDescController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTFiltrateHeaderModel.h"
#import "HTColorAndSizeFiltrateBox.h"
#import "HTFiltrateNodeModel.h"
#import "HTProductInventoryDescController.h"
#import "HTProductStyleReertoyDetailCell.h"
#import "HTProductInfoTableCell.h"
#import "HTTuneOutOrInController.h"
#import "HTStyleInventoryModel.h"
#import "HTTuneOutorInModel.h"
@interface HTProductInventoryDescController ()<UITableViewDelegate,UITableViewDataSource,HTColorAndSizeFiltrateBoxDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) HTColorAndSizeFiltrateBox *filtrateBox;
@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSString *searchSize;
@property (nonatomic,strong) NSString *searchColor;



@property (nonatomic,strong) HTStyleInventoryModel *inventoryModel;

@end

@implementation HTProductInventoryDescController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.searchSize = @"";
    self.searchColor = @"";
    [self createTb];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNav];
    [self filtrateBox];
    [self.view layoutIfNeeded];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.titleView = nil;
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTProductInfoTableCell"]) {
        HTProductInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductInfoTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.inventoryModel;
        return cell;
    }else{
        HTProductStyleReertoyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductStyleReertoyDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        cell.model = self.inventoryModel.stock[indexPath.row];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellsName[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.inventoryModel ?  self.cellsName.count : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc] init];
    vv.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTProductStyleReertoyDetailCell"]) {
        __weak typeof(self) weakSelf = self;
        HTStockInfoModel *mmm = self.inventoryModel.stock[indexPath.row];
        self.inventoryModel.colorCode = mmm.colorCode;
        [LPActionSheet showActionSheetWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"调入库存",@"调出库存"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (index == 1) {
                HTTuneOutOrInController *vc = [[HTTuneOutOrInController alloc] init];
                vc.turnType = HTTurnIn;
                vc.inventoryModel = self.inventoryModel;
                vc.sizeList = mmm.sizeList;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
            if (index == 2) {
                HTTuneOutOrInController *vc = [[HTTuneOutOrInController alloc] init];
                vc.turnType = HTTurnOut;
                vc.inventoryModel = self.inventoryModel;
                vc.sizeList = mmm.sizeList;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}
#pragma mark -CustomDelegate
-(void)FiltrateBoxDidSelectedInSection:(NSInteger)section andRow:(NSInteger)row{
    
}
-(void)searchBtClicked{
    
}
-(void)colorDismissWithColors:(NSArray *)colors andSizes:(NSArray *)sizes{
    if ([self.searchSize isEqualToString:[sizes componentsJoinedByString:@","]] && [self.searchColor isEqualToString:[colors componentsJoinedByString:@","]]) {
        
    }else{
        self.searchSize = [sizes componentsJoinedByString:@","];
        self.searchColor = [colors componentsJoinedByString:@","];
        [self loadData];
    }
}
#pragma mark -EventResponse
-(void)searchClicked:(UIButton *)sender{
    [self loadResultWithStr:self.searchBar.text];
}
#pragma mark -private methods

-(void)initNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"查询" target:self action:@selector(searchClicked:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"222222"];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, nav_height)];
    //    self.searchBar.backgroundColor = [UIColor clearColor];
    UITextField *searchField=[self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    self.searchBar.text = self.barcode;
    self.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    self.navigationItem.titleView = self.searchBar;
    for (UIView *view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;

    [self.tab registerNib:[UINib nibWithNibName:@"HTProductStyleReertoyDetailCell" bundle:nil] forCellReuseIdentifier:@"HTProductStyleReertoyDetailCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTProductInfoTableCell" bundle:nil] forCellReuseIdentifier:@"HTProductInfoTableCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId ? [HTHoldNullObj getValueWithUnCheakValue:self.companyId] : [HTShareClass shareClass].loginModel.companyId,
                          @"styleCode": [HTHoldNullObj getValueWithUnCheakValue:self.barcode],
                          @"color":[HTHoldNullObj getValueWithUnCheakValue:self.searchColor],
                          @"size":[HTHoldNullObj getValueWithUnCheakValue:self.searchSize]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,loadProductByStyleAndColor] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.inventoryModel = [HTStyleInventoryModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        NSMutableArray *arr = [NSMutableArray array];
        for (HTStockInfoModel *mm in self.inventoryModel.stock) {
            NSLog(@"%@",mm.color);
            [arr addObject:@"HTProductStyleReertoyDetailCell"];
        }
        [self.cellsName replaceObjectAtIndex:1 withObject:arr];
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING toView:self.view];
    }];
}

-(void)loadResultWithStr:(NSString *)barcode{
    NSDictionary *dic = @{
                          @"companyId":self.companyId ?  [HTHoldNullObj getValueWithUnCheakValue:self.companyId] : [HTShareClass shareClass].loginModel.companyId,
                          @"styleCode": barcode
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,loadColorBystylecode] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([json getDictionArrayWithKey:@"data"].allKeys.count == 0){
            [MBProgressHUD showError:@"未查到相应资料，请检查款号是否正确"];
            return ;
        }
        self.searchSize = @"";
        self.searchColor = @"";
        NSMutableArray *codeArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]] mutableCopy];
        if (!codeArray) {
            codeArray = [NSMutableArray array];
        }
        if (![codeArray containsObject:self.searchBar.text]) {
            [codeArray insertObject:self.searchBar.text atIndex:0];
        }
        [[NSUserDefaults standardUserDefaults] setObject:codeArray forKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]];
        
        self.barcode = barcode;
        self.sizeList = [[json getDictionArrayWithKey:@"data"] getArrayWithKey:@"size"];
        self.colorList = [[json getDictionArrayWithKey:@"data"] getArrayWithKey:@"color"];
        [self.filtrateBox removeFromSuperview];
        self.filtrateBox = nil;
        [self filtrateBox];
        [self loadData];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络" toView:self.view];
    }];
}
#pragma mark - getters and setters
-(HTColorAndSizeFiltrateBox *)filtrateBox
{
    if (!_filtrateBox) {
        _filtrateBox = [[HTColorAndSizeFiltrateBox alloc] initWithBoxFrame:CGRectMake(0, 16, HMSCREENWIDTH, 48)];
        _filtrateBox.delegate = self;
        HTFiltrateHeaderModel *m1 = [[HTFiltrateHeaderModel alloc] init];
        NSMutableArray *title1 = [NSMutableArray array];
        for (NSDictionary *dic in self.colorList) {
            [title1 addObject:dic];
        }
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i < title1.count; i++) {
            HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
            model.isSelected =  NO;
            NSDictionary *dic = title1[i];
            model.title = [dic getStringWithKey:@"color"];
            model.searchKey = @"colorCode";
            model.searchValue = [dic getStringWithKey:model.searchKey];
            [arr1 addObject:model];
        }
        m1.titles = arr1;
        m1.filtrateStyle = HTFiltrateStyleCollection;
        
        HTFiltrateHeaderModel *m2 = [[HTFiltrateHeaderModel alloc] init];
        NSMutableArray *title2 = [NSMutableArray array];
        for (NSDictionary *dic in self.sizeList) {
            [title2 addObject:dic];
        }
        NSMutableArray *arr2 = [NSMutableArray array];
        for (int i = 0; i < title2.count; i++) {
            HTFiltrateNodeModel *model = [[HTFiltrateNodeModel alloc] init];
            model.isSelected =  NO;
            NSDictionary *dic = title2[i];
            model.title = [dic getStringWithKey:@"size"];
            model.searchKey = @"sizeCode";
            model.searchValue = [dic getStringWithKey:model.searchKey];
            [arr2 addObject:model];
        }
        m2.titles = arr2;
        m2.filtrateStyle = HTFiltrateStyleCollection;
        _filtrateBox.dataArray = @[m1,m2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_filtrateBox];
        });
    }
    return _filtrateBox;
}
- (NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTProductInfoTableCell"]];
        [_cellsName addObject:@[]];
    }
    return _cellsName;
}
-(HTStyleInventoryModel *)inventoryModel{
    if (!_inventoryModel) {
        _inventoryModel = [[HTStyleInventoryModel alloc] init];
    }
    return _inventoryModel;
}
@end
