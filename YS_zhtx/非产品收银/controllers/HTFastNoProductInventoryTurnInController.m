//
//  HTFastNoProductInventoryTurnInController.m
//  有术
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTTuneTypeTableViewCell.h"
#import "HTProductNumbersCell.h"
#import "HTFastNoProductInventoryTurnInController.h"
#import "HTEditFastProductModel.h"
#import "HTLoginDataPersonModel.h"

@interface HTFastNoProductInventoryTurnInController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *okBtBottom;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (nonatomic,strong) NSMutableDictionary *typeDic;

@property (nonatomic,strong) NSArray *typeArray;

@property (nonatomic,strong) HTEditFastProductModel *numModel;

@end

@implementation HTFastNoProductInventoryTurnInController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库存调入";
    [self createUI];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTTuneTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTuneTypeTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.key = @"key";
        cell.dataList = self.typeArray;
        cell.typeDic = self.typeDic;
        return  cell;
    }else{
        HTProductNumbersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductNumbersCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.numModel;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 40)];
    v.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, HMSCREENWIDTH, 40)];
    title.text = @"请选择调入类型";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithHexString:@"#222222"];
    [v addSubview:title];
    if (section == 0) {
    return v;
    }else{
        UIView *vv = [[UIView alloc] init];
        vv.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        return vv;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ?  40 : 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
#pragma mark -CustomDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.holdLabel.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.holdLabel.hidden = NO;
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)turnInClicked:(id)sender {
    if (self.numModel.value.integerValue < 1) {
        [MBProgressHUD showError:@"请输入正确的调入数量"];
        return;
    }
    if ([self.typeDic getStringWithKey:@"value"].length == 0) {
        [MBProgressHUD showError:@"请选择调入类型"];
        return;
    }
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                       
                          @"remarks":[HTHoldNullObj getValueWithUnCheakValue:self.descTextView.text],
                          @"loginName":[HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.person.name ],
                          @"swapType":[self.typeDic getStringWithKey:@"value"],
                          @"stockCount":self.numModel.value
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/api/product_stock/crm_swap_stock_4_app.html"] params: dic  success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调入成功" btTitle:@"确定" okBtclicked:^{
                 [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
        }else{
            [MBProgressHUD showError:[[json getStringWithKey:@"msg"] length] > 0 ? [json getStringWithKey:@"msg"] : @"调入失败" toView:self.view];
        }
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"检查你的网络"];
    }];
    
}
#pragma mark -private methods
- (void)createUI{
    self.descTextView.delegate = self;
    self.okBtBottom.constant = isIPHONEX ?  SafeAreaBottomHeight : 0.0f;
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    self.mytableView.backgroundColor = [UIColor clearColor];
    [self.mytableView registerNib:[UINib nibWithNibName:@"HTTuneTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTuneTypeTableViewCell"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"HTProductNumbersCell" bundle:nil] forCellReuseIdentifier:@"HTProductNumbersCell"];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.mytableView.tableFooterView = view;
}


#pragma mark - getters and setters
-(NSArray *)typeArray{
    if (!_typeArray) {
        _typeArray = @[
                       @{
                           @"key":@"进货",
                           @"value":@"10"
                           },
                       @{
                           @"key":@"补货",
                           @"value":@"11"
                           },
                       ];
    }
    return _typeArray;
}
- (NSMutableDictionary *)typeDic{
    if (!_typeDic) {
        _typeDic = [NSMutableDictionary dictionary];
    }
    return _typeDic;
}
-(HTEditFastProductModel *)numModel{
    if (!_numModel) {
        _numModel = [[HTEditFastProductModel alloc] init];
        _numModel.title = @"调入数量";
    }
    return _numModel;
}
@end
