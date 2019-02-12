//
//  MGSwipeVC.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/30.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MGSwipeVC.h"
#import "SwipeModel.h"
#import "SwipeTableCell.h"

static NSString * cellID = @"cell";

@interface MGSwipeVC() <UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
/** 记录是否是同一个索引 */
@property (nonatomic,strong)NSIndexPath * index;

@end

@implementation MGSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}


- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        UITableView * tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // 设置分割线对齐
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 去除UITableView底部多余行及分割线
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView = tableView;
    }
    return _tableView;
}



- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"newsData" ofType:@"json"];
        NSData * data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSArray * tempArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray * modelArray = [NSMutableArray array];
        for (NSDictionary * dic in tempArray) {
            SwipeModel * model = [SwipeModel modelWithDic:dic];
            [modelArray addObject:model];
        }
        _dataSource = modelArray;
    }
    return _dataSource;
}








#pragma mark === tableView协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwipeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    
    // 取消cell选中变灰
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark ==== MGSwipe


//- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point{
//    return YES;
//}



-(NSArray *) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
              swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings{
    
//    expansionSettings.fillOnTrigger = YES;
//    expansionSettings.threshold = 20;
    
    if (direction ==MGSwipeDirectionLeftToRight) {
        
        // 获取所在行的索引
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        
        MGSwipeButton * deleteBtn = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            
            [self deleteMethod:indexPath];
            return YES;
            
        }];
        
        
        MGSwipeButton * collectionBtn = [MGSwipeButton buttonWithTitle:@"收藏" backgroundColor:[UIColor blueColor] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            
            [self collectionMethod:indexPath];
            return NO;
        }];
        
        
        return @[deleteBtn,collectionBtn];
    }else{
        
        // 获取所在行的索引
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        
        MGSwipeButton * moreBtn = [MGSwipeButton buttonWithTitle:@"更多" backgroundColor:[UIColor purpleColor] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            
            [self moreMethod:indexPath];
            
            return NO;
        }];
    
        return @[moreBtn];
    }
    
}



- (void)deleteMethod:(NSIndexPath *)indexPath{
    SwipeModel * model = self.dataSource[indexPath.row];
    [self.dataSource removeObject:model];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}



- (void)collectionMethod:(NSIndexPath *)indexPath{
    SwipeModel * model = self.dataSource[indexPath.row];
    if (model.collection) {
        model.collection = NO;
    }else{
        model.collection =YES;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}



- (void)moreMethod:(NSIndexPath *)indexPath{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"更多选择" message:@"你咬我啊" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"置顶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SwipeModel * model = self.dataSource[indexPath.row];
        [self.dataSource removeObject:model];
        [self.dataSource insertObject:model atIndex:0];
        [self.tableView reloadData];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
