//
//  HTCustEditHeadCollectionReusableView.h
//  有术
//
//  Created by mac on 2018/1/30.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTCustEditHeadTableViewCellDelegate

-(void)takePhotoClicked;

- (void)selectImgFormPhotos;

- (void)selectImgFormSysPhotos;

@end
@interface HTCustEditHeadCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (nonatomic,strong) NSString *headUrl;

@property (nonatomic,strong) UIImage *seletedImg;

@property (nonatomic,weak) id <HTCustEditHeadTableViewCellDelegate> delegate;

@end
