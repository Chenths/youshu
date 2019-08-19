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
@property (nonatomic, strong) HTBossGoodsChooseHeaderView *sectionHeaderView;
@property (nonatomic, assign) BOOL ifShowDetail;
@end

@implementation HTBossGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildTb];
    [self loadBasicData];
    self.basicArray = [NSMutableArray arrayWithArray:@[@"可用", @"历史", @"销售", @"在途"]];
    _ifShowDetail = 0;
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
        [self.colorArray insertObject:@"全部" atIndex:0];
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
    NSString *tempColor;
    if (_colorArray.count == 0) {
        tempColor = @"";
    }else{
        if (_currentChooseColor == 0) {
            tempColor = @"";
        }else{
            tempColor = _colorArray[_currentChooseColor];
        }
    }
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
//        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *sectionHeaderView = [[UIView alloc] init];
        return sectionHeaderView;
    }else if (section == 1){
        self.sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HTBossGoodsChooseHeaderView" owner:nil options:nil].lastObject;
//        [[HTBossGoodsChooseHeaderView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 180)];
//        view.backgroundColor = [UIColor yellowColor];
        _sectionHeaderView.delegate = self;
        _sectionHeaderView.currentType = _currentType;
        _sectionHeaderView.currentSelectedStatus = _currentChooseStatus;
        _sectionHeaderView.currentSelectedColor = _currentChooseColor;
        if (_colorArray.count > 0) {
            _sectionHeaderView.itemsStatusArray = [NSMutableArray arrayWithArray:_basicArray];
            _sectionHeaderView.itemsColorArray = [NSMutableArray arrayWithArray:_colorArray];
        }
        return _sectionHeaderView;
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
//        [cell.cv scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        cell.dataDic = _listArray[indexPath.row];
        return cell;
    }
}

- (void)bossChooseBtnDelegateAction:(NSInteger)tag{
//    [_goodsTb scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionNone animated:YES];
//    [_goodsTb scrollsToTop];
    if (tag == 100) {
        if (_currentType == 1) {
            _currentType = 0;
        }else{
            _currentType = 1;
        }
        [self setContentOffSet:CGPointMake(0, 0)];
//        if (_ifShowDetail) {
//            _goodsTb.contentOffset = CGPointMake(0, 166 + 260 + HMSCREENWIDTH);
//        }else{
//            _goodsTb.contentOffset = CGPointMake(0, 166 + HMSCREENWIDTH);
//        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
        [_goodsTb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//        [_goodsTb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
//        [_goodsTb reloadData];
    }else if (tag == 101){
        if (_currentType == 2) {
            _currentType = 0;
        }else{
            _currentType = 2;
        }
        [self setContentOffSet:CGPointMake(0, 0)];
//        if (_ifShowDetail) {
//            _goodsTb.contentOffset = CGPointMake(0, 166 + 260 + HMSCREENWIDTH);
//        }else{
//            _goodsTb.contentOffset = CGPointMake(0, 166 + HMSCREENWIDTH);
//        }
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
        [_goodsTb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//        [_goodsTb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        [_goodsTb reloadData];
    }else{
        if (_currentType == 1) {
            _currentChooseColor = tag;
            [self setContentOffSet:CGPointMake(0, 0)];
            [self getList];
//            if (_ifShowDetail) {
//                _goodsTb.contentOffset = CGPointMake(0, 166 + 260 + HMSCREENWIDTH);
//            }else{
//                _goodsTb.contentOffset = CGPointMake(0, 166 + HMSCREENWIDTH);
//            }
        }else if (_currentType == 2){
            _currentChooseStatus = tag;
//            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
//            [_goodsTb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//            [_goodsTb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            [self setContentOffSet:CGPointMake(0, 0)];
            [_goodsTb reloadData];
//            if (_ifShowDetail) {
//                _goodsTb.contentOffset = CGPointMake(0, 166 + 260 + HMSCREENWIDTH);
//            }else{
//                _goodsTb.contentOffset = CGPointMake(0, 166 + HMSCREENWIDTH);
//            }
        }else{
            
        }
    }
    
    
}


- (void)bossGoodRefreshDelegateActionShowDedetail:(BOOL)show{
    _ifShowDetail = show;
    [_goodsTb reloadData];
    [_goodsTb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
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
