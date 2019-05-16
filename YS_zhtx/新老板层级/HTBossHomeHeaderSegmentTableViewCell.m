//
//  HTBossHomeHeaderSegmentTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/4/26.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTBossHomeHeaderSegmentTableViewCell.h"

@implementation HTBossHomeHeaderSegmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.SegmentC addTarget:self action:@selector(selectsed:) forControlEvents:UIControlEventValueChanged];
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.SegmentC setTitleTextAttributes:attributes
                                 forState:UIControlStateNormal];
    
}

- (void)selectsed:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *)sender;

    if (self.delegate) {
        [self.delegate segmentControlValueChangedDelegate:seg.selectedSegmentIndex + 1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
