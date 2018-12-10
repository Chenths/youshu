//
//  HTSearchBoxStyleBetweenTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HcdDateTimePickerView.h"
#import "HTSearchBoxStyleBetweenTableViewCell.h"

@interface HTSearchBoxStyleBetweenTableViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *beginBack;
@property (weak, nonatomic) IBOutlet UITextField *beginField;

@property (weak, nonatomic) IBOutlet UITextField *endField;

@property (weak, nonatomic) IBOutlet UIView *endBack;

@end


@implementation HTSearchBoxStyleBetweenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.beginBack changeCornerRadiusWithRadius:3];
    [self.endBack changeCornerRadiusWithRadius:3];
    self.beginField.delegate = self;
    self.endField.delegate = self;
}
-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    self.beginField.text = [searchDic getStringWithKey:@"model.birthday_cust_to"];
    self.endField.text = [searchDic getStringWithKey:@"model.birthday_cust_from"];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
    dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
    __weak typeof(self) weakSelf = self;
    dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (textField == strongSelf.beginField) {
            textField.text = dateTimeStr;
            [self.searchDic setObject:dateTimeStr forKey:@"model.birthday_cust_to"];
        }
        if (textField == strongSelf.endField) {
            textField.text = dateTimeStr;
            [self.searchDic setObject:dateTimeStr forKey:@"model.birthday_cust_from"];
        }
    };
    [[[UIApplication sharedApplication].delegate window] addSubview:dateTimePickerView];
    dispatch_async(dispatch_get_main_queue(), ^{
    [dateTimePickerView showHcdDateTimePicker];
    });
    
  
    return NO;
}
@end
