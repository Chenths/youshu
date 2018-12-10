//
//  HTAddTagsViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define VSPACE 16
//按钮件水平间距
#define SPACE 16
//按钮宽度
#define BtWidth 50
//按钮高度
#define BtHeight 30
#import "HTCustomerButton.h"
#import "HTTagDescAlertView.h"
#import "HTAddTagsViewController.h"

@interface HTAddTagsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *selectedTagBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedTagHeight;
@property (weak, nonatomic) IBOutlet UIView *textFieldBack;

@property (weak, nonatomic) IBOutlet UITextField *tagField;
@property (weak, nonatomic) IBOutlet UIButton *saveBt;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *noticeBackSrollerView;
@property (weak, nonatomic) IBOutlet UIButton *finishBt;
@property (weak, nonatomic) IBOutlet UIView *finishBtBack;

@property (nonatomic,strong) NSArray *colors;
//选中容器
@property (nonatomic,strong) NSMutableArray *seletedArray;

@property (nonatomic,strong) NSDictionary *selecteDic;

@property (nonatomic,strong) NSString *searchText;

@property (nonatomic,strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pressHub;

//是否选择

@end

@implementation HTAddTagsViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增标签";
    [self configSubs];
    if (self.tagsArray) {
        [self.seletedArray addObjectsFromArray:self.tagsArray];
        [self createSelectedTagsWithArray:self.seletedArray];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, -nav_height, HMSCREENWIDTH, nav_height)];
    vv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vv];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.tagField];
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse
-(void)textDidChangeed:(NSNotification*)obj{
    UITextField *field = obj.object;
    self.selecteDic = [NSDictionary dictionary];
    self.saveBt.enabled = NO;
    [self.saveBt changeCornerRadiusWithRadius:3];
    [self.saveBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    [self.saveBt setTitle:@"保存标签" forState:UIControlStateNormal];
    
    [self.saveBt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    if ([field.text isEqualToString:self.searchText] ) {
        return;
    }
    if (field.text.length == 0) {
        return;
    }
    if (![self cheakTexg:self.tagField.text]) {
        [MBProgressHUD showError:@"标签只能由中文、字母或数字组成" toView:self.view];
        return;
    }
    [self.saveBt setTitle:@"" forState:UIControlStateNormal];
    self.pressHub.hidden = NO;
    [self.pressHub startAnimating];
    self.searchText = field.text;
    [self loadDataWithText:self.searchText];
}
-(void)deletTag:(UIButton *)sender{
    int  tag = (int)sender.tag - 300;
    [self.seletedArray removeObjectAtIndex:tag];
    [self createSelectedTagsWithArray:self.seletedArray];
}
-(void)addtag:(UIButton *)sender{
    self.tagField.text = sender.titleLabel.text;
    self.selecteDic = self.dataArray[sender.tag - 200];
}
-(void)rightBtClicked:(UIButton *)sender{
    
    [HTTagDescAlertView showTagDescAlert];
    
}
- (IBAction)saveBtClicked:(id)sender {
    
    if (self.selecteDic && self.tagField.text.length == 0) {
        [MBProgressHUD showError:@"请输入标签" toView:self.view];
        return;
    }
    if ([self getbateForText: self.tagField.text] > 10) {
        [MBProgressHUD showError:@"标签长度不得超过10个英文字母、数字或5个汉字"];
        return;
    }
    if (![self cheakTexg:self.tagField.text]) {
        [MBProgressHUD showError:@"标签只能由中文、字母或数字组成"];
        return;
    }
    if (self.selecteDic.allKeys.count == 0) {
        self.selecteDic = @{
                            @"name":[HTHoldNullObj getValueWithUnCheakValue:self.tagField.text]
                            };
    }
    for (NSDictionary *dic in self.seletedArray) {
        if ([[dic getStringWithKey:@"name"] isEqualToString:[self.selecteDic getStringWithKey:@"name"]]){
            [MBProgressHUD showError:@"已添加相同标签"];
            return;
        }
    }
    [self.seletedArray addObject:[self.selecteDic mutableCopy]];
    
    self.descLabel.hidden = YES;
    self.noticeBackSrollerView.hidden = YES;
    self.finishBtBack.backgroundColor =  [UIColor clearColor];
    self.tagField.text = @"";
    self.searchText = @"";
    [self createSelectedTagsWithArray:self.seletedArray];
}

- (IBAction)finshBtClicked:(id)sender {
    if (self.seletedArray.count == 0) {
        [MBProgressHUD showError:@"请确认您要添加的标签" toView:self.view];
        return;
    }
    if (!self.modelId) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.seletedArray) {
            NSMutableDictionary *tagDic = [NSMutableDictionary dictionary];
            [tagDic setDictionary:dic];
            [tagDic setObject:[dic getStringWithKey:@"name"] forKey:@"tagname"];
            [arr addObject:tagDic];
        }
        if (self.addTag) {
            self.addTag(@{
                          @"companyTag":arr,
                          @"stickTag":@[]
                          });
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        NSString *dataString = [@{@"companyTag":self.seletedArray,@"stickTag":@[]} jsonStringWithDic];
        NSDictionary *dic = @{
                              @"data":[HTHoldNullObj getValueWithUnCheakValue:dataString],
                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
                              @"modelId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId]
                              };
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleTag,saveCustomerTag] params:dic success:^(id json1) {
            
            [MBProgressHUD hideHUD];
            if ([[json1 getStringWithKey:@"state"] isEqualToString:@"1"] ) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"编辑信息成功"];
                if (self.addText) {
                    self.addText();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:[json1 getStringWithKey:@"msg"]];
            }
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    }
}

#pragma mark -private methods
-(void)createSelectedTagsWithArray:(NSArray *)arrs{
    for (UIView *subV in self.selectedTagBack.subviews) {
        [subV removeFromSuperview];
    }
    CGFloat btY = 24 ;
    CGFloat btX = SPACE;
    for (int i = 0; i < arrs.count; i++) {
        NSDictionary *dataDic = arrs[i];
        NSString *name = [dataDic  getStringWithKey:@"name"];
        CGFloat titleWidth = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20 + 16;
        titleWidth =   titleWidth >= BtWidth ? titleWidth : 40;
        CGRect frame = CGRectZero;
        CGRect imgFrame   = CGRectZero;
        if ((btX + titleWidth) > HMSCREENWIDTH ) {
            frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            imgFrame = CGRectMake(SPACE + 0 + titleWidth - 8, btY + (VSPACE + BtHeight) - 8,16, 16);
            btY = btY + (VSPACE + BtHeight);
            btX = SPACE + titleWidth + SPACE;
        }else{
            frame =  CGRectMake(btX , btY , titleWidth,BtHeight );
            imgFrame = CGRectMake(btX + titleWidth - 8, btY - 8,16, 16);
            btX = btX + titleWidth + SPACE;
            
        }
        HTCustomerButton *bt = [[HTCustomerButton alloc] initCustomerWithFrame:frame andColor:[UIColor colorWithHexString:self.colors[i % self.colors.count]]];
        [bt setTitle:name forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(deletTag:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 300 + i;
        UIImageView *delImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tagDel"]];
        delImg.frame = imgFrame;
        [self.selectedTagBack addSubview:bt];
        [self.selectedTagBack addSubview:delImg];
    }
    self.selectedTagHeight.constant = btY + BtHeight + 15;
    [self.selectedTagBack layoutIfNeeded];
}
- (int)getbateForText:(NSString *)text{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [text dataUsingEncoding:enc];
    return (int)[data length];
}
-(BOOL) cheakTexg:(NSString *) str{
    NSString * regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return   [pred evaluateWithObject:str] ;
    
}

-(void)configSubs{
    self.selectedTagHeight.constant = 10;
    [self.textFieldBack changeCornerRadiusWithRadius:3];
    [self.saveBt changeCornerRadiusWithRadius:3];
    [self.finishBt changeCornerRadiusWithRadius:3];
    [self.saveBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    self.descLabel.hidden = YES;
    self.finishBtBack.backgroundColor =  [UIColor clearColor];
    self.noticeBackSrollerView.hidden = YES;
    self.pressHub.hidden = YES;
    self.tagField.delegate = self;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeed:) name:UITextFieldTextDidChangeNotification object:self.tagField];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"tagDesc" highImageName:@"tagDesc" target:self action:@selector(rightBtClicked:)];
    
}
- (void)createTagsWithArray:(NSArray *)titles{
    for (UIView *subV in self.noticeBackSrollerView.subviews) {
        [subV removeFromSuperview];
    }
    self.finishBtBack.backgroundColor = [UIColor whiteColor];
    self.descLabel.hidden = NO;
    self.noticeBackSrollerView.hidden = NO;
    self.descLabel.text =  @"您可能是想选择";
    self.descLabel.textColor = [UIColor colorWithHexString:@"#555555" ];
    // bt的x坐标
    CGFloat btX = SPACE;
    // bt的y
    CGFloat btY = 8 ;
    for (int i = 0 ; i < titles.count; i++) {
        NSDictionary *dic = titles[i];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt  setTitle: [dic  getStringWithKey:@"name"] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setBackgroundColor:[UIColor whiteColor]];
        bt.tag = 200 + i ;
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(addtag:) forControlEvents:UIControlEventTouchUpInside];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
        [bt changeCornerRadiusWithRadius:3];
        //       需要设置选中的颜色差图片
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 15;
        titleWidth =   titleWidth >= 40 ? titleWidth : 40;
        if ((btX + titleWidth) > HMSCREENWIDTH - 35 ) {
            bt.frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            btY = btY + (VSPACE + BtHeight);
            btX = SPACE + titleWidth + SPACE;
        }else{
            bt.frame =  CGRectMake(btX , btY , titleWidth,BtHeight );
            btX = btX + titleWidth + SPACE;
        }
        [self.noticeBackSrollerView addSubview:bt];
    }
    self.noticeBackSrollerView.contentSize = CGSizeMake(HMSCREENWIDTH - 35, btY + BtHeight + 20);
}

-(void)createHasTagsWithArray:(NSArray *) titles andState:(NSInteger) state{
    for (UIView *subV in self.noticeBackSrollerView.subviews) {
        [subV removeFromSuperview];
    }
    // bt的x坐标
    CGFloat btX = SPACE;
    // bt的y
    CGFloat btY = 8 ;
    self.descLabel.text = state == 0 ? @"已存在相似标签" : @"相同标签";
    if (state == 1) {
        self.saveBt.enabled = NO;
        [self.saveBt setTitle:@"已存在相同标签 (请重新输入）" forState:UIControlStateNormal];
        [self.saveBt setTitleColor:[UIColor colorWithHexString:@"#999999"]   forState:UIControlStateNormal];
        [self.saveBt changeBorderStyleColor:[UIColor whiteColor] withWidth:1];
    }
    UIImageView *holdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"g-shopTag"]];
    holdImg.frame = CGRectMake(SPACE, btY, 17, 17);
    [self.noticeBackSrollerView addSubview:holdImg];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE + 5 + 17, btY, HMSCREENWIDTH - (SPACE + 5 + 17), 30)];
    titleLabel.text = @"店铺标签";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#ACACAC"];
    [self.noticeBackSrollerView addSubview:titleLabel];
    holdImg.center = CGPointMake(holdImg.center.x, titleLabel.center.y);
    btY += 38;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < titles.count; i++) {
       
        NSDictionary *dic = titles[i];
  if ([[dic getStringWithKey:@"exist"] isEqualToString:@"1"]) {
      
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt  setTitle: [dic  getStringWithKey:@"name"] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setBackgroundColor:[UIColor whiteColor]];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [bt changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
        [bt changeCornerRadiusWithRadius:3];
        bt.tag = 200 + i;
        if (state == 0) {
          [bt addTarget:self action:@selector(addtag:) forControlEvents:UIControlEventTouchUpInside];
        }
        //       需要设置选中的颜色差图片
        CGFloat titleWidth = [bt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, BtHeight) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 15;
        titleWidth =   titleWidth >= 40 ? titleWidth : 40;
        if ((btX + titleWidth) > HMSCREENWIDTH - 35 ) {
            bt.frame = CGRectMake(SPACE + 0 , btY + (VSPACE + BtHeight) , titleWidth,BtHeight );
            btY = btY + (VSPACE + BtHeight);
            btX = SPACE + titleWidth + SPACE;
        }else{
            bt.frame =  CGRectMake(btX , btY , titleWidth,BtHeight );
            btX = btX + titleWidth + SPACE;
        }
      [arr addObject:dic];
      [self.noticeBackSrollerView addSubview:bt];
      }
    }
    self.dataArray = arr;
    self.noticeBackSrollerView.contentSize = CGSizeMake(HMSCREENWIDTH - 35, btY + BtHeight + 20);
}

-(void)loadDataWithText:(NSString *) placeTag{
    
    NSDictionary *dic = @{
                          @"tagName":[HTHoldNullObj getValueWithUnCheakValue:placeTag],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleTag,loadTagBuyNameInfo] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        for (UIView *subV in self.noticeBackSrollerView.subviews) {
            [subV removeFromSuperview];
        }
        self.descLabel.text =  @"您可能是想选择";
        self.descLabel.textColor = [UIColor colorWithHexString:@"#222222" ];
        self.saveBt.enabled = YES;
        [self.saveBt setTitle:@"保存标签" forState:UIControlStateNormal];
        [self.pressHub stopAnimating];
        self.pressHub.hidden = YES;
        if ([json[@"data"] getArrayWithKey:@"systemTags"].count > 0) {
            [self createTagsWithArray:[json[@"data"] getArrayWithKey:@"systemTags"]];
            self.dataArray = [json[@"data"] getArrayWithKey:@"systemTags"];
        }
        if ([json[@"data"] getArrayWithKey:@"companyTags"].count > 0) {
            [self createHasTagsWithArray:[json[@"data"] getArrayWithKey:@"companyTags"] andState:0];
        }
        if ([json[@"data"] getArrayWithKey:@"customerTags"].count > 0) {
            [self createHasTagsWithArray:[json[@"data"] getArrayWithKey:@"customerTags"] andState:1];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        self.descLabel.textColor = [UIColor colorWithHexString:@"#222222" ];
        self.saveBt.enabled = YES;
        [self.saveBt setTitle:@"保存标签" forState:UIControlStateNormal];
        [self.pressHub stopAnimating];
        self.pressHub.hidden = YES;
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
        self.descLabel.textColor = [UIColor colorWithHexString:@"#222222" ];
        self.saveBt.enabled = YES;
        [self.saveBt setTitle:@"保存标签" forState:UIControlStateNormal];
        [self.pressHub stopAnimating];
        self.pressHub.hidden = YES;
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)seletedArray{
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (NSDictionary *)selecteDic{
    if (!_selecteDic) {
        _selecteDic = [NSDictionary dictionary];
    }
    return _selecteDic;
}
- (NSArray *)colors{
    if (!_colors) {
        _colors = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    }
    return _colors;
}
@end
