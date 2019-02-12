//
//  Model.h
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/24.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
/** 文本内容 */
@property (nonatomic,copy)NSString * desc;
/** 号码 */
@property (nonatomic,copy)NSString * pubdate;

//字典转模型
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
