//
//  HTChoosePrintSizeCell.m
//  有术
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTChoosePrintSizeCell.h"

@interface HTChoosePrintSizeCell()



@end

@implementation HTChoosePrintSizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.smallBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.smallBt  setBackgroundColor:[UIColor colorWithHexString:@"fc6b44"]];
    [self.bigBt setTitleColor:[UIColor colorWithHexString:@"cbcbcb"] forState:UIControlStateNormal];
    self.smallBt.layer.cornerRadius = 3;
    self.smallBt.layer.masksToBounds = YES;
    self.bigBt.layer.cornerRadius = 3;
    self.smallBt.layer.masksToBounds = YES;

}

- (void)setSeletedSize:(int)seletedSize{
    _seletedSize = seletedSize;
    if (_seletedSize == 0) {
        [self smallSeleted:nil];
    }else{
        [self bigSeleted:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)smallSeleted:(id)sender {
   
    [self.smallBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.smallBt  setBackgroundColor:[UIColor colorWithHexString:@"fc6b44"]];
    
    [self.bigBt setTitleColor:[UIColor colorWithHexString:@"cbcbcb"] forState:UIControlStateNormal];
    [self.bigBt  setBackgroundColor:[UIColor whiteColor]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseThisSize:)]) {
        [self.delegate choseThisSize:0];
    }
    
}
- (IBAction)bigSeleted:(id)sender {
    
    [self.bigBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigBt  setBackgroundColor:[UIColor colorWithHexString:@"fc6b44"]];
    
    [self.smallBt setTitleColor:[UIColor colorWithHexString:@"cbcbcb"] forState:UIControlStateNormal];
    [self.smallBt  setBackgroundColor:[UIColor whiteColor]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseThisSize:)]) {
        [self.delegate choseThisSize:1];
    }
}

@end
