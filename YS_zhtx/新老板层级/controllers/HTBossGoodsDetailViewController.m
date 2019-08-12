//
//  HTBossGoodsDetailViewController.m
//  YS_zhtx
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossGoodsDetailViewController.h"
#import "HTBossGoodsDetailHeadTableViewCell.h"
#import "HTBossGoodsCompareListTableViewCell.h"
#import "HTBossGoodsChooseHeaderView.h"
@interface HTBossGoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, HTBossGoodRefreshDelegate, HTBossChooseBtnDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *goodsTb;
@property (nonatomic, strong) NSDictionary *basicDic;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *basicArray;
//0是 没有 1 是颜色 2是状态
@property (nonatomic, assign) NSInteger currentType;
@property (nonatomic, assign) NSInteger currentChooseColor;
@property (nonatomic, assign) NSInteger currentChooseStatus;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation HTBossGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildTb];
    [self loadBasicData];
    self.basicArray = [NSMutableArray arrayWithArray:@[@"可用", @"历史", @"销售", @"在途"]];
    self.currentType = 0;
    self.currentChooseColor = 0;
    self.currentChooseStatus = 0;
    
}

- (void)loadBasicData{
    NSDictionary *dic = @{
                          @"styleCode": self.searchStr,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,getGoodsDetailMessage] params:dic success:^(id json) {
        self.basicDic = [NSDictionary dictionaryWithDictionary:json[@"data"][@"dateil"]];
        [self.goodsTb reloadData];
        [self getGoodColor];
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (void)getGoodColor{
    NSDictionary *dic = @{
                          @"styleCode": self.searchStr,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,getGoodsColorAll] params:dic success:^(id json) {
        self.colorArray = [NSMutableArray arrayWithArray:json[@"data"]];
        [self getList];
        [self.goodsTb reloadData];
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (void)getList{
    if (_colorArray.count) {
        
    }
    NSString *tempColor = _colorArray[_currentChooseColor];
    NSDictionary *dic = @{
                          @"styleCode": self.searchStr,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"color":tempColor
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,getGoodsDetailCompareData] params:dic success:^(id json) {
        self.listArray = [NSMutableArray arrayWithArray:json[@"data"]];
        [self.goodsTb reloadData];
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (void)buildTb{
    [self.goodsTb registerNib:[UINib nibWithNibName:@"HTBossGoodsDetailHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossGoodsDetailHeadTableViewCell"];
    [self.goodsTb registerNib:[UINib nibWithNibName:@"HTBossGoodsCompareListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossGoodsCompareListTableViewCell"];
    _goodsTb.rowHeight = UITableViewAutomaticDimension;
    _goodsTb.estimatedRowHeight = 200;
    UIView *tempFooter = [[UIView alloc] init];
    _goodsTb.tableFooterView = tempFooter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _listArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *sectionHeaderView = [[UIView alloc] init];
        return sectionHeaderView;
    }else if (section == 1){
        HTBossGoodsChooseHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"HTBossGoodsChooseHeaderView" owner:nil options:nil].lastObject;
//        [[HTBossGoodsChooseHeaderView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 180)];
//        view.backgroundColor = [UIColor yellowColor];
        view.delegate = self;
        view.currentType = _currentType;
        view.currentSelectedStatus = _currentChooseStatus;
        view.currentSelectedColor = _currentChooseColor;
        if (_colorArray.count > 0) {
            view.itemsStatusArray = [NSMutableArray arrayWithArray:_basicArray];
            view.itemsColorArray = [NSMutableArray arrayWithArray:_colorArray];            
        }
        return view;
    }else{
        UIView *sectionHeaderView = [[UIView alloc] init];
        return sectionHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        if (_currentType == 0) {
            return 45;
        }else if (_currentType == 1){
            if (_colorArray.count < 5) {
                return 90;
            }else if (_colorArray.count < 9){
                return 135;
            }else{
                return 180;
            }
        }else{
            return 90;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HTBossGoodsDetailHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossGoodsDetailHeadTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.dataDic = [NSDictionary dictionaryWithDictionary:self.basicDic];
        cell.delegate = self;
        return cell;
        
    }else{
        HTBossGoodsCompareListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossGoodsCompareListTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.detailStr = self.basicArray[_currentChooseStatus];
        __weak typeof(self) weakSelf = self;
        cell.returnOFFset = ^(CGPoint point) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf setContentOffSet:point];
        };
        cell.dataDic = _listArray[indexPath.row];
        return cell;
    }
}

- (void)bossChooseBtnDelegateAction:(NSInteger)tag{
    if (tag == 100) {
        if (_currentType == 1) {
            _currentType = 0;
        }else{
            _currentType = 1;
        }
    }else if (tag == 101){
        if (_currentType == 2) {
            _currentType = 0;
        }else{
            _currentType = 2;
        }
    }else{
        if (_currentType == 1) {
            _currentChooseColor = tag;
        }else if (_currentType == 2){
            _currentChooseStatus = tag;
        }else{
            
        }
    }
    [_goodsTb reloadData];
}

- (void)bossGoodRefreshDelegateAction{
    [_goodsTb scrollsToTop];
    [_goodsTb reloadData];
}

-(void)setContentOffSet:(CGPoint) offset{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (UITableViewCell *cell in self.goodsTb.visibleCells) {
        if ([cell isKindOfClass:[HTBossGoodsCompareListTableViewCell class]]) {
            [tempArr addObject:cell];
        }
    }
    for (HTBossGoodsCompareListTableViewCell* cell in tempArr) {
        cell.cv.contentOffset = offset;
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
