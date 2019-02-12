//
//  StatusModel.h
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/23.
//  Copyright © 2018年 Wistron. All rights reserved.
//

/*
 *<UIKit/UIKit.h>框架已经包含了<Foundation/Foundation.h>框架
 */
#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@interface StatusModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *picture;
@property (assign, nonatomic) BOOL vip;
@property (copy, nonatomic) NSString *foldStr;

/** 是否展开 */
@property (nonatomic, assign) BOOL isOpening;
/** 将每个cell的高度作为模型的一个属性在给模型对cell赋值的时候强制算出来，然后再传给cell */
@property (nonatomic,assign)CGFloat  height;
+(instancetype)statusWithDic:(NSDictionary *)dic;

@end
