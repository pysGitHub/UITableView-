//
//  MoreBtnModel.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/29.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MoreBtnModel.h"

@implementation MoreBtnModel

+ (instancetype)moreBtnModelWithDic:(NSDictionary *)dic{
    MoreBtnModel * model = [[self alloc] init];
    
    model.content = dic[@"content"];
    model.icon = dic[@"icon"];
    return model;
}

@end
