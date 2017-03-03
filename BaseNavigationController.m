//
//  BaseNavigationController.m
//  darongtong
//
//  Created by darongtong on 15/9/17.
//  Copyright © 2015年 rongtong. All rights reserved.
//

#import "BaseNavigationController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark - 控制状态栏的样式

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden=YES;
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 2.设置导航栏的背景图片
    [navBar setTintColor:[UIColor whiteColor]];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[navBar setBackgroundImage:[UIImage imageNamed:@"headpic"] forBarMetrics:UIBarMetricsDefault];
    // 3.标题
    [navBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:kFontBig18], NSForegroundColorAttributeName : [UIColor whiteColor] }];
#if 0
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
#endif

}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController setNavigationBarHidden:NO];
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES  ;
    }
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#if 0
//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    
//}
//
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (navigationController.viewControllers.count == 1)
//        self.currentShowVC = Nil;
//    else
//        self.currentShowVC = viewController;
//}
//
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        return (self.currentShowVC == self.topViewController); //the most important
//    }
//    return YES;
//}
//
//#endif
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}


@end
