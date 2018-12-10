//
//  HTPrintTableViewCell.m
//  24小助理
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTCustomDefualAlertView.h"
#import "HTPrintTableViewCell.h"
@interface HTPrintTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *imageBt1;



@property (weak, nonatomic) IBOutlet UIImageView *holdImf;


@property (weak, nonatomic) IBOutlet UIButton *imageBt2;

@end


@implementation HTPrintTableViewCell

- (void)setDataDic:(NSDictionary *)dataDic{
    
    _dataDic = dataDic;
    
    NSDictionary *dict = [dataDic[@"config"] dictionaryWithJsonString];
    
    if ([dict[@"default"] isEqualToString:@"1"]) {
        self.holdImf.image = [UIImage imageNamed:@"singleSelected"];
        _imageBt1.enabled = NO;
        _setBt.enabled = NO;
        [_setBt setTitle:@"默认设备" forState:UIControlStateNormal];
    }else{
        _imageBt1.enabled = YES;
        _setBt.enabled = YES;
        self.holdImf.image = [UIImage imageNamed:@"singleUnselected"];
        [_setBt setTitle:@"设为默认" forState:UIControlStateNormal];
        
    }
    
    _printLabel.text = dataDic[@"deviceCode"];
  
    
}
- (IBAction)deleClicked:(id)sender {
    
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否确定删除此设备" btsArray:@[@"取消",@"确定"] okBtclicked:^{
        NSDictionary *dic = @{
                              @"id": self.dataDic[@"id"]
                              };
        
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleDevice,@"remove_printer_4_app.html"] params:dic success:^(id json) {
            if ([json[@"isSuccess"] intValue] == 1) {
                self->_reload();
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
- (IBAction)setClicked:(id)sender {
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"id": self.dataDic[@"id"]
                          };
    
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleDevice,@"add_default_printer_4_app.html"] params:dic success:^(id json) {
        if ([json[@"isSuccess"] intValue] == 1) {
            self->_reload();
        }
    } error:^{
        [ MBProgressHUD showError:@"服务器忙，设置失败"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"设置失败，请检查网络"];
    }];
    
    
}




@end
