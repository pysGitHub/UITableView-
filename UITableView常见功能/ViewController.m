//
//  ViewController.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/2.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "ViewController.h"
#import "DeleteElement.h"
#import "AddElement.h"
#import "MoveElement.h"
#import "CustomCell.h"
#import "Show_Close.h"
#import "ShowClose.h"
#import "TwoCascades.h"
#import "MoreCellContentVC.h"
#import "StatusViewController.h"
#import "MoreVC.h"
#import "MoreBtnVC.h"
#import "MyMoveCellVC.h"
#import "MGSwipeVC.h"





#define KUANG 100
#define GAO 44
#define COL 3
#define MARGIN 20
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height



@interface ViewController ()

@property (nonatomic,strong)NSArray * array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"TAbleView常用功能";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
    [self createButton];
}



- (void)createButton{
    _array = [NSArray arrayWithObjects:@"删除",@"增加",@"移动组元素",@"自定义cell",@"cell展开闭合1",@"cell展开闭合2",@"二级联动",@"cell显示更多",@"非等高cell",@"元素不确定cell",@"侧滑有多个btn",@"自cell移动",@"第三方侧滑",nil];
    
    
    
    CGFloat W = 120;
    CGFloat H = 50;
    //每行列数
    NSInteger rank = 3;
    //每列间距
    CGFloat rankMargin = (self.view.frame.size.width - rank * W) / (rank + 1);
    //每行间距
    CGFloat rowMargin = 30;

    NSUInteger index = _array.count;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin) + rankMargin;
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 100;
        UIButton * btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor orangeColor];
        btn.frame = CGRectMake(X, Y+top, W, H);
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setTitle:_array[i] forState:UIControlStateNormal];
    
    }
    
}




- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        DeleteElement * delete = [[DeleteElement alloc] init];
        [self.navigationController pushViewController:delete animated:YES];
    }else if (btn.tag ==1){
        AddElement * add = [[AddElement alloc] init];
        [self.navigationController pushViewController:add animated:YES];
    }else if (btn.tag ==2){
        MoveElement * move = [[MoveElement alloc] init];
        [self.navigationController pushViewController:move animated:YES];
    }else if (btn.tag ==3){
        CustomCell * custonCell = [[CustomCell alloc] init];
        [self.navigationController pushViewController:custonCell animated:YES];
    }else if (btn.tag ==4){
        Show_Close * showClose = [[Show_Close alloc] init];
        [self.navigationController pushViewController:showClose animated:YES];
    }else if (btn.tag == 5){
        ShowClose * showClose = [[ShowClose alloc] init];
        [self.navigationController pushViewController:showClose animated:YES];
    }else if (btn.tag == 6){
        TwoCascades * cascades = [[TwoCascades alloc] init];
        [self.navigationController pushViewController:cascades animated:YES];
    }else if (btn.tag == 7){
        MoreCellContentVC * moreContentCell = [[MoreCellContentVC alloc] init];
        [self.navigationController pushViewController:moreContentCell animated:YES];
    }else if (btn.tag == 8){
        StatusViewController * statusVC = [[StatusViewController alloc] init];
        [self.navigationController pushViewController:statusVC animated:YES];
    }else if (btn.tag == 9){
        MoreVC * moreVc = [[MoreVC alloc] init];
        [self.navigationController pushViewController:moreVc animated:YES];
    }else if (btn.tag == 10){
        MoreBtnVC * moreBtnVc = [[MoreBtnVC alloc] init];
        [self.navigationController pushViewController:moreBtnVc animated:YES];
    }else if (btn.tag == 11){
        MyMoveCellVC * mymoveCellVc = [[MyMoveCellVC alloc] init];
        [self.navigationController pushViewController:mymoveCellVc animated:YES];
    }else if (btn.tag == 12){
        MGSwipeVC * mgVC = [[MGSwipeVC alloc] init];
        [self.navigationController pushViewController:mgVC animated:YES];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
