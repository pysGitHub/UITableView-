//
//  TwoCascades.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/8.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "TwoCascades.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height


@interface TwoCascades ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * leftArray;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UITableView * leftTableView;
@property (nonatomic,strong)UITableView * rightTableView;
/** 当前正在点击滑动中 */
@property(nonatomic,assign)BOOL clickScrolling;

@end

@implementation TwoCascades

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.clickScrolling = NO;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}




- (NSArray *)leftArray{
    
    if (!_leftArray) {
        NSArray * array = @[@"萝卜",@"黄瓜",@"西瓜",@"番茄",@"西红柿",@"鸡蛋",@"鸭蛋",@"鹅蛋",@"猪肉",@"肌肉",@"鸡肉"];
        _leftArray = array;
    }
    return  _leftArray;
}



- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray * array = @[@"萝卜",@"黄瓜",@"西瓜",@"番茄",@"西红柿",@"鸡蛋",@"鸭蛋",@"鹅蛋",@"猪肉",@"肌肉",@"鸡肉"];
        
        NSArray * array1 = @[@"黄",@"红",@"绿",@"青",@"紫",@"白",@"黑",@"粉",@"灰",@"棕",@"橙"];
        
        for (NSString * name in array) {
            NSMutableArray * addArray = [NSMutableArray array];
            for (NSString * head in array1) {
                NSString * text = [NSString stringWithFormat:@"%@%@",head,name];
                [addArray addObject:text];
            }
            [_dataArray addObject:addArray];
        }
        
    }
    return _dataArray;
}



- (UITableView *)leftTableView{
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH*0.3, HEIGHT) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        // tableView的基本设置
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleBlue;
        _leftTableView.separatorColor = [UIColor lightGrayColor];
        // 设置分割线的样式及颜色
        [_leftTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        // 去除UITableView底部多余行及分割线
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    
    return _leftTableView;
}



- (UITableView *)rightTableView{
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH*0.3, 0, WIDTH*0.7, HEIGHT) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        // tableView的基本设置
        _rightTableView.separatorStyle = UITableViewCellSelectionStyleBlue;
        _rightTableView.separatorColor = [UIColor lightGrayColor];
        // 设置分割线的样式及颜色
        [_rightTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        // 去除UITableView底部多余行及分割线
        _rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    
    return _rightTableView;
}




#pragma 协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.leftArray.count;
    }else{
        NSArray * subArray = self.dataArray[section];
        return subArray.count;
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        return self.leftArray[section];
    }else{
        return nil;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        return 50;
    }else{
        return 0;
    }
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        static NSString * leftID = @"leftCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
        }
        cell.textLabel.text = self.leftArray[indexPath.row];
        
        //cell .selectionStyle  = UITableViewCellSelectionStyleNone;

        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
        
        return cell;
    }else{
        
        static NSString * rightID = @"rightCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:rightID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
        }
        cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
        return cell;
    }
}




#pragma 核心=====

// 点击rightTableView，leftTableView滑到对应的session位置

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.clickScrolling) {
        return;
    }
    for (int i = 0; i < self.leftArray.count; i++) {
        
        NSArray * array = self.dataArray[i];
        NSIndexPath * index = [NSIndexPath indexPathForRow:array.count - 2 inSection:i];
        NSLog(@" index = %@",index);
        // 返回rightTableView中指定indexPath对应的cell
        //  [self.rightTableView cellForRowAtIndexPath:index]
        
        if ([self.rightTableView cellForRowAtIndexPath:index]) {
            NSIndexPath * index1 = [NSIndexPath indexPathForRow:i inSection:0];
            NSLog(@" index1 **** %@",index1);
            [_leftTableView selectRowAtIndexPath:index1 animated:YES scrollPosition:UITableViewScrollPositionNone];
            break;
        };
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选中 左侧 的 tableView
    if (tableView == self.leftTableView) {
        self.clickScrolling = YES;
        
        /* 获取lefetTableView点击的是哪一行，返回的索引是rightTableView对应的区的0行。
         例如: 点击 lefetTableView的第3行，那么rightTableView就移动到第3区0行的位置
         */
        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        NSLog(@"index = %@",index);
        
        //  控制rightTableView滚动到指定indexPath对应的cell的顶端 (中间 或者下方)
        [self.rightTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.clickScrolling = NO;
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
