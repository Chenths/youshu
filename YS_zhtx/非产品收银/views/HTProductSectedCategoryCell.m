//
//  HTProductSectedCategoryCell.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "GuAgeview.h"
#import "HTMenuModle.h"
#import "HTProductSectedCategoryCell.h"
//#import "HTCategroyViewController.h"
@interface HTProductSectedCategoryCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *TextFild;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
@implementation HTProductSectedCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.TextFild.enabled = NO;
//    self.TextFild
    // Initialization code
}

- (IBAction)textFiedEdit:(id)sender {
    
   
    if (self.dataArray.count > 0) {
        NSMutableArray *showArr = [NSMutableArray array];
        for (NSDictionary *dic in self.dataArray) {
            [showArr addObject:[dic getStringWithKey:@"text"]];
        }
        GuAgeview *lacateView = [[GuAgeview alloc] initWithTitle:showArr delegate:self];
        [lacateView showInView:[[UIApplication sharedApplication].delegate window]];
    }else{
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,@"/load_categories_tree_4_app.html"] params:@{@"companyId":[HTShareClass shareClass].loginModel.companyId} success:^(id json) {
            [self.dataArray addObjectsFromArray:[json getArrayWithKey:@"data"]];
            NSMutableArray *showArr = [NSMutableArray array];
            for (NSDictionary *dic in self.dataArray) {
                [showArr addObject:[dic getStringWithKey:@"text"]];
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
    NSDictionary *dic = self.dataArray[lacateView.selectNum.intValue];
    self.TextFild.text = dic[@"text"];
    self.model.value = [dic getStringWithKey:@"text"];
    self.model.categoreId = [dic getStringWithKey:@"id"];
}

- (void)setModel:(HTEditFastProductModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    if (model.value.length > 0) {
        self.TextFild.text = [NSString stringWithFormat:@"%@%@%@",model.pre,model.value,model.suf];
    }
    self.TextFild.keyboardType = model.keyBroardType;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
