//
//  HTChargeMaskViewController.m
//  YS_zhtx
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTChargeMaskViewController.h"
#import "HTNewPaySellerTableViewCell.h"
#import "HTSellerListModel.h"
@interface HTChargeMaskViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArr;
}
@end

@implementation HTChargeMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择导购";
    dataArr = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#222222"];
    [self getData];
    [self buildUI];
}

- (void)buildUI{
    _chooseSellerTb.delegate = self;
    _chooseSellerTb.dataSource = self;
//    _chooseSellerTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chooseSellerTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_chooseSellerTb registerNib:[UINib nibWithNibName:@"HTNewPaySellerTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPaySellerTableViewCell"];
}

- (void)getData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,loadStoreAllSeller] params:dic success:^(id json) {
        NSArray *listArr = [NSMutableArray arrayWithArray:json[@"data"]];
        if (listArr.count > 0 ) {
            for (NSDictionary *tempDic in listArr) {
                HTSellerListModel *model1 = [[HTSellerListModel alloc] init];
                [model1 setValuesForKeysWithDictionary:tempDic];
                [dataArr addObject:model1];
            }
            [self.chooseSellerTb reloadData];
        }
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTNewPaySellerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPaySellerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTSellerListModel *model = dataArr[indexPath.row];
    [cell.headerImv sd_setImageWithURL:[NSURL URLWithString:[HTHoldNullObj getValueWithUnCheakValue:@""]] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    cell.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    cell.priceView.hidden = YES;
    cell.biliView.hidden = YES;
    BOOL ifContent = 0;
    
    for (HTSellerListModel *tempModel in _selectArr) {
        if ([[NSString stringWithFormat:@"%@", tempModel.sellerId] isEqualToString:[NSString stringWithFormat:@"%@",  model.sellerId]]) {
            ifContent = 1;
            break;
        }
    }
    
    if (ifContent) {
        cell.selectImv.image = [UIImage imageNamed:@"select"];
    }else{
        cell.selectImv.image = [UIImage imageNamed:@"unselect"];
    }
    cell.zhiweiLabel.hidden = NO;
    cell.zhiweiLabel.text = model.roleName;
//    cell.priceTF.text = [HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"%@", _paySellerArr[indexPath.row]]];
//    cell.biliTF.text = [HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"%@", _biliArr[indexPath.row]]];
//    cell.headerImvLeft.constant = 17;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
- (void)finishAction{
    NSLog(@"点击完成");
    if (self.delegate) {
        [self.delegate chooseSellerBack:_selectArr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BOOL ifContent = 0;
    HTSellerListModel *currentModel = dataArr[indexPath.row];
    for (HTSellerListModel *tempModel in _selectArr) {
        if ([[NSString stringWithFormat:@"%@", currentModel.sellerId] isEqualToString:[NSString stringWithFormat:@"%@",  tempModel.sellerId]]) {
            ifContent = 1;
            if (_selectArr.count > 1) {
                [_selectArr removeObject:tempModel];
            }
            break;
        }
    }
    
    if (!ifContent) {
        [_selectArr addObject:dataArr[indexPath.row]];
    }

    if (_selectArr.count > 5) {
        [_selectArr removeObjectAtIndex:0];
    }
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
