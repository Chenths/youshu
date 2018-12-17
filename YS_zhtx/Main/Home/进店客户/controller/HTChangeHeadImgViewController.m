//
//  HTChangeHeadImgViewController.m
//  有术
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTChangeHeadImgViewController.h"
#import "HTCustEditHeadTableViewCell.h"
#import "HTChangeHeadsModel.h"
#import "HTChooseHeadImgCell.h"
//#import "CustomIOSAlertView.h"
#import "HTCustomColAlertView.h"
#import "HTChangeHeadImgCollectionCell.h"
#import "HTChangeHeadImgHeaderView.h"
#import "HTCustEditHeadCollectionReusableView.h"
@interface HTChangeHeadImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HTCustEditHeadTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *showArray;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *firstShowArray;

@property (nonatomic,strong) NSMutableArray *secedShowArray;

@property (nonatomic,strong) UIImage *selectedImg;

@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;


@end

@implementation HTChangeHeadImgViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑头像";
    [self createTb];
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.selectedImg && self.headImg) {
        self.headImg(self.selectedImg);
    }
}
#pragma mark -UITabelViewDelegate

#pragma mark -collectionDelegata

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count + 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return section == 0 ? 0 : [self.dataArray[section - 1] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    拿到相应列对应的搜索视图
        if (indexPath.section == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor greenColor];
            return cell;
        }else{
            HTChangeHeadImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTChangeHeadImgCollectionCell" forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.section - 1][indexPath.row];
            return cell;
        }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.dataCollectionView) {
        
        if (indexPath.section == 1) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否删除该照片" btsArray:@[@"取消",@"确认"] okBtclicked:^{
                
                NSMutableArray *dataArr = self.dataArray[indexPath.section - 1];
                HTChangeHeadsModel *model = dataArr[indexPath.row];
                NSDictionary *dic = @{
                                      @"imgId":[HTHoldNullObj getValueWithUnCheakValue:model.HTChangeHeadsModelId],
                                      @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                      @"uid":[HTHoldNullObj getValueWithUnCheakValue:self.uid],
                                      @"token":@"a82ccf4f38ec46d4b2655a4a3a8e8c5f"
                                      };
                [MBProgressHUD showMessage:@""];
                [HTHttpTools POST:@"http://47.95.148.218:8080/del_img.html" params:dic success:^(id json) {
                    [MBProgressHUD hideHUD];
                    [self loadData];
                } error:^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:SeverERRORSTRING];
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"请检查你的网络"];
                    
                }];
                
            } cancelClicked:^{
            }];
            [alert show];
           
        }else if (indexPath.section == 2 ||indexPath.section == 3 ){
            __block NSMutableArray *dataArr = self.dataArray[indexPath.section - 1];
            HTChangeHeadsModel *changeModel = dataArr[indexPath.row];
            [self.showArray removeAllObjects];
            [self.showArray addObjectsFromArray:self.firstShowArray];
            if (self.showArray.count < 5) {
                HTChangeHeadsModel *model = [[HTChangeHeadsModel alloc] init];
                model.HTChangeHeadsModelId = changeModel.HTChangeHeadsModelId;
                [self.showArray addObject:model];
            }
            __weak typeof(self) weakSelf = self;
            [HTCustomColAlertView showAlertWithDataArray:self.showArray btsArray:@[@"取消",@"确定"] okBtclicked:^{
                __strong typeof(weakSelf) strongself = weakSelf;
                HTChangeHeadsModel *selectedModel = [[HTChangeHeadsModel alloc] init];
                for (int i = 0; i < dataArr.count; i++) {
                    HTChangeHeadsModel *model = strongself.firstShowArray[i];                                        if (model.isSelected) {
                            selectedModel = model;
                                break;
                        }
                    }
               NSDictionary *dic = @{
                                     @"oldImgId":[HTHoldNullObj getValueWithUnCheakValue:selectedModel.HTChangeHeadsModelId],
                                     @"newImgId":[HTHoldNullObj getValueWithUnCheakValue:changeModel.HTChangeHeadsModelId],
                                     @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                     @"uid":[HTHoldNullObj getValueWithUnCheakValue:self.uid],
                                     @"token":@"a82ccf4f38ec46d4b2655a4a3a8e8c5f"
                                     };
               [MBProgressHUD showMessage:@""];
               [HTHttpTools POST:@"http://47.95.148.218:8080/replace_img.html" params:dic success:^(id json) {
                   [MBProgressHUD hideHUD];
                   [strongself loadData];
               } error:^{
                   [MBProgressHUD hideHUD];
                   [MBProgressHUD showError:SeverERRORSTRING];
               } failure:^(NSError *error) {
                   [MBProgressHUD hideHUD];
                   [MBProgressHUD showError:@"请检查你的网络"];
               }];
            } cancelClicked:nil addImgCliked:^(NSInteger index) {
                for (HTChangeHeadsModel *model in self.showArray) {
                    model.isSelected = NO;
                }
                for (HTChangeHeadsModel *model in self.firstShowArray) {
                    model.isSelected = NO;
                }
                HTChangeHeadsModel *model = self.showArray[index];
                NSDictionary *dic = @{
                                          @"imgId":[HTHoldNullObj getValueWithUnCheakValue:model.HTChangeHeadsModelId],
                                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                          @"uid":[HTHoldNullObj getValueWithUnCheakValue:self.uid],
                                          @"token":@"a82ccf4f38ec46d4b2655a4a3a8e8c5f"
                                          };
                [MBProgressHUD showMessage:@""];
                [HTHttpTools POST:@"http://47.95.148.218:8080/add_img.html" params:dic success:^(id json) {
                 [MBProgressHUD hideHUD];
                 [self loadData];
                } error:^{
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:SeverERRORSTRING];
                 } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查你的网络"];
            }];
            }];
            }
    }
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (collectionView == self.dataCollectionView) {
       
        if (kind == UICollectionElementKindSectionHeader)
        {
            if (indexPath.section == 0  ) {
                HTCustEditHeadCollectionReusableView *cell =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HTCustEditHeadCollectionReusableView" forIndexPath:indexPath];
                cell.headUrl = self.headUrl;
                if (self.selectedImg) {
                    cell.seletedImg = self.selectedImg;
                }
                cell.delegate = self;
                reusableview = cell;

                
            }else{
                HTChangeHeadImgHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HTChangeHeadImgHeaderView" forIndexPath:indexPath];
                headerView.titleLabel.text =  indexPath.section == 1 ? @"后台照片": indexPath.section == 2 ? @"最新照片":@"全部照片";
                reusableview = headerView;
                
            }
        }
    }
     return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.dataCollectionView == collectionView) {
        return section == 0 ? CGSizeMake(HMSCREENWIDTH, 175) : CGSizeMake(HMSCREENWIDTH , 40);
    }else{
        return CGSizeZero;
    }
    
}


#pragma mark -HTCustEditHeadTableViewCellDelegate
-(void)takePhotoClicked{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])///<检测该设备是否支持拍摄
    {
        //                    [Tools showAlertView:@"sorry, 该设备不支持拍摄"];///<显示提示不支持
        [MBProgressHUD showError:@"该设备不支持拍摄" toView:self.view];
        return;
    }
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;///<设置数据来源为拍照
    picker.allowsEditing = YES;
    picker.delegate = self;///<代理设置
    picker.navigationBar.translucent = NO;
    [self presentViewController:picker animated:YES completion:nil];///<推出视图控制器
}
- (void)selectImgFormPhotos{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;///<设置数据来源为相册
    //允许选择照片之后可编辑
    picker.allowsEditing = YES;
    picker.delegate = self;///<代理设置
    picker.navigationBar.translucent = NO;
    [self presentViewController:picker animated:YES completion:nil];///<推出视图控制器
}
- (void)selectImgFormSysPhotos{
    
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:self.firstShowArray];
    [self.showArray addObjectsFromArray:self.secedShowArray];
    __weak typeof(self) weakSelf = self;
    [HTCustomColAlertView showAlertWithDataArray:self.showArray btsArray:@[@"取消",@"确认"] okBtclicked:^{
        __strong typeof(weakSelf) strongself = weakSelf;
        HTChangeHeadsModel *selectedModel = [[HTChangeHeadsModel alloc] init];
        for (int i = 0; i < self.showArray.count; i++) {
            HTChangeHeadsModel *model = strongself.showArray[i];
            if (model.isSelected) {
                selectedModel = model;
                break;
            }
        }
        self.headUrl = selectedModel.path;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imgUrl = [NSURL URLWithString:selectedModel.path];
        [manager diskImageExistsForURL:imgUrl completion:^(BOOL isInCache) {
            if (isInCache) {
               strongself.selectedImg =  [[manager imageCache] imageFromDiskCacheForKey:imgUrl.absoluteString];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:imgUrl];
                if (data) {
                    strongself.selectedImg = [UIImage imageWithData:data];
                }
            }
             [strongself postImge];
        }];
    } cancelClicked:nil addImgCliked:nil];
}
#pragma mark - DNImagePickerControllerDelegate

#pragma mark - 相册/相机回调  显示所有的照片，或者拍照选取的照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    //获取编辑之后的图片
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectedImg = image;
    [self postImge];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//  取消选择 返回当前试图
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(( HMSCREENWIDTH  - 20) / 5, ( HMSCREENWIDTH  - 20) / 5 + 40) ;
    
    layout.minimumLineSpacing = 5 ;
    layout.minimumInteritemSpacing = 0;
    self.dataCollectionView.collectionViewLayout = layout;
    self.dataCollectionView.backgroundColor = [UIColor whiteColor];
    self.dataCollectionView.delegate   = self;
    self.dataCollectionView.dataSource = self;
    self.dataCollectionView.backgroundColor = [UIColor clearColor];
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTChangeHeadImgHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HTChangeHeadImgHeaderView"];
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTCustEditHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HTCustEditHeadCollectionReusableView"];
   [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTChangeHeadImgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTChangeHeadImgCollectionCell"];
    [self.dataCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.dataCollectionView.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(HMSCREENWIDTH, 40);
    
}
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"uid":[HTHoldNullObj getValueWithUnCheakValue:self.uid]
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFace,@"user_head_list.html"] params:dic success:^(id json) {
        NSArray *headers = [json[@"data"] getArrayWithKey:@"headers"];
        NSArray *news = [json[@"data"] getArrayWithKey:@"news"];
        [self.dataArray removeAllObjects];
        [self.firstShowArray removeAllObjects];
        [self.secedShowArray removeAllObjects];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (NSDictionary *dic in headers) {
            HTChangeHeadsModel *model = [[HTChangeHeadsModel alloc] init];
            [model  setValuesForKeysWithDictionary:dic];
            model.isOldHead = YES;
            [arr1 addObject:model];
            [self.firstShowArray addObject:model];
        }
         NSMutableArray *arr2 = [NSMutableArray array];
        for (NSDictionary *dic in news) {
            HTChangeHeadsModel *model = [[HTChangeHeadsModel alloc] init];
            [model  setValuesForKeysWithDictionary:dic];
            model.isOldHead = NO;
             [arr2 addObject:model];
            [self.secedShowArray addObject:model];
        }
        [self.dataArray addObject:arr1];
        [self.dataArray addObject:arr2];
        [self loadData1];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络" toView:self.view];
        
    }];
    
}
-(void)loadData1{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };

    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFace,@"img_list.html"] params:dic success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view];
        NSMutableArray *arr2 = [NSMutableArray array];
        for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
            HTChangeHeadsModel *model = [[HTChangeHeadsModel alloc] init];
            [model  setValuesForKeysWithDictionary:dic];
            model.isOldHead = NO;
            [arr2 addObject:model];
        }
        [self.dataArray addObject:arr2];
        [self.dataCollectionView reloadData];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络" toView:self.view];
        
    }];
    
}

- (void)postImge{
    [self.dataCollectionView reloadData];
}
- (NSData *) changeImageDataWithImageWithImage:(UIImage *) image{
    float j = 1.0;
    NSData * data = [NSData data];
    for (int i = 0; i < 10; i ++) {
        NSData  * imageData     = UIImageJPEGRepresentation(image, j);
        float f = imageData.length / 1024;
        if (f < 500) {
            data = imageData;
            break;
        }
        j = j - 0.1;
    }
    return data;
    
}
- (NSString *) getBase64ImgWithImg:(NSData *)data{
    return  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
#pragma mark - getters and setters

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)secedShowArray{
    if (!_secedShowArray) {
        _secedShowArray = [NSMutableArray array];
    }
    return _secedShowArray;
}
- (NSMutableArray *)firstShowArray{
    if (!_firstShowArray) {
        _firstShowArray = [NSMutableArray array];
    }
    return _firstShowArray;
}
- (NSMutableArray *)showArray{
    if (!_showArray) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}
@end
