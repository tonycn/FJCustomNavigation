//
//  FJBaseViewController.m
//  muzhigou
//
//  Created by 建军 吴 on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FJBaseViewController.h"

@implementation FJBaseUIViewController
@synthesize appTabBarController = _appTabBarController;
@synthesize appNavController = _appNavController;
@synthesize appTabItemView = _appTabItemView;
@synthesize appCustomNavBar = _appCustomNavBar;

- (void)dealloc {
  
  [_appTabItemView release];
  [_appCustomNavBar release];

  [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end


