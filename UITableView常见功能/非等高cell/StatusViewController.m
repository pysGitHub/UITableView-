//
//  StatusViewController.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/23.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "StatusViewController.h"
#import "ModelCell.h"
#import "Model.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString * cellID = @"modelCell";

@interface StatusViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
}



-(UITableView *)tableView{
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
        // 注册重用标识
        [tableView registerClass:[ModelCell class] forCellReuseIdentifier:cellID];
        _tableView = tableView;
        
    }
    return _tableView;
}



-(NSArray *)dataArray{
    if (!_dataArray) {
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"newsData" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            Model * statusModel = [Model modelWithDic:dic];
            [tempArray addObject:statusModel];
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
    ModelCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return [self.tableView fd_heightForCellWithIdentifier:cellID cacheByIndexPath:indexPath configuration:^(id cell) {
            ModelCell *modelCell = (ModelCell *)cell;
            modelCell.model = self.dataArray[indexPath.row];
        }];
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
