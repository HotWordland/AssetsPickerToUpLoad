//
//  PhotosToUploadVC.m
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/11.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//
#if 0
#define SERVER_URL @"http://burningland.koding.io/multiUpload/uploadInterface.php"
#else
#define SERVER_URL @"http://172.16.0.26/multiUpload/uploadinterface.php"
#endif
#import "AssetsToUploadVC.h"
#import "PhotosToUploadCell.h"
#import "WLUpLoadEngine.h"
#import "NSMutableURLRequest+Upload.h"
#import "WLUploadOperation.h"
@interface AssetsToUploadVC ()<UITableViewDelegate>
{
    NSMutableData *mData;
    NSMutableURLRequest *request;
    NSURLConnection *connection;
    WLUpLoadEngine *uploadEngine;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AssetsToUploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
}

- (IBAction)clickToUploadOnebyone:(UIBarButtonItem *)sender {
    [self addImagesToUploadWithTaskType:TaskToOneByOne];
}
- (IBAction)clickToUoloadAll:(UIBarButtonItem *)sender {
    [self addImagesToUploadWithTaskType:TaskTOAll];

}

-(void)addImagesToUploadWithTaskType:(UploadTaskType)uploadType
{
    [self executeOperationUsingOperationQueueWithUploadType:uploadType];
}
-(void)executeOperationUsingOperationQueueWithUploadType:(UploadTaskType)uploadType{
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue setMaxConcurrentOperationCount:1];
    //[queue waitUntilAllOperationsAreFinished];
    switch (_fileTypeObj.intValue) {
        case Photo:
        {
            NSMutableArray *images = [[NSMutableArray alloc]init];
            NSMutableArray *imageNames = [[NSMutableArray alloc]init];
            NSMutableArray *datas = [[NSMutableArray alloc]init];
            PHImageManager *manager = [PHImageManager defaultManager];
            __block int totalCount = 0;
            // NSMutableArray *operations = [[NSMutableArray alloc]init];
            for (int i = 0; i < self.assets.count; i++) {
                CGFloat scale = UIScreen.mainScreen.scale;
                CGSize targetSize = CGSizeMake(tableViewRowHeight * scale, tableViewRowHeight * scale);
                                [manager requestImageForAsset:self.assets[i]
                                   targetSize:targetSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:self.requestOptions
                                resultHandler:^(UIImage *image, NSDictionary *info){
                                    [images addObject:image];
                                    [imageNames addObject:[NSString stringWithFormat:@"wlUploadEngine-ceshiImage%d.png",i]];
                                    NSData *data = UIImagePNGRepresentation(image);
                                    [datas addObject:data];
                                    totalCount++;
                                    if (totalCount==self.assets.count) {
                                        if (!uploadEngine) {
                                            uploadEngine = [[WLUpLoadEngine alloc]init];
                                        }
                                        [uploadEngine executeUploadWithFileUploadUrl:SERVER_URL files:[NSArray arrayWithArray:datas] fileNames:imageNames KeyName:@"upload_file[]" upLoadProgress:^(float progress, int uploadIndex) {
                                            PhotosToUploadCell *cell = (PhotosToUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:uploadIndex inSection:0]];
                                            [cell.progress setProgress:progress animated:NO];
                                        } uploadDone:^(NSString *message,int uploadIndex) {
                                            PhotosToUploadCell *cell = (PhotosToUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:uploadIndex inSection:0]];
                                            [cell.progress setProgress:1 animated:NO];
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                                            [alert show];
                                        } uploadType:uploadType];
                                        
                                    }
                                }];
            }
        }
            break;
            case Video:
        {
            PHImageManager *manager = [PHImageManager defaultManager];
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHVideoRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
            options.networkAccessAllowed = true;
            NSMutableArray *videoUrls = [[NSMutableArray alloc]init];
            NSMutableArray *videoNames = [[NSMutableArray alloc]init];
            NSMutableArray *datas = [[NSMutableArray alloc]init];
           __block int totalCount = 0;
            for (int i = 0; i < self.assets.count; i++) {
                [videoNames addObject:[NSString stringWithFormat:@"wlUploadEngine-ceshiVideo%d.mov",i]];
                [manager requestAVAssetForVideo:self.assets[i] options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                    NSURL *videoURL = [(AVURLAsset *)asset URL];
                    [videoUrls addObject:videoURL];
                    NSData *data = [NSData dataWithContentsOfURL:videoURL];
                    [datas addObject:data];
                    totalCount++;
                    /*
                    NSString *toFilePathString = [NSString stringWithFormat:@"/Documents/wlUploadEngine-ceshiVideoCompress%d.mp4",i];
                    NSString *debugPth = [NSHomeDirectory() stringByAppendingString:toFilePathString];
                    NSLog(debugPth);
                    NSURL *toFilePath =   [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:toFilePathString]];
                    [self encodeVideoByUrl:videoURL ToUrl:toFilePath Quality:AVAssetExportPresetLowQuality Completion:^(BOOL isSuccess) {
                        if (isSuccess) {
                            NSLog(@"压缩成功");
                        }else NSLog(@"压缩失败");
                    }];
                     */
                    if (totalCount==self.assets.count) {
                        if (!uploadEngine) {
                            uploadEngine = [[WLUpLoadEngine alloc]init];
                        }
                        [uploadEngine executeUploadWithFileUploadUrl:SERVER_URL files:[NSArray arrayWithArray:datas] fileNames:videoNames KeyName:@"upload_file[]" upLoadProgress:^(float progress, int uploadIndex) {
                            PhotosToUploadCell *cell = (PhotosToUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:uploadIndex inSection:0]];
                            [cell.progress setProgress:progress animated:NO];
                        } uploadDone:^(NSString *message,int uploadIndex) {
                            PhotosToUploadCell *cell = (PhotosToUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:uploadIndex inSection:0]];
                            [cell.progress setProgress:1 animated:NO];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                            [alert show];
                        } uploadType:uploadType];
                        
                    }
                }];

            }

            
        }
            break;
            
        default:
            break;
    }


}
//视频转MP4 -Quality 压缩的质量
- (void)encodeVideoByUrl:(NSURL*)_videoURL ToUrl:(NSURL*)_mp4URL Quality:(NSString *const)quality Completion:(void (^)(BOOL isSuccess))completion
{
    if(!_videoURL){
        if(completion)
            completion(NO);
    }
    if([[NSFileManager defaultManager] removeItemAtURL:_mp4URL error:nil]){
        NSLog(@"Delete old MP4 Successful!");
    }
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    CMTime assetTime = [avAsset duration];
    Float64 duration = CMTimeGetSeconds(assetTime);
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSString *mQuality;
    if(quality.length)
        mQuality = quality;
    else
        mQuality = AVAssetExportPresetMediumQuality;
    if ([compatiblePresets containsObject:mQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:mQuality];
        
        exportSession.outputURL = _mp4URL;
        exportSession.shouldOptimizeForNetworkUse = YES;
        //格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //视频截取
        //        CMTime start = CMTimeMakeWithSeconds(0.0, avAsset.duration.timescale);
        //        float trimDuration = 10.0;
        //        if(trimDuration>duration){
        //            trimDuration = duration;
        //        }
        //        CMTime cmDuration = CMTimeMakeWithSeconds(trimDuration, avAsset.duration.timescale);
        //        CMTimeRange range = CMTimeRangeMake(start, cmDuration);
        //        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:{
                    NSLog(@"Convert to MP4 Failed!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                            completion(NO);
                    });
                }
                    break;
                case AVAssetExportSessionStatusCancelled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                            completion(NO);
                    });
                }
                    break;
                case AVAssetExportSessionStatusCompleted:{
                    NSLog(@"Convert to MP4 Successful!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                            completion(YES);
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        NSLog(@"AVAsset doesn't support mp4 quality");
    }
}
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"response length=%lld  statecode%ld", [response expectedContentLength],(long)responseCode);
}


// A delegate method called by the NSURLConnection as data arrives.  The
// response data for a POST is only for useful for debugging purposes,
// so we just drop it on the floor.
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    if (mData == nil) {
        mData = [[NSMutableData alloc] initWithData:data];
    } else {
        [mData appendData:data];
    }
    NSLog(@"response connection");
    
}

// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    
    NSLog(@"response error%@", [error localizedFailureReason]);
}

// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSString *responseString = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    NSLog(@"response body%@", responseString);
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseString delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    //    [alert show];
    //    [self.uoloadprogress setProgress:0.0];
}
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float myProgress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    NSLog(@"Proggy: %f",myProgress);
   // self.progressBlock(myProgress);
    
    //    self.uoloadprogress.progress = myProgress;
}




#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewRowHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosToUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
        cell = [[PhotosToUploadCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    PHAsset *asset = [self.assets objectAtIndex:indexPath.row];
    cell.textLabel.text         = [self.dateFormatter stringFromDate:asset.creationDate];
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%ld X %ld", (unsigned long)asset.pixelWidth, (unsigned long)asset.pixelHeight];
    cell.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    cell.clipsToBounds          = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize targetSize = CGSizeMake(tableViewRowHeight * scale, tableViewRowHeight * scale);
    
    [manager requestImageForAsset:asset
                       targetSize:targetSize
                      contentMode:PHImageContentModeAspectFill
                          options:self.requestOptions
                    resultHandler:^(UIImage *image, NSDictionary *info){
                        cell.imageView.image = image;
                        [cell setNeedsLayout];
                        [cell layoutIfNeeded];
                    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:self.assets];
    vc.pageIndex = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
