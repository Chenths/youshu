//
//  HTSeemoreHeaderView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSeemoreHeaderView.h"
@interface HTSeemoreHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *seemoreClicked;

@end
@implementation HTSeemoreHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.seemoreClicked changeCornerRadiusWithRadius:self.seemoreClicked.height *0.5];
    [self.seemoreClicked changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
}

- (IBAction)moreClicked:(id)sender {
    if (self.delegate) {
        [self.delegate moreClicked];
    }
}

@end
