//
//  SwipeModel.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/31.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "SwipeModel.h"

@implementation SwipeModel

+ (instancetype)modelWithDic:(NSDictionary *)dic{
    SwipeModel * model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
