//
//  WLUploadOperation.h
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/11.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLUploadOperation : NSOperation
{
    NSString *videoPath;
    NSString *fileName;
    NSString *keyName;
    NSMutableData *mData;
    NSData *fileData;
}
@property (nonatomic,copy) NSString *uploadUrl;
@property (nonatomic,copy) void(^progressBlock)(float progress);
@property (nonatomic,copy) void(^uploadDoneBlock)(NSString *message);
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableURLRequest *request;
- (id)initWithuploadUrl:(NSString *)uploadurl FileData:(NSData *)paramData FileName:(NSString *)filename KeyName:(NSString *)keyname;
@end
