//
//  HTCustomColAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/9/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChooseHeadImgCell.h"
#import "HTCustomColAlertView.h"
@interface HTCustomColAlertView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UICollectionView *col;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *okBt;
@property (nonatomic,copy) okBtClick  okBtClicked;

@property (nonatomic,copy) addBtClick  addClicked;

@property (nonatomic,copy) cancleBtClick cancleClicked;

@property (nonatomic,strong) NSArray *dataArray;


@end
@implementation HTCustomColAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    [self.okBt changeCornerRadiusWithRadius:3];
    [self changeCornerRadiusWithRadius:3];
    
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =  CGSizeMake(( HMSCREENWIDTH * 0.8 - 20  - 32  ) / 3, ( HMSCREENWIDTH * 0.8 - 32  - 20 ) / 3 + 40) ;
    layout.minimumLineSpacing = 5 ;
    layout.minimumInteritemSpacing = 0;
    self.col.collectionViewLayout = layout;
    self.col.backgroundColor = [UIColor clearColor];
    self.col.delegate   = self;
    self.col.dataSource = self;
    [self.col registerNib:[UINib nibWithNibName:@"HTChooseHeadImgCell" bundle:nil] forCellWithReuseIdentifier:@"HTChooseHeadImgCell"];
}

+(void)showAlertWithDataArray:(NSArray *)products btsArray:(NSArray *)btTitles okBtclicked:(okBtClick)ok cancelClicked:(cancleBtClick)cancel addImgCliked:(addBtClick)addClicked{
    HTCustomColAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTCustomColAlertView" owner:nil options:nil].lastObject;
    
    NSInteger count = products.count / 3 + (products.count % 3 > 0 ? 1 : 0);
    
    CGFloat alertHeight = ( count * (( HMSCREENWIDTH * 0.8  - 20 - 32) / 3 + 40) >= (HEIGHT *0.8 - 130) ?  HEIGHT *0.8 - 130 : count * (( HMSCREENWIDTH * 0.8 - 32 - 20 ) / 3 + 40)) + 130;
    alert.frame = CGRectMake(HMSCREENWIDTH * 0.1, HEIGHT - alertHeight, HMSCREENWIDTH * 0.8 , alertHeight);
    alert.dataArray = products;
    if (ok) {
        alert.okBtClicked = ok;
    }
    if (cancel) {
        alert.cancleClicked = cancel;
    }
    if (addClicked) {
        alert.addClicked = addClicked;
    }
    if (btTitles.count >= 2) {
        [alert.cancelBt setTitle:[btTitles firstObject] forState:UIControlStateNormal];
        [alert.okBt setTitle:btTitles[1] forState:UIControlStateNormal];
    }
    [alert.col reloadData];
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}


- (IBAction)cancelClicked:(id)sender {
    [KLCPopup dismissAllPopups];
    if (self.cancleClicked) {
        self.cancleClicked();
    }
}
- (IBAction)okClicked:(id)sender {
    [KLCPopup dismissAllPopups];
    if (self.okBtClicked) {
        self.okBtClicked();
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HTChooseHeadImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTChooseHeadImgCell" forIndexPath:indexPath];
    cell.changeModel = self.dataArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      for (HTChangeHeadsModel *model in self.dataArray) {
         model.isSelected = NO;
      }
    HTChangeHeadsModel *model = self.dataArray[indexPath.row];
    if (model.path.length == 0 && model.create_time.length == 0) {
        [KLCPopup dismissAllPopups];
        if (self.addClicked) {
            self.addClicked(indexPath.row);
        }
        return;
    }
    model.isSelected = YES;
    [self.col reloadData];
}
@end
