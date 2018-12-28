//
//  HTMsgSetViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMsgSetViewController.h"
#import "HTRoleSelecteCell.h"
#import "HTNoticePushSetionModel.h"
#import "HTRolsModel.h"
@interface HTMsgSetViewController ()<UITableViewDelegate,UITableViewDataSource,HTRoleSelecteCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation HTMsgSetViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self loadRoleData];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTRoleSelecteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTRoleSelecteCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTNoticpushSeterModel *model = self.dataArray[indexPath.section];
    HTNoticePushSetionModel *mmm = self.sectionArray[indexPath.section];
    cell.delegate = self;
    cell.model = model;
    cell.sectionModel = mmm;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc] init];
    vv.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    return vv;
}
#pragma mark -CustomDelegate
-(void)topBtClicked{
    [self.tab reloadData];
}
- (void)okBtClickedWithCell:(HTRoleSelecteCell *)cell{
    
    NSIndexPath *indexpath = [self.tab indexPathForCell:cell];
    __block HTNoticePushSetionModel *sectionModel = self.sectionArray[indexpath.section];
    
    HTNoticpushSeterModel *model = self.dataArray[indexpath.section];
    NSMutableArray *ids = [NSMutableArray array];
    __block  NSMutableString *desc = [NSMutableString string];
    for (int i = 0 ; i < model.selectedRoles.count; i++) {
        HTRolsModel *obj = model.selectedRoles[i];
        [ids addObject:obj.HTRolsModelId];
        if (i < 2) {
            [desc appendString:obj.name];
        }
        if (i < 1 && model.selectedRoles.count > 1) {
            [desc appendString:@","];
        }
    }
    [desc appendString:[NSString stringWithFormat:@"等%ld人",model.selectedRoles.count]];
    NSString *idStr = [ids componentsJoinedByString:@","];
    NSDictionary *dic = @{
                          @"key":indexpath.section == 0 ? @"transferGoods" : @"salePushWhich",
                          @"value":idStr,
                          @"defau":@"1",
                          @"companyId": self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleConfig,updateConfig4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            sectionModel.descStr = desc;
            [self.tab reloadData];
        }
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
    
    
}

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTRoleSelecteCell" bundle:nil] forCellReuseIdentifier:@"HTRoleSelecteCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}

- (void)loadRoleData{
    
    NSDictionary *dic = @{
                          @"companyId": self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleRole,loadRole4App] params:dic success:^(id json) {
        NSArray *roles = [json getArrayWithKey:@"roles"];
        NSMutableArray  *allrole = [NSMutableArray array];
        for (NSDictionary *dic in roles) {
            HTRolsModel *model = [[HTRolsModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [allrole addObject:model];
        }
        HTNoticpushSeterModel *model1  = [[HTNoticpushSeterModel alloc] init];
        HTNoticpushSeterModel *model2  = [[HTNoticpushSeterModel alloc] init];
        model1.allRoles = allrole;
        model2.allRoles = allrole;
        [self.dataArray addObject:model1];
        [self.dataArray addObject:model2];
        [self loadData];
        
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"检查我的网络"];
    }];
}

-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleConfig,loadCompanyConfig4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *dataArr = [json getDictionArrayWithKey:@"data"];
        NSString *valuestr = [dataArr getStringWithKey:@"value"];
        self.editTime = [[dataArr getStringWithKey:@"editDateStr"] length] > 11 ? [[dataArr getStringWithKey:@"editDateStr"] substringWithRange:NSMakeRange(0, 11)] : [dataArr getStringWithKey:@"editDateStr"];
        self.editName = [[dataArr getStringWithKey:@"editorName"] isNull] ? @"老板层级" : [dataArr getStringWithKey:@"editorName"];
        self.descLabel.text = [NSString stringWithFormat:@"最近修改 %@ %@",self.editTime,self.editName];
        NSDictionary *valueDic = [valuestr dictionaryWithJsonString];
        
        HTNoticePushSetionModel *sectionModel = self.sectionArray[0];
        HTNoticpushSeterModel *model1 = self.dataArray[0];
        NSString *transferGoods = [valueDic getStringWithKey:@"transferGoods"];
        NSArray *transferGoodIds = [transferGoods componentsSeparatedByString:@","];
        NSMutableString *desc1 = [NSMutableString string];
        for (NSString * roleId in transferGoodIds) {
            for (HTRolsModel *model in model1.allRoles) {
                if ([[HTHoldNullObj getValueWithUnCheakValue:model.HTRolsModelId] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:roleId] ]) {
                    [model1.selectedRoles addObject:model];
                    if (model1.selectedRoles.count <= 2) {
                        [desc1 appendString:model.name];
                    }
                    if (model1.selectedRoles.count < 2) {
                        [desc1 appendString:@"，"];
                    }
                }
            }
        }
        if (desc1.length > 0) {
            if (model1.selectedRoles.count == 1) {
                [desc1 deleteCharactersInRange:NSMakeRange(desc1.length - 1, 1)];
            }
            [desc1 appendString:[NSString stringWithFormat:@"等%ld人",model1.selectedRoles.count]];
            sectionModel.descStr = desc1;
        }
        
        
        HTNoticePushSetionModel *sectionModel1 = self.sectionArray[1];
        HTNoticpushSeterModel *model2 = self.dataArray[1];
        NSString *salePushWhich = [valueDic getStringWithKey:@"salePushWhich"];
        NSArray *salePushWhichIds = [salePushWhich componentsSeparatedByString:@","];
        NSMutableString *desc2 = [NSMutableString string];
        for (NSString * roleId in salePushWhichIds) {
            for (HTRolsModel *model in model2.allRoles) {
                if ([[HTHoldNullObj getValueWithUnCheakValue:model.HTRolsModelId] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:roleId] ]) {
                    [model2.selectedRoles addObject:model];
                    if (model2.selectedRoles.count <= 2) {
                        [desc2 appendString:model.name];
                    }
                    if (model2.selectedRoles.count < 2  ) {
                        [desc2 appendString:@"，"];
                    }                }
            }
        }
        if (desc2.length > 0 ) {
            if (model2.selectedRoles.count == 1) {
                [desc2 deleteCharactersInRange:NSMakeRange(desc2.length - 1, 1)];
            }
            [desc2 appendString:[NSString stringWithFormat:@"等%ld人",model2.selectedRoles.count]];
            sectionModel1.descStr = desc2;
        }
        
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
    if (!_sectionArray ) {
        _sectionArray = [NSMutableArray array];
        NSArray *titels = @[@"库存消息推送",@"销售消息推送"];
        NSArray *descs = @[@"未设置",@"未设置"];
        NSArray *holds = @[@"库存消息将推送给选中角色",@"销售消息将推送给选中角色"];
        for (int i = 0; i < titels.count; i++) {
            HTNoticePushSetionModel *model = [[HTNoticePushSetionModel alloc] init];
            model.titleStr = titels[i];
            model.descStr = descs[i];
            model.holdStr = holds[i];
            [_sectionArray addObject:model];
        }
        [self.tab reloadData];
    }
    return _sectionArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
