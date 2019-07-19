//
//  HTChooseCustomerViewController.m
//  YS_zhtx
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTChooseCustomerViewController.h"
#import "HTChooseCustomerCell.h"
#import "HTCustomerListModel.h"
#import "HTShareClass.h"
#import "HTMenuModle.h"
#import "HTAddVipViewController.h"
#import "HTEditVipViewController.h"
@interface HTChooseCustomerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *maintableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *takeInTF;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger currentIndexRow;
@property (nonatomic, strong) UIButton *currentSelectBtn;
@property (nonatomic, strong) UIView *customView;
@end

@implementation HTChooseCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择会员";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"完成" target:self action:@selector(finishAction)];
    self.dataArray = [NSMutableArray array];
    [self buildUI];
    self.page = 1;
    [self loadDataWithPage:self.page];
}

- (UIView*)customView {
    if (!_customView) {
        _customView =[[UIView alloc]initWithFrame:CGRectMake(-1, 0, HMSCREENWIDTH + 2, 40)];
        _customView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(HMSCREENWIDTH - 55, 5, 40, 28)];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_customView addSubview:btn];
    }
    return _customView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    textField.inputAccessoryView = self.customView; // 往自定义view中添加各种UI控件(以UIButton为例)
    CGRect frame = [self.view convertRect:self.view.bounds fromView:textField];
    NSLog(@"%@",NSStringFromCGRect(frame));
    return YES;
}

- (void)btnClicked{
    [self.view endEditing:YES];
    _currentIndexRow = -1;
    _currentSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.page = 1;
    [self loadDataWithPage:self.page];
}

- (void)loadDataWithPage:(NSInteger)page{
    NSString *moduleId;
    for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
        if ([mmm.moduleName isEqualToString:@"customer"]) {
            moduleId = [HTHoldNullObj getValueWithUnCheakValue:[mmm.moduleId stringValue]];
            break;
        }
    }
    
    NSDictionary *dic;
    if (self.takeInTF.text.floatValue > 10000000000 && self.takeInTF.text.floatValue < 20000000000) {
        dic = @{
                @"sortType":@(2),
                @"moduleId":moduleId,
                @"pageNo":@(page),
                @"pageSize":@"10",
                @"model.phone_cust":self.takeInTF.text,
                @"companyId":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId]
                };
    }else if(self.takeInTF.text.floatValue > 0 && self.takeInTF.text.floatValue < 9999 && self.takeInTF.text.length == 4){
        dic = @{
                @"sortType":@(2),
                @"moduleId":moduleId,
                @"pageNo":@(page),
                @"pageSize":@"10",
                @"model.phone_back_four_cust":self.takeInTF.text,
                @"companyId":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId]
                };
    }else if(self.takeInTF.text != nil && ![self.takeInTF.text isEqualToString:@""]){
        dic = @{
                @"sortType":@(2),
                @"moduleId":moduleId,
                @"pageNo":@(page),
                @"pageSize":@"10",
                @"companyId":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId],
                @"model.nickname_cust":self.takeInTF.text
                };
    }else{
        dic = @{
                @"sortType":@(2),
                @"moduleId":moduleId,
                @"pageNo":@(page),
                @"pageSize":@"10",
                @"companyId":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId]
                };
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValuesForKeysWithDictionary:dic];
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadCustomerList] params:postDic success:^(id json) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTCustomerListModel *model = [HTCustomerListModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        
        [self.maintableView reloadData];
        [self.maintableView.mj_header endRefreshing];
        [self.maintableView.mj_footer endRefreshing];
    } error:^{
        self.page--;
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.maintableView.mj_header endRefreshing];
        [self.maintableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD showError:NETERRORSTRING];
        [self.maintableView.mj_header endRefreshing];
        [self.maintableView.mj_footer endRefreshing];
    }];
}

- (void)finishAction{
    if (_isFromFace) {
        if (_currentIndexRow >= 20000) {
            HTCustomerListModel *model = _dataArray[_currentIndexRow - 20000];
            //明天从这里开始 注意传值传全 编辑完成后跳到详情时 点击返回回到首页
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:model.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            vc.faceNoVipModel = self.faceNoVipModel;
            vc.isFromFace = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            return;
        }
    }
    NSString *phone;
    if (_currentIndexRow >= 20000) {
        HTCustomerListModel *model = _dataArray[_currentIndexRow - 20000];
        if ([_delegate respondsToSelector:@selector(sendDic:WithModel:)]) {
            [_delegate sendDic:@{} WithModel:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (self.takeInTF.text.floatValue > 10000000000 && self.takeInTF.text.floatValue < 20000000000) {
            phone = _takeInTF.text;
            NSLog(@"完成");
            HTAddVipViewController *vc = [[HTAddVipViewController alloc] init];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
            }
            vc.isFromList = 1;
            vc.phone = [HTHoldNullObj getValueWithUnCheakValue:phone];
            [self.navigationController pushViewController:vc animated:YES];
//            if ([_delegate respondsToSelector:@selector(sendDic:WithModel:)]) {
//                [_delegate sendDic:@{@"phone" : phone} WithModel:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
        }else{
            return;
        }
    }
    
}

- (void)buildUI{
    self.maintableView.delegate = self;
    self.maintableView.dataSource = self;
    [self.maintableView registerNib:[UINib nibWithNibName:@"HTChooseCustomerCell" bundle:nil] forCellReuseIdentifier:@"HTChooseCustomerCell"];
    self.maintableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        [self loadDataWithPage:self.page];
    }];
    self.maintableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadDataWithPage:self.page];
    }];
    self.maintableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.sureBtn addTarget:self action:@selector(touchSure) forControlEvents:UIControlEventTouchUpInside];
}

//- (void)touchSure{
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HTChooseCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseCustomerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTCustomerListModel *model = _dataArray[indexPath.row];
    cell.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name].length == 0 ? @"未录入称呼" :  [HTHoldNullObj getValueWithUnCheakValue:model.name];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    cell.ageLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.birthday_cust];
    cell.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.phone_cust];
    cell.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.custlevel];
    cell.sexImv.image = [[HTHoldNullObj getValueWithUnCheakValue:model.sex_cust] isEqualToString:@"1"] ? [UIImage imageNamed:@"g-man"] :[UIImage imageNamed:@"g-woman"];
    cell.chooseBtn.tag = 20000 + indexPath.row;
    if (_currentIndexRow - 20000 == indexPath.row) {
        [cell.chooseBtn setImage:[UIImage imageNamed:@"singleSelected"] forState:UIControlStateNormal];
    }else{
        [cell.chooseBtn setImage:[UIImage imageNamed:@"singleUnselected"] forState:UIControlStateNormal];
    }
    [cell.chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)chooseAction:(UIButton *)btn{
    NSLog(@"当前第:%ld", btn.tag - 20000);
    [self.currentSelectBtn setImage:[UIImage imageNamed:@"singleUnselected"] forState:UIControlStateNormal];
    _currentIndexRow = btn.tag;
    self.currentSelectBtn = btn;
    [self.currentSelectBtn setImage:[UIImage imageNamed:@"singleSelected"] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row + 20000;
    UIButton *tempBtn = (UIButton *)[self.view viewWithTag:index];
    [self.currentSelectBtn setImage:[UIImage imageNamed:@"singleUnselected"] forState:UIControlStateNormal];
    self.currentSelectBtn = tempBtn;
    _currentIndexRow = index;
    [self.currentSelectBtn setImage:[UIImage imageNamed:@"singleSelected"] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
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
