//
//  AddElement.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/2.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "AddElement.h"
#import "StudentModel.h"
@interface AddElement ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation AddElement

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    [self createTableView];
    [self createDeleteBtn];
   
    
}


//创建数据源
- (void)prepareData
{
    _dataArray = [NSMutableArray arrayWithCapacity:2];
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





- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 设置分割线的样式及颜色
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    // 分割线左对齐
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    
    // 去除UITableView底部多余行及分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}




#pragma 实现协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *subArray = _dataArray[section];
    return subArray.count;
}


//每组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"男同学";
    }else if(section == 1){
        return @"女同学";
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    //取到当前组的当前行对应的学生类型对象
    NSArray * array = _dataArray[indexPath.section];
    StudentModel *curModel = array[indexPath.row];
    
    cell.textLabel.text = curModel.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"年龄:%ld",(long)curModel.age];
    return cell;
}



//创建编辑按钮
- (void)createDeleteBtn
{
    //编辑按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)editTableView:(id)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else{
        self.tableView.editing = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
}

/*
 
 1.tableView 进入编辑状态
     [self.tableView setEditing:YES animated:YES];
 2.对数据进行添加或者删除
 
 */



# pragma 元素的删除和增加
- (BOOL )tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
// 删除数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 获取该行所在的区数据
        NSMutableArray * array = self.dataArray[indexPath.section];
        // 删除该行数据
        [array removeObjectAtIndex:indexPath.row];
        // 数据刷新
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        // 获取该行所在区的数据
        NSMutableArray * dataArray = self.dataArray[indexPath.section];
        // 创建新元素
        StudentModel * newData = [[StudentModel alloc]init];
        if (indexPath.section == 0) {
            newData.name = [NSString stringWithFormat:@"我是新来的男%d号",(int)indexPath.row];
        }
        else{
            newData.name = [NSString stringWithFormat:@"我是新来的女%d号",(int)indexPath.row];
        }
        newData.age = 20 + arc4random()%5;
        // 将新元素放入数组
        [dataArray insertObject:newData atIndex:indexPath.row];
        // 刷新数据
        [tableView reloadData];
    }
}

// 判断是删除还是增加
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
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
