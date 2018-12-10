//
//  HTExchangeProductsDetailView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "TYCyclePagerView.h"
#import "HTExchangeProductDetailCollectionCell.h"
#import "HTExchangeProductsDetailView.h"
#import "HTOrderDetailProductModel.h"

@interface HTExchangeProductsDetailView()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) TYCyclePagerView *col;

@end

@implementation HTExchangeProductsDetailView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self createCol];
}
- (instancetype)initWithAlertFrame:(CGRect)frame
{
    self = [[NSBundle mainBundle] loadNibNamed:@"HTExchangeProductsDetailView" owner:nil options:nil].lastObject;
    [self setFrame:frame];
    return self;
}
-(void)show{
    KLCPopup *pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [pop show];
}
-(void)setExchangeProducts:(NSArray *)exchangeProducts{
    _exchangeProducts = exchangeProducts;
    [self.col reloadData];
    
}
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.exchangeProducts.count;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    HTExchangeProductDetailCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HTExchangeProductDetailCollectionCell" forIndex:index];
    cell.model = self.exchangeProducts[index];
    return cell ;
    
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(self.col.width * 0.5, self.col.height);
    layout.itemSpacing = 10;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    layout.itemHorizontalCenter = YES;
    layout.minimumAlpha = 0.5;
    return layout;
}
- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.titleLabel.text = [NSString stringWithFormat:@"换货商品(%ld/%ld)",toIndex + 1 , self.exchangeProducts.count];
}
-(void)createCol{
    self.col = [[TYCyclePagerView alloc] init];
    self.col.isInfiniteLoop = NO;
    self.col.dataSource = self;
    self.col.delegate = self;
    [self.col registerNib:[UINib nibWithNibName:@"HTExchangeProductDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTExchangeProductDetailCollectionCell"];
    self.col.frame = CGRectMake(0,self.titleLabel.y + 32, self.width, self.height - self.titleLabel.y - 32);
    [self addSubview:self.col];
    [self insertSubview:self.col atIndex:0];
    [self.col reloadData];
}


@end
