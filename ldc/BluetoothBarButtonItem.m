//
//  BluetoothBarButtonItem.m
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "BluetoothBarButtonItem.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothBarButtonItem ()
@property (weak, nonatomic) IBOutlet UIButton *btButton;
@property (nonatomic) UIView *view;
@end

@implementation BluetoothBarButtonItem

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
	self.frame = CGRectMake(CGRectGetMinX(self.frame), 0, 45, 45);

	//Load view
	self.view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.view];

	//Add constraints
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:18]]; //Leading constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]]; //Trailing constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]]; //Top constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]]; //Bottom constraint
}

- (IBAction)bluetoothButtonPressed:(UIButton *)sender {
	if (self.delegate) {
		[self.delegate bluetoothButtonDidPressButton:sender];
	}
}

-(void)setCustomState:(BOOL)activeState
{
	if (activeState) {
		[self.btButton setImage:[UIImage imageNamed:@"ic_bt_active"] forState:UIControlStateNormal];
	} else {
		[self.btButton setImage:[UIImage imageNamed:@"ic_bt_inactive"] forState:UIControlStateNormal];
	}
}

@end
