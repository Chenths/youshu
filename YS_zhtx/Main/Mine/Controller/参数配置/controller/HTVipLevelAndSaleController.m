//
//  HTVipLevelAndSaleController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTVipLevelEditCell.h"
#import "HTVipLevelNomalCell.h"
#import "HTVipLevelSectionModel.h"
#import "HTVipLevelAndSaleController.h"

@interface HTVipLevelAndSaleController ()<UITableViewDelegate,UITableViewDataSource,HTVipLevelEditCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HTVipLevelAndSaleController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *section = self.dataArray[indexPath.section];
    HTVipLevelSeterModel *model = section[indexPath.row];
    HTVipLevelSectionModel *sectionModel = self.sectionArray[indexPath.section];
    
    if (sectionModel.state == HTSECTIONSTATEEDIT) {
        
        HTVipLevelEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTVipLevelEditCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.isEdit = YES;
        cell.model = model;
        cell.isLatst = indexPath.row + 1 == section.count ? YES : NO;
        return cell;
        
    }else if (sectionModel.state == HTSECTIONSTATENOMALE){
        
        if (model.heightValue.length != 0 ||(indexPath.row + 1 == section.count && model.lowValue.length > 0) ) {
            HTVipLevelNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTVipLevelNomalCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            cell.isLast = indexPath.row + 1 == section.count ? YES : NO;
            return cell;
        }else{
            HTVipLevelEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTVipLevelEditCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isEdit = NO;
            cell.model = model;
            cell.isLatst = indexPath.row + 1 == section.count ? YES : NO;
            return cell;
        }
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ceee"];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HTVipLevelSectionModel *model = self.sectionArray[section];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 35)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *dateNameLabel = [[UILabel alloc] init];
    dateNameLabel.font = [UIFont systemFontOfSize:15];
    dateNameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    dateNameLabel.text = model.titleStr;
    [headView addSubview:dateNameLabel];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    if (model.state == HTSECTIONSTATEEDIT) {
        [bt setTitle:@"完成" forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [bt setBackgroundColor:[UIColor colorWithHexString:@"#222222"]];
    }else if (model.state == HTSECTIONSTATENOMALE){
        [bt setTitle:@"编辑" forState:UIControlStateNormal];
        [bt setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
         [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        bt.imageEdgeInsets = UIEdgeInsetsMake(bt.imageEdgeInsets.top, bt.imageEdgeInsets.left, bt.imageEdgeInsets.bottom,8);
        [bt setImage:[UIImage imageNamed:@"g-mineEdit"] forState:UIControlStateNormal];
    }
    bt.layer.masksToBounds = YES;
    bt.layer.cornerRadius = 3;
    bt.tag = 200 + section;
    bt.titleLabel.font = [UIFont systemFontOfSize:14];
    [bt addTarget:self action:@selector(sectionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:bt];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.imgName]];
    [headView addSubview:imageView];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(headView.mas_leading).offset(15);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.width.offset(25);
        make.height.offset(25);
        
    }];
    [dateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(imageView.mas_trailing).offset(8);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(headView.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.width.offset(65);
        make.height.offset(30);
    }];
    
    
    return headView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    return v ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
#pragma mark -CustomDelegate
- (void)heightValueChangeWithText:(NSString *)vlaue andCell:(HTVipLevelEditCell *)cell{
    NSIndexPath *indexrow = [self.tab indexPathForCell:cell];
    
    HTVipLevelSeterModel *selectModel = self.dataArray[indexrow.section][indexrow.row];
    selectModel.heightValue = vlaue;
    selectModel.change = YES;
    if (indexrow.row + 1  <= [self.dataArray[indexrow.section] count]) {
        HTVipLevelSeterModel *nextModel = self.dataArray[indexrow.section][indexrow.row + 1];
        nextModel.lowValue = [NSString stringWithFormat:@"%d",vlaue.intValue + 1] ;
        nextModel.change = YES;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexrow.row + 1 inSection:indexrow.section];
        [self.tab reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
#pragma mark -EventResponse
- (void)sectionBtClicked:(UIButton *)sender{
    
    int tag = (int)sender.tag - 200;
    
    HTVipLevelSectionModel *model1 = self.sectionArray[tag];
    if (model1.state == HTSECTIONSTATEEDIT) {
        NSArray *arr = self.dataArray[tag];
        NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
        BOOL isChange = NO;
        for (int i = 0 ; i < arr.count; i++) {
            HTVipLevelSeterModel *model = arr[i];
            if (model.change) {
                isChange = YES;
            }
            if (model.heightValue.length == 0 || model.lowValue.length == 0 || (model.heightValue.integerValue < model.lowValue.integerValue)) {
                if ((arr.count == i + 1 )&& model.lowValue.length > 0 ) {
                }else{
                    [MBProgressHUD  showError:[NSString stringWithFormat:@"%@ 参数错误",model.title]];
                    model1.state = HTSECTIONSTATEEDIT ;
                    [self.tab reloadData];
                    return;
                }
            }
            [valueDic setObject:[NSString stringWithFormat:@"%@-%@",model.lowValue,model.heightValue.length == 0 ? @"-10" : model.heightValue] forKey:model.key];
            model.change = NO;
        }
        if (!isChange) {
            model1.state = HTSECTIONSTATENOMALE;
            [self.tab reloadData];
            return;
        }
        NSDictionary *dic = @{
                              @"key":[HTHoldNullObj getValueWithUnCheakValue:model1.sectionKey],
                              @"value":[valueDic jsonStringWithDic],
                              @"defau":@"1",
                              @"companyId": self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                              };
        [MBProgressHUD showMessage:@"" toView:self.view];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleConfig,updateConfig4App] params:dic success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
                model1.state = HTSECTIONSTATENOMALE;
                [self.tab reloadData];
            }
        } error:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"网络繁忙"];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请检查你的网络"];
        }];
    }else if(model1.state == HTSECTIONSTATENOMALE){
        model1.state = HTSECTIONSTATEEDIT;
    }
    [self.tab reloadData];
}

#pragma mark -private methods
- (void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTVipLevelEditCell" bundle:nil] forCellReuseIdentifier:@"HTVipLevelEditCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTVipLevelNomalCell" bundle:nil] forCellReuseIdentifier:@"HTVipLevelNomalCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
}
- (void)loadData{

        NSDictionary *dic = @{
                              @"companyId": self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                              };
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleConfig,loadCompanyConfig4App] params:dic success:^(id json) {
            [MBProgressHUD hideHUD];
            NSDictionary *dataArr = [json getDictionArrayWithKey:@"data"];
            NSString *valuestr = [dataArr getStringWithKey:@"value"];
            self.editTime = [[dataArr getStringWithKey:@"editDateStr"] length] > 11 ? [[dataArr getStringWithKey:@"editDateStr"] substringWithRange:NSMakeRange(0, 11)] : [dataArr getStringWithKey:@"editDateStr"];
            self.editName = [[dataArr getStringWithKey:@"editorName"] isNull] ? @"老板层级" : [dataArr getStringWithKey:@"editorName"];
            self.descLabel.text = [NSString stringWithFormat:@"最近修改 %@ %@",self.editTime,self.editName];
            NSDictionary *valueDic = [valuestr dictionaryWithJsonString];
            NSArray *section1 = self.dataArray[0];
            NSArray *section2 = self.dataArray[1];
            HTVipLevelSectionModel *secModel1 = self.sectionArray[0];
            HTVipLevelSectionModel *secModel2 = self.sectionArray[1];
            NSString *secValue1 = [valueDic getStringWithKey:secModel1.sectionKey];
            NSDictionary *sec1ValueDic = [secValue1 dictionaryWithJsonString];
            NSString *secValue2 = [valueDic getStringWithKey:secModel2.sectionKey];
            NSDictionary *sec2ValueDic = [secValue2 dictionaryWithJsonString];
            
            for (HTVipLevelSeterModel *model in section1) {
                NSArray *values = [[sec1ValueDic getStringWithKey:model.key] componentsSeparatedByString:@"-"];
                if (values.count >= 2) {
                    model.lowValue = [values firstObject];
                    model.heightValue = values[1];
                }
            }
            
            for (HTVipLevelSeterModel *model in section2) {
                NSArray *values = [[sec2ValueDic getStringWithKey:model.key] componentsSeparatedByString:@"-"];
                if (values.count >= 2) {
                    model.lowValue = [values firstObject];
                    model.heightValue = values[1];
                }
            }
            [self.tab reloadData];
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
}
#pragma mark - getters and setters
- (NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray  = [NSMutableArray array];
        NSArray *titles = @[@"会员分级规则",@"消费金额分级"];
        NSArray *imgName = @[@"g-mineVip",@"g-mineSale"];
        NSArray *keys = @[@"vipLevelRole",@"saleLevelRole"];
        for (int i = 0 ; i < titles.count; i++) {
            HTVipLevelSectionModel *model = [[HTVipLevelSectionModel alloc] init];
            model.titleStr = titles[i];
            model.imgName = imgName[i];
            model.sectionKey = keys[i];
            model.state = HTSECTIONSTATENOMALE;
            [_sectionArray addObject:model];
        }
    }
    return _sectionArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSArray *section1Title = @[@"活跃会员",@"沉默会员",@"潜水会员",@"流失会员"];
        NSArray *section1Low = @[@"1",@"",@"",@""];
        NSArray *section1Key = @[@"hyvip",@"cmvip",@"qsvip",@"lsvip"];
        NSArray *section2Title = @[@"第一档",@"第二档",@"第三档",@"第四档",@"第五档"];
        
        NSArray *section2Low = @[@"1",@"",@"",@"",@""];
        NSArray *section2Key = @[@"saleLevel1",@"saleLevel2",@"saleLevel3",@"saleLevel4",@"saleLevel5"];
        NSMutableArray *section1 = [NSMutableArray array];
        for (int i = 0; i < section1Title.count; i++) {
            HTVipLevelSeterModel *model = [[HTVipLevelSeterModel alloc] init];
            model.title = section1Title[i];
            model.lowValue = section1Low[i];
            model.key = section1Key[i];
            model.units = @"天";
            [section1 addObject:model];
        }
        NSMutableArray *section2 = [NSMutableArray array];
        for (int i = 0; i < section2Title.count; i++) {
            HTVipLevelSeterModel *model = [[HTVipLevelSeterModel alloc] init];
            model.title = section2Title[i];
            model.key = section2Key[i];
            model.lowValue = section2Low[i];
            model.units = @"元";
            [section2 addObject:model];
        }
        [_dataArray addObject:section1];
        [_dataArray addObject:section2];
    }
    return _dataArray;
}


@end
