//
//  HTGuideSaleDescInfoController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderSaleDescTopCell.h"
#import "HTGuideSaleDescItemCell.h"
#import "HTGuiderSaleListItemCell.h"
#import "HTGuideSaleDescInfoController.h"
#import "HTGuideDescModel.h"

@interface HTGuideSaleDescInfoController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *topArray;

@end

@implementation HTGuideSaleDescInfoController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售贡献榜";
    [self createTb];
    [self createCol];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTGuiderSaleDescTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTGuiderSaleDescTopCell" forIndexPath:indexPath];
    cell.model = self.topArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTGuideDescModel *model = self.topArray[indexPath.row];
    return CGSizeMake(model.colWidth, 48);
}
#pragma mark -CustomDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTGuideSaleDescItemCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HTGuideSaleDescItemCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.returnOFFset = ^(CGPoint point) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setContentOffSet:point];
        [strongSelf setTopOffSet:point];
    };
    cell.dataAar = self.topArray;
    HTGuideSaleInfoModel *model = self.dataArray[indexPath.row];
    model.index = indexPath;
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.topCollectionView) {
        [self setContentOffSet:self.topCollectionView.contentOffset];
    }
}

#pragma mark -EventResponse

#pragma mark -private methods
-(void)configData{
    
}
-(void)setContentOffSet:(CGPoint) offset{
    for (HTGuideSaleDescItemCell* cell in self.dataTableView.visibleCells) {
        cell.col.contentOffset = offset;
    }
}
-(void)setTopOffSet:(CGPoint)offSet{
    self.topCollectionView.contentOffset = offSet;
}
-(void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTGuideSaleDescItemCell" bundle:nil] forCellReuseIdentifier:@"HTGuideSaleDescItemCell"];
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)createCol{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.topCollectionView.showsHorizontalScrollIndicator = NO;
    self.topCollectionView.showsVerticalScrollIndicator = NO;
    self.topCollectionView.collectionViewLayout = layout;
    self.topCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
    self.topCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.topCollectionView registerNib:[UINib nibWithNibName:@"HTGuiderSaleDescTopCell" bundle:nil] forCellWithReuseIdentifier:@"HTGuiderSaleDescTopCell"];
}
#pragma mark - getters and setters
-(NSMutableArray *)topArray{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
        NSArray *titles = @[@"折扣率",@"连带率",@"退换货单量",@"退换货销量",@"退换货差价"];
        NSArray *keys = @[@"discount",@"serialup",@"ordernumre",@"salesvolumere",@"totalpricere"];
        for (int i = 0 ; i < titles.count; i++) {
            NSString *str = titles[i];
            HTGuideDescModel *model = [[HTGuideDescModel alloc] init];
            model.value = str;
            model.key = keys[i];
            model.colWidth = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
            [self.topArray addObject:model];
        }
    }
    return _topArray;
}


@end
