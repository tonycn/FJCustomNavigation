//
//  FJBaseViewController.h
//  muzhigou
//
//  Created by 建军 吴 on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FJTabBarController;
@class FJNavigationController;
@class FJNavigationBar;

#ifndef FJ_CUSTOM_NAV_LOGGING
#define FJ_CUSTOM_NAV_LOGGING

#define FJError(xx, ...)  NSLog(@"%s(%d): FJError " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define FJDebugLog(xx, ...)  NSLog(@"%s(%d): FJError " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define FJDebugLog(xx, ...) ((void)0)
#endif

#endif

@protocol FJBaseViewController <NSObject>

@property (nonatomic, assign) FJTabBarController *appTabBarController;
@property (nonatomic, assign) FJNavigationController *appNavController;
@property (nonatomic, retain) UIControl *appTabItemView;
@property (nonatomic, retain) FJNavigationBar *appCustomNavBar;

@end

@interface FJBaseUIViewController : UIViewController <FJBaseViewController>  {
  
  FJNavigationBar *_appCustomNavBar;
}

@end


