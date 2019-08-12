//
//  HTBossAllWaySearchViewController.m
//  YS_zhtx
//
//  Created by mac on 2019/7/30.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossAllWaySearchViewController.h"
#import "HTBossSearchHistoryTableViewCell.h"
#import "HTBossGoodsDetailViewController.h"
@interface HTBossAllWaySearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *naviTitleView;
@property (weak, nonatomic) IBOutlet UITableView *historyTb;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray *historyArr;
@end

@implementation HTBossAllWaySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createTb];
    [self getData];
}

- (void)checkGoodsNum:(NSString *)str{
    NSDictionary *dic = @{
                          @"styleCode": str,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,checkGoodsIsNotNull] params:dic success:^(id json) {
        if ([json[@"isNull"] boolValue] == 1){
            [self dealDataThings:str];
            if ([self.searchTF isFirstResponder]) {
                [self.searchTF resignFirstResponder];
            }
            //此处跳转
            HTBossGoodsDetailViewController *vc = [[HTBossGoodsDetailViewController alloc] init];
            vc.title = str;
            vc.searchStr = str;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ([self.searchTF isFirstResponder]) {
                [self.searchTF resignFirstResponder];
            }
            [MBProgressHUD showError:json[@"msg"]];
            
        }
        
    } error:^{
        if ([self.searchTF isFirstResponder]) {
            [self.searchTF resignFirstResponder];
        }
        
        [MBProgressHUD showError:SeverERRORSTRING];
        
    } failure:^(NSError *error) {
        if ([self.searchTF isFirstResponder]) {
            [self.searchTF resignFirstResponder];
        }
        
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (void)getData{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    _historyArr = [NSMutableArray arrayWithArray:[currentDefaults objectForKey:@"bossSearchHistoryArray"]];
    if (_historyTb) {
        [_historyTb reloadData];
    }
}

- (void)createTb{
    [self.historyTb registerNib:[UINib nibWithNibName:@"HTBossSearchHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossSearchHistoryTableViewCell"];
    _historyTb.rowHeight = UITableViewAutomaticDimension;
    _historyTb.estimatedRowHeight = 49.5;
    UIView *tempFooter = [[UIView alloc] init];
    _historyTb.tableFooterView = tempFooter;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNavTitleView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.naviTitleView.hidden = YES;
}
- (IBAction)deleteHistoryAction:(id)sender {
    NSLog(@"清空操作");
    [_historyArr removeAllObjects];
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:_historyArr forKey:@"bossSearchHistoryArray"];
    [currentDefaults synchronize];
    [_historyTb reloadData];
}

- (void)createNavTitleView{
    if (_naviTitleView) {
        _naviTitleView.hidden = NO;
        return;
    }
    self.naviTitleView = [[UIView alloc] init];
    _naviTitleView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    if (isIPHONEX) {
        _naviTitleView.frame = CGRectMake(80, 40 + 4, HMSCREENWIDTH - 160, 32);
    }else{
        _naviTitleView.frame = CGRectMake(80, 20 + 4, HMSCREENWIDTH - 160, 32);
    }
    _naviTitleView.clipsToBounds = YES;
    _naviTitleView.layer.cornerRadius = _naviTitleView.frame.size.height / 2;
    self.navigationItem.titleView = _naviTitleView;
    
    UIImageView *searchImv = [[UIImageView alloc] init];
    searchImv.frame = CGRectMake(17, 8, 16, 16);
    searchImv.image = [UIImage imageNamed:@"bossSearch"];
    [_naviTitleView addSubview: searchImv];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(43, 0, HMSCREENWIDTH - 160 - 43 - 10 , 32)];
    _searchTF.font = [UIFont systemFontOfSize:14];
    _searchTF.placeholder = @"商品全渠道查询";
    _searchTF.backgroundColor = [UIColor whiteColor];
    _searchTF.textColor = [UIColor colorWithHexString:@"#222222"];
    _searchTF.delegate = self;
    _searchTF.returnKeyType = UIReturnKeySearch;
    [_naviTitleView addSubview:_searchTF];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTBossSearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSearchHistoryTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.nameLabel.text = _historyArr[indexPath.row];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, cell.deleteImv.frame.size.width, cell.deleteImv.frame.size.height);
    deleteButton.tag = 20000 + indexPath.row;
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteImv addSubview:deleteButton];
    return cell;
}

- (void)deleteAction:(UIButton *)sender{
    NSLog(@"当前是第%ld", sender.tag - 20000);
    [_historyArr removeObjectAtIndex:sender.tag - 20000];
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:_historyArr forKey:@"bossSearchHistoryArray"];
    [currentDefaults synchronize];
    [_historyTb reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //此处网络请求调用
    [self checkGoodsNum:_historyArr[indexPath.row]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"完成");
    //此处网络请求调用
    [self checkGoodsNum:textField.text];
    
    return YES;
}

- (void)dealDataThings:(NSString *)str{
    if ([_historyArr containsObject:str]) {
        [_historyArr removeObject:str];
        [_historyArr insertObject:str atIndex:0];
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        [currentDefaults setObject:_historyArr forKey:@"bossSearchHistoryArray"];
        [currentDefaults synchronize];
        [_historyTb reloadData];
    }else{
        if (_historyArr.count == 10) {
            [_historyArr removeLastObject];
            [_historyArr insertObject:str atIndex:0];
            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
            [currentDefaults setObject:_historyArr forKey:@"bossSearchHistoryArray"];
            [currentDefaults synchronize];
            [_historyTb reloadData];
        }else{
            [_historyArr insertObject:str atIndex:0];
            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
            [currentDefaults setObject:_historyArr forKey:@"bossSearchHistoryArray"];
            [currentDefaults synchronize];
            [_historyTb reloadData];
        }
    }
    
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
