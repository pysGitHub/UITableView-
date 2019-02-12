//
//  MoveElement.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/2.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MoveElement.h"
#import "StudentModel.h"
@interface MoveElement ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation MoveElement

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    [self createTableView];
    [self prepareData];
    [self createMoveBtn];
    
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



//创建行移动按钮
- (void)createMoveBtn
{
    
    // 行移动
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"行移动" style:UIBarButtonItemStylePlain target:self action:@selector(beginMove:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}



- (void)beginMove:(id)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"行移动"]) {
        self.tableView.editing = YES;
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else{
        self.tableView.editing = NO;
        self.navigationItem.rightBarButtonItem.title = @"行移动";
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





#pragma mark - 移动
//返回能否移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}




//移动时候调用
//这个方法必须实现
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    /*
     NSMutableArray *sourceArray = _dataArray[sourceIndexPath.section];
     StudentModel *sourceModel = sourceArray[sourceIndexPath.row];
     [sourceArray removeObject:sourceModel];
     
     NSMutableArray *destArray = _dataArray[destinationIndexPath.section];
     
     [destArray addObject:sourceModel];
     */
    
    //修改数据里面的内容
    NSMutableArray *array = _dataArray[sourceIndexPath.section];
    
    [array exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}


////返回交换的位置
////sourceIndexPath需要交换的位置
////proposedDestinationIndexPath将要交换到的位置
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        //如果在不同的section中，不允许交换
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
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
