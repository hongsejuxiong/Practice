//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by xie on 17/1/23.
//  Copyright © 2017年 drt. All rights reserved.
//
#define SCREEN_WIDTH                    CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT                   CGRectGetHeight([UIScreen mainScreen].bounds)
#define TITLE_HEIGHT                    64.f

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
@interface ViewController ()<UIScrollViewDelegate>{
    
    
    UIScrollView       *_mainScrollView;
}

@property(nonatomic, strong)UIViewController *currentVC;
@property(nonatomic, strong)UIViewController *twoVC;
@property(nonatomic, strong)UIViewController *oneVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    OneViewController *oneVC = [[OneViewController alloc]init];
    self.oneVC = oneVC;
//    oneVC.view.frame = CGRectMake(0, 150, SCREEN_WIDTH, 300);
    [self addChildViewController:oneVC];
    
    
    TwoViewController *twoVC = [[TwoViewController alloc]init];
    [self addChildViewController:twoVC];
//    twoVC.view.frame = CGRectMake(0, 150, SCREEN_WIDTH, 300);
    self.twoVC = twoVC;

    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.backgroundColor = [UIColor cyanColor];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
//    [self.view addSubview:_mainScrollView];

    
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = _mainScrollView.bounds;
    [_mainScrollView addSubview:vc.view];

    
    UIButton *button1 = [UIButton buttonWithType:0];
    button1.backgroundColor = [UIColor redColor];
    button1.tag = 0;
    [button1 setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateSelected];
    button1.frame = CGRectMake(100, 70, 100, 50);
    [button1 addTarget:self action:@selector(changebgView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    UIButton *button2 = [UIButton buttonWithType:0];
    button2.backgroundColor = [UIColor blueColor];
    button2.tag = 1;

    button2.frame = CGRectMake(300, 70, 50, 25);
//    [button2 addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    
//    [_mainScrollView addSubview:oneVC.view];
    
    
//    [self.view addSubview:oneVC.view];

//    self.currentVC = oneVC;

    
}

- (void)changeView:(UIButton *)button{
    
    [_mainScrollView setContentOffset:CGPointMake(button.tag*SCREEN_WIDTH, 0) animated:YES];

//    if (button.tag == 1) {
//        
//        [_mainScrollView setContentOffset:CGPointMake(0, 0)];
//        [self changeController:_oneVC];
//        
//    }else{
//        
//        [_mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
//        
////        if (self.twoVC.view == nil) {
////            
////            [_mainScrollView addSubview:self.twoVC.view];
////        }
//        [self changeController:_twoVC];
//
//    }
}

- (void)changeController:(UIViewController *)selectVC{
    
    [self transitionFromViewController:self.currentVC
                      toViewController:selectVC
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{

                            }
                            completion:^(BOOL finished){

                                self.currentVC = selectVC;
                            }];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = _mainScrollView.contentOffset.x / _mainScrollView.frame.size.width;

    UIViewController *vc = self.childViewControllers[index];
    
    
    if(vc.view.superview)return;
    
    vc.view.frame = _mainScrollView.bounds;
    [_mainScrollView addSubview:vc.view];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    
    NSUInteger index = _mainScrollView.contentOffset.x / _mainScrollView.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    
    if(vc.view.superview)return;
    
    vc.view.frame = _mainScrollView.bounds;
    [_mainScrollView addSubview:vc.view];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changebgView:(UIButton *)button{
    
    button.selected = !button.selected;

}

@end
