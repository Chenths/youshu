//
//  HTNewCustomerBaceInfoView.m
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTCustomDefualAlertView.h"
#import "HTCashierChooseSizeOrColorView.h"
#import "HTProductSyleSelectedCell.h"
#import "HTAccount.h"
#import "HTShowImg.h"
@interface HTCashierChooseSizeOrColorView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inventoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearSesonLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet UIButton *delBt;
@property (weak, nonatomic) IBOutlet UIButton *okBt;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) HTCahargeProductModel *model;

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,strong) NSMutableArray *keys;

@end
@implementation HTCashierChooseSizeOrColorView


#pragma mark -life cycel
+ (instancetype)initInfoViewWithFrame:(CGRect)frame{
    HTCashierChooseSizeOrColorView *infoView =  [[[NSBundle mainBundle] loadNibNamed:@"HTCashierChooseSizeOrColorView" owner:nil
                                                                             options:nil] lastObject];
    [infoView setFrame:frame];
    
    return infoView;
}
+ (void)showAlertViewInView:(UIView *)bigView andDelegate:(id<HTCashierChooseSizeOrColorViewDelegate>)delegate withGoodData:(HTCahargeProductModel*) productModel{
    CGRect alrtFrame = CGRectZero;
    alrtFrame = CGRectMake(0,bigView.frame.size.height, bigView.frame.size.width, 410);
    HTCashierChooseSizeOrColorView *alrtView = [self initInfoViewWithFrame:alrtFrame];
    alrtView.delegate = delegate;
    alrtView.backgroundColor = [UIColor clearColor];
    //添加遮罩
    [alrtView createCoverViewWithFrame:bigView.bounds];
    alrtView.model = productModel;
    [alrtView createTb];
    if (productModel.sizeGrop.count > 1) {
        [alrtView.datas addObject:productModel.sizeGrop];
        [alrtView.keys addObject:@"size"];
    }else if(productModel.sizeGrop.count == 1){
        alrtView.model.selecedSizeCode = [productModel.sizeGrop.firstObject objectForKey:@"sizecode"];
    }
    if (productModel.colorGrop.count > 1) {
        [alrtView.datas addObject:productModel.colorGrop];
        [alrtView.keys addObject:@"color"];
    }else if(productModel.colorGrop.count == 1){
        alrtView.model.selecedColorCode = [productModel.colorGrop.firstObject objectForKey:@"colorcode"];
    }
    [alrtView.tab reloadData];
    [bigView addSubview:alrtView.coverView];
    [bigView addSubview:alrtView];
    [UIView animateWithDuration:0.3 animations:^{
        alrtView.frame = CGRectMake(0,(bigView.frame.size.height - 410), bigView.frame.size.width, 410);
    }];
    
}

#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTProductSyleSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductSyleSelectedCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    cell.model =  self.model;
    cell.key = self.keys[indexPath.row];
    cell.dataArray = self.datas[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.choose = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf.model.isChoose) {
            if (strongSelf.model.selecedSizeCode.length > 0 && strongSelf.model.selecedColorCode.length > 0) {
                strongSelf.model.isChoose = YES;
                [strongSelf.okBt sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    };
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse
- (void) tapCoverView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAlertViewFromBigView:)]) {
        [_coverView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            self.y = HEIGHT;
        } completion:^(BOOL finished) {
//            [self removeFromSuperview];
            [self.delegate dismissAlertViewFromBigView:self];
        }];
    }
}
- (IBAction)closeBt:(id)sender {
    [self tapCoverView];
}
- (IBAction)delProductClicked:(id)sender {
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否删除该商品" btsArray:@[@"取消",@"确定"] okBtclicked:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(delClickWithProduct:)]) {
            [self.delegate delClickWithProduct:self.model];
        }
        [self tapCoverView];
    } cancelClicked:^{
    }];
    [alert show];
}
- (IBAction)okBtClicked:(id)sender {
    
    if (self.model.sizeGrop.count > 0 && self.model.selecedSizeCode.length == 0) {
        [MBProgressHUD showError:@"请选择尺码"];
        return;
    }
    if (self.model.colorGrop.count > 0 && self.model.selecedColorCode.length == 0) {
        [MBProgressHUD showError:@"请选择颜色"];
        return;
    }
    BOOL isSelected = NO;
    for (HTChargeProductInfoModel *mmm in self.model.product) {
        if ([self.model.selecedColorCode isEqualToString:mmm.colorcode] &&[self.model.selecedSizeCode isEqualToString:mmm.sizecode]) {
            self.model.selectedModel = mmm;
            isSelected = YES;
            break;
        }
    }
    if (!isSelected) {
        [MBProgressHUD showError:@"选择商品数据有误，请重新选择"];
        return;
    }
    [self tapCoverView];
    if (self.delegate) {
        [self.delegate okBtClickWithProduct:self.model];
    }
}

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTProductSyleSelectedCell" bundle:nil] forCellReuseIdentifier:@"HTProductSyleSelectedCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//创建遮罩蒙板
- (void)createCoverViewWithFrame:(CGRect)frame{
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height )];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha  = 0.2;
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView)];
    [_coverView addGestureRecognizer:tap];
}
#pragma mark - getters and setters

-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
-(NSMutableArray *)keys{
    if (!_keys) {
        _keys = [NSMutableArray array];
    }
    return _keys;
}
-(void)setModel:(HTCahargeProductModel *)model{
    _model = model;
    HTChargeProductInfoModel *mmm = model.selectedModel ? model.selectedModel : [model.product firstObject];
    self.barcodeLabel.text = [NSString stringWithFormat:@"%@",mmm.stylecode];
    self.yearSesonLabel.text = [NSString stringWithFormat:@"(%@ %@)",mmm.year,mmm.season];
    self.inventoryLabel.text = [NSString stringWithFormat:@"库存 %@ 件",model.selectedModel ? mmm.inventory : @"?"];
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",mmm.finalprice];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%@",mmm.price];
    
    if ([_model.selectedModel.productimage isEqualToString:@""] || _model.selectedModel.productimage == nil) {
        
        [self.productImg sd_setImageWithURL:[NSURL URLWithString:[[_model.product firstObject] productimage]]];
    }else{
        [self.productImg sd_setImageWithURL:[NSURL URLWithString:_model.selectedModel.productimage]];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];
}

- (void)tapAction{
    if ([_model.selectedModel.productimage isEqualToString:@""] || _model.selectedModel.productimage == nil) {
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:[[_model.product firstObject] productimage]];
    }else{
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_model.selectedModel.productimage];
    }
    
}




@end
