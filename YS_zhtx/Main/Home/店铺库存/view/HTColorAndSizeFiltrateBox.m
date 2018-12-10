//
//  HTColorAndSizeFiltrateBox.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTColorAndSizeFiltrateBox.h"

#define collectionSpace 15
#define collectionHeight 50
#import "HTFiltrateTableStyleCell.h"
#import "HTFiltrateCollectionStyleCell.h"
#import "HTCustomerFiltrateBoxView.h"
#import "HTFiltrateNodeModel.h"
#import "HTFiltrateHeaderModel.h"

@interface HTColorAndSizeFiltrateBox()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UITableView *dataTableView;

@property (nonatomic,strong) UICollectionView *dataCollectionView;

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,assign) HTFiltrateStyle showStyle;

@property (nonatomic,strong) NSMutableArray *sizes;

@property (nonatomic,strong) NSMutableArray *colors;

@end

@implementation HTColorAndSizeFiltrateBox



#pragma mark -life cycel

- (instancetype)initWithBoxFrame:(CGRect)frame
{
    HTColorAndSizeFiltrateBox *boxView = [[NSBundle mainBundle] loadNibNamed:@"HTColorAndSizeFiltrateBox" owner:nil options:nil].lastObject;
    [boxView setFrame:frame];
    return boxView;
}
-(void)initSubviews{
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTFiltrateTableStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTFiltrateTableStyleCell" forIndexPath:indexPath];
    HTFiltrateHeaderModel *model = self.dataArray[tableView.tag - 600];
    cell.model = model.titles[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HTFiltrateHeaderModel *model = self.dataArray[tableView.tag - 600];
    return model.titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *label = [self viewWithTag:tableView.tag - 200];
    HTFiltrateHeaderModel *model = self.dataArray[tableView.tag - 600];
    HTFiltrateNodeModel *node = model.titles[indexPath.row];
    label.text = node.title;
    for (HTFiltrateNodeModel *modl in model.titles) {
        modl.isSelected = NO;
    }
    node.isSelected = YES;
    if (self.delegate) {
        [self.delegate FiltrateBoxDidSelectedInSection:tableView.tag - 600 andRow:indexPath.row];
    }
    [self tapCoverView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    HTFiltrateHeaderModel *model = self.dataArray[collectionView.tag - 600];
    return model.titles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTFiltrateCollectionStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTFiltrateCollectionStyleCell" forIndexPath:indexPath];
    HTFiltrateHeaderModel *model = self.dataArray[collectionView.tag - 600];
    cell.model = model.titles[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *label = [self viewWithTag:collectionView.tag - 200];
    HTFiltrateHeaderModel *model = self.dataArray[collectionView.tag - 600];
    HTFiltrateNodeModel *node = model.titles[indexPath.row];
    node.isSelected = !node.isSelected;
    if ([node.searchKey isEqualToString:@"colorCode"]) {
        [self.colors removeAllObjects];
        for (HTFiltrateNodeModel *mm in model.titles) {
            if (mm.isSelected) {
                [self.colors addObject:mm.searchValue];
            }
        }
        if (self.colors.count > 0) {
            NSString *nnn =   [self.colors firstObject];
            NSString *mmm = @"";
            for (HTFiltrateNodeModel *mm in model.titles) {
                if ([mm.searchValue isEqualToString:nnn]) {
                    mmm = mm.title;
                    break;
                }
            }
            if (self.colors.count > 1) {
                label.text = [NSString stringWithFormat:@"%@等",mmm];
            }else{
                label.text = mmm;
            }
        }else{
            label.text = @"全部";
        }
    }else{
        [self.sizes removeAllObjects];
        for (HTFiltrateNodeModel *mm in model.titles) {
            if (mm.isSelected) {
                [self.sizes addObject:mm.searchValue];
            }
        }
        if (self.sizes.count > 0) {
            NSString *nnn =   [self.sizes firstObject];
            NSString *mmm = @"";
            for (HTFiltrateNodeModel *mm in model.titles) {
                if ([mm.searchValue isEqualToString:nnn]) {
                    mmm = mm.title;
                    break;
                }
            }
            if (self.sizes.count > 1) {
                label.text = [NSString stringWithFormat:@"%@等",mmm];
            }else{
                label.text = mmm;
            }
        }else{
            label.text = @"全部";
        }
    }
    [collectionView reloadData];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse
- (IBAction)headBtClicked:(id)sender {
    
    UIButton *bt = (UIButton *)sender;
    UIImageView *img = [self viewWithTag:bt.tag + 200];
    HTFiltrateHeaderModel *model = self.dataArray[bt.tag - 500];
    if (model.filtrateStyle == HTFiltrateStyleTableview) {
        if (self.dataCollectionView.height > 0) {
            self.dataCollectionView.frame = CGRectMake(self.dataCollectionView.x, self.dataCollectionView.y, self.dataTableView.width,0);
            [self.dataCollectionView removeFromSuperview];
        }
        if ((bt.tag - 500 == self.dataTableView.tag - 600) && self.dataTableView.height > 0) {
            [self tapCoverView];
            return;
        }
        self.showStyle = HTFiltrateStyleTableview;
        self.dataTableView.tag = bt.tag + 100;
        [self.superview addSubview:self.coverView];
        [self.superview addSubview:self.dataTableView];
        [self.dataTableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.dataTableView.frame = CGRectMake(self.dataTableView.x, self.dataTableView.y, self.dataTableView.width, 40 * model.titles.count);
        }];
        
    }else{
        if (self.dataTableView.height > 0) {
            self.dataTableView.frame = CGRectMake(self.dataTableView.x, self.dataTableView.y, self.dataTableView.width,0);
            [self.dataTableView removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(colorDismissWithColors:andSizes:)]) {
                [self.delegate colorDismissWithColors:self.colors andSizes:self.sizes];
            }
        }
        if ((bt.tag - 500 == self.dataCollectionView.tag - 600) && self.dataCollectionView.height > 0) {
            img.image = [UIImage imageNamed:@"g-mineDown"];
            [self tapCoverView];
            return;
        }
        self.showStyle = HTFiltrateStyleCollection;
        self.dataCollectionView.tag = bt.tag + 100;
        [self.superview addSubview:self.coverView];
        [self.superview addSubview:self.dataCollectionView];
        [self.dataCollectionView reloadData];
        CGFloat hgt = model.titles.count % 4 == 0 ?  model.titles.count / 4 * (collectionSpace + collectionHeight) :( model.titles.count / 4  + 1)  *(collectionSpace + collectionHeight);
        img.image = [UIImage imageNamed:@"g-mineUp"];
        [UIView animateWithDuration:0.3 animations:^{
            self.dataCollectionView.frame = CGRectMake(self.dataCollectionView.x, self.dataCollectionView.y, self.dataCollectionView.width,hgt);
        }];
    }
  
}
-(void)tapCoverView{
    
    if (self.dataCollectionView.height  > 0 && self.showStyle == HTFiltrateStyleCollection) {
        [UIView animateWithDuration:0.3 animations:^{
            self.dataCollectionView.frame = CGRectMake(self.dataCollectionView.x, self.dataCollectionView.y, self.dataCollectionView.width,0);
        } completion:^(BOOL finished) {
            [self.dataCollectionView removeFromSuperview];
            [self.coverView removeFromSuperview];
        }];
    }
    if (self.dataTableView.height > 0 && self.showStyle == HTFiltrateStyleTableview) {
        [UIView animateWithDuration:0.3 animations:^{
            self.dataTableView.frame = CGRectMake(self.dataTableView.x, self.dataTableView.y, self.dataTableView.width,0);
        } completion:^(BOOL finished) {
            [self.dataTableView removeFromSuperview];
            [self.coverView removeFromSuperview];
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorDismissWithColors:andSizes:)]) {
        [self.delegate colorDismissWithColors:self.colors andSizes:self.sizes];
    }
    
}
#pragma mark -private methods

#pragma mark - getters and setters


-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.y + self.height, self.width, 0) style:UITableViewStylePlain];
        self.dataTableView.delegate = self;
        self.dataTableView.dataSource = self;
        [self.dataTableView registerNib:[UINib nibWithNibName:@"HTFiltrateTableStyleCell" bundle:nil] forCellReuseIdentifier:@"HTFiltrateTableStyleCell"];
    }
    return _dataTableView;
}
-(UICollectionView *)dataCollectionView{
    if (!_dataCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake((HMSCREENWIDTH -  collectionSpace ) / 4, collectionHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.y + self.height, self.width, 0) collectionViewLayout:layout];
        _dataCollectionView.showsVerticalScrollIndicator = NO;
        _dataCollectionView.showsHorizontalScrollIndicator = NO;
        [_dataCollectionView registerNib:[UINib nibWithNibName:@"HTFiltrateCollectionStyleCell" bundle:nil] forCellWithReuseIdentifier:@"HTFiltrateCollectionStyleCell"];
        _dataCollectionView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        _dataCollectionView.delegate = self;
        _dataCollectionView.dataSource = self;
    }
    return _dataCollectionView;
}
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(self.x, self.y + self.height, self.width, HEIGHT - nav_height - self.y - self.height)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha  = 0.2;
        _coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}
-(NSMutableArray *)sizes{
    if (!_sizes) {
        _sizes = [NSMutableArray array];
    }
    return _sizes;
}
-(NSMutableArray *)colors{
    if (!_colors) {
        _colors = [NSMutableArray array];
    }
    return _colors;
}

@end

