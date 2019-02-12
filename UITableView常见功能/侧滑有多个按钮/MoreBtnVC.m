//
//  MoreBtnVC.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/29.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MoreBtnVC.h"
#import "MoreBtnModel.h"
#import "MoreBtnCell.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString * cellID = @"modelCell";

@interface MoreBtnVC ()<UITableViewDelegate,UITableViewDataSource>
/** 数据 */
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;
@end

@implementation MoreBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}



- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSMutableArray * array = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"这是一个contentLabel",@"content",@"vip",@"icon",
                                  nil];
            [array addObject:dic];
        }
        
        NSMutableArray * array1 = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            MoreBtnModel * model = [MoreBtnModel moreBtnModelWithDic:dic];
            [array1 addObject:model];
        }
        _dataArray = array1;
    }
    return _dataArray;
}



- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        // 设置分割线的样式及颜色
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor lightGrayColor];
        // 分割线左对齐
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        // 去除UITableView底部多余行及分割线
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _tableView = tableView;
        [_tableView registerClass:[MoreBtnCell class] forCellReuseIdentifier:cellID];
    }
    
    return _tableView;
}











#pragma mark tableView有关的系统协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MoreBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MoreBtnModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}



- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        [self deleteElement:indexPath];
    }];
    // 删除一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        [self moveToTop:indexPath];
    }];
    topRowAction.backgroundColor = [UIColor blueColor];
    
    // 添加一个更多按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了更多");
        
        
    }];
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction, moreRowAction];
}


// 删除
- (void)deleteElement:(NSIndexPath *)indexPath{
    MoreBtnModel * model = self.dataArray[indexPath.row];
    [self.dataArray removeObject:model];
    //[self.tableView reloadData];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}



// 置顶
- (void)moveToTop:(NSIndexPath *)indexPath{
    MoreBtnModel * model = self.dataArray[indexPath.row];
    [self.dataArray removeObject:model];
    [self.dataArray insertObject:model atIndex:0];
    model.content = [NSString stringWithFormat:@"这是第%ld行",(long)indexPath.row];
    //[self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    [self.tableView reloadData];
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
