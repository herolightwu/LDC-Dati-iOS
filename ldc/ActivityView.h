//
//  ActivityView.h
//
//  Created by Armands Lazdins
//  Copyright (c) 2015 Armands Lazdins. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ActivityViewStatus)
{
    ActivityViewStatusHidden,
    ActivityViewStatusAnimating,
    ActivityViewStatusError
};

@protocol ActivityViewDelegate;

@interface ActivityView : UIView

@property (nonatomic, weak) IBOutlet id <ActivityViewDelegate> delegate;

@property (nonatomic, readonly) ActivityViewStatus status;

@property (nonatomic) UIActivityIndicatorViewStyle style;

@property (nonatomic) IBInspectable NSString *errorLabelTextKey;
@property (nonatomic) IBInspectable NSString *errorButtonTextKey;
@property (nonatomic) UIColor *errorLabelTextColor;
@property (nonatomic) UIColor *errorButtonTextColor;

- (void)startAnimatingAnimated:(BOOL)animated delay:(CGFloat)delay;
- (void)stopAnimatingAnimated:(BOOL)animated delay:(CGFloat)delay;
- (void)showErrorAnimated:(BOOL)animated delay:(CGFloat)delay;

@end

@protocol ActivityViewDelegate <NSObject>

- (void)activityView:(ActivityView *)activityView didSelectErrorButton:(UIButton *)errorButton;

@end
