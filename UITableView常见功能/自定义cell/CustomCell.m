//
//  CustomCell.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/2.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "CustomCell.h"
#import "StudentModel.h"
#import "StudentCell.h"
#define WIDH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height

@interface CustomCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation CustomCell

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    
}



- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    // 设置tabelView的一些属性
    
    // 设置分割线的样式及颜色
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor lightGrayColor];
    // 分割线左对齐
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    
    // 去除UITableView底部多余行及分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}



-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        //创建男同学的数组
        NSMutableArray *boyArray = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            
            NSString *name = [NSString stringWithFormat:@"第%d个男同学",i];
            
            //创建学生类型的对象
            StudentModel *sModel = [[StudentModel alloc] init];
            sModel.name = name;
            sModel.age = 20+arc4random()%10;
            
            [boyArray addObject:sModel];
        }
        
        [_dataArray addObject:boyArray];
        
        
        //创建女同学的数组
        NSMutableArray *girlArray = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            
            NSString *name = [NSString stringWithFormat:@"第%d个女同学",i];
            
            //创建学生对象
            StudentModel *model = [[StudentModel alloc] init];
            model.name = name;
            model.age = 18+arc4random()%10;
            [girlArray addObject:model];
        }
        
        [_dataArray addObject:girlArray];
    }
    return _dataArray;
}



#pragma 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"    男生";
    }else{
        return @"    女生";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * ID = @"myCell";
    StudentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[StudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSArray * array = self.dataArray[indexPath.section];
    cell.student = array[indexPath.row];
    
    return cell;
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
