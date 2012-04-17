//
//  FJTabBarController.h
//  muzhigou
//
//  Created by 建军 吴 on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJBaseViewController.h"

#define APP_CUSTOM_TABBAR_HEIGHT 49.f

@protocol FJBaseViewController;
@class AppTabBar;

@protocol AppTabBarDelegate

- (void)tabBar:(AppTabBar *)tabBar didSelectTabIndex:(NSInteger)tabIndex;

@end

@interface AppTabBar : UIView {

@private

  UIImageView                *_backgroundView;
  id<AppTabBarDelegate>  _delegate;
  NSArray               *_items;
  UIControl          *_selectedItem;
  
  UIColor *_itemBackgroundColor;
  UIColor *_selectedItemBackgroundColor;
}

@property(nonatomic, readonly) UIImageView *backgroundView;
@property(nonatomic, assign) id<AppTabBarDelegate> delegate;     // weak reference. default is nil
@property(nonatomic, copy)   NSArray             *items;        // get/set visible UITabBarItems. default is nil. changes not animated. shown in order
@property(nonatomic,assign) UIControl *selectedItem; // will show feedback based on mode. default is nil
//- (void)setItems:(NSArray *)items animated:(BOOL)animated;   // will fade in or out or reorder and adjust spacing

@property(nonatomic, retain) UIColor *itemBackgroundColor;
@property(nonatomic, retain) UIColor *selectedItemBackgroundColor;

@end

@protocol FJTabBarControllerDelegate <UITabBarControllerDelegate>

@end

@interface FJTabBarController : FJBaseUIViewController <AppTabBarDelegate> {
  
  AppTabBar *_appTabBarView;
  UIView *_containerView;
  
  NSArray *_viewControllers;
  UIViewController<FJBaseViewController> *_selectedViewController;  
  UIViewController<FJBaseViewController> *_selectedViewControllerDuringWillAppear;
  
  NSInteger _selectedIndex;
  BOOL _viewLoaded;
  
  id<FJTabBarControllerDelegate> _delegate;  
}

@property (nonatomic, assign) id<FJTabBarControllerDelegate> delegate;
@property (nonatomic,copy) NSArray *viewControllers;


@property (nonatomic, assign) UIViewController<FJBaseViewController> *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;

- (AppTabBar *)appTabBarView;
//- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

@end
