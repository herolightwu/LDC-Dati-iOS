//
//  FlashlightBarButtonItem.m
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "FlashlightBarButtonItem.h"

@import AVFoundation;


@interface FlashlightBarButtonItem ()
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
@property (nonatomic) UIView *view;
@end

@implementation FlashlightBarButtonItem

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
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:5]]; //Leading constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]]; //Trailing constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]]; //Top constraint
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]]; //Bottom constraint
}
- (IBAction)flashlightButtonPressed:(UIButton *)sender {
	Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
	if (captureDeviceClass != nil) {
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		if ([device hasTorch] && [device hasFlash]){

			[device lockForConfiguration:nil];
			if (!self.torchON) {
				[device setTorchMode:AVCaptureTorchModeOn];
				[device setFlashMode:AVCaptureFlashModeOn];
				self.torchON = YES;
				[self.flashlightButton setImage:[UIImage imageNamed:@"ic_flashlight_active"] forState:UIControlStateNormal];
			} else {
				[device setTorchMode:AVCaptureTorchModeOff];
				[device setFlashMode:AVCaptureFlashModeOff];
				self.torchON = NO;
				[self.flashlightButton setImage:[UIImage imageNamed:@"ic_flashlight_inactive"] forState:UIControlStateNormal];
			}
			[device unlockForConfiguration];
		}
	}
}

@end
