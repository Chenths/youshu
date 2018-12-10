//
//  HTUnderstockListAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTWarningToStudyCell.h"
#import "HTNewGoodsImgTableViewCell.h"
#import "HTUnderstockListAlertView.h"
#import "HTGSaleReportViewController.h"
#import "HTCustomersInfoReportController.h"
@interface HTUnderstockListAlertView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *okBt;

@property (nonatomic,copy) okBtClick  okBtClicked;

@property (nonatomic,copy) cancleBtClick cancleClicked;

@property (nonatomic,copy) indexClick indexclll;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) BOOL isSale;

@end
@implementation HTUnderstockListAlertView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    [self.okBt changeCornerRadiusWithRadius:3];
    [self changeCornerRadiusWithRadius:3];
    
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewGoodsImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewGoodsImgTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTWarningToStudyCell" bundle:nil] forCellReuseIdentifier:@"HTWarningToStudyCell"];
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = vvv;
    self.tab.estimatedRowHeight = 300;
    [self changeCornerRadiusWithRadius:3];

}
+(void)showAlertWithWarningArray:(NSArray *)warns tilte:(NSString *)title btsArray:(NSArray *)btTitles okBtclicked:(okBtClick)ok cancelClicked:(cancleBtClick)cancel andInClick:(indexClick)indexclick{
    HTUnderstockListAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTUnderstockListAlertView" owner:nil options:nil].lastObject;
    CGFloat alertHeight = (warns.count * 46 >= (HEIGHT *0.8 - 130) ?  HEIGHT * 0.8 - 130 : warns.count * 46) + 130;
    alert.frame = CGRectMake(30, HEIGHT - alertHeight, HMSCREENWIDTH - 60 , alertHeight);
    alert.dataArray = warns;
    alert.title = title;
    alert.titleLabel.text = title;
    if (ok) {
        alert.okBtClicked = ok;
    }
    if (cancel) {
        alert.cancleClicked = cancel;
    }
    if (indexclick) {
        alert.indexclll = indexclick;
    }
    if (btTitles.count >= 2) {
        [alert.cancelBt setTitle:[btTitles firstObject] forState:UIControlStateNormal];
        [alert.okBt setTitle:btTitles[1] forState:UIControlStateNormal];
    }
    [alert.tab reloadData];
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}
+(void)showAlertWithDataArray:(NSArray *)products btsArray:(NSArray *)btTitles okBtclicked:(okBtClick)ok cancelClicked:(cancleBtClick)cancel{
    HTUnderstockListAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTUnderstockListAlertView" owner:nil options:nil].lastObject;
    CGFloat alertHeight = (products.count * 104 >= (HEIGHT *0.8 - 130) ?  HEIGHT *0.8 - 130 : products.count * 104) + 130;
    alert.frame = CGRectMake(30, HEIGHT - alertHeight, HMSCREENWIDTH -60 , alertHeight);
    alert.dataArray = products;
    if (ok) {
        alert.okBtClicked = ok;
    }
    if (cancel) {
        alert.cancleClicked = cancel;
    }
    if (btTitles.count >= 2) {
        [alert.cancelBt setTitle:[btTitles firstObject] forState:UIControlStateNormal];
        [alert.okBt setTitle:btTitles[1] forState:UIControlStateNormal];
    }
    [alert.tab reloadData];
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.title.length > 0) {
        HTWarningToStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTWarningToStudyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
        HTNewGoodsImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewGoodsImgTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.title.length > 0) {
        if (self.indexclll) {
            [KLCPopup dismissAllPopups];
            self.indexclll(indexPath);
        }
    }
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



@end
