//
//  PhotosToUploadVC.h
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/11.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//
#define tableViewRowHeight 80.0f

#import <UIKit/UIKit.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <CTAssetsPickerController/CTAssetsPageViewController.h>

@interface AssetsToUploadVC : UIViewController
typedef enum : NSUInteger {
   Photo ,
    Video,
} FileType;
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic,strong) NSNumber *fileTypeObj;

@end
