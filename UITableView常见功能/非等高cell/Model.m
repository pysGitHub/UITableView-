//
//  Model.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/24.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (instancetype)modelWithDic:(NSDictionary *)dic{
    Model * model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
