//
//  BluetoothBarButtonItem.h
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BluetoothBarButtonItemDelegate;
@interface BluetoothBarButtonItem : UIButton
@property (nonatomic, weak) id<BluetoothBarButtonItemDelegate> delegate;
-(void)setCustomState:(BOOL)activeState;
@end

@protocol BluetoothBarButtonItemDelegate <NSObject>

-(void)bluetoothButtonDidPressButton:(UIButton *)button;

@end
