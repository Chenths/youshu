//
//  HTTurnOutCompanyCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTurnOutCompanyCell.h"
#import "GuAgeview.h"
@interface HTTurnOutCompanyCell()<UITextFieldDelegate,HTGuageViewDelegate>{
    NSArray *dataArray;
    NSMutableArray *showArr;
    
}
@property (weak, nonatomic) IBOutlet UITextField *selecteCompanyTextField;

@property (weak, nonatomic) IBOutlet UIView *companyView;

@end
@implementation HTTurnOutCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.companyView changeCornerRadiusWithRadius:3];
    self.selecteCompanyTextField.delegate = self;
    showArr = [NSMutableArray array];
 }

- (void)setCompanys:(NSArray *)companys{
    _companys = companys;
    for (NSDictionary *dic in companys) {
        [showArr addObject:[dic getStringWithKey:@"companyName"]];
    }
}
/**
 *  文本开始编辑
 *
 */
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    GuAgeview *lacateView = [[GuAgeview alloc] initWithTitle:showArr delegate:self];
    lacateView.delega = self;
    [lacateView showInView:[HTShareClass shareClass].getCurrentNavController.view];
    return NO;
}
/**
 *  单选选中
 *
 *  @param actionSheet 单选框
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    GuAgeview *lacateView = (GuAgeview *)actionSheet;
    self.selecteCompanyTextField.text = showArr[lacateView.selectNum.intValue];
    if (self.selecteCompanyTextField.text.length > 0) {
        for (NSDictionary *dic in self.companys) {
            if ([[dic getStringWithKey:@"companyName"] isEqualToString:self.selecteCompanyTextField.text]) {
                [self.selectedDic setDictionary:dic];
            }
        }
    }
}
- (void)guageViewDismiss{
    
}
@end
