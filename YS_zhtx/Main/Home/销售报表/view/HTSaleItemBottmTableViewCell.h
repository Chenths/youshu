//
//  HTSaleItemBottmTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSaleItemMode.h"
@protocol chooseShowPayDetailDelegate <NSObject>
//0为左 1为右
- (void)selectChooseShowPayKindType:(NSInteger)type; //声明协议方法
@end
@interface HTSaleItemBottmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomImv;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImv;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) HTSaleItemMode *leftModel;
@property (nonatomic, strong) HTSaleItemMode *rightModel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, assign) BOOL ifShowDownImv;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
//0 为未选中 1为选中左侧 2为选中右侧
@property (nonatomic, assign) NSInteger currentSelectShowPayKindType;
@property (nonatomic, weak) id<chooseShowPayDetailDelegate> delegate;
@end
