//
//  HTEditVipCustLevelCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "GuAgeview.h"
#import "HTEditVipCustLevelCell.h"
@interface HTEditVipCustLevelCell()<HTGuageViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hubPress;

@end
@implementation HTEditVipCustLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hubPress.hidden = YES;
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellClicked)];
    [self.contentView addGestureRecognizer:tap];
}
-(void)loadLevelConfig{
  
}
-(void)tapCellClicked{
    if (self.superview.superview) {
        [self.superview.superview endEditing:YES];
    }
    if(self.model.levels.count == 0){
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadCompanyCustLevel] params:@{@"companyId":[HTShareClass shareClass].loginModel.companyId} success:^(id json) {
            self.model.levels = json[@"data"];
            NSMutableArray *showArr = [NSMutableArray array];
            for (NSDictionary *dic in self.model.levels) {
                [showArr addObject:[dic getStringWithKey:@"name"]];
            }
            [MBProgressHUD hideHUD];
            GuAgeview *lacateView = [[GuAgeview alloc] initWithTitle:showArr delegate:self];
            [lacateView showInView:[[UIApplication sharedApplication].delegate window]];
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    }else{
        NSMutableArray *showArr = [NSMutableArray array];
        for (NSDictionary *dic in self.model.levels) {
            [showArr addObject:[dic getStringWithKey:@"name"]];
        }
        GuAgeview *lacateView = [[GuAgeview alloc] initWithTitle:showArr delegate:self];
        [lacateView showInView:[[UIApplication sharedApplication].delegate window]];
    }
   
}
/**
 *  单选选中
 *
 *  @param actionSheet 单选框
 *  buttonIndex 选中的index
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    GuAgeview *lacateView = (GuAgeview *)actionSheet;
    NSDictionary *dic = self.model.levels[lacateView.selectNum.intValue];
    
    NSDictionary *ddddic = @{
                             @"level":[NSNumber numberWithInteger:[dic getStringWithKey:@"id"].integerValue],
                             @"id":[HTShareClass shareClass].loginModel.companyId,
                             };
    [self.requestDic setObject:[@[ddddic] arrayToJsonString] forKey:self.model.SearchKey];
    self.model.SearchValue = [dic getStringWithKey:@"name"];
    self.valueLabel.text = [dic getStringWithKey:@"name"];
}

-(void)setModel:(HTCustEditConfigModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    self.valueLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    if (model.readOnly) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.valueLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    if (model.require) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }
}
-(void)setRequestDic:(NSMutableDictionary *)requestDic{
    _requestDic = requestDic;
    self.hubPress.hidden = YES;
    self.valueLabel.hidden = NO;
    if ([requestDic getStringWithKey:self.model.SearchKey].length == 0) {
        self.valueLabel.text = @"未添加";
    }else{
        
        if(self.model.levels.count == 0){
            self.hubPress.hidden = NO;
            self.valueLabel.hidden = YES;
            [self.hubPress startAnimating];
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadCompanyCustLevel] params:@{@"companyId":[HTShareClass shareClass].loginModel.companyId} success:^(id json) {
                self.hubPress.hidden = YES;
                self.valueLabel.hidden = NO;
                [self.hubPress stopAnimating];
                self.model.levels = json[@"data"];
                for (NSDictionary *dic in self.model.levels) {
                    NSArray *levels = [[requestDic getStringWithKey:self.model.SearchKey] ArrayWithJsonString];
                    NSString *idddd = @"";
                    for (NSDictionary *dic in levels) {
                        if ([[dic getStringWithKey:@"id"] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId]]) {
                            idddd = [dic getStringWithKey:@"level"];
                            break;
                        }
                    }
                    if ([[dic getStringWithKey:@"id"] isEqualToString:idddd]) {
                        self.valueLabel.text = [dic getStringWithKey:@"name"];
                        break;
                    }
                }
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:NETERRORSTRING];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:NETERRORSTRING];
            }];
        }else{
            for (NSDictionary *dic in self.model.levels) {
                NSArray *levels = [[requestDic getStringWithKey:self.model.SearchKey] ArrayWithJsonString];
                NSString *idddd = @"";
                for (NSDictionary *dic in levels) {
                    if ([[dic getStringWithKey:@"id"] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId]]) {
                        idddd = [dic getStringWithKey:@"level"];
                        break;
                    }
                }
                if ([[dic getStringWithKey:@"id"] isEqualToString:idddd]) {
                    self.valueLabel.text = [dic getStringWithKey:@"name"];
                    break;
                }
            }
        }
        
        
    }
}

@end
