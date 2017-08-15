//
//  LSAgendaModel.h
//  LSchedule
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "LSModel.h"
#import "LSPerson.h"

/** 当天对应的日程 */
@interface LSAgendaModel : LSModel

+(LSAgendaModel*)copyModel:(LSAgendaModel*)model;

+(NSMutableArray<LSAgendaModel*>*)forgeDataSource;

+(NSMutableDictionary*)forgeDataSource1;

/**
 通过日期查询数据
 
 @param date 日期  格式  2020-12-12
 @return 对应天的日程数组
 */
+(NSArray<LSAgendaModel*>*)queryModelsDate:(NSDate*)date;


/**
 通过日期和领导id 查询对应日程

 @param date 日期  格式  2020-12-12
 @param leadersId 根据后台返回数据样式，领导之间是用空格分开的，可能好几个空格，不确定
 @return 对应天的日程数组
 */
+(NSArray<LSAgendaModel*>*)queryModelsDate:(NSDate*)date leadersId:(NSString*)leadersId;

/**
 查询合法日程数据

 @param date 日期  格式  2020-12-12
 @param leadersId 根据后台返回数据样式，领导之间是用空格分开的，可能好几个空格，不确定
 @return 对应天的日程数组
 */
+(NSArray<LSAgendaModel*>*)queryLegalModelsDate:(NSDate*)date leadersId:(NSString*)leadersId;



/**
 获取节假日

 @return 节假日
 */
+(NSString*)holidays;


/*
 "smsContent": "",
 "remark": "",
 "smsType": 0,
 "leadersId": "13946709792911646768699192320654,13946711535570236005531181935216,7745829,13946711635570236005531181935216,13946712241508084682667760927870",
 "creatorId": "",
 "pid": "",
 "creatTime": "2017-04-28 00:00:00.0",
 "endTime": "2017-05-02 10:00:00.0",
 "type": "0",
 "leaders": "  ´÷ÖÒ  ÍõÐ¡½Ü  ÑîÁÖ  Îº±ù  ·½Á¦",
 "noId": "ef8b9c89564ac215015bb2982fe403bd",
 "creator": "½¯ÒàÎ°",
 "modifier": "",
 "startTime": "2017-05-02 09:00:00.0",
 "holiday": "0",
 "content": "·Ö¹«Ë¾Áìµ¼ÅöÍ·»á",
 "modifierId": "",
 "address": "1111»áÒéÊÒ",
 "pending": "1"
 */

/** 日程ID  */
@property (nonatomic, copy) NSString* noId;

/** 地址 */
@property (nonatomic, copy) NSString* address;

/** 会议内容 */
@property (nonatomic, copy) NSString* content;

/** <#description#> */
@property (nonatomic, copy) NSString* creatTime;
/** <#description#> */
@property (nonatomic, copy) NSString* creator;
/** <#description#> */
@property (nonatomic, copy) NSString* creatorId;
/** <#description#> */
@property (nonatomic, copy) NSString* endTime;
/** <#description#> */
@property (nonatomic) BOOL holiday;

/** <#description#> */
@property (nonatomic, copy) NSString* leaders;
/** <#description#> */
@property (nonatomic, copy) NSString* leadersId;
/** <#description#> */
@property (nonatomic, copy) NSString* modifier;
/** <#description#> */
@property (nonatomic, copy) NSString* modifierId;
/** <#description#> */
@property (nonatomic) NSInteger pending;
/** <#description#> */
@property (nonatomic, copy) NSString* pid;
/** <#description#> */
@property (nonatomic, copy) NSString* remark;
/** <#description#> */
@property (nonatomic) NSInteger smsContent;

/** <#description#> */
@property (nonatomic, copy) NSString* smsType;

/** <#description#> */
@property (nonatomic, copy) NSString* startTime;

/** 重写 setter 当赋值的时候meetType也会同步赋值 */
@property (nonatomic) NSInteger shType;

#pragma mark -
#pragma mark - 非服务器字段
/** 重写getter 根据type获取值 */
@property (nonatomic, copy) NSString* meetType;




/**
 获取固定时间段的领导日程

 @param startTime 起始时间  毫秒
 @param endTime 结束时间    毫秒
 @param successBlock 成功的回调
 @param failureBlock 失败回调
 */
+(void)asyncGetAgendaListStartTime:(NSTimeInterval)startTime
                           endTime:(NSTimeInterval)endTime
                      successBlock:(void(^)(NSMutableDictionary* data))successBlock
                      failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 新增或者修改日程   当id存在的时候就是修改

 @param model 日程对象
 @param successBlock 成功的回调
 @param failureBlock 失败回调
 */
+(void)asyncUpdateAgendaInfo:(LSAgendaModel*)model
             successBlock:(void(^)(id data))successBlock
             failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


/**
 删除日程   当id存在的时候就是修改
 
 @param agendaId 日程对象
 @param successBlock 成功的回调
 @param failureBlock 失败回调
 */
+(void)asyncDeleteAgendaById:(NSString*)agendaId
            successBlock:(void(^)(id data))successBlock
            failureBlock:(void(^)(id msg, ERequestState state))failureBlock;


@end
