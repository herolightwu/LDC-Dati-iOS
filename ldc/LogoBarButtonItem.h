//
//  LogoBarButtonItem.h
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogoBarButtonItemDelegate;

@interface LogoBarButtonItem : UIButton
@property (nonatomic, weak) id<LogoBarButtonItemDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLb;
-(void)setTitle:(NSString *)title;
@end
@protocol LogoBarButtonItemDelegate <NSObject>
@end
