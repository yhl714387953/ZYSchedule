//
//  LSRequest.h
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "AFNetworking.h"
#import "LSMacro.h"

/** 网络请求BaseURL */
extern NSString *kLSBaseURL;

/** 临时手机号码 */
extern NSString *kLSTempPhoneNumber;

typedef NS_ENUM(NSInteger, ERequestState) {
    
    /** 普通错误状态，可直接抛出错误信息 */
    ERequestStateDefaultError = 0,
    
    /** 成功 */
    ERequestStateSuccess,
    
    /** 没有网络 */
    ERequestStateNotReachable,
    
    /** 服务器错误 */
    ERequestStateServeError,
    
    /** 用户参数输入错误(预留) */
    ERequestStateParamError
};

@interface EFile : NSObject

/** 类似于ID */
@property (nonatomic, copy) NSString* name;

/** 文件名字 */
@property (nonatomic, copy) NSString* fileName;

/** 文件路径 当fileData 不存在的时候， 会从这个路径读取data*/
@property (nonatomic, copy) NSString* filePath;

/** 文件data */
@property (nonatomic, strong) NSData* fileData;

/** 文件类型 */
@property (nonatomic, copy) NSString* mimeType;

@end



@interface LSRequest : AFHTTPSessionManager

+(instancetype)sharedManager;

/**
 网络监听，如果调用过一次之后，会实时改变isNetavailable 属性

 @param netChangeBlock 网络变化回调
 */
+ (void)checkNetworkStatus:(void(^)(AFNetworkReachabilityStatus status))netChangeBlock;


/** 是否有网络 */
@property (nonatomic) BOOL isNetavailable;

/**
 GET请求
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param params 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)getRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;

/**
 POST请求
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param params 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)postRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;

/**
 PUT请求
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param params 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)putRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;

/**
 DELETE请求
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param params 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)deleteRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 上传NSData 类型数据
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param params 参数
 @param datas data数组
 @param progress 上传进度
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+(void)postDatasRequest:(NSString*)url params:(NSDictionary*)params datas:(NSArray<EFile*>*)datas progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;

/**
 上传data
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param data data
 @param progress 进度
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)uploadRequest:(NSString *)url data:(NSData *)data
             progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress
         successBlock:(void(^)(id body))successBlock
         failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 上传文件
 
 @param url url路径，只有后半部分，前半部分内部拼接
 @param filePath 文件路径
 @param progress 进度
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)uploadRequest:(NSString *)url filePath:(NSString *)filePath
             progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress
         successBlock:(void(^)(id body))successBlock
         failureBlock:(void(^)(id msg, ERequestState state))failureBlock;



/**
 下载文件
 
 @param url url全路径路径
 @param tarPath 目标路径
 @param progress 进度
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)downloadRequest:(NSString *)url
             targetPath:(NSString*)tarPath
               progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress
           successBlock:(void(^)(id body))successBlock
           failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 继续完成某个未完成的下载任务
 
 @param resumeData 下载信息
 @param tarPath 目标位置
 @param progress 下载进度
 @param successBlock 成功回调
 @param failureBlock 失败回调用
 */
+ (void)downloadResumeData:(NSData *)resumeData targetPath:(NSString*)tarPath progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 获取当前上传队列
 
 @return 上传队列
 */
+(NSArray<NSURLSessionUploadTask*>*)getUploadQueue;


/**
 获取当前下载队列
 
 @return 下载队列
 */
+(NSArray<NSURLSessionUploadTask*>*)getdownloadQueue;


/**
 取消队列中的某一个请求(上传、下载、普通请求)
 
 @param url 待中断请求的url
 */
+(void)cancelTaskUrl:(NSString*)url;


/**
 取消所有请求，登录或者退出的时候使用
 */
+(void)cancelAllTasks;


@end
