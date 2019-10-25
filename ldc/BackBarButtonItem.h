//
//  BackBarButtonItem.h
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackBarButtonItemDelegate;
@interface BackBarButtonItem : UIButton
@property (nonatomic, weak) id<BackBarButtonItemDelegate> delegate;
@end

@protocol BackBarButtonItemDelegate <NSObject>

-(void)backButtonDidPressButton:(UIButton *)button;

@end
