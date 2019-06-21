//
//  HTAddVipWithPhoneController.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "PhoneNumberTools.h"
#import "HTCustomerReportViewController.h"
#import "HTAddVipViewController.h"
#import "HTAddVipWithPhoneController.h"

@interface HTAddVipWithPhoneController ()
@property (weak, nonatomic) IBOutlet UIView *phoneTextBack;

@property (weak, nonatomic) IBOutlet UIButton *nextBt;

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@end

@implementation HTAddVipWithPhoneController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增会员";
    [self configSub];
    [self loadAuth];
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)nextBtClicked:(id)sender {
    
    if (self.phoneText.text.length == 0) {
        [MBProgressHUD showError:@"请输入电话号码"];
        return;
    }
    self.phoneText.text = [[self.phoneText.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    if (![PhoneNumberTools isMobileNumber:self.phoneText.text]) {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"phone":[HTHoldNullObj getValueWithUnCheakValue:self.phoneText.text]
                          };
    self.nextBt.enabled = NO;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,cheakCustByPhone] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"data"] getStringWithKey:@"id"].length == 0) {
            HTAddVipViewController *vc = [[HTAddVipViewController alloc] init];
            vc.custId = [json[@"data"] getStringWithKey:@"customerId"];
            vc.model = self.faceModel;
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
            }
            vc.phone = [HTHoldNullObj getValueWithUnCheakValue:self.phoneText.text];
            vc.path = self.path;
            [self.navigationController pushViewController:vc animated: YES];
        }else{
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"该账户已存在，是否查看详情" btsArray:@[@"取消",@"确定"] okBtclicked:^{
//               跳转编辑页面
                HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
                HTCustomerListModel *mm = [[HTCustomerListModel alloc] init];
                mm.custId = [json[@"data"] getStringWithKey:@"id"];
                vc.model = mm;
                [self.navigationController pushViewController:vc animated:YES];
            } cancelClicked:^{
            }];
            [alert show];
        }
        self.nextBt.enabled = YES;
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        self.nextBt.enabled = YES;
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        self.nextBt.enabled = YES;
    }];
}
#pragma mark -private methods
-(void)configSub{
    [self.phoneTextBack changeCornerRadiusWithRadius:3];
    [self.nextBt changeCornerRadiusWithRadius:3];
}
/**
 *  请求权限
 */
- (void) loadAuth{
    [MBProgressHUD showMessage:@""];
    __weak typeof(self ) weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadModuleAuth];
    
    NSDictionary *dict =@{
                          @"moduleId":[HTHoldNullObj getValueWithUnCheakValue:self.moduleId]
                          
                          };
    [HTHttpTools GET:url params:dict success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL  auth = [json[@"data"][@"moduleAuthorityRule"][@"add"] boolValue];
        if (auth) {
            
        }else{
            [MBProgressHUD showError:@"权限不足,无法进行此操作"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        
        
    } error:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求数据失败，服务器忙"];
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark - getters and setters

@end
