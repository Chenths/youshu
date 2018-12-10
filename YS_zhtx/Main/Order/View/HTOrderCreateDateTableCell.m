//
//  HTOrderCreateDateTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HcdDateTimePickerView.h"
#import "HTOrderCreateDateTableCell.h"
@interface HTOrderCreateDateTableCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
@implementation HTOrderCreateDateTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
}
-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    self.textField.text = [searchDic getStringWithKey:@"model.create_date_to"];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateTimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
    dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
    __weak typeof(self) weakSelf = self;
    dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.searchDic setObject:endTime forKey:@"model.create_date_to"];
        [strongSelf.searchDic setObject:beginTime  forKey:@"model.create_date_from"];
        strongSelf.textField.text = [NSString stringWithFormat:@"%@-%@",beginTime,endTime];
    };
   
    [[[UIApplication sharedApplication].delegate window] addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
    return NO;
}

@end
