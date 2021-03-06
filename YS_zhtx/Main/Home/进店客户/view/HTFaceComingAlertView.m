//
//  HTFaceComingAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTFaceVipModel.h"
#import "TYCyclePagerView.h"
#import "HTFaceComingAlertView.h"
#import "HTComingFaceCollectionCell.h"
#import "HTCustomerReportViewController.h"
#import "HTMyShopCustomersCenterController.h"
@interface HTFaceComingAlertView()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *moreBt;

@property (weak, nonatomic) IBOutlet UIButton *receptionBt;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,strong) TYCyclePagerView *col;

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,strong) NSArray *datas;

@end


@implementation HTFaceComingAlertView
+(void)showWithDatas:(NSArray *)dataArray{
    HTFaceComingAlertView *alet = [[self alloc] initWithAlertFrame:CGRectMake(0, 0, HMSCREENWIDTH, HEIGHT - SafeAreaBottomHeight)];
    [alet initSubviews];
    [alet createCol];
    alet.datas = dataArray;
    [alet.col reloadData];
    [[[UIApplication sharedApplication].delegate window] addSubview:alet];
}
- (instancetype)initWithAlertFrame:(CGRect)frame
{
    HTFaceComingAlertView *alerView = [[NSBundle mainBundle] loadNibNamed:@"HTFaceComingAlertView" owner:nil options:nil].lastObject;
    [alerView setFrame:frame];
 
    return alerView;
}
-(void)initSubviews{
    [self.backView changeCornerRadiusWithRadius:3];
    [self.receptionBt changeCornerRadiusWithRadius:self.receptionBt.height * 0.5];
    [self.receptionBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    self.backgroundColor = [UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:0.8];
    self.backView.alpha = 1;
    self.backView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
   
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Click)];
    [self addGestureRecognizer:tap];
    [self.backView addGestureRecognizer:tap1];
}
-(void)createCol{
    self.col = [[TYCyclePagerView alloc] init];
    self.col.isInfiniteLoop = NO;
    self.col.dataSource = self;
    self.col.delegate = self;
    [self.col registerNib:[UINib nibWithNibName:@"HTComingFaceCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTComingFaceCollectionCell"];
    self.col.frame = CGRectMake(0, 0, HMSCREENWIDTH - 32, self.receptionBt.y - 32);
    [self.backView addSubview:self.col];
    [self.backView insertSubview:self.col atIndex:0];
    [self.col reloadData];
}
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.datas.count;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    HTComingFaceCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HTComingFaceCollectionCell" forIndex:index];
    if (index == 1 && !self.isFirst) {
    [self.col scrollToItemAtIndex:1 animate:NO];
     self.isFirst = YES;
    }
    cell.model = self.datas[index];
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
-(void)tapClicked:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}
- (IBAction)coloseClicked:(id)sender {
    [self removeFromSuperview];
}

-(void)tap1Click{
}
- (IBAction)repitClicked:(id)sender {
    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
    vc.customerType = HTCustomerReportTypeFacePush;
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
     [self removeFromSuperview];
}

- (IBAction)moreBtClicked:(id)sender {
    HTMyShopCustomersCenterController *vc = [[HTMyShopCustomersCenterController alloc] init];
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}
-(NSArray *)datas{
    if (!_datas) {
        _datas = [NSArray array];
    }
    return _datas;
}


@end
