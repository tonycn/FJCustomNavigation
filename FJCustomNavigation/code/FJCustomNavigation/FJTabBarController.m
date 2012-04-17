//
//  FJTabBarController.m
//  muzhigou
//
//  Created by 建军 吴 on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FJBaseViewController.h"
#import "FJTabBarController.h"
#import "FJNavigationController.h"

@implementation AppTabBar

@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize items = _items;
@synthesize selectedItem = _selectedItem;
@synthesize itemBackgroundColor = _itemBackgroundColor;
@synthesize selectedItemBackgroundColor = _selectedItemBackgroundColor;

- (void)dealloc {

  [_backgroundView release];
  [_backgroundView release];
  _delegate = nil;
  _selectedItem = nil;
  
  
  [super dealloc];
}

- (void)tabItemTouchUpInside:(UIControl *)item {
  
  NSInteger tabIndex = [_items indexOfObject:item];
  self.selectedItem.backgroundColor = self.itemBackgroundColor;
  item.backgroundColor = self.selectedItemBackgroundColor;
  self.selectedItem = item;
  if (tabIndex != NSNotFound && self.delegate) {
    [self.delegate tabBar:self didSelectTabIndex:tabIndex];
  }
}

- (void)setItems:(NSArray *)items {
  if (items == _items) {
    return;
  }
  [_items autorelease];
  UIControl *aItem;
  for (aItem in _items) {
    [aItem removeFromSuperview];
  }
  _items = [items copy];
  for (aItem in items) {
    aItem.backgroundColor = self.itemBackgroundColor;
    [self addSubview:aItem];
    [aItem addTarget:self 
              action:@selector(tabItemTouchUpInside:) 
    forControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)layoutSubviews {
  
  UIView *aItem = nil;
  CGFloat defaultItemWidth = CGRectGetWidth(self.frame) / [_items count];
  CGFloat itemHeight = CGRectGetHeight(self.frame);
  NSInteger count = 0;
  CGFloat offsetX = 0.f;
  CGFloat itemWidth = 0.f;
  for (aItem in _items) {
    itemWidth = aItem.frame.size.width > 0.f ? aItem.frame.size.width : defaultItemWidth;
    aItem.frame = CGRectMake(offsetX, 0, itemWidth, itemHeight);
    offsetX = CGRectGetMaxX(aItem.frame);
    ++count;
  }
}

//- (void)setItems:(NSArray *)items animated:(BOOL)animated {
//    
//}

@end

@implementation FJTabBarController
@synthesize delegate = _delegate;
@synthesize viewControllers = _viewControllers;
@synthesize selectedViewController = _selectedViewController;
@synthesize selectedIndex = _selectedIndex;

- (void)dealloc {
  _delegate = nil;

  [_appTabBarView release];
  [_viewControllers release];
  _selectedViewController = nil;
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    _selectedIndex = 0;
    _containerView = [[UIView alloc] init];
    _appTabBarView = [[AppTabBar alloc] init];
    _appTabBarView.delegate = self;    
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


- (AppTabBar *)appTabBarView {
  return _appTabBarView;
}
#pragma mark - Tab Bar Controller

- (void)setTabBarControllerNavInfoForController:(UIViewController<FJBaseViewController> *)controller {
  
  self.appCustomNavBar = controller.appCustomNavBar;
  self.title = controller.title;
}

- (void)setViewControllers:(NSArray *)viewControllers {
  
  [_viewControllers autorelease];
  
  _viewControllers = [viewControllers mutableCopy];
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:5];
  for (UIViewController<FJBaseViewController> *controller in viewControllers) {
    UIControl *tableItem = controller.appTabItemView;
    if (tableItem == nil) {
      tableItem = [UIButton buttonWithType:UIButtonTypeCustom];
      [(id)tableItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [(id)tableItem setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
      [(id)tableItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
      
      [(id)tableItem setTitle:@"Tab" forState:UIControlStateNormal];
      [(id)tableItem setTitle:@"Selected" forState:UIControlStateSelected];
      controller.appTabItemView = tableItem;
    }
    [items addObject:tableItem];
  }
  _appTabBarView.items = items;
  
  [self setTabBarControllerNavInfoForController:[_viewControllers objectAtIndex:0]];
}

- (void)switchFromTab:(UIViewController<FJBaseViewController> *)fromTab 
                   to:(UIViewController<FJBaseViewController> *)toTab {
  if (fromTab == toTab || toTab == nil || toTab == _selectedViewController) {
    return;
  }
  
  if (fromTab != nil) {
    [fromTab viewWillDisappear:NO];
    [fromTab.view removeFromSuperview];
    [fromTab viewDidDisappear:NO];
  }
  toTab.view.frame = CGRectMake(0, 0, 
                                CGRectGetWidth(_containerView.frame), 
                                CGRectGetHeight(_containerView.frame));
  [toTab viewWillAppear:NO];
  [_containerView addSubview:toTab.view];
  if (self.appNavController) {
    [self setTabBarControllerNavInfoForController:toTab];
    [self.appNavController renderTabBarForCurrentViewController];
  }
  [toTab viewDidAppear:NO];
    
  [self.view bringSubviewToFront:_appTabBarView];
}

- (void)setSelectedViewController:(UIViewController<FJBaseViewController> *)selectedViewController {
  
  NSInteger index = [_viewControllers indexOfObject:selectedViewController];
  [self setSelectedIndex:index];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
  
  if (selectedIndex == _selectedIndex && _selectedViewController != nil) {
    return;
  }
  
  if (!(selectedIndex >= 0 && selectedIndex < [_viewControllers count])) {
    NSLog(@"FJTabBarController: invalid selected index");
  }
  
  
  if (_viewLoaded) {
    UIViewController<FJBaseViewController> *toSelect = [_viewControllers objectAtIndex:selectedIndex];
    _selectedViewControllerDuringWillAppear = _selectedViewController;
    _selectedViewController.appTabItemView.selected = NO;
    [self switchFromTab:_selectedViewController to:toSelect];
    _selectedViewController.appTabItemView.backgroundColor = self.appTabBarView.itemBackgroundColor;
    _selectedViewController = toSelect;
    _selectedViewController.appTabItemView.selected = YES;
    _selectedViewController.appTabItemView.backgroundColor = self.appTabBarView.selectedItemBackgroundColor;
  }
  
  _selectedIndex = selectedIndex;
}

//- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
//
//}

- (void)tabBar:(AppTabBar *)tabBar didSelectTabIndex:(NSInteger)tabIndex {
  self.selectedIndex = tabIndex;
  
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  _viewLoaded = YES;
    
  CGRect frame = self.view.frame;
  frame.origin = CGPointZero;
  frame.size.height = CGRectGetHeight(frame) - APP_CUSTOM_TABBAR_HEIGHT;
  _containerView.frame = frame;
  _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
  
  frame = CGRectMake(0, CGRectGetMaxY(_containerView.frame), 
                     CGRectGetWidth(_containerView.frame), APP_CUSTOM_TABBAR_HEIGHT);
  [self.view addSubview:_containerView];
  _appTabBarView.frame = frame;
  _appTabBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [self.view addSubview:_appTabBarView];
  self.selectedIndex = 0;
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  _selectedViewController = nil;
  
  _viewLoaded = NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self setSelectedIndex:_selectedIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
