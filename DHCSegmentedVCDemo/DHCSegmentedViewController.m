//
//  DHCSegmentedViewController.m
//  DHCSegmentedVCDemo
//
//  Created by sdlcdhch on 16/9/18.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "DHCSegmentedViewController.h"

#define DHC_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define DHC_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define DHC_STRING_NOT_EMPTY(str) ([str isKindOfClass:[NSString class]] && [str dhc_trim].length != 0)

@interface DHCSegmentedViewController ()

@property (nonatomic, strong) UIScrollView *titleScrollView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UICollectionView *contentCollectionView;

@property (nonatomic, strong) NSMutableArray<__kindof UILabel *> *titleLabels;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation DHCSegmentedViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _titleLabels = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:249.f / 255 green:249.f / 255 blue:249.f / 255 alpha:1.f];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}

- (void)setupSubviews
{
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 48.f)];
    _titleScrollView.delegate = self;
    _titleScrollView.contentInset = self.titlesEdgeInsets;
    
    
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake(DHC_SCREEN_WIDTH, DHC_SCREEN_HEIGHT - CGRectGetMaxY(_titleScrollView.frame));
    
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleScrollView.frame), DHC_SCREEN_WIDTH, DHC_SCREEN_HEIGHT - CGRectGetMaxY(_titleScrollView.frame)) collectionViewLayout:flowLayout];
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.pagingEnabled = YES;
    [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:_titleScrollView];
    [self.view addSubview:_contentCollectionView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.f, 30.f, 4.f)];
    _lineView.backgroundColor = [UIColor blackColor];
    [_titleScrollView addSubview:_lineView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.titleLabels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) * 1.f / 255
                                                       green:(arc4random() % 255) * 1.f / 255
                                                        blue:(arc4random() % 255) * 1.f / 255
                                                       alpha:1.f];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.contentCollectionView isEqual:scrollView])
    {
        CGRect lineFrame = [self frameOfLineViewByTitlesOffset:scrollView.contentOffset];
        [UIView performWithoutAnimation:^{
            self.lineView.frame = lineFrame;
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentCollectionView])
    {
        self.currentIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentCollectionView])
    {
        self.currentIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    }
}

// 让选中的按钮居中显示
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _selectedIndex = currentIndex;
    if (_currentIndex == currentIndex || currentIndex > [self.titleLabels count] || currentIndex < 0)
    {
        return;
    }
    _currentIndex = currentIndex;
    
    for (UILabel *pLabels in self.titleLabels)
    {
        if (pLabels.tag == currentIndex)
        {
            pLabels.textColor = self.selectedColor;
        }
        else
        {
            pLabels.textColor = self.normalColor;
        }
    }
    
    if (!_titleScrollView.scrollEnabled)
    {
        return;
    }
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = self.titleLabels[currentIndex].center.x + self.titleScrollView.contentInset.left - CGRectGetWidth(_titleScrollView.frame) / 2;
    
    if (offsetX < 0)
    {
        offsetX = -_titleScrollView.contentInset.left;
    }
    
    if (_titleScrollView.contentSize.width - self.titleLabels[currentIndex].center.x < CGRectGetWidth(_titleScrollView.frame) / 2)
    {
        offsetX = _titleScrollView.contentSize.width - CGRectGetWidth(_titleScrollView.frame) + _titleScrollView.contentInset.right;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (CGRect)frameOfLineViewByTitlesOffset:(CGPoint)offset
{
    CGRect rFrame = self.lineView.frame;
    
    CGSize contentSize = self.contentCollectionView.contentSize;
    
    if (contentSize.width <= CGRectGetWidth(rFrame))
    {
        return rFrame;
    }
    
    CGSize verifySize = CGSizeMake(contentSize.width - CGRectGetWidth(self.contentCollectionView.frame), CGRectGetHeight(rFrame));
    
    if (CGRectContainsPoint((CGRect){CGPointZero,verifySize}, offset))
    {
        NSInteger page = offset.x / CGRectGetWidth(self.contentCollectionView.frame);
        CGFloat realOffsetX = offset.x - CGRectGetWidth(self.contentCollectionView.frame) * page;
        CGFloat distance = CGRectGetMinX([self.titleLabels objectAtIndex:page + 1].frame) - CGRectGetMinX([self.titleLabels objectAtIndex:page].frame);
        rFrame.origin.x = CGRectGetMinX([self.titleLabels objectAtIndex:page].frame) + distance * realOffsetX / CGRectGetWidth(self.contentCollectionView.frame);
        
        CGFloat diff = CGRectGetWidth([self.titleLabels objectAtIndex:page + 1].frame) - CGRectGetWidth([self.titleLabels objectAtIndex:page].frame);
        rFrame.size.width = CGRectGetWidth([self.titleLabels objectAtIndex:page].frame) + diff * realOffsetX / CGRectGetWidth(self.contentCollectionView.frame);
    }
    return rFrame;
}

- (void)refreshDisplay
{
    NSMutableArray *titleSizeArray = [NSMutableArray array];
    
    CGFloat totalWidth = 0;
    for (UIViewController *childVC in self.childViewControllers)
    {
        
        NSAssert(DHC_STRING_NOT_EMPTY(childVC.title), @"childVC must have a title,please go to set %@'s title!",[childVC class]);
        CGSize titleSize = [childVC.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f]}];
        NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(ceil(titleSize.width), ceil(titleSize.height))];
        [titleSizeArray addObject:sizeValue];
        totalWidth += titleSize.width + _interTitleSpacing;
    }
    totalWidth -= _interTitleSpacing;
    
    CGFloat startX = 0;     // title的起始位置
    CGFloat realInterTitleItemSpacing = _interTitleSpacing;  //title之间的设置间距的差值
    
    /* 比较titleScrollView的可视区域宽度和所有title内容宽度，如果实际内容所占的宽度比titleScrollView的可视区域宽度小，计算出来realInterTitleItemSpacing */
    CGFloat diff = CGRectGetWidth(_titleScrollView.frame) - _titleScrollView.contentInset.left - _titleScrollView.contentInset.right - totalWidth;
    if (diff > 0)
    {
        realInterTitleItemSpacing = diff / ([self.childViewControllers count] + 1);
        self.titleScrollView.scrollEnabled = NO;
    }
    else
    {
        self.titleScrollView.scrollEnabled = YES;
    }
    
    // 根据显示模式确定title的实际开始位置以及用于渲染时title之间的真实间距
    /*
    if (MRSegmentedTitleViewAlignmentCenter == _titleViewAligment)
    {
        if (diff > 0)
        {
            startX = _titleScrollView.contentInset.left + realInterTitleItemSpacing;
        }
    }
    */
    NSUInteger itemCount = self.childViewControllers.count;
    
    for (NSInteger pIndex = 0; pIndex < itemCount; ++pIndex)
    {
        UIViewController *childVC = [self.childViewControllers objectAtIndex:pIndex];
        CGSize itemSize = [[titleSizeArray objectAtIndex:pIndex] CGSizeValue];
        
        UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, 0, itemSize.width, CGRectGetHeight(self.titleScrollView.frame) - CGRectGetHeight(self.lineView.frame))];
        if (_selectedIndex == pIndex)
        {
            pLabel.textColor = self.selectedColor;
        }
        else
        {
            pLabel.textColor = self.normalColor;
        }
        
        pLabel.userInteractionEnabled = YES;
        pLabel.font = self.normalFont;
        pLabel.text = childVC.title;
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.tag = pIndex;
        pLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleSelected:)];
        [pLabel addGestureRecognizer:tap];
        
        [_titleScrollView addSubview:pLabel];
        [self.titleLabels addObject:pLabel];
        
        startX += itemSize.width + realInterTitleItemSpacing;
        
        _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(pLabel.frame) + _titleScrollView.contentInset.right, 0);
    }
    
    [titleSizeArray removeAllObjects];
    
    [self.contentCollectionView reloadData];
    
    self.currentIndex = _selectedIndex;
}

- (void)titleSelected:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]
                                       atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                               animated:YES];
}

@end
