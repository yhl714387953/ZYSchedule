//
//  LSRequest.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSRequest.h"
#import <Foundation/Foundation.h>

@implementation EFile

@end

/** 临时手机号码 */
NSString *kLSTempPhoneNumber = @"";
/** 网络请求BaseURL */
NSString *kLSBaseURL = @"";

@implementation LSRequest
+(instancetype)sharedManager{
    static LSRequest* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self getSessionRequstManager];
    });
    
    return sharedInstance;
}

+ (void)getRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock
{
    BOOL isNetavailable = [self handleNetStatusFailureBlock:failureBlock];
    
    if (!isNetavailable) {
        return;
    }
    
    //接完整的url
    NSString* fullURL = [self requestUrl:url];
    
    //请求的参数
    NSDictionary* requestParams = [self params:params];
    
    [[LSRequest sharedManager] GET:fullURL parameters:requestParams progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResObj:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error failureBlock:failureBlock];
    }];
}

+ (void)postRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock
{
    BOOL isNetavailable = [self handleNetStatusFailureBlock:failureBlock];
    
    if (!isNetavailable) {
        return;
    }
    
    //接完整的url
    NSString* fullURL = [self requestUrl:url];
    //请求的参数
    NSDictionary* requestParams = [self params:params];
    
    [[LSRequest sharedManager] POST:fullURL parameters:requestParams progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResObj:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error failureBlock:failureBlock];
    }];
    
}

+ (void)putRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock
{
    BOOL isNetavailable = [self handleNetStatusFailureBlock:failureBlock];
    
    if (!isNetavailable) {
        return;
    }
    
    //接完整的url
    NSString* fullURL = [self requestUrl:url];
    //请求的参数
    NSDictionary* requestParams = [self params:params];
    
    [[LSRequest sharedManager] PUT:fullURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResObj:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error failureBlock:failureBlock];
    }];
}

+ (void)deleteRequest:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock
{
    BOOL isNetavailable = [self handleNetStatusFailureBlock:failureBlock];
    
    if (!isNetavailable) {
        return;
    }
    
    //接完整的url
    NSString* fullURL = [self requestUrl:url];
    //请求的参数
    NSDictionary* requestParams = [self params:params];
    
    [[LSRequest sharedManager] DELETE:fullURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResObj:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error failureBlock:failureBlock];
    }];
}

+ (LSRequest *)getSessionRequstManager {
    
    LSRequest *manager = [LSRequest manager];
    // 请求超时设定
    manager.requestSerializer.timeoutInterval = 30;
    
    /*
     NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     LSRequest* manager = [[LSRequest alloc] initWithSessionConfiguration:configuration];
     manager.requestSerializer.timeoutInterval = 30;
     */
    
    //声明请求的数据是json类型
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    @"application/json", @"text/json", @"text/javascript"
//    [manager.requestSerializer setValue:@"text/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //声明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"manager/html", @"text/plain",nil];
    
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return manager;
}

//上传NSData 类型数据
+(void)postDatasRequest:(NSString*)url params:(NSDictionary*)params datas:(NSArray<EFile*>*)datas progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    [self handleNetStatusFailureBlock:failureBlock];
    
    //接完整的url
    NSString* fullURL = [self requestUrl:url];
    //请求的参数
    NSDictionary* requestParams = [self params:params];
    
    [[LSRequest sharedManager] POST:fullURL parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (EFile* file in datas) {
            //            NSString* fileName = params[@"fileName"] ? : [NSString stringWithFormat:@"%.0lf%d%@", [[NSDate date] timeIntervalSince1970], arc4random() % 9000 + 1000, params[@"fileType"]];
            NSData* data = file.fileData ? : [NSData dataWithContentsOfFile:file.filePath];
            if (data) {
                [formData appendPartWithFileData:data name:file.name fileName:file.fileName mimeType:file.mimeType];
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress) progress(uploadProgress.completedUnitCount , uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResObj:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error failureBlock:failureBlock];
    }];
}

+ (void)uploadRequest:(NSString *)url data:(NSData *)data progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    [self handleNetStatusFailureBlock:failureBlock];
    
    NSURL* upUrl = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:upUrl];
    
    [[LSRequest sharedManager] uploadTaskWithRequest:request fromData:data progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress) progress(uploadProgress.completedUnitCount , uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) successBlock(@"上传成功");
        }else{
            [self handleFailure:error failureBlock:failureBlock];
        }
    }];
    
}

+ (void)uploadRequest:(NSString *)url filePath:(NSString *)filePath progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    [self handleNetStatusFailureBlock:failureBlock];
    
    NSURL* upUrl = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:upUrl];
    
    [[LSRequest sharedManager] uploadTaskWithRequest:request fromFile:upUrl progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress) progress(uploadProgress.completedUnitCount , uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) successBlock(@"上传成功");
        }else{
            [self handleFailure:error failureBlock:failureBlock];
        }
    }];
    
}

+(NSArray<NSURLSessionUploadTask*>*)getUploadQueue{
    
    return [LSRequest sharedManager].uploadTasks;
}


+ (void)downloadRequest:(NSString *)url targetPath:(NSString*)tarPath progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    [self handleNetStatusFailureBlock:failureBlock];
    
    NSURL* downloadUrl = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:downloadUrl];
    
    NSURLSessionDownloadTask *downloadTask = [[LSRequest sharedManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress) progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:tarPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) successBlock(@"下载成功");
        }else{
            [self handleFailure:error failureBlock:failureBlock];
        }
    }];
    
    [downloadTask resume];
}

+ (void)downloadResumeData:(NSData *)resumeData targetPath:(NSString*)tarPath progress:(void(^)(int64_t completedUnitCount, int64_t totalUnitCount))progress successBlock:(void(^)(id body))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    [self handleNetStatusFailureBlock:failureBlock];
    
    NSURLSessionDownloadTask *downloadTask = [[LSRequest sharedManager] downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress) progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:tarPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) successBlock(@"下载成功");
        }else{
            [self handleFailure:error failureBlock:failureBlock];
        }
    }];
    
    [downloadTask resume];
}



+(NSArray<NSURLSessionDownloadTask*>*)getdownloadQueue{
    
    return [LSRequest sharedManager].downloadTasks;
}



#pragma mark -
#pragma mark --监控网络状态
+ (void)checkNetworkStatus:(void(^)(AFNetworkReachabilityStatus status))netChangeBlock{
    
    __block BOOL isNetworkUse = YES;
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (netChangeBlock) {
            netChangeBlock(status);
        }
        
        [LSRequest sharedManager].isNetavailable = YES;
        if (status == AFNetworkReachabilityStatusUnknown) {
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusNotReachable){
            // 网络异常操作
            isNetworkUse = NO;
            NSLog(@"网络异常,请检查网络是否可用！");
            [LSRequest sharedManager].isNetavailable = NO;
        }
    }];
    [reachabilityManager startMonitoring];

}

+(void)cancelTaskUrl:(NSString*)url{
    if (!url || ![url isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSArray<NSURLSessionTask*>* tasks = [LSRequest sharedManager].tasks;
    for (NSURLSessionTask* task in tasks) {
        if ([task.currentRequest.URL.absoluteString containsString:url]) {
            [task cancel];
        }
    }
}

+(void)cancelAllTasks{
    //    [[LSRequest sharedManager].operationQueue cancelAllOperations];
    for (NSURLSessionTask* task in [LSRequest sharedManager].tasks) {
        [task cancel];
    }
}

#pragma mark -
#pragma mark - 处理请求参数
+(NSString*)requestUrl:(NSString*)url{
    
    NSString* fullURL =  [kLSBaseURL stringByAppendingString:url];
    NSLog(@"当前请求url %@", fullURL);
    return fullURL;
}

+(NSDictionary*)params:(NSDictionary *)params{
    NSLog(@"当前请求参数 %@", params);
    
    return params;
}

#pragma mark -
#pragma mark - 回调处理
+(BOOL)handleNetStatusFailureBlock:(void(^)(id info, ERequestState state))failureBlock{
    
    NSLog(@"当前队列已经存在请求数目：%lu", (unsigned long)[LSRequest sharedManager].tasks.count);

    if (![LSRequest sharedManager].isNetavailable) {
        NSLog(@"网络状态不可用");
        failureBlock(@"网络异常", ERequestStateNotReachable);
        return NO;
    }else{
        NSLog(@"网络正常");
        return YES;
    }
}

+(void)handleFailure:(NSError * )error failureBlock:(void(^)(id info, ERequestState state))failureBlock{
    
    NSLog(@"当前请求错误信息 %@", error);
    NSString* errorMessage = error.description;
    
    if (error.code == -1001 || error.code == -1004) {
        errorMessage = error.userInfo[@"NSLocalizedDescription"];
    }else if (error.code < 0 || (error.code <= 600 && error.code >= 400)) {
        errorMessage = @"服务器异常";
    }
    
    if (error.code == -999) {
        errorMessage = nil;
    }
    
    if (failureBlock) {
        failureBlock(errorMessage, ERequestStateServeError);
    }
}

+(void)handleResObj:(id)responseObj successBlock:(void(^)(id data))successBlock failureBlock:(void(^)(id info, ERequestState state))failureBlock{
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        
        NSString* pStr = @"";
        for (id key in [responseObj allKeys]) {
            
            pStr = [pStr stringByAppendingFormat:@"\n       %@：%@", key, responseObj[key]];
        }
        
        NSLog(@"当前请求返回%@", pStr);
        
    }else{
        NSLog(@"当前请求返回 %@", responseObj);
    }
    
    
    
    if(!successBlock) return;
    if(!failureBlock) return;
    
    if (!responseObj) {
        failureBlock(@"服务器异常", ERequestStateServeError);
        return;
    }
    
    if (![responseObj isKindOfClass:[NSDictionary class]]) {
        failureBlock(@"服务器异常", ERequestStateServeError);
        return;
    }
    
    NSInteger resCode = [responseObj[@"state"] integerValue];
    if (resCode == -1) {
        failureBlock(@"服务器错误", ERequestStateServeError);
    }else if (resCode != 0) {
        failureBlock(responseObj[@"Msg"], ERequestStateDefaultError);
    }else{
       successBlock(responseObj);
    }
}

@end
