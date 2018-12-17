//
//  HTSearchPrucutInventoryController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTProductInventoryDescController.h"
#import "HTSearchPrucutInventoryController.h"

@interface HTSearchPrucutInventoryController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation HTSearchPrucutInventoryController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNav];
    [self.view layoutIfNeeded];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.titleView = nil;
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ceee"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ceee"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    UIImageView *delImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inv-deleteSimple"]];
    delImg.userInteractionEnabled = YES;
    [cell.contentView addSubview:delImg];
    [delImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.trailing.mas_equalTo(cell.mas_trailing).offset(-32);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deltHistory:)];
    delImg.tag = 1000 + indexPath.row;
    [delImg addGestureRecognizer:tap];
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.leading.mas_equalTo(cell.mas_leading).offset(16);
    }];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadResultWithStr:self.dataArray[indexPath.row]];
}
#pragma mark -CustomDelegate
#pragma mark -EventResponse
-(void)deltHistory:(UITapGestureRecognizer *)tap{
    UIView *vvv = tap.view;
    NSInteger tag = vvv.tag - 1000;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArray];
    [arr removeObjectAtIndex:tag];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]];
    self.dataArray = arr;
    [self.tab reloadData];
}
- (IBAction)deleteHistoryClicked:(id)sender {
   [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]];
    self.dataArray = @[];
    [self.tab reloadData];
}
-(void)searchClicked:(UIButton *)sender{
    if (self.searchBar.text.length == 0) {
        [MBProgressHUD showError:@"请输入款号"];
        return;
    }
    [self loadResultWithStr:self.searchBar.text];
}
#pragma mark -private methods
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
        NSMutableArray *codeArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]] mutableCopy];
        if (!codeArray) {
            codeArray = [NSMutableArray array];
        }
        if (![codeArray containsObject:self.searchBar.text]) {
            [codeArray insertObject:self.searchBar.text atIndex:0];
        }
        [[NSUserDefaults standardUserDefaults] setObject:codeArray forKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]];
        HTProductInventoryDescController *vc = [[HTProductInventoryDescController alloc] init];
        vc.barcode = barcode;
        vc.sizeList = [[json getDictionArrayWithKey:@"data"] getArrayWithKey:@"size"];
        vc.colorList = [[json getDictionArrayWithKey:@"data"] getArrayWithKey:@"color"];
        [self.navigationController pushViewController:vc animated:YES];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NETERRORSTRING toView:self.view];
    }];
}
-(void)initNav{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"查询" target:self action:@selector(searchClicked:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"222222"];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.navigationItem.leftBarButtonItem.width + 8, 0,HMSCREENWIDTH - (self.navigationItem.leftBarButtonItem.width + 8 ), nav_height)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.tintColor = [UIColor clearColor];
    for (UIView *view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    UITextField *searchField=[self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
    self.searchBar.placeholder = @"输入款号";
    self.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.translucent = NO;
    
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSUserDefaults standardUserDefaults] arrayForKey:[NSString stringWithFormat:@"%@%@",HTSEARCHHISTORY,[HTShareClass shareClass].loginId]];
    }
    return _dataArray;
}

@end
