//
//  UserBarButtonItem.h
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserBarButtonItemDelegate;
@interface UserBarButtonItem : UIButton
@property (nonatomic, weak) id<UserBarButtonItemDelegate> delegate;
-(void)setCustomState:(BOOL)activeState;
@end

@protocol UserBarButtonItemDelegate <NSObject>

-(void)userButtonDidPressButton:(UIButton *)button;

@end
