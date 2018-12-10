//
//  HTCustomerTapMoreController.m
//  有术
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTCustomerTapMoreController.h"
#import "HTCutomerTapMoreCell.h"
@interface HTCustomerTapMoreController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *custLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *levelBack;



@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end

@implementation HTCustomerTapMoreController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_dataDic) {
        [self setDataDic];
    }
    if (self.model) {
        [self setModel];
    }
}
#pragma mark -UITabelViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTCutomerTapMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *title = self.dataArray[indexPath.row];
    if ([title isEqualToString:@"电话"]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.phone_cust ];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [[HTShareClass shareClass].getCurrentNavController.view addSubview:callWebview];
    }else{
        if (self.delegate) {
            [self.delegate didTapWithString:self.dataArray[indexPath.row] andIndex:self.index];
        }
    }
    
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)canclicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -private methods
- (void)setDataDic{
    
    
    NSDictionary *headers = [_dataDic getDictionArrayWithKey:@"header"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[headers getStringWithKey:@"fullPath"]] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    NSString *phone = [self.dataDic getStringWithKey:@"phone_cust"];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",phone];
    NSString *name = [self.dataDic getStringWithKey:@"nickname_cust"];
    self.nameLabel.text =  [NSString stringWithFormat:@"%@",name];
    NSString *sex = [self.dataDic getStringWithKey:@"sex_cust"].length == 0 ? @"nv" :[[self.dataDic getStringWithKey:@"sex_cust"] isEqualToString:@"女"] ? @"nv" : @"man";
    self.sexImg.image = [UIImage imageNamed:sex];
    NSDictionary *levelDic = [self.dataDic getDictionArrayWithKey:@"custlevel"];
    self.custLabel.text = [NSString stringWithFormat:@"%@", [levelDic getStringWithKey:@"name"].length == 0 ? @"普通会员" : [levelDic getStringWithKey:@"name"]];
    
}
- (void)setModel{

    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.model.headimg] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    NSString *phone = [HTHoldNullObj getValueWithUnCheakValue:self.model.phone_cust];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",phone];
    NSString *name = self.model.name;
    self.nameLabel.text =  [NSString stringWithFormat:@"%@",name];
    NSString *sex = [[HTHoldNullObj getValueWithUnCheakValue: self.model.sex_cust] isEqualToString:@"1"] ? @"g-man" : @"g-woman";
    self.sexImg.image = [UIImage imageNamed:sex];
    self.custLabel.text = [NSString stringWithFormat:@"%@", _model.custlevel.length == 0 ? @"普通会员" : self.model.custlevel];
    
}
- (void)createCollectionView{
    //    设置流
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake( (HMSCREENWIDTH - 2) / 3  , (HMSCREENWIDTH - 2) / 3  );
    layout.minimumInteritemSpacing = 1 ;
    layout.minimumLineSpacing = 1 ;
    //    设置collectionView的frame
    
    self.myCollectionView.collectionViewLayout = layout;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    //    设置代理
    self.myCollectionView.delegate   = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"HTCutomerTapMoreCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    [self.levelBack changeCornerRadiusWithRadius:self.levelBack.height / 2];
    [self.levelBack changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
    
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height / 2];
}
#pragma mark - getters and setters



@end
