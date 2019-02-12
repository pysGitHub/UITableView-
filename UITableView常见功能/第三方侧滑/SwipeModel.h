//
//  SwipeModel.h
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/31.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwipeModel : NSObject

/** 文本内容 */
@property (nonatomic,copy)NSString * desc;
/** 号码 */
@property (nonatomic,copy)NSString * pubdate;
/** 收藏 */
@property (nonatomic,assign)BOOL collection;
//字典转模型
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
