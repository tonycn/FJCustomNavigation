//
//  FJNavigationBar.m
//  ToothHealthy
//
//  Created by Jianjun Wu on 4/8/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import "FJNavigationBar.h"

static UIColor * __NavigationBarBackgroundColor = nil;
@implementation FJNavigationBar

@synthesize leftItem = _leftItem;
@synthesize rightItem = _rightItem;
@synthesize titleView = _titleView;
@synthesize titleLabel = _titleLabel;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize useDefaultBackButton = _useDefaultBackButton;

+ (void)setNavigationBarBackgroundColor:(UIColor *)color {
  [__NavigationBarBackgroundColor autorelease];
  __NavigationBarBackgroundColor = [color retain];
}

- (id)init {
  self = [super init];
  if (self) {
    if (__NavigationBarBackgroundColor == nil) {
      [FJNavigationBar setNavigationBarBackgroundColor:[UIColor blackColor]];
    }
    _leftItem = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _rightItem = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _backgroundImageView = [[UIImageView alloc] init];
    _useDefaultBackButton = YES;
    
    [self addSubview:_backgroundImageView];
    [self addSubview:_titleLabel];
    [self addSubview:_leftItem];
    [self addSubview:_rightItem];
    
    self.backgroundColor = __NavigationBarBackgroundColor;
  }
  return self;
}

- (void)layoutSubviews {
  CGRect frame = self.frame;
  
  frame.origin = CGPointZero;
  frame.size.width = FJ_NAV_BAR_ITEM_WIDTH;
  _leftItem.frame = frame;
  
  frame.origin.x = CGRectGetMaxX(self.frame) - FJ_NAV_BAR_ITEM_WIDTH;
  frame.size.width = FJ_NAV_BAR_ITEM_WIDTH;
  _rightItem.frame = frame;
  
  frame.origin.x = FJ_NAV_BAR_ITEM_WIDTH;
  frame.size.width = CGRectGetWidth(self.frame) - 2 * FJ_NAV_BAR_ITEM_WIDTH;
  _titleLabel.frame = frame;
  
  if (_titleView) {
    _titleView.frame = self.bounds;
  }
  [self bringSubviewToFront:_leftItem];
  [self bringSubviewToFront:_rightItem];
  
  _backgroundImageView.frame = self.bounds;
}

- (void)setLeftItem:(UIButton *)leftItem {
  
  if (leftItem == _leftItem) {
    return;
  }
  [_leftItem removeFromSuperview];
  [_leftItem autorelease];
  _leftItem = [leftItem retain];
  if (_leftItem) {
    [self addSubview:_leftItem];
  }
  [self setNeedsLayout];
}

- (void)setRightItem:(UIButton *)rightItem {
  
  if (rightItem == _rightItem) {
    return;
  }
  [_rightItem removeFromSuperview];
  
  [_rightItem autorelease];
  _rightItem = [rightItem retain];
  if (_rightItem) {
    [self addSubview:_rightItem];
  }  
  [self setNeedsLayout];
}


- (void)setTitleView:(UIView *)titleView {
  
  if (titleView == _titleView) {
    return;
  }
  [_titleView removeFromSuperview];
  
  [_titleView autorelease];
  _titleView = [titleView retain];
  if (_titleView) {
    _titleView.frame = self.bounds;
    [self addSubview:_titleView];
  }  
  [self setNeedsLayout];
}

- (void)setLeftItemAnimated:(UIButton *)leftItem {
  
  if (leftItem == _leftItem) {
    return;
  }
  UIView *itemToFadeOut = _leftItem;
  [UIView animateWithDuration:APP_NAV_SLIDE_DURATION
                   animations:^{
                     itemToFadeOut.alpha = 0.f;
                   } 
                   completion:^(BOOL completed){
                     [itemToFadeOut removeFromSuperview];
                     itemToFadeOut.alpha = 1.f;
                     
                     [_leftItem autorelease];
                     _leftItem = [leftItem retain];
                     
                     if (_leftItem) {
                       [self addSubview:_leftItem];
                     }
                     [self setNeedsLayout];                   
                   }];
}

- (void)setRightItemAnimated:(UIButton *)rightItem {
  
  if (rightItem == _rightItem) {
    return;
  }
  UIView *itemToFadeOut = _rightItem;
  [UIView animateWithDuration:APP_NAV_SLIDE_DURATION
                   animations:^{
                     itemToFadeOut.alpha = 0.f;
                   } 
                   completion:^(BOOL completed){
                     [itemToFadeOut removeFromSuperview];
                     itemToFadeOut.alpha = 1.f;
                     
                     [_rightItem autorelease];
                     _rightItem = [rightItem retain];
                     
                     if (_rightItem) {
                       [self addSubview:_rightItem];
                     }
                     [self setNeedsLayout];                   
                   }];
}

- (void)setTitleTextAnimated:(NSString *)title {
  
  [UIView animateWithDuration:APP_NAV_SLIDE_DURATION
                   animations:^{
                     _titleLabel.alpha = 0.f;
                   } 
                   completion:^(BOOL completed){
                     _titleLabel.alpha = 1.f;
                     _titleLabel.text = title;
                   }]; 
}

- (void)setTitleViewAnimated:(UIView *)titleView {
  
  if (titleView == _titleView) {
    return;
  }
  UIView *itemToFadeOut = _titleView;
  [UIView animateWithDuration:APP_NAV_SLIDE_DURATION
                   animations:^{
                     itemToFadeOut.alpha = 0.f;
                   } 
                   completion:^(BOOL completed){
                     [itemToFadeOut removeFromSuperview];
                     itemToFadeOut.alpha = 1.f;
                     
                     [_titleView autorelease];
                     _titleView = [titleView retain];
                     
                     if (_titleView) {
                       _titleView.frame = self.bounds;
                       [self addSubview:_titleView];
                     }
                     [self setNeedsLayout];                   
                   }];
}
@end

