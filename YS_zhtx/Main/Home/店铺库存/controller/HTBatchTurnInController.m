//
//  HTBatchTurnInController.m
//  有术
//
//  Created by mac on 2018/3/12.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBatchTurnInController.h"
#import "HTBatchTurnInCell.h"
#import "HTCahargeProductModel.h"
#import "HTLoginDataPersonModel.h"
#import "HTTurnOutDiscountCell.h"
@interface HTBatchTurnInController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *okBtBottom;
@property (nonatomic,strong) NSMutableDictionary * discount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end

@implementation HTBatchTurnInController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调入库存";
    [self createUI];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTTurnOutDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTurnOutDiscountCell" forIndexPath:indexPath];
        cell.discount = self.discount;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        HTBatchTurnInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBatchTurnInCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 44 : 110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  section == 0 ? 1 :  self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return section == 0 ? 0.01 : 20.0f;
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
#pragma mark -EventResponse

#pragma mark -private methods
- (void)createUI{
    self.descTextView.delegate = self;
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    [self.mytableView registerNib:[UINib nibWithNibName:@"HTBatchTurnInCell" bundle:nil] forCellReuseIdentifier:@"HTBatchTurnInCell"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"HTTurnOutDiscountCell" bundle:nil] forCellReuseIdentifier:@"HTTurnOutDiscountCell"];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.mytableView.tableFooterView = view;
    self.bottomHeight.constant = 16 + SafeAreaBottomHeight;
}
#pragma mark - getters and setters

- (IBAction)turnInBtClicked:(id)sender {
    
    NSMutableArray *updateBtchjson = [NSMutableArray array];
    for (HTCahargeProductModel *obj in self.dataArray) {
        HTChargeProductInfoModel * productmodel = obj.selectedModel;
        NSDictionary *dic = @{
                              @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:productmodel.stylecode],
                              @"colorCode":[HTHoldNullObj getValueWithUnCheakValue:productmodel.colorcode],
                              @"sizeGroup":[HTHoldNullObj getValueWithUnCheakValue:productmodel.sizegroup],
                              [NSString stringWithFormat:@"%@/%@",productmodel.size,productmodel.sizecode] : [HTHoldNullObj getValueWithUnCheakValue:obj.turnInNums],
                              };
        [updateBtchjson addObject:dic];
    }
    if (([self.discount getStringWithKey:@"discount"].length == 0) && ([self.discount getStringWithKey:@"money"].length == 0)) {
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调货折扣或成本价格未设置，是否继续？" btsArray:@[@"取消",@"确认"] okBtclicked:^{
            [self turnInNetWorkWithArr:updateBtchjson];
        }
                                                                               cancelClicked:^{
                                                                                   
                                                                               }];
        [alert show];
        
        return;
    }
    if ([self.discount getStringWithKey:@"discount"].length > 0) {
        if (  [self.discount getFloatWithKey:@"discount"] >= 1 && [self.discount getFloatWithKey:@"discount"]  <= 10) {
        }else{
            [MBProgressHUD showError:@"成本折扣应在0折到10折" toView:self.view];
            return;
        }
    }
    [self turnInNetWorkWithArr:updateBtchjson];
    
}

- (void)turnInNetWorkWithArr:(NSMutableArray *)updateBtchjson{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"styleCode":@"",
                          @"colorCode":@"",
                          @"remarks":[HTHoldNullObj getValueWithUnCheakValue:self.descTextView.text],
                          @"updateBtchJson":[updateBtchjson arrayToJsonString],
                          @"sizeGroup":@"",
                          @"loginName":[HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.person.name ],
                          @"swapType":@"11",
                          @"initDiscount":[self.discount getStringWithKey:@"discount"].length == 0 ? @"" : [NSString stringWithFormat:@"%.1lf",[self.discount getFloatWithKey:@"discount"]]
                          ,
                          @"initPrice":[self.discount getStringWithKey:@"money"].length == 0 ? @"" : [self.discount getStringWithKey:@"money"]
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/api/product_stock/save_swap_product_stock_in_4_app.html"] params: dic  success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"调入成功" btTitle:@"确定" okBtclicked:^{
                [self.navigationController popViewControllerAnimated:YES];
                if (self.reloadList) {
                    self.reloadList();
                }
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

-(NSMutableDictionary *)discount{
    if (!_discount) {
        _discount = [NSMutableDictionary dictionary];
    }
    return _discount;
}


@end
