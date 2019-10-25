//
//  ScannerViewController.h
//  ldc
//
//  Created by Nikita Work on 01/02/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBBarcodeScanner.h"

@protocol ScannerViewControllerDelegate;

@interface ScannerViewController : UIViewController

@property (nonatomic, weak) id<ScannerViewControllerDelegate> delegate;

@property (nonatomic) BOOL showCloseButton;
@property (nonatomic) NSString *descriptionKey;
@property (nonatomic) BOOL torchON;

@end

@protocol ScannerViewControllerDelegate <NSObject>

-(void)scannerViewcontroller:(ScannerViewController *)viewController didCompleteScanningWithResults:(NSString *)results;
-(void)scannerViewcontroller:(ScannerViewController *)viewController shouldUseFlash:(BOOL)torch;

@end
