//
//  HTShopingGuideReportController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderBaceInfoTableViewCell.h"
#import "HTGuiderDateSaleSurveyCell.h"
#import "HTGuiderSaleDataInfoTableViewCell.h"
#import "HTAgeAndeSexInfoReportCell.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTShopingGuideReportController.h"
#import "HTSaleDescViewController.h"
#import "HTDateSaleDescModel.h"
#import "HTIndexesBox.h"
#import "HTIndexsModel.h"
#import "HTGuiderReportModel.h"
#import "HTYearsSaleinfoLineReportCell.h"
@interface HTShopingGuideReportController ()<UITableViewDelegate,UITableViewDataSource,HTNewPieCellTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSArray *secArray;

@property (nonatomic,strong) HTIndexesBox *indexBox;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) HTGuiderReportModel *guiderModel;

@end

@implementation HTShopingGuideReportController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self createTb];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.guiderModel ?  self.cellsName.count : 0 ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.guiderModel ?  [self.cellsName[section] count] : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTGuiderBaceInfoTableViewCell"]) {
        HTGuiderBaceInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HTGuiderBaceInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        cell.model = self.guiderModel;
        return cell;
    }else if ([cellname isEqualToString:@"HTGuiderSaleDataInfoTableViewCell"]){
        HTGuiderSaleDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTGuiderSaleDataInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.guiderModel;
        return cell;
    }else if ([cellname isEqualToString:@"HTGuiderDateSaleSurveyCell"]){
        HTGuiderDateSaleSurveyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTGuiderDateSaleSurveyCell" forIndexPath:indexPath];
        cell.model = self.secArray[indexPath.row];
        cell.guideModel = self.guiderModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == self.secArray.count - 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        }
        return cell;
    }else if ([cellname isEqualToString:@"HTAgeAndeSexInfoReportCell"]){
        HTAgeAndeSexInfoReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTAgeAndeSexInfoReportCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.companyId = self.companyId;
        cell.userId = self.guiderId;
        cell.sexModel = self.guiderModel.sexModel;
        cell.ageModel = self.guiderModel.ageModel;
        [cell createSubWithAgelist:self.guiderModel.ageModel.data andSexList:self.guiderModel.sexModel.data];
        return cell;
        
    }else if ([cellname isEqualToString:@"HTYearsSaleinfoLineReportCell"]){
        HTYearsSaleinfoLineReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTYearsSaleinfoLineReportCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
        cell.dataArray = @[self.guiderModel.yearOfMonth,self.guiderModel.lastYearOfMonth];
        return cell;
    }else{
        HTNewPieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPieCellTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.companyId = self.companyId;
        cell.userId = self.guiderId;
        cell.model = self.guiderModel.activeModel;
        cell.delegate = self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cells = self.cellsName[indexPath.section];
    NSString *cellname = cells[indexPath.row];
    if ([cellname isEqualToString:@"HTGuiderDateSaleSurveyCell"]) {
        HTSaleDescViewController *vv = [[HTSaleDescViewController alloc] init];
        vv.typeModel = self.secArray[indexPath.row];
        vv.guideId = [HTHoldNullObj getValueWithUnCheakValue:self.guiderId];
        vv.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
        [self.navigationController pushViewController:vv animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  section == 0  ? 0.01f : 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
     self.indexBox.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:section];
    ;
    if (section >= 1) {
        NSArray *titles = @[@"个人销售情况",@"VIP基本情况",@"会员活跃度"];
        NSArray *imgs = @[@"g-saleInfo",@"g-vipBaseInfo",@"g-vipActive"];
        UIImageView *holdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgs[section - 1]]];
        UILabel *title = [[UILabel alloc] init];
        title.text = titles[section - 1];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor colorWithHexString:@"222222"];
        [v addSubview:holdImg];
        [v addSubview:title];
        [holdImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.centerY.mas_equalTo(v.mas_centerY);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(holdImg.mas_trailing).offset(4);
            make.centerY.mas_equalTo(v.mas_centerY);
        }];
    }
    return v;
}
#pragma mark -CustomDelegate
-(void)seemoreClickedWithCell:(HTNewPieCellTableViewCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:5];
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
-(void)shareClick:(UIButton *)sender{
    [MBProgressHUD showMessage:@"请稍等"];
    self.tab.frame = CGRectMake(0, 0, HMSCREENWIDTH, self.tab.contentSize.height);
    [self.tab layoutIfNeeded];
    [self.tab reloadData];
    [self.tab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.cellsName.count - 1] atScrollPosition:5 animated:YES];
    [self performSelector:@selector(reloadAndSaveImg) withObject:nil afterDelay:3];
}
-(void)reloadAndSaveImg{
    UIGraphicsBeginImageContextWithOptions(self.tab.contentSize,NO,[UIScreen mainScreen].scale);
    [self.tab.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [MBProgressHUD hideHUD];
    self.tab.frame = CGRectMake(0,0, HMSCREENWIDTH, HEIGHT - nav_height - SafeAreaBottomHeight);
    [self.tab layoutIfNeeded];
    [self.tab reloadData];
    NSMutableArray *activityItems = [NSMutableArray array];
    [activityItems addObject:image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityVC animated:YES completion:nil];
    });

}
#pragma mark -private methods
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"userId":[HTHoldNullObj getValueWithUnCheakValue:self.guiderId],
                          @"version":@"2"
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadPersonPersonalReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.guiderModel = [HTGuiderReportModel yy_modelWithJSON:json[@"data"]];
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)initNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-share" highImageName:@"g-share" target:self action:@selector(shareClick:)];
    self.title = @"个人报表";
}
-(void)createTb{
    self.tab.frame = CGRectMake(0, 0, HMSCREENWIDTH, HEIGHT - nav_height - SafeAreaBottomHeight );
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTGuiderBaceInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTGuiderBaceInfoTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTGuiderDateSaleSurveyCell" bundle:nil] forCellReuseIdentifier:@"HTGuiderDateSaleSurveyCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTGuiderSaleDataInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTGuiderSaleDataInfoTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTAgeAndeSexInfoReportCell" bundle:nil] forCellReuseIdentifier:@"HTAgeAndeSexInfoReportCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewPieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPieCellTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTYearsSaleinfoLineReportCell" bundle:nil] forCellReuseIdentifier:@"HTYearsSaleinfoLineReportCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters
-(NSArray *)secArray{
    if (!_secArray) {
        HTDateSaleDescModel *model = [[HTDateSaleDescModel alloc] init];
        model.dataType = HTSaleDataDescTypeDay;
        
        HTDateSaleDescModel *model1 = [[HTDateSaleDescModel alloc] init];
        model1.dataType = HTSaleDataDescTypeMonth;
        
        HTDateSaleDescModel *model2 = [[HTDateSaleDescModel alloc] init];
        model2.dataType = HTSaleDataDescTypeYear;
        
        _secArray = @[model,model1,model2];
    }
    return _secArray;
}
-(HTIndexesBox *)indexBox{
    if (!_indexBox) {
        NSArray *tites = @[@"个人销售情况",@"VIP基本情况",@"会员活跃度"];
        
        NSArray *indexs = @[[NSIndexPath indexPathForRow:0 inSection:1],[NSIndexPath indexPathForRow:0 inSection:2],[NSIndexPath indexPathForRow:0 inSection:3]];
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
            [strongSelf.tab scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        //第一组数据
        [_cellsName addObject:@[@"HTGuiderBaceInfoTableViewCell",@"HTGuiderSaleDataInfoTableViewCell"]];
//        第二组数据
        [_cellsName addObject:@[@"HTGuiderDateSaleSurveyCell",@"HTGuiderDateSaleSurveyCell",@"HTGuiderDateSaleSurveyCell",@"HTYearsSaleinfoLineReportCell"]];
//        第三组
        [_cellsName addObject:@[@"HTAgeAndeSexInfoReportCell"]];
        //        第4组
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
    }
    return _cellsName;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [[HTShareClass shareClass].loginModel.companyId  stringValue];
    }
    return _companyId;
}
-(NSString *)guiderId{
    if (!_guiderId) {
        _guiderId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginId];
    }
    return _guiderId;
}
@end
