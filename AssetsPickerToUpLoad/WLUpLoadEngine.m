//
//  WLUpLoadEngine.m
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/12.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import "WLUpLoadEngine.h"
#import "WLUploadOperation.h"
#import <UIKit/UIKit.h>
@implementation WLUpLoadEngine
-(void)executeUploadWithFileUploadUrl:(NSString *)uploadUrl files:(NSArray *)filesParamArray fileNames:(NSArray *)filesNames KeyName:(NSString *)keyName upLoadProgress:(void(^)(float progress,int uploadIndex))progressBlock uploadDone:(void(^)(NSString *message,int uploadIndex))uploadDoneBlock uploadType:(UploadTaskType)uploadType{
    NSOperationQueue  *queue = [[NSOperationQueue alloc]init];
    if (uploadType == TaskToOneByOne) {
        [queue setMaxConcurrentOperationCount:1];
    }
    NSMutableArray *operations = [[NSMutableArray alloc]init];
    for (int i = 0; i < filesParamArray.count; i++) {
        NSAssert([filesParamArray[i] isKindOfClass:[NSData class]],@"class is not NSData");
        NSAssert([filesNames[i] isKindOfClass:[NSString class]],@"class is not NSString");
        
        NSData *data = filesParamArray[i];
        WLUploadOperation *wlOp = [[WLUploadOperation alloc]initWithuploadUrl:uploadUrl FileData:data FileName:filesNames[i] KeyName:keyName];
        [operations addObject:wlOp];
        if (uploadType == TaskToOneByOne) {
            if (operations.count>1) {
                WLUploadOperation *previousOp = operations[operations.count -2 ];
                [wlOp addDependency:previousOp];
            }
        }
            [wlOp setProgressBlock:^(float progress) {
            progressBlock(progress,i);
        }];
        [wlOp setUploadDoneBlock:^(NSString *message) {
            uploadDoneBlock(message,i);
        }];
        
        [queue addOperation:wlOp];
    }
}


@end
