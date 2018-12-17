//
//  HTShopInventorySeasonInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTRatioSliderView.h"
#import "HTInventoryDescInfoCollectionCell.h"
#import "HTShopInventorySeasonInfoCell.h"

@interface HTShopInventorySeasonInfoCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic,strong) HTRatioSliderView *slider;
@end

@implementation HTShopInventorySeasonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubs];
}

-(void)initSubs{
    [self createCollecionView];
}

-(void)setModel:(HTPiesModel *)model{
    _model = model;
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *colors = @[@"#59B4A5",@"#FC5C7D",@"#FDB00B",@"#614DB6"];
    for (int i = 0 ; i < model.data.count ; i++) {
        HTPieDataItem *mmm = model.data[i];
        if (i < colors.count) {
           mmm.color = [UIColor colorWithHexString:colors[i]];
        }
        [arr addObject:mmm.data];
    }
    [self.slider removeFromSuperview];
    self.slider = [[HTRatioSliderView alloc] initWithFrame:CGRectMake(16, 67, HMSCREENWIDTH - 32, 7) withDatas:arr andColors:@[@"#59B4A5",@"#FC5C7D",@"#FDB00B",@"#614DB6"]];
    [self.contentView addSubview:self.slider];
    [self.dataCollectionView reloadData];
    self.collectionViewHeight.constant = (model.data.count / 2 ) * 166 + ((model.data.count % 2) == 0 ? 0 : 166);
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
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTInventoryDescInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTInventoryDescInfoCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.model.data[indexPath.row];
    return cell;
}
@end
