//
//  NewsModel.m
//  FoldTableViewCellDemo
//
//  Created by Anchoriter on 2018/1/31.
//  Copyright © 2018年 Anchoriter. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)dealWithDict:(NSDictionary *)dict{
    NewsModel * news = [[self alloc] init];
     [news setValuesForKeysWithDictionary:dict];
    return news;
}

@end
