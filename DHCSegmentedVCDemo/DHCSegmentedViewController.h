//
//  DHCSegmentedViewController.h
//  DHCSegmentedVCDemo
//
//  Created by sdlcdhch on 16/9/18.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+DHC.h"

@interface DHCSegmentedViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 当前所在的index */
@property (nonatomic, assign,getter=currentIndex) NSInteger selectedIndex;

/** 设置title之间的间距 */
@property (nonatomic, assign) NSInteger interTitleSpacing;

/** 设置title距离边界的间距 */
@property (nonatomic, assign) UIEdgeInsets titlesEdgeInsets;

/** title未选中状态的颜色 */
@property (nonatomic, strong) UIColor *normalColor;

/** title选中状态时的颜色 */
@property (nonatomic, strong) UIColor *selectedColor;

/** title的字体设置 */
@property (nonatomic, strong) UIFont *normalFont;

- (void)refreshDisplay;

@end
