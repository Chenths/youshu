//
//  HTPrinterViewController.m
//  24小助理
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTPrinterViewController.h"
#import "HTAccountTool.h"
#import "HTPrintTableViewCell.h"
#import "UIBarButtonItem+Extension.h"
#import "HTPrinterTool.h"
@interface HTPrinterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

{
    HTPrinterTool *printManager ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *setpagesBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btBottomHeight;

@end

@implementation HTPrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTB];
    
}
- (void)createTB{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HTPrintTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    printManager = [[HTPrinterTool alloc] init];
    printManager.isNoPrint = YES;
    __weak typeof(self) weakSelf = self;
    printManager.dosucces = ^{
        __strong  typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadData];
    };
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-goodsAdd" highImageName:@"g-goodsAdd" target:self action:@selector(rightBtClicked:)];
    _setpagesBt.layer.masksToBounds = YES;
    _setpagesBt.layer.cornerRadius = 5;
    self.btBottomHeight.constant = SafeAreaBottomHeight + 8;
}

- (IBAction)setPageClicked:(id)sender {
    
    if ([HTShareClass shareClass].loginModel.printers.count == 0 ) {
        [MBProgressHUD showError:@"请先添加打印设备"];
        return;
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请设置打印联数" message:nil delegate:  self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    av.tag = 800;
    av.delegate = self;
    [av textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    
    NSDictionary *dict =  [[HTShareClass shareClass].loginModel.printers firstObject];
    NSDictionary *dic = [dict[@"config"] dictionaryWithJsonString];
    [av textFieldAtIndex:0].placeholder  = [NSString stringWithFormat:@"当前设置为%@联",dic[@"printCount"]];
    [av show];
}


- (void)rightBtClicked:(UIButton *) sender{
    [printManager addPrinter];
}

- (void)loadData{
    
    [HTAccountTool loginWillEnterForeground:^{
        
    } Succes:^(id json) {
        if ([HTShareClass shareClass].loginModel.printers.count == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lastVersion"];
        }
        [self.tableView reloadData];
    }];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        if ([alertView textFieldAtIndex:0].text.length == 0) {
        }else{
            NSDictionary *dic = @{
                                  @"companyId": [HTShareClass shareClass].loginModel.companyId,
                                  @"printCount":[alertView textFieldAtIndex:0].text
                                      };
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleDevice,modifyCompanyPrinterCount] params:dic success:^(id json) {
              
                if ([json[@"isSuccess"] intValue] == 1) {
                     [MBProgressHUD showSuccess:@"设置成功"];
                    [HTAccountTool loginWillEnterForeground:^{
                    } Succes:^(id json){
                    }];
                }
            } error:^{
                [MBProgressHUD showError:@"设置失败，网络繁忙"];
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"设置失败，请检查你的网络"];
            }];
            
            NSString *length = [alertView textFieldAtIndex:0].text;
            [[NSUserDefaults standardUserDefaults] setInteger:length.integerValue forKey:@"printPage"];
           
        }
    }
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [HTShareClass shareClass].loginModel.printers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTPrintTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell.dataDic = [HTShareClass shareClass].loginModel.printers[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.reload =^{
        __strong  typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadData];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectWhich) {
        [self.navigationController popViewControllerAnimated:YES];
        self.selectWhich([[HTShareClass shareClass].loginModel.printers[indexPath.row] valueForKey:@"name"]);
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    __weak typeof(self) weakSelf = self;
    NSDictionary *dataDic = [HTShareClass shareClass].loginModel.printers[indexPath.row];
    
    
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否确定删除此设备" btsArray:@[@"取消",@"确定"] okBtclicked:^{
        NSDictionary *dic = @{
                              @"id": dataDic[@"id"]
                              };
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleDevice,@"remove_printer_4_app.html"] params:dic success:^(id json) {
            if ([json[@"isSuccess"] intValue] == 1) {
                __strong  typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf loadData];
            }
        } error:^{
            [ MBProgressHUD showError:@"网络繁忙，删除失败"];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"删除失败，请检查网络"];
        }];
    } cancelClicked:^{
    }];
    [alert show];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


@end
