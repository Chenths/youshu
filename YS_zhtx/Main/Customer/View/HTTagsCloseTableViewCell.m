//
//  HTTagsCloseTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTagsCloseTableViewCell.h"
//按钮间竖直间距
#define VSPACE 10
//按钮件水平间距
#define SPACE 10
//按钮宽度
#define BtWidth 50
//按钮高度
#define BtHeight 30
#import "HTCustomerButton.h"
@interface HTTagsCloseTableViewCell()

@property (weak, nonatomic) IBOutlet UIScrollView *backScollerView;

@property (weak, nonatomic) IBOutlet UIButton *openBt;

@property (nonatomic,strong) NSArray *colors;

@end
@implementation HTTagsCloseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backScollerView.showsVerticalScrollIndicator = NO;
    self.backScollerView.showsHorizontalScrollIndicator = NO;
}

-(void)setModel:(HTNewTagsModel *)model{
    _model = model;
    for (UIView *sub in self.backScollerView.subviews) {
        [sub removeFromSuperview];
    }
    NSMutableArray *arrs = [model.tagsArray mutableCopy];
    if (model.tageType == HTTAGShop ) {
        [arrs addObject:@{
                          @"tagname":@" + ",
                          }];
    }
    CGFloat btX = SPACE;
    for (int i = 0; i < arrs.count; i++) {
        NSDictionary *dataDic = arrs[i];
        NSString *name = [dataDic  getStringWithKey:@"tagname"];
        CGFloat titleWidth = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20 + 16;
        titleWidth =   titleWidth >= BtWidth ? titleWidth : 40;
        CGRect frame = CGRectZero;
        frame =  CGRectMake(btX ,(self.backScollerView.height - BtHeight) * 0.5, titleWidth ,BtHeight);
        btX = btX + titleWidth + SPACE;
        HTCustomerButton *bt = [[HTCustomerButton alloc] initCustomerWithFrame:frame andColor:[UIColor colorWithHexString:self.colors[i % self.colors.count]]];
        [bt setTitle:name forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        if ([bt.titleLabel.text isEqualToString:@" + "]) {
            [bt addTarget:self action:@selector(addtag) forControlEvents:UIControlEventTouchUpInside];
        }
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [self.backScollerView addSubview:bt];
    }
    self.backScollerView.contentSize = CGSizeMake(btX + 60, self.backScollerView.height);
}

- (IBAction)moreclicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomoalTypeClicekedWithCell:)]) {
        [self.delegate nomoalTypeClicekedWithCell:self];
    }
}
-(void)addtag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomorlTypeAddTag)]) {
        [self.delegate nomorlTypeAddTag];
    }
}

- (NSArray *)colors{
    if (!_colors) {
        _colors = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    }
    return _colors;
}

@end
