//
//  ViewController.h
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ExternalAccessory;

//@class EADSessionController;

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mResultLabel;
@property (weak, nonatomic) IBOutlet UIView *mResultView;
    @property (weak, nonatomic) IBOutlet UIView *mLoginView;
    @property (weak, nonatomic) IBOutlet UITextField *mUsername;
    @property (weak, nonatomic) IBOutlet UITextField *mPassword;
@property (weak, nonatomic) IBOutlet UIButton *mCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *mAASBtn;

- (IBAction)onAASClick:(id)sender;
- (IBAction)onLoginClick:(id)sender;
    
@end

