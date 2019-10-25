//
//  LogoBarButtonItem.m
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "LogoBarButtonItem.h"

@interface LogoBarButtonItem()
@property (nonatomic) UIView *view;
@end

@implementation LogoBarButtonItem

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self loadNibWithConstraints];
	}
	return self;
}

-(void)awakeFromNib
{
	[super awakeFromNib];
}

- (void)loadNibWithConstraints
{
	//Load view
	self.view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.view];

	//Add constraints
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]]; //Leading constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]]; //Trailing constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:7]]; //Top constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]]; //Bottom constraint
}

-(void)setTitle:(NSString *)title{
    self.mTitleLb.text = title;
}
@end



