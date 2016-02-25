//
//  PCHamburgerMenuBaseViewController.h
//  PCHamburgerMenu
//
//  Created by Paul Carpenter on 3/28/14.
//  Copyright (c) 2014 Paul Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCHamburgerMenuTraits.h"

typedef void (^PCHamburgerMenuAnimationBlock)(id object1, id object2);

@interface PCHamburgerMenuBaseViewController : UIViewController

@property(nonatomic, strong) UIViewController<PCHamburgerMenuTraits>* menuController;
@property(nonatomic, strong) UIViewController* contentController;
@property(nonatomic, assign, readonly) BOOL isShowingMenu;

@property(nonatomic, strong) PCHamburgerMenuAnimationBlock showMenuAnimation;
@property(nonatomic, strong) PCHamburgerMenuAnimationBlock hideMenuAnimation;

- (void)toggleMenuAnimated:(BOOL)animated;

@end
