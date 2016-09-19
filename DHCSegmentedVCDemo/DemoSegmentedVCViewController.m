//
//  DemoSegmentedVCViewController.m
//  DHCSegmentedVCDemo
//
//  Created by sdlcdhch on 16/9/18.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "DemoSegmentedVCViewController.h"

@interface DemoSegmentedVCViewController ()

@end

@implementation DemoSegmentedVCViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.normalFont = [UIFont systemFontOfSize:20.f];
        self.normalColor = [UIColor lightGrayColor];
        self.selectedColor = [UIColor purpleColor];
        self.interTitleSpacing = 15.f;
        self.titlesEdgeInsets = UIEdgeInsetsMake(0, 20.f, 0, 20.f);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildViewControllers
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    for (NSInteger pIndex = 0; pIndex < 10; ++pIndex)
    {
        UIViewController *vc = [UIViewController new];
        if (pIndex == 0)
        {
            vc.title = [NSString stringWithFormat:@"%zd",pIndex];
        }else if (pIndex == 1)
        {
            vc.title = [NSString stringWithFormat:@"简%zd",pIndex];
        }else if (pIndex == 2)
        {
            vc.title = [NSString stringWithFormat:@"简单%zd",pIndex];
        }else if (pIndex == 3)
        {
            vc.title = [NSString stringWithFormat:@"简单的%zd",pIndex];
        }else if (pIndex == 4)
        {
            vc.title = [NSString stringWithFormat:@"简单的测%zd",pIndex];
        }else
        {
            vc.title = [NSString stringWithFormat:@"简单的测试%zd",pIndex];
        }
        
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    
    [self refreshDisplay];
}

@end
