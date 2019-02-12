//
//  MoreCellContentVC.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/21.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MoreCellContentVC.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *NewsCellIdentifier = @"newsCellIdentifier";


@interface MoreCellContentVC ()<UITableViewDelegate,UITableViewDataSource,NewsCellCellDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * newsDataArray;
@end

@implementation MoreCellContentVC


/*
 *懒加载
*/

-(UITableView *)newsTableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 设置分割线的样式及颜色
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor lightGrayColor];
        // 分割线左对齐
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        
        // 去除UITableView底部多余行及分割线
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        /**
         * 使用第三方UITableView+FDTemplateLayoutCell框架cell的重用注册必须使用UITableView 的 -registerClass:forCellReuseIdentifier: 或 -registerNib:forCellReuseIdentifier:其中之一的注册方法。
         */
        
        
        
        [_tableView registerClass:[NewsCell class] forCellReuseIdentifier:NewsCellIdentifier];
    }
    return _tableView;
}



- (NSArray *)newsDataArray{
    if (!_newsDataArray) {
        _newsDataArray = [NSMutableArray array];
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"newsData" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        
        NSMutableArray * modelArray = [NSMutableArray array];
        // 字典转模型
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *dic in array) {
            NewsModel * newModel = [NewsModel dealWithDict:dic];
            [modelArray addObject:newModel];
        }
        _newsDataArray = modelArray;
    }
    return _newsDataArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.newsTableView];
    
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if (!newsCell) {
        newsCell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier];
    }
    newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    newsCell.cellDelegate = self;
    
    NewsModel *model = self.newsDataArray[indexPath.row];
    newsCell.newsModel = model;
    
    return newsCell;
}
#pragma mark - 折叠按钮点击代理
/**
 *  折叠按钮点击代理
 *
 *  @param cell 按钮所属cell
 */
-(void)clickFoldLabel:(NewsCell *)cell{
    
    NSIndexPath * indexPath = [self.newsTableView indexPathForCell:cell];
    NewsModel *model = self.newsDataArray[indexPath.row];
    
    model.isOpening = !model.isOpening;
    
    [UIView animateWithDuration:0.01 animations:^{
        [self.newsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.newsDataArray.count > 0)
//    {
//        NewsModel *model = [self.newsDataArray objectAtIndex:indexPath.row];
//        // 动态计算cell高度
//        // 这里使用了forkingdog的框架
//        // https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
//        // UITableView+FDTemplateLayoutCell这个分类牛逼的地方就在于自动计算行高了
//        // 如果我们在没有缓存的情况下，只要你使用了它其实高度的计算不需要我们来管，我们只需要[self.tableView reloadData]就完全足够了
//        // 但是如果有缓存的时候，这个问题就来了，你会发现，点击展开布局会乱，有一部分会看不到，这是因为高度并没有变化，一直用的是缓存的高度，所以解决办法如下
//
//
//        if (model.isOpening) {
//            // 使用不缓存的方式
//            return [self.newsTableView fd_heightForCellWithIdentifier:NewsCellIdentifier configuration:^(id cell) {
//
//                [self handleCellHeightWithNewsCell:cell indexPath:indexPath];
//            }];
//        }else{
//            // 使用缓存的方式
//            return [self.newsTableView fd_heightForCellWithIdentifier:NewsCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
//
//                [self handleCellHeightWithNewsCell:cell indexPath:indexPath];
//            }];
//        }
//    } else{
//
//        return 10;
//    }
    
    // iOS8系统自带的
    return UITableViewAutomaticDimension;
}

/**
 处理cell高度
 */
-(void)handleCellHeightWithNewsCell:(id)cell indexPath:(NSIndexPath *)indexPath{
    NewsCell *newsCell = (NewsCell *)cell;
    newsCell.newsModel = self.newsDataArray[indexPath.row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
