//
//  LSPerson.h
//  LSchedule
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSModel.h"

@interface LSPerson : LSModel

/*
 "loginname": "yanglin1",
 "Email": "yanglin@chinamobile.com",
 "userId": "7745829",
 "name": "ÑîÁÖ",
 "role": "2",
 "mobile": "13910822286"
 */

/** 登录账户名 */
@property (nonatomic, copy) NSString* loginname;
/** 邮箱 */
@property (nonatomic, copy) NSString* Email;
/** 用户ID */
@property (nonatomic, copy) NSString* userId;
/** 用户名 */
@property (nonatomic, copy) NSString* name;
/** 角色  1可以创建日程 */
@property (nonatomic, copy) NSString* role;
/** 手机 */
@property (nonatomic, copy) NSString* mobile;

/** 排序key */
@property (nonatomic, copy) NSString* sort;

/** 颜色 */
@property (nonatomic, copy) NSString* color;


@end


@interface LSUser : LSPerson

/**
 是否有权限更新日程

 @return 是否有权限
 */
+(BOOL)canCreateSchedule;

//当前有权限的账户，如果存在，返回的就是本身
+(LSUser*)currentUser;

+(NSMutableArray<LSUser*>*)parserAndSaveUsers:(NSArray<NSDictionary*>*)infos;

@end

@interface LSLeader : LSPerson

+(NSMutableArray<LSLeader*>*)parserAndSaveLeaders:(NSArray<NSDictionary*>*)infos;

+(NSMutableArray<LSLeader*>*)queryLeaders;

@end
