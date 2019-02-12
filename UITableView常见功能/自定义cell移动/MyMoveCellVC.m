//
//  MyMoveCellVC.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/30.
//  Copyright © 2018年 Wistron. All rights reserved.
//


/**
 * 所有的tableView只要继承 RowMoveTableView 就能实现行移动
 */

#import "MyMoveCellVC.h"
#import "RowMoveTableView.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MyMoveCellVC ()<RowMoveTableViewDelegate,RowMoveTableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation MyMoveCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.dataSource = [NSMutableArray new];
    NSArray *sectionTextArray = @[@"我只是一段普通的文本😳",
                                  @"我只是一段可爱的文本😊",
                                  @"我只是一段调皮的文本😜",
                                  @"我只是一段无聊的文本🙈"];
    for (NSInteger section = 0; section < sectionTextArray.count; section ++) {
        NSMutableArray *sectionArray = [NSMutableArray new];
        for (NSInteger row = 0; row < 5; row ++) {
            [sectionArray addObject:[NSString stringWithFormat:@"%@-%ld", sectionTextArray[section], row]];
        }
        [_dataSource addObject:sectionArray];
    }
    
    RowMoveTableView *tableView = [[RowMoveTableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    //tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    // 分割线左对齐
    [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    // 设置分割线的样式及颜色
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor lightGrayColor];
    // 去除UITableView底部多余行及分割线
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    tableView.gestureMinimumPressDuration = 1.0;
    tableView.drawMoveCellBlock = ^(UIView * moveCell){
        moveCell.layer.shadowColor = [UIColor grayColor].CGColor;
        moveCell.layer.masksToBounds = NO;
        moveCell.layer.cornerRadius = 0;
        moveCell.layer.shadowOffset = CGSizeMake(5, 0);
        moveCell.layer.shadowOpacity = 0.4;
        moveCell.layer.shadowRadius = 5;
    };
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return NO;
    }
    
    return YES;
}

- (NSMutableArray *)dataSourceArrayInTableView:(RowMoveTableView *)tableView
{
    return self.dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}



/**
 * 下面4个方法是为了解决在UITableViewStyleGrouped风格下顶部和底部出现多余的空白。其原理是重新设置区头和区尾高度。
 */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section !=self.dataSource.count-1) {
        return 20;
    }
    return CGFLOAT_MIN;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section !=0) {
        return 20;
    }
    return CGFLOAT_MIN;
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
