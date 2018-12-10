//
//  HTNewEditProductStyleController.m
//  有术
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTPostProductDescInfoCell.h"
#import "HTProductColImgsTableCell.h"
#import "HTPostImgEditInfoTableViewCell.h"
#import "HTAddProductImgTableCell.h"
#import "HTNewEditProductStyleController.h"
#import "HTPostImageModel.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HTAccountTool.h"
//#import "HTBindWechatController.h"
#import "UIBarButtonItem+Extension.h"
#define KCompressibilityFactor 1280.00

@interface HTNewEditProductStyleController ()<UITableViewDelegate,UITableViewDataSource,HTPostProductDescInfoCellDelegate,HTProductColImgsTableCellDelegate,DNImagePickerControllerDelegate,HTPostProductDescInfoCellDelegate,HTPostImgEditInfoTableViewCellDelegate>{
    int selectedChangeIndex;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (weak, nonatomic) IBOutlet UIButton *cancleBt;

@property (weak, nonatomic) IBOutlet UIButton *okBt;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *sectionTitles;

@property (nonatomic,strong) NSMutableArray *brandImgs;

@property (nonatomic,strong) NSMutableArray *shopImgs;

@property (strong,nonatomic) NSMutableArray *assetsArray;

@property (nonatomic,strong) NSMutableArray *detsArray;

@property (nonatomic,strong) NSString *postImgID;

@property (nonatomic,assign) BOOL isChange;

@end

@implementation HTNewEditProductStyleController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品图片详情";
    [self createTb];
    [self configData];
    [self configUI];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsName.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellsName[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectons = self.cellsName[indexPath.section];
    NSString *cellName = sectons[indexPath.row];
    
    if ([cellName isEqualToString:@"HTPostProductDescInfoCell"]) {
        HTPostProductDescInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTPostProductDescInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.controllerType = self.controllertype;
        cell.model = self.model;
        return cell;
    }else if ([cellName isEqualToString:@"HTProductColImgsTableCell"]){
        HTProductColImgsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProductColImgsTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.controllertype == ControllerCoverEdit) {
            cell.isEdit = YES;
        }else{
            cell.isEdit = NO;
        }
        NSString *title = self.sectionTitles[indexPath.section];
        if ([title isEqualToString:@"品牌图片"]) {
            cell.dataArray = self.brandImgs;
        }
        if ([title isEqualToString:@"店铺图片"]) {
            cell.dataArray = self.shopImgs;
        }
        cell.delegate = self;
        return cell;
        
    }else if ([cellName isEqualToString:@"HTAddProductImgTableCell"]){
        HTAddProductImgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTAddProductImgTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        HTPostImgEditInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTPostImgEditInfoTableViewCell" forIndexPath:indexPath];
        cell.controllerType = self.controllertype;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.shopImgs[indexPath.row];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *title = self.sectionTitles[section];
    if (title.length == 0) {
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 35)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *dateNameLabel = [[UILabel alloc] init];
    dateNameLabel.font = [UIFont systemFontOfSize:15];
    dateNameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    dateNameLabel.text = title;
    [headView addSubview:dateNameLabel];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([title isEqualToString:@"店铺图片"] && self.controllertype == ControllerDetail ){
        [bt setTitle:@"编辑" forState:UIControlStateNormal];
        [bt setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [bt setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        bt.imageEdgeInsets = UIEdgeInsetsMake(bt.imageEdgeInsets.top, bt.imageEdgeInsets.left, bt.imageEdgeInsets.bottom,8);
        [bt setImage:[UIImage imageNamed:@"g-mineEdit"] forState:UIControlStateNormal];
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius = 3;
        bt.tag = 200 + section;
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt addTarget:self action:@selector(sectionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:bt];
        
    }
    [dateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(headView.mas_leading).offset(16);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(headView.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.width.offset(65);
        make.height.offset(30);
    }];
    return headView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.sectionTitles[section] length] == 0 ? 0.01f : 44.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[HTAddProductImgTableCell class]]) {
        if (self.shopImgs.count >= 9) {
            [MBProgressHUD showError:@"最多只能添加9张图片"];
            return;
        }
        selectedChangeIndex = -1;
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        imagePicker.imagePickerDelegate = self;
        imagePicker.navigationBar.translucent = NO;
        [HTShareClass shareClass].seltedPhotosCount = 9 - self.shopImgs.count;
        [self presentViewController:imagePicker animated:YES completion:nil];
        if (self.controllertype != ControllerEdit || self.controllertype != ControllerPost) {
            self.controllertype = ControllerEdit;
            [self configUI];
        }
    }
    if ([cell isKindOfClass:[HTPostImgEditInfoTableViewCell class]]) {
        if (self.controllertype != ControllerDetail) {
            [self changeImgTapWithCell:[tableView cellForRowAtIndexPath:indexPath]];
        }else{
            NSMutableArray *photos = [NSMutableArray array];
            
            HTPostImageModel *model = self.shopImgs[indexPath.row];
            MJPhoto *photo = [[MJPhoto alloc] init];
            if (model.image) {
                photo.image = model.image;
            }else{
                if (model.imageSeverUrl.length > 0 ) {
                    photo.url = [NSURL URLWithString: model.imageSeverUrl];
                }else{
                    photo.image = [UIImage imageNamed:@"相机"];
                }
            }

            [photos addObject:photo];
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
        }
    }
}
#pragma mark -CustomDelegate
-(void)topBtClick{
    self.controllertype = ControllerCoverEdit;
    [self configUI];
    [self.tab reloadData];
}
-(void)selectedTopImgWithModel:(HTPostImageModel *)model1{
    for (HTPostImageModel *model in self.brandImgs) {
        model.isSeleted = NO;
    }
    for (HTPostImageModel *model in self.shopImgs) {
        model.isSeleted = NO;
    }
    model1.isSeleted = YES;
    [self.tab reloadData];
}
- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    if (selectedChangeIndex != -1 && imageAssets.count == 1 && self.shopImgs.count > 0) {
        ALAsset *asset  = imageAssets[0];
        
        HTPostImageModel *model = self.shopImgs[selectedChangeIndex];
        UIImage *image;
        if (fullImage) {
            NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
            UIImageOrientation orientation = UIImageOrientationUp;
            if (orientationValue != nil) {
                orientation = [orientationValue intValue];
            }
            image = [UIImage imageWithCGImage:asset.thumbnail];
        } else {
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }
        model.image = image;
        model.isFullImg = fullImage;
        model.holdImageSeverUrl = model.imageSeverUrl;
        model.imageSeverUrl = @"";
        model.pathUrl = @"";
        [self.assetsArray addObject:model];
        [self.tab reloadData];
    }else{
        for (ALAsset *asset in imageAssets) {
            HTPostImageModel *model = [[HTPostImageModel alloc] init];
            UIImage *image;
            if (fullImage) {
                NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
                UIImageOrientation orientation = UIImageOrientationUp;
                if (orientationValue != nil) {
                    orientation = [orientationValue intValue];
                }
                image = [UIImage imageWithCGImage:asset.thumbnail];
            } else {
                image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            }
            model.image = image;
            model.isFullImg = fullImage;
            [self.shopImgs addObject:model];
            [self.assetsArray addObject: model];
        }
        [self configUI];
        [self.tab reloadData];
    }
    selectedChangeIndex = -1;
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    selectedChangeIndex = -1;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)deleteItemWithCell:(HTPostImgEditInfoTableViewCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    HTPostImageModel *model = self.shopImgs[index.row];
    [self.detsArray addObject:model];
    [self.shopImgs removeObjectAtIndex:index.row];
    [self configUI];
    [self.tab reloadData];
}

- (void)changeImgTapWithCell:(HTPostImgEditInfoTableViewCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    selectedChangeIndex = (int)index.row;
    self.isChange = YES;
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    imagePicker.navigationBar.translucent = NO;
    [HTShareClass shareClass].seltedPhotosCount = 1;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark -EventResponse
-(void)sectionBtClicked:(UIButton *)sender{
    self.controllertype = ControllerEdit;
    [self configUI];
    [self.tab reloadData];
}
- (IBAction)cancleBtClicked:(id)sender {
    
    if (self.controllertype == ControllerEdit || self.controllertype == ControllerPost) {
        if (self.isChange) {
            for (HTPostImageModel *model in self.assetsArray) {
                model.imageSeverUrl = model.holdImageSeverUrl;
            }
        }
        if (self.assetsArray.count > 0 && !self.isChange) {
            [self.shopImgs removeObjectsInArray:self.assetsArray];
            [self.assetsArray removeAllObjects];
        }
        if (self.detsArray.count > 0) {
            for (HTPostImageModel *model in self.detsArray) {
                if (model.imageSeverUrl.length > 0) {
                    [self.shopImgs addObject:model];
                }
            }
            [self.detsArray removeAllObjects];
        }
    }
    
    self.controllertype = ControllerDetail;
    for (HTPostImageModel *model in self.brandImgs) {
        model.isSeleted = NO;
    }
    for (HTPostImageModel *model in self.shopImgs) {
        model.isSeleted = NO;
    }
    self.isChange = NO;
    [self configUI];
    [self.tab reloadData];
    
}

- (IBAction)okBtClicked:(id)sender {
    UIButton *bt = (id)sender;
    if ([bt.titleLabel.text isEqualToString:@"确定"]) {
        HTPostImageModel *selectedModel = [[HTPostImageModel alloc] init];
        for (HTPostImageModel *model in self.brandImgs) {
            if (model.isSeleted) {
                selectedModel = model;
                break;
            }
        }
        for (HTPostImageModel *model in self.shopImgs) {
            if (model.isSeleted) {
                selectedModel = model;
                break;
            }
        }
        if (selectedModel.imageSeverUrl.length == 0) {
            self.controllertype = ControllerDetail;
            [self configUI];
            [self.tab reloadData];
        }else{
            [self setTopImgLoadWithImgModel:selectedModel];
        }
        
    }
    if ([bt.titleLabel.text isEqualToString:@"完成"]) {
        if (self.shopImgs.count == 0) {
            [MBProgressHUD showError:@"请添加商品图片"];
            return;
        }
        [self postImage];
    }
    
}

- (void)shareClicked:(UIBarButtonItem *)sender{
    if (![HTShareClass shareClass].isShowAliCode) {
        if (![HTAccountTool cheackUnionId]) {
//            HTBindWechatController *vc = [[HTBindWechatController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    [MBProgressHUD showMessage:@"正在处理"];
    NSMutableArray *activityItems = [NSMutableArray array];
    NSMutableArray *imgs = [NSMutableArray array];
    [imgs addObjectsFromArray:self.brandImgs];
    [imgs addObjectsFromArray:self.shopImgs];
    for (int  i = 0; i < imgs.count; i++) {
        if (i > 8) {
            break;
        }
        HTPostImageModel *model = imgs[i];
        
        if (model.image != nil) {
            [activityItems addObject:[self getJPEGImagerImg: model.image]];
        }else{
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            NSURL *imgUrl = [NSURL URLWithString:model.imageSeverUrl];
            
            [manager diskImageExistsForURL:imgUrl completion:nil];
            [manager diskImageExistsForURL:imgUrl completion:^(BOOL isInCache) {
                if (isInCache) {
                  [activityItems addObject: [self getJPEGImagerImg: [[manager imageCache] imageFromDiskCacheForKey:imgUrl.absoluteString]]];
                }else{
                    NSData *data = [NSData dataWithContentsOfURL:imgUrl];
                    if (data) {
                        [activityItems addObject: [self getJPEGImagerImg: [UIImage imageWithData:data]]];
                    }
                }
            }];
        }
    }
    UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
    appPasteBoard.persistent = YES;
    NSString *pasteStr = [NSString stringWithFormat:@"点击链接购买\nhttp://24v5.com/store/qr/product_info.html?b=%@&personId=%@",self.model.stylecode,[HTShareClass shareClass].loginId];
    [appPasteBoard setString:pasteStr];
    if (activityItems.count == 0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"未发现图片资源不能分享"];
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [MBProgressHUD hideHUD];
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"已将该商品购买网址复制到粘贴板，分享时粘贴即可" btTitle:@"确定" okBtclicked:^{
    }];
    [alert show];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityVC animated:YES completion:nil];
    });
    
}

#pragma mark -private methods
-(void)setTopImgLoadWithImgModel:(HTPostImageModel *)model{
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.model.stylecode],
                          @"imgPath":model.imageSeverUrl
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProduct,settingProductTopImg] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        model.isSeleted = NO;
        self.model.topimg = [json getStringWithKey:@"data"];
        self.controllertype = ControllerDetail;
        [self configUI];
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTPostProductDescInfoCell" bundle:nil] forCellReuseIdentifier:@"HTPostProductDescInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTProductColImgsTableCell" bundle:nil] forCellReuseIdentifier:@"HTProductColImgsTableCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTPostImgEditInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTPostImgEditInfoTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTAddProductImgTableCell" bundle:nil] forCellReuseIdentifier:@"HTAddProductImgTableCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
-(void)configData{
  
    NSArray *imgs = [self.model.imgs ArrayWithJsonString];
    for (NSDictionary *dic in imgs) {
        HTPostImageModel *model = [[HTPostImageModel alloc] init];
        model.desc = [dic getStringWithKey:@"describe"];
        model.pathUrl =[dic getStringWithKey:@"path"];
        model.imageSeverUrl = [dic getStringWithKey:@"fullPath"];
        self.postImgID = [dic getStringWithKey:@"parentId"];
        [self.shopImgs addObject:model];
    }
    NSArray *brands = [self.model.brandimgs ArrayWithJsonString];
    for (NSDictionary *dic in brands) {
        HTPostImageModel *model = [[HTPostImageModel alloc] init];
        model.desc = [dic getStringWithKey:@"describe"];
        model.pathUrl =[dic getStringWithKey:@"path"];
        model.imageSeverUrl = [dic getStringWithKey:@"fullPath"];
        [self.brandImgs addObject:model];
    }
}
-(void)configUI{
    [self.sectionTitles removeAllObjects];
    [self.cellsName removeAllObjects];
    [self.sectionTitles addObject:@""];
    switch (self.controllertype) {
        case ControllerEdit:
        {
            self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
            self.okBt.hidden = NO;
            self.cancleBt.hidden = NO;
            [self.okBt setTitle:@"完成" forState:UIControlStateNormal];
            [self.cellsName addObject:@[@"HTPostProductDescInfoCell"]];
            if (self.brandImgs.count > 0) {
                [self.cellsName addObject:@[@"HTProductColImgsTableCell"]];
                [self.sectionTitles addObject:@"品牌图片"];
            }
            if (self.shopImgs.count > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < self.shopImgs.count; i++) {
                    [arr addObject:@"HTPostImgEditInfoTableViewCell"];
                }
                [arr addObject:@"HTAddProductImgTableCell"];
                [self.sectionTitles addObject:@"店铺图片"];
                [self.cellsName addObject:arr];
            }
          self.navigationItem.rightBarButtonItem = nil;
           
        }
            break;
        case ControllerPost:
        {
            self.okBt.hidden = YES;
            self.cancleBt.hidden = YES;
            self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
            [self.sectionTitles addObject:@"店铺图片"];
            [self.cellsName addObject:@[@"HTPostProductDescInfoCell"]];
            [self.cellsName addObject:@[@"HTAddProductImgTableCell"]];
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        case ControllerDetail:
        {
            self.tabBottomHeight.constant = SafeAreaBottomHeight;
            self.okBt.hidden = YES;
            self.cancleBt.hidden = YES;
            [self.cellsName addObject:@[@"HTPostProductDescInfoCell"]];
            if (self.brandImgs.count > 0) {
                [self.cellsName addObject:@[@"HTProductColImgsTableCell"]];
                [self.sectionTitles addObject:@"品牌图片"];
            }
             [self.sectionTitles addObject:@"店铺图片"];
            if (self.shopImgs.count > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < self.shopImgs.count; i++) {
                    [arr addObject:@"HTPostImgEditInfoTableViewCell"];
                }
                [arr addObject:@"HTAddProductImgTableCell"];
                [self.cellsName addObject:arr];
            }else{
                [self.cellsName addObject:@[@"HTAddProductImgTableCell"]];
            }
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"分享" target:self action:@selector(shareClicked:) ];
        }
            break;
        case ControllerCoverEdit:
        {
            self.okBt.hidden = NO;
            self.cancleBt.hidden = NO;
            self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
            [self.okBt setTitle:@"确定" forState:UIControlStateNormal];
            [self.cellsName addObject:@[@"HTPostProductDescInfoCell"]];
            if (self.brandImgs.count > 0) {
                [self.cellsName addObject:@[@"HTProductColImgsTableCell"]];
                [self.sectionTitles addObject:@"品牌图片"];
            }
            if (self.shopImgs.count > 0) {
                [self.cellsName addObject:@[@"HTProductColImgsTableCell"]];
                [self.sectionTitles addObject:@"店铺图片"];
            }
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        default:
            break;
    }
}
#pragma mark - 压缩一张图片 最大宽高1280 类似于微信算法
- (UIImage *)getJPEGImagerImg:(UIImage *)image{
    CGFloat oldImg_WID = image.size.width;
    CGFloat oldImg_HEI = image.size.height;
    //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
    if(oldImg_WID > KCompressibilityFactor || oldImg_HEI > KCompressibilityFactor){
        //超过设置的最大宽度 先判断那个边最长
        if(oldImg_WID > oldImg_HEI){
            //宽度大于高度
            oldImg_HEI = (KCompressibilityFactor * oldImg_HEI)/oldImg_WID;
            oldImg_WID = KCompressibilityFactor;
        }else{
            oldImg_WID = (KCompressibilityFactor * oldImg_WID)/oldImg_HEI;
            oldImg_HEI = KCompressibilityFactor;
        }
    }
    UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
    NSData *dJpeg = nil;
    if (UIImagePNGRepresentation(newImg)==nil) {
        dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
    }else{
        dJpeg = UIImagePNGRepresentation(newImg);
    }
    return [UIImage imageWithData:dJpeg];
}
#pragma mark - 压缩多张图片 最大宽高1280 类似于微信算法
- (NSArray *)getJPEGImagerImgArr:(NSArray *)imageArr{
    NSMutableArray *newImgArr = [NSMutableArray new];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *newImg = [self getJPEGImagerImg:imageArr[i]];
        [newImgArr addObject:newImg];
    }
    return newImgArr;
}
#pragma mark - 压缩一张图片 自定义最大宽高
- (UIImage *)getJPEGImagerImg:(UIImage *)image compressibilityFactor:(CGFloat)compressibilityFactor{
    CGFloat oldImg_WID = image.size.width;
    CGFloat oldImg_HEI = image.size.height;
    //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
    if(oldImg_WID > compressibilityFactor || oldImg_HEI > compressibilityFactor){
        //超过设置的最大宽度 先判断那个边最长
        if(oldImg_WID > oldImg_HEI){
            //宽度大于高度
            oldImg_HEI = (compressibilityFactor * oldImg_HEI)/oldImg_WID;
            oldImg_WID = compressibilityFactor;
        }else{
            oldImg_WID = (compressibilityFactor * oldImg_WID)/oldImg_HEI;
            oldImg_HEI = compressibilityFactor;
        }
    }
    UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
    NSData *dJpeg = nil;
    if (UIImagePNGRepresentation(newImg)==nil) {
        dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
    }else{
        dJpeg = UIImagePNGRepresentation(newImg);
    }
    return [UIImage imageWithData:dJpeg];
}
#pragma mark - 压缩多张图片 自定义最大宽高
- (NSArray *)getJPEGImagerImgArr:(NSArray *)imageArr compressibilityFactor:(CGFloat)compressibilityFactor{
    NSMutableArray *newImgArr = [NSMutableArray new];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *newImg = [self getJPEGImagerImg:imageArr[i] compressibilityFactor:compressibilityFactor];
        [newImgArr addObject:newImg];
    }
    return newImgArr;
}
#pragma mark - 根据宽高压缩图片
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void) postImage{
    
    if (self.assetsArray.count > 0) {
        NSDictionary *dic = @{
                              @"year":[HTHoldNullObj getValueWithUnCheakValue:self.model.year],
                              @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.model.stylecode],
                              @"companyId":[HTShareClass shareClass].loginModel.companyId
                              };
        [MBProgressHUD showMessage:@"正在上传"];
        [HTHttpTools POSTData:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFilerSource,uploadFile] params:dic formData:^(id<AFMultipartFormData> formData) {
            // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            // 这里的_photoArr是你存放图片的数组
            for (int i = 0; i < self.assetsArray.count; i++) {
                HTPostImageModel *model = self.assetsArray[i];
                UIImage *image = model.image;
                NSData *imageData = [self changeImageDataWithImageWithImage:image];
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@%@%d.jpg", dateString,self.model.stylecode,i];
                /*
                 *该方法的参数
                 1. appendPartWithFileData：要上传的照片[二进制流]
                 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                 3. fileName：要保存在服务器上的文件名
                 4. mimeType：上传的文件的类型
                 */
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i] fileName:fileName mimeType:@"image/jpeg"]; //
            }
            
        } success:^(id json) {
            NSArray *urls = [json getArrayWithKey:@"data"];
            for (int i = 0 ; i < urls.count; i++) {
                NSDictionary *dic = urls[i];
                HTPostImageModel *model = self.assetsArray[i];
                model.imageSeverUrl = [dic getStringWithKey:@"fullPath"];
                model.pathUrl = [dic getStringWithKey:@"path"];
            }
            self.postImgID = [json getStringWithKey:@"id"];
            
            NSMutableArray *jsonArray = [NSMutableArray array];
            for (HTPostImageModel *mode in self.shopImgs) {
                NSDictionary *dic1 = @{
                                       @"path":[HTHoldNullObj getValueWithUnCheakValue:mode.pathUrl],
                                       @"name":[HTHoldNullObj getValueWithUnCheakValue:mode.desc]
                                       };
                [jsonArray addObject:dic1];
            }
            
            NSDictionary *dict = @{
                                   @"id":[HTHoldNullObj getValueWithUnCheakValue:self.postImgID],
                                   @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.model.stylecode],
                                   @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                   @"json":[jsonArray arrayToJsonString]
                                   };
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFilerSource,updateFileResource4APP] params:dict success:^(id json) {
                [MBProgressHUD hideHUD];
                if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"上传成功"];
                    [self.assetsArray removeAllObjects];
                    self.isChange = NO;
                    self.controllertype = ControllerDetail;
                    [self configUI];
                    [self.tab reloadData];
                }
                
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络繁忙,图片上传失败"];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"图片上传失败,检查你的网络"];
            }];
            
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络繁忙,图片上传失败"];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"图片上传失败,检查你的网络"];
            
        }];
        
    }else{
        NSMutableArray *jsonArray = [NSMutableArray array];
        for (HTPostImageModel *mode in self.shopImgs) {
            NSDictionary *dic1 = @{
                                   @"path":[HTHoldNullObj getValueWithUnCheakValue:mode.pathUrl],
                                   @"name":[HTHoldNullObj getValueWithUnCheakValue:mode.desc]
                                   };
            [jsonArray addObject:dic1];
        }
        
        NSDictionary *dict = @{
                               @"id":[HTHoldNullObj getValueWithUnCheakValue:self.postImgID],
                               @"styleCode":[HTHoldNullObj getValueWithUnCheakValue:self.model.stylecode],
                               @"companyId":[HTShareClass shareClass].loginModel.companyId,
                               @"json":[jsonArray arrayToJsonString]
                               };
        [MBProgressHUD showMessage:@"正在上传"];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFilerSource,updateFileResource4APP] params:dict success:^(id json) {
            [MBProgressHUD hideHUD];
            if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"上传成功"];
                [self.assetsArray removeAllObjects];
                self.controllertype = ControllerDetail;
            }
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络繁忙,图片上传失败"];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"图片上传失败,检查你的网络"];
        }];
    }
}

/**
 *  压缩图片格式
 *
 */
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

#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
    }
    return _cellsName;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)sectionTitles{
    if (!_sectionTitles) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}
-(NSMutableArray *)shopImgs{
    if (!_shopImgs) {
        _shopImgs = [NSMutableArray array];
    }
    return _shopImgs;
}
-(NSMutableArray *)brandImgs{
    if (!_brandImgs) {
        _brandImgs = [NSMutableArray array];
    }
    return _brandImgs;
}
- (NSMutableArray *)assetsArray{
    if (!_assetsArray) {
        _assetsArray = [NSMutableArray array];
    }
    return _assetsArray;
}
-(NSMutableArray *)detsArray{
    if (!_detsArray) {
        _detsArray = [NSMutableArray array];
    }
    return _detsArray;
}
@end
