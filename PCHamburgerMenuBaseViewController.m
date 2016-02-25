//
//  PCHamburgerMenuBaseViewController.m
//  PCHamburgerMenu
//
//  Created by Paul Carpenter on 3/28/14.
//  Copyright (c) 2014 Paul Carpenter. All rights reserved.
//

#import "PCHamburgerMenuBaseViewController.h"
#import "UIView+UIHelper.h"
#import "UIImage+PUImages.h"

const float kDefaultHamburgerMenuAnimationDuration = 0.15;

@interface PCHamburgerMenuBaseViewController ()

@property(nonatomic, assign, readwrite) BOOL isShowingMenu;
@property(nonatomic) UINavigationController* currentNavViewController;
@property(nonatomic) UISwipeGestureRecognizer* swipeRecognizer;

@end

@implementation PCHamburgerMenuBaseViewController

@synthesize currentContentViewController = _currentContentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(menuSwiped:)];
        self.swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.isShowingMenu = YES;
        RAC(self, currentNavViewController) = [RACObserve(self, currentContentViewController) filter:^BOOL(UIViewController* newCurrentVC) {
            return [newCurrentVC isKindOfClass:[UINavigationController class]];
        }];
        RAC(self, currentNavViewController.topViewController.view.userInteractionEnabled) = [RACObserve(self, isShowingMenu) not];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSAssert(self.currentContentViewController, @"Need at least one content controller");
}

- (void)toggleMenuAnimated:(BOOL)animated
{
    @weakify(self);
    if (self.isShowingMenu) {
        if (animated) {
            if (self.showMenuAnimation) {
                self.showMenuAnimation(self.currentContentViewController, self.menuController);
            } else {
                [UIView animateWithDuration:kDefaultHamburgerMenuAnimationDuration animations:^{
                    @strongify(self);
                    self.currentContentViewController.view.frameX = 0.f;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.isShowingMenu = NO;
                    [[[UIApplication sharedApplication] keyWindow] removeGestureRecognizer:self.swipeRecognizer];
                }];
            }
        } else {
            self.contentController.view.frameX = 0.f;
            self.isShowingMenu = NO;
            [[[UIApplication sharedApplication] keyWindow] removeGestureRecognizer:self.swipeRecognizer];
        }
    } else {
        if (animated) {
            if (self.hideMenuAnimation) {
                self.hideMenuAnimation(self.contentController, self.menuController);
            } else {
                [UIView animateWithDuration:kDefaultHamburgerMenuAnimationDuration animations:^{
                    @strongify(self);
                    self.contentController.view.frameX = self.menuController.menuWidth;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.isShowingMenu = YES;
                    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:self.swipeRecognizer];
                }];
            }
        } else {
            self.contentController.view.frameX = self.menuController.menuWidth;
            self.isShowingMenu = YES;
            [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:self.swipeRecognizer];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMenuController:(UIViewController<PCHamburgerMenuTraits> *)menuController
{
    if(self.menuController != menuController)
    {
        _menuController = menuController;
        
        [self addChildViewController:menuController];
        
        // Insert the menu below all other views.
        [self.view insertSubview:menuController.view atIndex:0];
    }
}

- (void)setContentController:(UIViewController *)contentController
{
    if (_contentController != contentController)
    {
        [_contentController removeFromParentViewController];
        [_contentController.view removeFromSuperview];
        
        _contentController = contentController;
        
        [self addChildViewController:contentController];
        [self.view addSubview:contentController.view];
    }
}

- (void)menuSwiped:(id)sender
{
    [self toggleMenuAnimated:YES];
}

@end
