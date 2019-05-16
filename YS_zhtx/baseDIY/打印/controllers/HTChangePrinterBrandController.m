//
//  HTChangePrinterBrandController.m
//  有术
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTPrinterBrandCell.h"
#import "HTPrinterBrandModel.h"
#import "UIBarButtonItem+Extension.h"
#import "HTChangePrinterBrandController.h"

@interface HTChangePrinterBrandController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) BOOL isTap;

@end

@implementation HTChangePrinterBrandController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
    self.title = @"选择打印机型号";
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!self.isTap) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectedBrand)]) {
            [self.delegate cancelSelectedBrand];
        }
    }
}

- (void)back{
//    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//    if (index > 2) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    }
    self.isTap = YES;
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectedBrand)]) {
        [self.delegate cancelSelectedBrand];
    }
}

#pragma mark -UITabelViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return   [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTPrinterBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ceell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (HTPrinterBrandModel *model in self.dataArray) {
        model.isSelected = NO;
    }
    HTPrinterBrandModel *model = self.dataArray[indexPath.row];
    model.isSelected = YES;
    [self.myCollectionView reloadData];
}

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)okBtClicekd:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    self.isTap = YES;
    for (int i = 0; i < self.dataArray.count; i++ ) {
        HTPrinterBrandModel *model = self.dataArray[i];
        if (model.isSelected) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedPrinterBrandWithVerison:)]) {
                [self.delegate selectedPrinterBrandWithVerison:i + 1];
                break;
            }
        }
    }
}
- (IBAction)cancleBtClicked:(id)sender {
    self.isTap = YES;
   [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectedBrand)]) {
        [self.delegate cancelSelectedBrand];
    }
}
- (void)neverTiXing{
    self.isTap = YES;
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if (index > 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
     if (self.delegate && [self.delegate respondsToSelector:@selector(neverNoticeSelectedBrand)]) {
        [self.delegate neverNoticeSelectedBrand];
     }
}

#pragma mark -private methods
- (void)createCollectionView{
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.view.backgroundColor = [UIColor blueColor];
    UICollectionViewFlowLayout *loyout = [[UICollectionViewFlowLayout alloc] init];
    loyout.itemSize = CGSizeMake((HMSCREENWIDTH - 10) / 2,(HMSCREENWIDTH) / 2 * 15 / 13 + 30 );
    loyout.minimumLineSpacing = 5;
    self.myCollectionView.collectionViewLayout = loyout;
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"HTPrinterBrandCell" bundle:nil] forCellWithReuseIdentifier:@"ceell"];
    [self.myCollectionView reloadData];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"不再提醒" target:self action:@selector(neverTiXing)];
}

#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        HTPrinterBrandModel *model = [[HTPrinterBrandModel alloc] init];
        model.imgName = @"第一代";
        model.title = @"56mm打印机";
        HTPrinterBrandModel *model1 = [[HTPrinterBrandModel alloc] init];
        model1.imgName = @"第二代";
        model1.isSelected = YES;
        model1.title = @"80mm自动切刀打印机";
        //
        [_dataArray addObject:model];
        [_dataArray addObject:model1];
        //这里执行的是debug模式下
//        HTPrinterBrandModel *model2 = [[HTPrinterBrandModel alloc] init];
//        model2.imgName = @"蓝牙打印.jpg";
//        model2.title = @"蓝牙打印机";
//        [_dataArray addObject:model2];
    }
    return _dataArray;
}
@end
