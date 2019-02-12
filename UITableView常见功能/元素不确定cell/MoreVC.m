//
//  MoreVC.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/24.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MoreVC.h"
#import "StatusCell.h"
#import "StatusModel.h"


#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString * cellID = @"statusCell";


@interface MoreVC ()<UITableViewDelegate,UITableViewDataSource,StatusCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;
@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
   
    [self.view addSubview:self.tableView];
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 设置分割线的样式及颜色
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor lightGrayColor];
        // 分割线左对齐
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        // 去除UITableView底部多余行及分割线
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // 注册重用标识
        [_tableView registerClass:[StatusCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        // 加载plist中的字典数组
        NSString *path = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        // 字典数组 -> 模型数组
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            StatusModel * status = [StatusModel statusWithDic:dict];
            [tempArray addObject:status];
        }
        _dataArray = tempArray;
    }
    return _dataArray;
}



#pragma mark ---- tableview的协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellDelegate = self;
    cell.statusModel = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StatusModel * statusModel = self.dataArray[indexPath.row];
    return statusModel.height;
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
   
}




-(void)clickFoldLabel:(StatusCell *)cell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    StatusModel *model = self.dataArray[indexPath.row];
    
    model.isOpening = !model.isOpening;
    [UIView animateWithDuration:0.01 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
