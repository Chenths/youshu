//
//  HTMessgeTableViewCell.m
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTMessgeModel.h"
#import "HTMessgeTableViewCell.h"
#import "PNColor.h"
@interface HTMessgeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLable;

@property (weak, nonatomic) IBOutlet UIView *stateBackView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateBackWidtj;

@end

@implementation HTMessgeTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.stateLable.hidden = YES;
    self.stateBackView.hidden = YES;
    self.stateBackWidtj.constant = 0;
    self.stateBackView.layer.masksToBounds = YES;
    self.stateBackView.layer.cornerRadius = 3;
    [self.stateBackView layoutIfNeeded];
}

- (void)setModel:(HTMessgeModel *)model{
        _model = model;
    if (model) {
        _titleLabel.text = model.title;
        _contentLabel.text = model.content;
        _dateLabel.text = model.noticeAt;
        if ([_model.isRead intValue] == 0) {
            [self notLook];
        }else{
            [self isLook];
        }
        if (model.isWill) {
            _readView.hidden = YES;
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.dateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
        if (model.showState) {
            [self changeStateWithHandelType:[HTHoldNullObj getValueWithUnCheakValue: model.handleType]];
        }else{
            self.stateLable.hidden = YES;
            self.stateBackView.hidden = YES;
            self.stateBackWidtj.constant = 0;
            [self.stateBackView layoutIfNeeded];
        }
    }
}
- (void) isLook{
    
    _readView.hidden = YES;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
}

- (void) notLook {
    _readView.hidden = NO;
    _readView.layer.masksToBounds = YES;
    _readView.layer.cornerRadius = 4;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
}
-(void) changeStateWithHandelType:(NSString *)handleType{
    self.stateBackView.hidden = NO;
    self.stateLable.hidden = NO;
    self.stateBackWidtj.constant = 45;
    if ([handleType isEqualToString:@"0"]) {
        self.stateLable.text = @"未处理";
        self.stateBackView.backgroundColor = PNDarkBlue;
    }else if([handleType isEqualToString:@"1"]){
        self.stateLable.text = @"已同意";
        self.stateBackView.backgroundColor = PNGreen;
    }else if ([handleType isEqualToString:@"-1"]){
        self.stateLable.text = @"已拒绝";
        self.stateBackView.backgroundColor = PNRed;
    }else{
        self.stateBackView.hidden = YES;
        self.stateLable.hidden = YES;
        self.stateBackWidtj.constant = 0;

    }
    [self.stateBackView layoutIfNeeded];
}

@end
