//
//  WLUpLoadEngine.h
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/12.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLUpLoadEngine : NSObject
typedef enum : NSUInteger {
    TaskToOneByOne,
    TaskTOAll,
} UploadTaskType;

/**
 *  上传
 *
 *  @param uploadUrl       负责上传的 url
 *  @param filesParamArray  要上传的文件(NSData数组)
 *  @param filesNames 要保存在服务器上的文件名数组
 *  @param keyName      服务器脚本字段名
 *  @param progressBlock 进度回调
 *  @param uploadDoneBlock 完成回调
 *  @return multipart/form-data POST 请求
 *  @param uploadType 任务类型(TaskToOneByOne 有顺序的一个一个上传. TaskTOAll 无顺序一齐上传)
 */

+(void)executeUploadWithFileUploadUrl:(NSString *)uploadUrl files:(NSArray *)filesParamArray fileNames:(NSArray *)filesNames KeyName:(NSString *)keyName upLoadProgress:(void(^)(float progress,int uploadIndex))progressBlock uploadDone:(void(^)(NSString *message,int uploadIndex))uploadDoneBlock uploadType:(UploadTaskType)uploadType;

@end
