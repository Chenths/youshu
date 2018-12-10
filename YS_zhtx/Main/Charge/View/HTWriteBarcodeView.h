//
//  HTWriteBarcodeView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTWriteBarcodeViewDelegate <NSObject>

-(void)searchProductWithBarCode:(NSString *)barcode;

@end
@interface HTWriteBarcodeView : UIView

@property (nonatomic,weak) id <HTWriteBarcodeViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *barcodeTextfiled;

@end
