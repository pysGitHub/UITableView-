//
//  MoreBtnModel.h
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/29.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreBtnModel : NSObject
/** 内容 */
@property (nonatomic,copy)NSString * content;
/** 图片 */
@property (nonatomic,copy)NSString * icon;


+ (instancetype)moreBtnModelWithDic:(NSDictionary *)dic;

@end
