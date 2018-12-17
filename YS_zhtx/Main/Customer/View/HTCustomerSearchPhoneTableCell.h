//
//  HTCustomerSearchPhoneTableCell.h
//  YS_zhtx
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCustomerSearchPhoneTableCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *searchDic;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
