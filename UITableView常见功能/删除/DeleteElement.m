//
//  DeleteElement.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/2.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "DeleteElement.h"
#import "StudentModel.h"
@interface DeleteElement ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * boysDeleteArray;
@property (nonatomic,strong)NSMutableArray * girlsDeleteArray;
@property (nonatomic,strong)UITableView * tableView;


@end

@implementation DeleteElement

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    [self prepareData];
    [self createDeleteBtn];
}



//创建数据源
- (void)prepareData
{
    _dataArray = [NSMutableArray arrayWithCapacity:2];
    _boysDeleteArray = [NSMutableArray array];
    _girlsDeleteArray = [NSMutableArray array];
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



//创建删除按钮
- (void)createDeleteBtn
{
    
    // 多选删除
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(beginDelete:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    // 全选删除
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(allDelete:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}



- (void)beginDelete:(id)sender
{
    
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    
    if ([title isEqualToString:@"删除"]) {
        //进入多行删除的状态
        [self.tableView setEditing:YES];
        
        //把导航右边按钮的文字修改为确认
        self.navigationItem.rightBarButtonItem.title = @"确认";
        
    }else{
        //执行删除的操作
        [_dataArray[0] removeObjectsInArray:_boysDeleteArray];
        [_dataArray[1] removeObjectsInArray:_girlsDeleteArray];
        
        //刷新表格
        [self.tableView reloadData];
        //清空删除数组里面的内容
        [_boysDeleteArray removeAllObjects];
        [_girlsDeleteArray removeAllObjects];
        //退出标记状态
        [self.tableView setEditing:NO];
        
        //修改右边按钮的文字
        self.navigationItem.rightBarButtonItem.title = @"删除";
        
    }
}




- (void)allDelete:(id)sender
{
    
    NSString *title = self.navigationItem.leftBarButtonItem.title;
    
    if ([title isEqualToString:@"全部删除"]) {
        //进入多行删除的状态
        [self.tableView setEditing:YES];
        
        //把导航右边按钮的文字修改为确认
        self.navigationItem.leftBarButtonItem.title = @"确认";
        
    }else{
        NSArray * boysArray = _dataArray[0];
        NSArray * girlsArray = _dataArray[1];
        
        for (int i = 0; i < boysArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_boysDeleteArray addObjectsFromArray:boysArray];
        }
        
        for (int i = 0; i < girlsArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_girlsDeleteArray addObjectsFromArray:girlsArray];
        }
        
        [_dataArray[0] removeObjectsInArray:_boysDeleteArray];
        [_dataArray[1] removeObjectsInArray:_girlsDeleteArray];
        
        
        [_boysDeleteArray removeAllObjects];
        [_girlsDeleteArray removeAllObjects];
        
        //刷新表格
        [self.tableView reloadData];
        //退出标记状态
        [self.tableView setEditing:NO];
        
        //修改右边按钮的文字
        self.navigationItem.leftBarButtonItem.title = @"全部删除";
        
    }
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





//实现多选删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 处于编辑状态时选择多选删除
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{// 处于未编辑状态时选择多选删除
        return UITableViewCellEditingStyleDelete;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.editing == YES) {
        
        // 判断当前选中的是哪一个session
        if (indexPath.section == 0) {
            // 添加要删除的男生数据
            StudentModel * boy = _dataArray[0][indexPath.row];
            if (![_boysDeleteArray containsObject:boy]) {
                [_boysDeleteArray addObject:boy];
            }
            
        }else{
            // 添加要删除的女生数据
            StudentModel * girl = _dataArray[1][indexPath.row];
            if (![_girlsDeleteArray containsObject:girl]) {
                [_girlsDeleteArray addObject:girl];
            }
        }
    }
    NSLog(@"======删除的数据:%@\n%@",_boysDeleteArray,_girlsDeleteArray);
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing == YES) {
        
        
        // 判断当前选中的是哪一个session
        if (indexPath.section == 0) {
            // 取消要删除的男生数据
            StudentModel * boy = _dataArray[0][indexPath.row];
            if ([_boysDeleteArray containsObject:boy]) {
                [_boysDeleteArray removeObject:boy];
            }
            
        }else{
            // 取消要删除的女生数据
            StudentModel * girl = _dataArray[1][indexPath.row];
            if ([_girlsDeleteArray containsObject:girl]) {
                [_girlsDeleteArray removeObject:girl];
            }
        }
    }
    NSLog(@"======取消删除的数据:%@\n%@",_boysDeleteArray,_girlsDeleteArray);
    
}


/*
 侧滑删除


 1、设置cell可编辑
 2、设置编辑格式
 3、设置编辑按钮的文字标题
 4、删除数据

 */

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableArray *subArray = _dataArray[indexPath.section];
        [subArray removeObjectAtIndex:indexPath.row];

        //刷新表格视图
        //[tableView reloadData];
        //删除一行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

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
