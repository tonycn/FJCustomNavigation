//
//  FJNavigationController.h
//  ToothHealthy
//
//  Created by Jianjun Wu on 3/26/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJBaseViewController.h"
#import "FJNavigationBar.h"

@class FJNavigationController;

@protocol FJNavigationControllerDelegate <NSObject>

@optional
- (void)navigationController:(FJNavigationController *)navigationController 
      willShowViewController:(id<FJBaseViewController>)viewController animated:(BOOL)animated;
- (void)navigationController:(FJNavigationController *)navigationController 
       didShowViewController:(id<FJBaseViewController>)viewController animated:(BOOL)animated;
@end

@interface FJNavigationController : FJBaseUIViewController <FJNavigationControllerDelegate> {
  
  UIView *_containerView;
  NSMutableArray *_viewControllers;
  
  BOOL _customBarHidden;
  BOOL _useSingleCustomBar;
}

@property (nonatomic, assign) BOOL customBarHidden;
@property(nonatomic, assign) BOOL useSingleCustomBar;

// The top view controller on the stack.
@property(nonatomic,readonly,retain) UIViewController<FJBaseViewController> *topViewController; 
@property(nonatomic, assign) id<FJNavigationControllerDelegate> delegate;

- (id)initWithRootViewController:(UIViewController<FJBaseViewController> *)rootViewController; // Convenience method pushes the root view controller without animation.

- (void)pushViewController:(UIViewController<FJBaseViewController> *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (UIViewController<FJBaseViewController> *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (NSArray *)popToViewController:(UIViewController<FJBaseViewController> *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.

- (void)renderTabBarForCurrentViewController;

@end