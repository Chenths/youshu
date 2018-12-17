//
//  HTSelectedProductStyleAlert.m
//  YS_zhtx
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSelectedProductStyleAlert.h"
@interface HTSelectedProductStyleAlert()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,copy) selectedItem selcedAcction;

@property (nonatomic,strong) NSString  *searchStr;

@end
@implementation HTSelectedProductStyleAlert

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    UIView *vvv = [[UIView alloc] init];
    vvv.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = vvv;
    [self changeCornerRadiusWithRadius:3];

}

+(void)showSelectedProductStyleData:(NSArray *)stylecodes withSearchStr:(NSString *)serchSrt andSeleced:(selectedItem)selcetd {
    
    HTSelectedProductStyleAlert *alert = [[NSBundle mainBundle] loadNibNamed:@"HTSelectedProductStyleAlert" owner:nil options:nil].lastObject;
    CGFloat alertHeight = (stylecodes.count * 40 >= (HEIGHT *0.6 - 48) ?  HEIGHT *0.6 - 48 : stylecodes.count * 40) + 48;
    alert.frame = CGRectMake(0, HEIGHT - alertHeight, HMSCREENWIDTH, alertHeight);
    alert.selcedAcction = selcetd;
    alert.dataArray = stylecodes;
    alert.searchStr = serchSrt;
    [alert.tab reloadData];
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    KLCPopupLayout layout;
    layout.horizontal = KLCPopupHorizontalLayoutCenter;
    layout.vertical = KLCPopupVerticalLayoutBottom;
    
    [pop showWithLayout:layout];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.dataArray[indexPath.row] firstObject];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    cell.textLabel.attributedText = [self getAttFormBehindStr:self.searchStr behindColor:[UIColor colorWithHexString:@"#F53434"] andStr:[dic getStringWithKey:@"stylecode"]];
    cell.detailTextLabel.text = [dic getStringWithKey:@"name"];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selcedAcction) {
        self.selcedAcction(indexPath.row);
        [KLCPopup dismissAllPopups];
    }
}
-(NSMutableAttributedString *)getAttFormBehindStr:(NSString *)behind behindColor:(UIColor *)behindColor andStr:(NSString *)end {
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",end]];
    [str2 addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange(0, behind.length)];
    return str2;
}


@end
