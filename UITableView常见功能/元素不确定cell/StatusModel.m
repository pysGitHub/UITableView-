//
//  StatusModel.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/23.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel

+ (instancetype)statusWithDic:(NSDictionary *)dic{
    StatusModel * statusModel = [[self alloc] init];
    [statusModel setValuesForKeysWithDictionary:dic];
    return statusModel;
}

@end
