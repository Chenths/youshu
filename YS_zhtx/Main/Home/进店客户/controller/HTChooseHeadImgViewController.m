//
//  HTChooseHeadImgViewController.m
//  有术
//
//  Created by mac on 2017/11/3.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTChooseHeadImgCell.h"
#import "HTChooseHeadImgViewController.h"
#import "HTFaceImgListModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface HTChooseHeadImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *selectedDataArray;

@property (weak, nonatomic) IBOutlet UILabel *seeTitle;
@property (weak, nonatomic) IBOutlet UIButton *seebt;

@property (nonatomic,strong) UIImage *selectedImg1;

@property (nonatomic,strong) NSString *imgId;

@property (nonatomic, strong) UIView *topView;

@end

@implementation HTChooseHeadImgViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.seeTitle.hidden = YES;
    self.seebt.enabled = NO;
    [self createCollectionView];
    [self loadData];
    self.title = @"选择头像";
}
#pragma mark -UITabelViewDelegate

/**
 *  没组多少item
 *
 *  @param collectionView
 *  @param section        第几组
 *
 *  @return 多少
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    拿到相应列对应的搜索视图
    HTChooseHeadImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTChooseHeadImgCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.seebt.enabled = YES;
    self.seeTitle.hidden = NO;
    if (self.selectedDataArray.count == 1) {
        HTFaceImgListModel *model = self.dataArray[indexPath.row];
        if (model.isSelected) {
        }else{
            [MBProgressHUD showError:@"人脸识别照片最多选择1张"];
            return;
        }
    }
    HTFaceImgListModel *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.selectedDataArray addObject:model];
    }else{
        if ([self.selectedDataArray containsObject:model]) {
            [self.selectedDataArray removeObject:model];
        }
    }
    HTChooseHeadImgCell *cell = (HTChooseHeadImgCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedImg1 = cell.headImg.image;
    self.imgId =  model.uid;
    self.seeTitle.text = [NSString stringWithFormat:@"预览(%ld/1)",self.selectedDataArray.count];
    [self.dataCollectionView reloadData];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)okBtClicked:(id)sender {
    if (self.selectedImg) {
        self.selectedImg([self.selectedDataArray copy]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)haveASeeClicked:(id)sender {
    NSMutableArray *photos = [NSMutableArray array];
    for (HTFaceImgListModel *model in self.dataArray) {
        if (model.isSelected) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:model.path];
            [photos addObject:photo];
        }
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma mark -private methods
- (void)createCollectionView{
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =  CGSizeMake(( HMSCREENWIDTH - 20   ) / 3, ( HMSCREENWIDTH  - 20 ) / 3 + 40) ;
    layout.minimumLineSpacing = 5 ;
    layout.minimumInteritemSpacing = 0;
    self.dataCollectionView.collectionViewLayout = layout;
    self.dataCollectionView.backgroundColor = [UIColor clearColor];
    self.dataCollectionView.delegate   = self;
    self.dataCollectionView.dataSource = self;
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTChooseHeadImgCell" bundle:nil] forCellWithReuseIdentifier:@"HTChooseHeadImgCell"];
    
    
    _cvHeader.constant += 40;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 40)];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#E6384C"];
    [self.view addSubview:_topView];
    
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(18, 11, HMSCREENWIDTH - 18 - 21 - 18 - 4, 18);
    textLabel.text = @"为了提高识别准确率，请使用正面照片录入资料。";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:13];
    [_topView addSubview:textLabel];
    
    UIImageView *imv = [[UIImageView alloc] init];
    imv.frame = CGRectMake(HMSCREENWIDTH - 21 - 18, 9, 21, 21);
    imv.image= [UIImage imageNamed:@"colseWhite"];
    [_topView addSubview:imv];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(HMSCREENWIDTH - 21 - 18 - 8, 9, 37, 21);
    [closeBtn addTarget:self action:@selector(closeRedAlert) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:closeBtn];
    
    
}

- (void)closeRedAlert{
    _cvHeader.constant -= 40;
    [_topView removeFromSuperview];
}
- (void)loadData{
    
    NSString *uid = @"";
    if (self.notVipModel) {
        uid = self.notVipModel.uid;
    }
    if (self.model) {
        uid = self.model.uid;
    }
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"uid": [HTHoldNullObj getValueWithUnCheakValue:uid]
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFace,faceImageList] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        for (NSDictionary *dic in json[@"data"]) {
            HTFaceImgListModel *model = [[HTFaceImgListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.dataCollectionView reloadData];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NETERRORSTRING toView:self.view];
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedDataArray{
    if (!_selectedDataArray) {
        _selectedDataArray = [NSMutableArray array];
    }
    return _selectedDataArray;
}
@end
