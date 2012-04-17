//
//  FJNavigationController.m
//  ToothHealthy
//
//  Created by Jianjun Wu on 3/26/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import "FJNavigationController.h"


@interface FJNavigationController ()
@property (nonatomic, retain) UIView *containerView;
@end


@implementation FJNavigationController

@synthesize customBarHidden = _customBarHidden;
@synthesize useSingleCustomBar = _useSingleCustomBar;
@synthesize delegate = _delegate;
@synthesize containerView = _containerView;

- (void)dealloc {
  
  [_containerView release];
  [_viewControllers release];
  [_containerView release];
  
  [super dealloc];
}

- (id)initWithRootViewController:(UIViewController<FJBaseViewController> *)rootViewController {
  
  self = [super init];
  if (self) {

    _viewControllers  = [[NSMutableArray alloc] initWithCapacity:8];
    [_viewControllers addObject:rootViewController]; 
    _useSingleCustomBar = NO;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
    
  self.view.backgroundColor = [UIColor blackColor];
}

- (void)layoutContainer {
  
  UIViewController<FJBaseViewController> *topController = self.topViewController;
  _containerView.frame = self.view.bounds;
  if (_customBarHidden) {
    [topController.appCustomNavBar removeFromSuperview];
    topController.view.frame = _containerView.bounds;
  } else {
    [_containerView addSubview:topController.appCustomNavBar];
    
    CGRect frame = _containerView.bounds;
    topController.appCustomNavBar.frame = CGRectMake(0, 0,       
                                                     CGRectGetWidth(frame), APP_CUSTOM_NAV_BAR_HEIGHT);
    frame.origin.y = APP_CUSTOM_NAV_BAR_HEIGHT;
    frame.size.height -= APP_CUSTOM_NAV_BAR_HEIGHT;
    topController.view.frame = frame;
  }
}

- (void)setCustomBarHidden:(BOOL)customBarHidden {
  _customBarHidden = customBarHidden;

  [self layoutContainer];
}

- (void)setUseSingleCustomBar:(BOOL)useSingleCustomBar {
  _useSingleCustomBar = useSingleCustomBar;
  if (_useSingleCustomBar) {
    self.appCustomNavBar.frame = CGRectMake(0, 0, 
                                            self.view.frame.size.width, APP_CUSTOM_NAV_BAR_HEIGHT);
    [self.view addSubview:self.appCustomNavBar];
  } else {
    [self.appCustomNavBar removeFromSuperview];
  }
}

- (FJNavigationBar *)appCustomNavBar {
  
  if (_appCustomNavBar == nil) {
    _appCustomNavBar = [[FJNavigationBar alloc] init];
  }
  return _appCustomNavBar;
}

- (void)viewWillAppear:(BOOL)animated {
  
  if (_containerView == nil || self.topViewController.view.superview == _containerView) {
    [self pushViewController:self.topViewController animated:NO];
  } else {
    [self layoutContainer];
  }
}

- (void)switchNavigationBarToBar:(FJNavigationBar *)toBar 
                        animated:(BOOL)animated  {
  if (animated) {
    [self.appCustomNavBar setLeftItemAnimated:toBar.leftItem];
    [self.appCustomNavBar setRightItem:toBar.rightItem];
    [self.appCustomNavBar setTitleTextAnimated:toBar.titleLabel.text];
    [self.appCustomNavBar setTitleViewAnimated:toBar.titleView];
  } else {
    self.appCustomNavBar.leftItem = toBar.leftItem;
    self.appCustomNavBar.rightItem = toBar.rightItem;
    self.appCustomNavBar.titleLabel.text = toBar.titleLabel.text;
    self.appCustomNavBar.titleView = toBar.titleView;
  }
  if (self.appCustomNavBar.superview == nil) {
    self.appCustomNavBar.frame = CGRectMake(0, 0, 
                                            self.view.frame.size.width, APP_CUSTOM_NAV_BAR_HEIGHT);
    [self.view addSubview:self.appCustomNavBar];
  }
}

- (void)pushNavigationBarToBar:(FJNavigationBar *)toBar 
                      animated:(BOOL)animated {
  
  [self switchNavigationBarToBar:toBar animated:animated];
}

- (void)pushViewController:(UIViewController<FJBaseViewController> *)viewController animated:(BOOL)animated {
  if (viewController == nil) {
    FJError(@"viewController can't be nil");
    return;
  }
  
  [self setNavigationBarForControllerWhenPushing:viewController];

  CGRect frame = self.view.bounds;
  
  if (animated) {
    UIViewController<FJBaseViewController> *pushOut = self.topViewController;
    if (pushOut.view.superview == nil) {
      pushOut = nil;
    }
    UIView *pushOutContainerView = self.containerView;
    [pushOut viewWillDisappear:animated];

    UIView *pushInContainerView = [self containerViewForController:viewController];
    [viewController viewWillAppear:animated];
    frame = pushInContainerView.frame;
    frame.origin.x = frame.size.width;
    pushInContainerView.frame = frame;
    [self.view addSubview:pushInContainerView];
    if (_useSingleCustomBar) {
      [self pushNavigationBarToBar:viewController.appCustomNavBar 
                          animated:YES];
    }
    [viewController viewDidAppear:animated];

    [UIView animateWithDuration:APP_NAV_SLIDE_DURATION
                     animations:^(void){
                       CGRect frame = pushOutContainerView.frame;
                       frame.origin.x = -frame.size.width;
                       pushOutContainerView.frame = frame;
                       
                       frame = pushInContainerView.frame;
                       frame.origin.x = 0;
                       pushInContainerView.frame = frame;
                     } 
                     completion:^(BOOL completed){
                       [pushOutContainerView removeFromSuperview];
                       self.containerView = pushInContainerView;
                     }];
  } else {
    UIViewController<FJBaseViewController> *controllerPushOut = self.topViewController;
    if (controllerPushOut && controllerPushOut.view.superview) {
      FJDebugLog(@"push out controller %@ without animation", controllerPushOut);
      [controllerPushOut viewWillDisappear:animated];
      [self.containerView removeFromSuperview];
      self.containerView = nil;
      [controllerPushOut viewDidDisappear:animated];
    }
    FJDebugLog(@"push in controller %@ without animation", viewController);
    self.containerView = [self containerViewForController:viewController];
    [viewController viewWillAppear:animated];
    [self.view addSubview:self.containerView];
    if (_useSingleCustomBar) {
      [self pushNavigationBarToBar:viewController.appCustomNavBar 
                          animated:NO];
    }
    [viewController viewDidAppear:animated];
  }
  
  viewController.appNavController = self;
  if ([_viewControllers indexOfObject:viewController]  == NSNotFound) {
    [_viewControllers addObject:viewController];
  }
}

- (void)popNavigationBarToBar:(FJNavigationBar *)toBar 
                    animated:(BOOL)animated {
  
  [self switchNavigationBarToBar:toBar animated:animated];
}

- (UIViewController<FJBaseViewController> *)popViewControllerAnimated:(BOOL)animated {
  
  if ([_viewControllers count] == 1) {
    FJError(@"Cannot pop up last view controller");
    return nil;
  }

  UIViewController<FJBaseViewController> *popIn = [_viewControllers 
                                                   objectAtIndex:[_viewControllers count] - 2];
  UIViewController<FJBaseViewController> *popOut = [_viewControllers lastObject];
  CGRect frame = self.view.bounds;
  
  if (animated) {

    UIView *popOutContainerView = self.containerView;
    [popOut viewWillDisappear:animated];
    
    UIView *popInContainerView = [self containerViewForController:popIn];
    [popIn viewWillAppear:animated];
    frame = popInContainerView.frame;
    frame.origin.x = -frame.size.width;
    popInContainerView.frame = frame;
    [self.view addSubview:popInContainerView];
    if (_useSingleCustomBar) {
      [self popNavigationBarToBar:popIn.appCustomNavBar 
                        animated:YES];
    }
    [popIn viewDidAppear:animated];
    
    [UIView animateWithDuration:APP_NAV_SLIDE_DURATION
                     animations:^(void){
                       CGRect frame = popOutContainerView.frame;
                       frame.origin.x = frame.size.width;
                       popOutContainerView.frame = frame;
                       
                       frame = popInContainerView.frame;
                       frame.origin.x = 0;
                       popInContainerView.frame = frame;
                     } 
                     completion:^(BOOL completed){
                       [popOutContainerView removeFromSuperview];
                       self.containerView = popInContainerView;
                     }];
  } else {

    FJDebugLog(@"pop out controller %@ without animation", popOut);
    [popOut viewWillDisappear:animated];
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    [popOut viewDidDisappear:animated];
    
    FJDebugLog(@"pop in controller %@ without animation", popIn);
    self.containerView = [self containerViewForController:popIn];
    [popIn viewWillAppear:animated];
    [self.view addSubview:self.containerView];
    if (_useSingleCustomBar) {
      [self popNavigationBarToBar:popIn.appCustomNavBar 
                         animated:YES];
    }
    [popIn viewDidAppear:animated];
  }
  
  popIn.appNavController = self;
  popOut = [[popOut retain] autorelease];
  [_viewControllers removeLastObject];
  return popOut;
}

- (UIViewController<FJBaseViewController> *)popViewControllerWithAnimation {
  
  return [self popViewControllerAnimated:YES];
}

- (NSArray *)popToViewController:(UIViewController<FJBaseViewController> *)viewController 
                        animated:(BOOL)animated {
  
  NSInteger popToIndex = [_viewControllers indexOfObject:viewController];
  
  NSInteger count = [_viewControllers count];
  NSInteger countToRemove = (count - popToIndex - 2);
  if (countToRemove > 0) {
    [_viewControllers removeObjectsInRange:NSMakeRange(popToIndex + 1, countToRemove)];
  }  else {
    NSLog(@"Nothing to remove in %@", [FJNavigationController class]);
  }
  [self popViewControllerAnimated:animated];
  return _viewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
  
  NSInteger count = [_viewControllers count];
  if (count > 2) {
    [_viewControllers removeObjectsInRange:NSMakeRange(1, count - 2)];
  }  
  [self popViewControllerAnimated:animated];
  return _viewControllers;
}

- (void)renderTabBarForCurrentViewController {
  
  [self switchNavigationBarToBar:self.topViewController.appCustomNavBar animated:NO];
}

- (UIViewController<FJBaseViewController> *)topViewController {
  
  if (_viewControllers && [_viewControllers count]) {
    return [_viewControllers lastObject];
  }
  return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods

- (void)setNavigationBarForControllerWhenPushing:(UIViewController<FJBaseViewController> *)controller {
  
  if (self.customBarHidden) {
    return;
  }
  
  if (controller.appCustomNavBar == nil) {
    controller.appCustomNavBar = [[[FJNavigationBar alloc] init] autorelease];
  }
  if ([_viewControllers count] > 0 && [_viewControllers lastObject] != controller) {
    UIControl *leftItem = controller.appCustomNavBar.leftItem;
    if (leftItem 
        && [leftItem isKindOfClass:[UIButton class]] 
        && controller.appCustomNavBar.useDefaultBackButton) {
      UIButton *leftButton = (UIButton *)leftItem;
      NSString *title = [leftButton titleForState:UIControlStateNormal];
      if (title == nil) {
        [leftButton setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
      }
      [controller.appCustomNavBar.leftItem addTarget:self 
                                              action:@selector(popViewControllerWithAnimation) 
                                    forControlEvents:UIControlEventTouchUpInside];
    }
  }  
  controller.appCustomNavBar.titleLabel.text = controller.title;
}

- (UIView *)containerViewForController:(UIViewController<FJBaseViewController> *)controller {
  
  UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
  if (self.customBarHidden == NO && _useSingleCustomBar == NO) {
    if (controller.appCustomNavBar == nil) {
      controller.appCustomNavBar = [[[FJNavigationBar alloc] init] autorelease];
    }
    [contentView addSubview:controller.appCustomNavBar];
    [contentView addSubview:controller.view];
        
    CGRect frame = contentView.bounds;
    controller.appCustomNavBar.frame = CGRectMake(0, 0,       
                                                     CGRectGetWidth(frame), APP_CUSTOM_NAV_BAR_HEIGHT);
    frame.origin.y = APP_CUSTOM_NAV_BAR_HEIGHT;
    frame.size.height -= APP_CUSTOM_NAV_BAR_HEIGHT;
    controller.view.frame = frame;
  } else {
    [contentView addSubview:controller.view];
    
    if (_useSingleCustomBar) {
      controller.appCustomNavBar.titleLabel.text = controller.title;
      CGRect f = contentView.bounds;
      f.origin.y = APP_CUSTOM_NAV_BAR_HEIGHT;
      f.size.height -= APP_CUSTOM_NAV_BAR_HEIGHT;
      contentView.frame = f;
      controller.view.frame = contentView.bounds;
    } else {
      controller.view.frame = contentView.bounds;
    }
  }
  return [contentView autorelease];
}

@end
