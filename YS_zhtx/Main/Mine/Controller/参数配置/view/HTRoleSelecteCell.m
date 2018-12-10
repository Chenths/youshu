//
//  HTRoleSelecteCell.m
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTRolsModel.h"
#import "HTRoleSelecteCell.h"
//按钮间竖直间距
#define VSPACE 10
//按钮件水平间距
#define SPACE 10
//按钮宽度
#define BtWidth 50
//按钮高度
#define BtHeight 30
@interface HTRoleSelecteCell()

@property (nonatomic,strong) NSMutableArray *selectedArray;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *holdLabel;

@property (weak, nonatomic) IBOutlet UIImageView *upOrDownImg;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic,strong) NSMutableArray *bts;

@property (weak, nonatomic) IBOutlet UIButton *finshBt;

@end;


@implementation HTRoleSelecteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.hidden = YES;
    self.backHeight.constant = 0.0f;
    [self.finshBt changeCornerRadiusWithRadius:3];
}
-(void)setSectionModel:(HTNoticePushSetionModel *)sectionModel{
    _sectionModel = sectionModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",sectionModel.titleStr];
    self.holdLabel.text = sectionModel.descStr;
    self.descLabel.text = sectionModel.holdStr;
}
- (void)setModel:(HTNoticpushSeterModel *)model{
    _model = model;
   
}
- (void)roleBtClicked:(UIButton *)sender{
    int i =  (int)sender.tag - 100;
    HTRolsModel *model = self.model.allRoles[i];
    if ([self.selectedArray containsObject:model]) {
        [self.selectedArray removeObject:model];
        [sender changeBorderStyleColor:[UIColor colorWithHexString:@"#F1F1F1"] withWidth:1];
        [sender setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
    }else{
        [self.selectedArray addObject:model];
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
        [sender setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
       
    }
}
- (IBAction)finshBtCicked:(id)sender {
    if (self.selectedArray.count == self.model.selectedRoles.count) {
        BOOL isSame = YES;
        for (HTRolsModel * role in self.selectedArray) {
            for (HTRolsModel *role1 in self.model.selectedRoles) {
                if (![[HTHoldNullObj getValueWithUnCheakValue:role.HTRolsModelId] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:role1.HTRolsModelId]] ) {
                    isSame = NO;
                    break;
                }
            }
        }
        if (!isSame) {
            [MBProgressHUD showError:@"您未进行更改"];
            return;
        }
    }
    [self.model.selectedRoles removeAllObjects];
    [self.model.selectedRoles addObjectsFromArray:self.selectedArray];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(okBtClickedWithCell:)]) {
        [self.delegate okBtClickedWithCell:self];
    }
}


- (IBAction)topBtClicked:(id)sender {
    if (self.backHeight.constant > 0) {
        self.backHeight.constant = 0;
        self.backView.hidden = YES;
    }else{
        for (UIView *subV in self.bts) {
            [subV removeFromSuperview];
        }
        [self.selectedArray removeAllObjects];
        [self.bts removeAllObjects];
        NSMutableArray *ids = [NSMutableArray array];
        for (HTRolsModel *obj in self.model.selectedRoles ) {
            [ids addObject:obj.HTRolsModelId];
            [self.selectedArray addObject:obj];
        }
        // bt的x坐标
        CGFloat btX = SPACE;
        // bt的y坐标
        CGFloat btY = SPACE;
        for (int i = 0 ; i < self.model.allRoles.count; i++) {
            HTRolsModel *roleModel = self.model.allRoles[i];
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
            [bt  setTitle:roleModel.name forState:UIControlStateNormal];
            bt.tag = 100 + i ;
            [bt changeCornerRadiusWithRadius:3];
            bt.titleLabel.font = [UIFont systemFontOfSize:14];
            if ([ids containsObject:roleModel.HTRolsModelId]) {
                [bt setBackgroundColor:[UIColor whiteColor]];
                [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
                [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
            }else{
                [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
                [bt setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
                [sender changeBorderStyleColor:[UIColor colorWithHexString:@"#F1F1F1"] withWidth:1];
            }
            [bt addTarget:self action:@selector(roleBtClicked:) forControlEvents:UIControlEventTouchUpInside];
            //       需要设置选中的颜色差图片
            CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 30;
            titleWidth =   titleWidth >= 40 ? titleWidth : 40;
            if ((btX + titleWidth) > HMSCREENWIDTH ) {
                bt.frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
                btY = btY + (VSPACE + BtHeight);
                btX = SPACE + titleWidth + SPACE;
            }else{
                bt.frame =    CGRectMake(btX , btY , titleWidth,BtHeight );
                btX = btX + titleWidth + SPACE;
            }
            [_backView addSubview:bt];
            [self.bts addObject:bt];
        }
        self.backView.hidden = NO;
        self.backHeight.constant = 110 + btY + BtHeight;
    }
    if (self.delegate) {
        [self.delegate topBtClicked];
    }
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
    
}
-(NSMutableArray *)bts{
    if (!_bts) {
        _bts = [NSMutableArray array];
    }
    return _bts;
}

@end
