//
//  HTInventoryYearInfoTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define PIEWIDTH 183.0
#import "HTInventoryDescInfoCollectionCell.h"
#import "HTInventoryYearInfoTableCell.h"
#import "PNChart.h"
@interface HTInventoryYearInfoTableCell()<UICollectionViewDelegate,UICollectionViewDataSource,PNChartDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic,strong) PNPieChart *pieChart;

@end
@implementation HTInventoryYearInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubs];
}

-(void)initSubs{
    [self createCollecionView];
}

-(void)createCollecionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake( (HMSCREENWIDTH - 1)  / 2 , 166 );
    layout.minimumInteritemSpacing = 1 ;
    layout.minimumLineSpacing = 1 ;
    //    设置collectionView的frame
    self.dataCollectionView.collectionViewLayout = layout;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.dataSource = self;
    self.dataCollectionView.scrollEnabled = NO;
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTInventoryDescInfoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTInventoryDescInfoCollectionCell"];
    self.dataCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
}
-(void)setModel:(HTPiesModel *)model{
    _model = model;
    NSArray *colors = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    for (int i = 0 ; i < model.data.count ; i++) {
        HTPieDataItem *mmm = model.data[i];
        if (i < colors.count) {
            mmm.color = [UIColor colorWithHexString:colors[i]];
        }
    }
    if (self.pieChart) {
        [self.pieChart removeFromSuperview];
    }
    NSMutableArray *items  = [NSMutableArray array];
    for (HTPieDataItem *model in self.model.data) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:model.data.floatValue color:model.color description:model.name]];
    }
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((HMSCREENWIDTH - PIEWIDTH) / 2 , 25 , PIEWIDTH , PIEWIDTH ) items:items];
    self.pieChart.delegate = self;
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.pieTitelText = self.model.title;
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self. pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = YES;
    self.pieChart.innerCircleRadius = (PIEWIDTH - 68 ) * 0.5;
    self.pieChart.outerCircleRadius = PIEWIDTH * 0.5;
    [self.pieChart strokeChart];
    [self.contentView addSubview:self.pieChart];
    [self.dataCollectionView reloadData];
    self.collectionViewHeight.constant = (model.data.count / 2 ) * 166 + ((model.data.count % 2) == 0 ? 0 : 166);
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTInventoryDescInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTInventoryDescInfoCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.model.data[indexPath.row];
    if([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]){
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

@end
