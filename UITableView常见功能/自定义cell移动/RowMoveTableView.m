//
//  RowMoveTableView.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/31.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "RowMoveTableView.h"

static NSTimeInterval kPanMovableCellAnimationTime = 0.25;


@interface RowMoveTableView()

/** cell的长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *gesture;
/** 选中cell的索引 */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
/** 选中cell的截图 */
@property (nonatomic, strong) UIView *tempView;
/** 临时的数据源 */
@property (nonatomic, strong) NSMutableArray *tempDataSource;
/** CADisplayLink是用于同步屏幕刷新频率的计时器 */
@property (nonatomic, strong) CADisplayLink *edgeScrollTimer;

@end




@implementation RowMoveTableView

@dynamic dataSource, delegate;


- (void)dealloc
{
    self.drawMoveCellBlock = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initData];
        [self addGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
        [self addGesture];
    }
    return self;
}

- (void)initData
{
    self.gestureMinimumPressDuration = 1.0f;
    self.canEdgeScroll = YES;
    self.edgeScrollRange = 150.f;
}

#pragma mark Setter

- (void)setGestureMinimumPressDuration:(CGFloat)gestureMinimumPressDuration
{
    _gestureMinimumPressDuration = gestureMinimumPressDuration;
    _gesture.minimumPressDuration = MAX(0.2, gestureMinimumPressDuration);
}

#pragma mark Gesture

- (void)addGesture
{
    self.gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(processGesture:)];
    self.gesture.minimumPressDuration = self.gestureMinimumPressDuration;
    [self addGestureRecognizer:self.gesture];
}

- (void)processGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self gestureBegan:gesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (!self.canEdgeScroll) {
                [self gestureChanged:gesture];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self gestureEndedOrCancelled:gesture];
        }
            break;
        default:
            break;
    }
}

- (void)gestureBegan:(UILongPressGestureRecognizer *)gesture
{
    //locationInView:获取到的是手指点击屏幕实时的坐标点；
    CGPoint point = [gesture locationInView:gesture.view];
    //获取某个点在tableView中的位置信息
    NSIndexPath *selectedIndexPath = [self indexPathForRowAtPoint:point];
    if (!selectedIndexPath) {
        return;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        if (![self.dataSource tableView:self canMoveRowAtIndexPath:selectedIndexPath]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:tryMoveUnmovableCellAtIndexPath:)]) {
                [self.delegate tableView:self tryMoveUnmovableCellAtIndexPath:selectedIndexPath];
            }
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:willMoveCellAtIndexPath:)]) {
        [self.delegate tableView:self willMoveCellAtIndexPath:selectedIndexPath];
    }
    if (self.canEdgeScroll) {
        //开启边缘滚动
        [self startEdgeScroll];
    }
    //每次移动开始获取一次数据源
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataSourceArrayInTableView:)]) {
        self.tempDataSource = [self.dataSource dataSourceArrayInTableView:self];
    }
    self.selectedIndexPath = selectedIndexPath;
    UITableViewCell *cell = [self cellForRowAtIndexPath:selectedIndexPath];
    self.tempView = [self snapshotViewWithInputView:cell];
    if (self.drawMoveCellBlock) {
        //将self.tempView通过block让使用者自定义
        self.drawMoveCellBlock(self.tempView);
    }else {
        //配置默认样式
        self.tempView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.tempView.layer.masksToBounds = NO;
        self.tempView.layer.cornerRadius = 0;
        self.tempView.layer.shadowOffset = CGSizeMake(-5, 0);
        self.tempView.layer.shadowOpacity = 0.4;
        self.tempView.layer.shadowRadius = 5;
    }
    self.tempView.frame = cell.frame;
    [self addSubview:self.tempView];
    //隐藏cell
    cell.hidden = YES;
    [UIView animateWithDuration:kPanMovableCellAnimationTime animations:^{
        self.tempView.center = CGPointMake(self.tempView.center.x, point.y);
    }];
}

- (void)gestureChanged:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    NSIndexPath *currentIndexPath = [self indexPathForRowAtPoint:point];
    //让截图跟随手势
    self.tempView.center = CGPointMake(self.tempView.center.x, [self tempViewYToFitTargetY:point.y]);
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        if (![self.dataSource tableView:self canMoveRowAtIndexPath:currentIndexPath]) {
            return;
        }
    }
    
    if (currentIndexPath && ![self.selectedIndexPath isEqual:currentIndexPath]) {
        //交换数据源和cell
        [self updateDataSourceAndCellFromIndexPath:self.selectedIndexPath toIndexPath:currentIndexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didMoveCellFromIndexPath:toIndexPath:)]) {
            [self.delegate tableView:self didMoveCellFromIndexPath:self.selectedIndexPath toIndexPath:currentIndexPath];
        }
        self.selectedIndexPath = currentIndexPath;
    }
}

- (void)gestureEndedOrCancelled:(UILongPressGestureRecognizer *)gesture
{
    if (self.canEdgeScroll) {
        [self stopEdgeScroll];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:endMoveCellAtIndexPath:)]) {
        [self.delegate tableView:self endMoveCellAtIndexPath:self.selectedIndexPath];
    }
    UITableViewCell *cell = [self cellForRowAtIndexPath:self.selectedIndexPath];
    [UIView animateWithDuration:kPanMovableCellAnimationTime animations:^{
        self.tempView.frame = cell.frame;
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [self.tempView removeFromSuperview];
        self.tempView = nil;
    }];
}

#pragma mark Private action

- (UIView *)snapshotViewWithInputView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

- (void)updateDataSourceAndCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self numberOfSections] == 1) {
        //只有一组
        [self.tempDataSource[fromIndexPath.section] exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        //交换cell
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }else {
        //有多组
        id fromData = self.tempDataSource[fromIndexPath.section][fromIndexPath.row];
        id toData = self.tempDataSource[toIndexPath.section][toIndexPath.row];
        NSMutableArray *fromArray = self.tempDataSource[fromIndexPath.section];
        NSMutableArray *toArray = self.tempDataSource[toIndexPath.section];
        [fromArray replaceObjectAtIndex:fromIndexPath.row withObject:toData];
        [toArray replaceObjectAtIndex:toIndexPath.row withObject:fromData];
        [self.tempDataSource replaceObjectAtIndex:toIndexPath.section withObject:toArray];
        //交换cell
        [self beginUpdates];
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        [self moveRowAtIndexPath:toIndexPath toIndexPath:fromIndexPath];
        [self endUpdates];
    }
}

- (CGFloat)tempViewYToFitTargetY:(CGFloat)targetY
{
    CGFloat minValue = self.tempView.bounds.size.height/2.0;
    CGFloat maxValue = self.contentSize.height - minValue;
    return MIN(maxValue, MAX(minValue, targetY));
}

#pragma mark EdgeScroll

//开启边缘滚动
- (void)startEdgeScroll
{
    self.edgeScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(processEdgeScroll)];
    //每次屏幕刷新时,计时器的方法都会被触发.
    [self.edgeScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)processEdgeScroll
{
    [self gestureChanged:self.gesture];
    CGFloat minOffsetY = self.contentOffset.y + self.edgeScrollRange;
    CGFloat maxOffsetY = self.contentOffset.y + self.bounds.size.height - self.edgeScrollRange;
    CGPoint touchPoint = self.tempView.center;
    //处理上下达到极限之后不再滚动tableView，其中处理了滚动到最边缘的时候，当前处于edgeScrollRange内，但是tableView还未显示完，需要显示完tableView才停止滚动
    if (touchPoint.y < self.edgeScrollRange) {
        if (self.contentOffset.y <= 0) {
            return;
        }else {
            if (self.contentOffset.y - 1 < 0) {
                return;
            }
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - 1) animated:NO];
            self.tempView.center = CGPointMake(self.tempView.center.x, [self tempViewYToFitTargetY:self.tempView.center.y - 1]);
        }
    }
    if (touchPoint.y > self.contentSize.height - self.edgeScrollRange) {
        if (self.contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
            return;
        }else {
            if (self.contentOffset.y + 1 > self.contentSize.height - self.bounds.size.height) {
                return;
            }
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + 1) animated:NO];
            self.tempView.center = CGPointMake(self.tempView.center.x, [self tempViewYToFitTargetY:self.tempView.center.y + 1]);
        }
    }
    //处理滚动
    CGFloat maxMoveDistance = 20;
    if (touchPoint.y < minOffsetY) {
        //cell在往上移动
        CGFloat moveDistance = (minOffsetY - touchPoint.y)/self.edgeScrollRange*maxMoveDistance;
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - moveDistance) animated:NO];
        self.tempView.center = CGPointMake(self.tempView.center.x, [self tempViewYToFitTargetY:self.tempView.center.y - moveDistance]);
    }else if (touchPoint.y > maxOffsetY) {
        //cell在往下移动
        CGFloat moveDistance = (touchPoint.y - maxOffsetY)/self.edgeScrollRange*maxMoveDistance;
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + moveDistance) animated:NO];
        self.tempView.center = CGPointMake(self.tempView.center.x, [self tempViewYToFitTargetY:self.tempView.center.y + moveDistance]);
    }
}

- (void)stopEdgeScroll
{
    if (self.edgeScrollTimer) {
        [self.edgeScrollTimer invalidate];
        self.edgeScrollTimer = nil;
    }
}


@end
