//
//  LSModel.m
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSModel.h"
#import "LSRequest.h"

@implementation EPage

+(EPage*)parserPage:(NSDictionary*)pageInfo{
    if (![pageInfo isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    EPage* page = [[EPage alloc] init];
    page.countSize = [pageInfo[@"countSize"] integerValue];
    page.pageCount = [pageInfo[@"pageCount"] integerValue];
    page.pageIndex = [pageInfo[@"pageIndex"] integerValue];
    
    page.pageSize = [pageInfo[@"pageSize"] integerValue];
    
    return page;
}

@end

@implementation LSModel

+(void)asyncGetUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    NSDictionary* fullParams = [self addUserIdParam:params];
    [LSRequest getRequest:url params:fullParams successBlock:successBlock failureBlock:failureBlock];
}

+(void)asyncPostUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    NSDictionary* fullParams = [self addUserIdParam:params];
    
    [LSRequest postRequest:url params:fullParams successBlock:successBlock failureBlock:failureBlock];
}

+(void)asyncPutUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    NSDictionary* fullParams = [self addUserIdParam:params];
    
    [LSRequest putRequest:url params:fullParams successBlock:successBlock failureBlock:failureBlock];
}

+(void)asyncDeleteUrl:(NSString *)url param:(NSDictionary *)params successBlock:(void (^)(id))successBlock failureBlock:(void(^)(id msg, ERequestState state))failureBlock{
    
    NSDictionary* fullParams = [self addUserIdParam:params];
    
    [LSRequest deleteRequest:url params:fullParams successBlock:successBlock failureBlock:failureBlock];
}


+(void)cancelRequest:(NSString *)url{
    [LSRequest cancelTaskUrl:url];
}

#pragma mark -
#pragma mark - 给请求默认添加一个userId
+(NSDictionary*)addUserIdParam:(NSDictionary*)param{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    Class userModelClass = NSClassFromString(@"EUserModel");
    
    id userModel = [[userModelClass alloc] init];
    SEL userIDSelector = NSSelectorFromString(@"getUserID");
    
    SEL tokenSelector = NSSelectorFromString(@"getUserToken");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id userId = nil;
    if ([userModel respondsToSelector:userIDSelector]) {
        userId = [userModel performSelector:userIDSelector];
    }
    
    id token = nil;
    if ([userModel respondsToSelector:tokenSelector]) {
        token = [userModel performSelector:tokenSelector];
    }
    
#pragma clang diagnostic pop
    
    //添加userID
    if (userId) {
        dic[@"userId"] = userId;
    }
    
    //添加MD5
    if (!param[@"md5"]) {
        
//        dic[@"md5"] = [[NSString stringWithFormat:@"%@%@%@", userId, token, kRequestKey] EMD5];
    }
    
    
    dic[@"Login"] = @"true";
//    dic[@"loginname"] = @"zhuning";
    dic[@"mobile"] = kLSTempPhoneNumber;// @"13810984118";// @"18332379039"

    
    
    return dic;
}

+ (NSString *)dbName {
    
    return @"LSDataBase";
}

+ (NSString *)tableName {
    
    return NSStringFromClass([self class]);
}

+ (NSString *)primaryKey {
    return nil;
}


#pragma mark -
#pragma mark - runtime
- (NSArray *)getAllProperties{
    
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++){
        
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

- (NSDictionary *)getAllPropertyKeyValues
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

@end
