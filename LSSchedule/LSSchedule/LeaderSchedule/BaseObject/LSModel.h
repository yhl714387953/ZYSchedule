//
//  LSModel.h
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "GYDataCenter.h"
#import "LSRequest.h"

@interface EPage : NSObject

/** 总数 */
@property (nonatomic) NSInteger countSize;

/** 页数 */
@property (nonatomic) NSInteger pageCount;

/** 索引 */
@property (nonatomic) NSInteger pageIndex;

/** 分页大小 */
@property (nonatomic) NSInteger pageSize;


/**
 解析page对象
 
 @param pageInfo page字典
 @return page对象
 */
+(EPage*)parserPage:(NSDictionary*)pageInfo;

@end

@interface LSModel : GYModelObject


/**
 get请求
 
 @param url url后半部分路径即可，内部拼接
 @param params 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+(void)asyncGetUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 post请求
 
 @param url url后半部分路径即可，内部拼接
 @param params 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+(void)asyncPostUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;

/**
 put请求
 
 @param url url后半部分路径即可，内部拼接
 @param params 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+(void)asyncPutUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;

/**
 delete请求
 
 @param url url后半部分路径即可，内部拼接
 @param params 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+(void)asyncDeleteUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;



/**
 获取对象的所有属性，不包括父类的

 @return 属性值
 */
- (NSArray *)getAllProperties;


/**
 获取对象的所有属性 以及属性值 不包括父类的  如果值为空，就忽略掉这个字段

 @return keys-values
 */
- (NSDictionary *)getAllPropertyKeyValues;

@end
