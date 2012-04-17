//
//  FJNavigationBar.h
//  ToothHealthy
//
//  Created by Jianjun Wu on 4/8/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FJ_NAV_BAR_ITEM_WIDTH 80.f
#define APP_CUSTOM_NAV_BAR_HEIGHT 44.f
#define APP_NAV_SLIDE_DURATION .4f

@interface FJNavigationBar : UIView

@property (nonatomic, retain) UIControl *leftItem;
@property (nonatomic, retain) UIControl *rightItem;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic, assign) BOOL useDefaultBackButton;

+ (void)setNavigationBarBackgroundColor:(UIColor *)color;
- (void)setLeftItemAnimated:(UIControl *)leftItem;
- (void)setRightItemAnimated:(UIControl *)rightItem;
- (void)setTitleTextAnimated:(NSString *)title;
- (void)setTitleViewAnimated:(UIView *)titleView;

@end
