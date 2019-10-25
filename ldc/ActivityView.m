//
//  ActivityView.m
//
//  Created by Armands Lazdins
//  Copyright (c) 2015 Armands Lazdins. All rights reserved.
//

#import "ActivityView.h"

@interface ActivityView()

@property (nonatomic, readwrite) ActivityViewStatus status;

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *errorContainer;

@end

@implementation ActivityView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alpha = 0;
        [self createViews];
        [self createConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.alpha = 0;
        [self createViews];
        [self createConstraints];
    }
    return self;
}

#pragma mark - Setters & Targets

- (void)errorButtonPressed:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate activityView:self didSelectErrorButton:sender];
    }
}

#pragma mark - Public

-(void)startAnimatingAnimated:(BOOL)animated delay:(CGFloat)delay
{
    if (self.status == ActivityViewStatusAnimating) return;
    self.status = ActivityViewStatusAnimating;
    
    void (^startAnimating)(void) = ^{
        [self.activityIndicator startAnimating];
        if (self.alpha == 0 || !animated) self.activityIndicator.alpha = 1;
        if (!animated) {
            self.errorContainer.alpha = 0;
            self.alpha = 1;
        }
        else {
            [UIView animateWithDuration:0.3f animations:^{
                self.errorContainer.alpha = 0;
                if (self.alpha == 1) self.activityIndicator.alpha = 1;
                else self.alpha = 1;
            } completion:nil];
        }
    };
    
    if (delay == 0) {
        startAnimating();
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.status == ActivityViewStatusAnimating) {
                startAnimating();
            }
        });
    }
}

-(void)stopAnimatingAnimated:(BOOL)animated delay:(CGFloat)delay
{
    if (self.status == ActivityViewStatusHidden) return;
    self.status = ActivityViewStatusHidden;
    
    void (^stopAnimating)(void) = ^{
        if (!animated) {
            self.alpha = 0;
            self.errorContainer.alpha = 0;
            self.activityIndicator.alpha = 0;
            [self.activityIndicator stopAnimating];
        }
        else {
            [UIView animateWithDuration:0.3f animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.alpha = 0;
                    self.errorContainer.alpha = 0;
                }
            }];
        }
    };
    
    if (delay == 0) {
        stopAnimating();
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.status == ActivityViewStatusHidden) {
                stopAnimating();
            }
        });
    }
}

-(void)showErrorAnimated:(BOOL)animated delay:(CGFloat)delay
{
    if (self.status == ActivityViewStatusError) return;
    self.status = ActivityViewStatusError;

    void (^showError)(void) = ^{
        if (!animated) {
            self.alpha = 1;
            [self.activityIndicator stopAnimating];
            self.activityIndicator.alpha = 0;
            self.errorContainer.alpha = 1;
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                self.alpha = 1;
                self.errorContainer.alpha = 1;
                self.activityIndicator.alpha = 0;
            } completion:^(BOOL finished) {
                [self.activityIndicator stopAnimating];
            }];
        }
    };
    
    if (delay == 0) {
        showError();
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.status == ActivityViewStatusError) {
                showError();
            }
        });
    }
}

#pragma mark - Helpers

- (void)createViews
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.alpha = 0;
    self.activityIndicator.hidesWhenStopped = NO;
	self.activityIndicator.color = [UIColor blackColor];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityIndicator];
    
    self.errorContainer = [[UIView alloc] init];
    self.errorContainer.alpha = 0;
    self.errorContainer.backgroundColor = [UIColor clearColor];
    self.errorContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.errorContainer];

}

- (void)createConstraints
{
    //ActivityIndicator
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    //ErrorContainer
    NSLayoutConstraint *errorContainerLeading = [NSLayoutConstraint constraintWithItem:self.errorContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];
    errorContainerLeading.priority = 999;
    [self addConstraint:errorContainerLeading];
    NSLayoutConstraint *errorContainerTop = [NSLayoutConstraint constraintWithItem:self.errorContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
    errorContainerTop.priority = 999;
    [self addConstraint:errorContainerTop];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.errorContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.errorContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - Setters


-(void)setStyle:(UIActivityIndicatorViewStyle)style
{
    _style = style;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

#pragma mark - Super

-(void)tintColorDidChange
{
    [super tintColorDidChange];
    self.activityIndicator.color = self.tintColor;
}

@end
