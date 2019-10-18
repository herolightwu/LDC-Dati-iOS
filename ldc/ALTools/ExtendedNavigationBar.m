//
//  ExtendedNavigationBar.m
//
//  Created by Armands Lazdiņš
//  Copyright (c) 2015 Armands Lazdiņš. All rights reserved.
//

#import "ExtendedNavigationBar.h"

#define NavigationBarExtensionValue 15

@interface ExtendedNavigationBar()

@end

@implementation ExtendedNavigationBar
@synthesize loadingProgress = _loadingProgress;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //Apply transform if neccessary
        if (NavigationBarExtensionValue) {
            [self setTransform:CGAffineTransformMakeTranslation(0, -NavigationBarExtensionValue/2)];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Apply transform if neccessary
        if (NavigationBarExtensionValue) {
            [self setTransform:CGAffineTransformMakeTranslation(0, -NavigationBarExtensionValue/2)];
        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Apply transform if neccessary
        if (NavigationBarExtensionValue) {
            [self setTransform:CGAffineTransformMakeTranslation(0, -NavigationBarExtensionValue/2)];
        }
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += NavigationBarExtensionValue;
    return amendedSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //Update bar dimensions if neccessary
    if (NavigationBarExtensionValue) {
        static NSString *backgroundClassName = @"_UIBarBackground";
        static NSString *legacyBackgroundClassName = @"_UINavigationBarBackground";
        for (UIView *view in self.subviews) {
            NSString *viewClassName = NSStringFromClass(view.class);
            if ([viewClassName isEqualToString:backgroundClassName] || [viewClassName isEqualToString:legacyBackgroundClassName]) {
                CGRect extendedFrame = view.frame;
                CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
                extendedFrame.origin.y = self.bounds.origin.y - statusBarHeight;
                extendedFrame.size.height = self.bounds.size.height + statusBarHeight + NavigationBarExtensionValue/2;
                view.frame = extendedFrame;
            }
        }
    }
}

@end
