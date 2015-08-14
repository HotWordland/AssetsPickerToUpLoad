//
//  WLUploadOperation.m
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/11.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

/*
 配置并发执行的 Operation
 
 在默认情况下，operation 是同步执行的，也就是说在调用它的 start 方法的线程中执行它们的任务。而在 operation 和 operation queue 结合使用时，operation queue 可以为非并发的 operation 提供线程，因此，大部分的 operation 仍然可以异步执行。但是，如果你想要手动地执行一个 operation ，又想这个 operation 能够异步执行的话，你需要做一些额外的配置来让你的 operation 支持并发执行。下面列举了一些你可能需要重写的方法：
 
 start ：必须的，所有并发执行的 operation 都必须要重写这个方法，替换掉 NSOperation 类中的默认实现。start 方法是一个 operation 的起点，我们可以在这里配置任务执行的线程或者一些其它的执行环境。另外，需要特别注意的是，在我们重写的 start 方法中一定不要调用父类的实现；
 main ：可选的，通常这个方法就是专门用来实现与该 operation 相关联的任务的。尽管我们可以直接在 start 方法中执行我们的任务，但是用 main 方法来实现我们的任务可以使设置代码和任务代码得到分离，从而使 operation 的结构更清晰；
 isExecuting 和 isFinished ：必须的，并发执行的 operation 需要负责配置它们的执行环境，并且向外界客户报告执行环境的状态。因此，一个并发执行的 operation 必须要维护一些状态信息，用来记录它的任务是否正在执行，是否已经完成执行等。此外，当这两个方法所代表的值发生变化时，我们需要生成相应的 KVO 通知，以便外界能够观察到这些状态的变化；
 isConcurrent ：必须的，这个方法的返回值用来标识一个 operation 是否是并发的 operation ，我们需要重写这个方法并返回 YES 。
 
 */


#import "WLUploadOperation.h"
#import "NSMutableURLRequest+Upload.h"
@implementation WLUploadOperation
@synthesize executing = _executing;
@synthesize finished  = _finished;
- (id)initWithuploadUrl:(NSString *)uploadurl FileData:(NSData *)paramData FileName:(NSString *)filename KeyName:(NSString *)keyname{
    self = [super init];
    if (self) {
        fileName = filename;
        keyName = keyname;
        fileData = paramData;
        _uploadUrl = uploadurl;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}
- (BOOL)isExecuting {
    return _executing;
}
- (BOOL)isFinished {
    return _finished;
}
- (void)start {
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];

    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];

    /*
    if(!self.isCancelled) {
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_uploadUrl] datas:@[fileData] fileNames:@[fileName] name:keyName];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                              delegate:self
                                                      startImmediately:NO];
            
            [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                       forMode:NSRunLoopCommonModes];
            
            [self.connection start];
            [self willChangeValueForKey:@"isExecuting"];
            _executing = YES;
            [self didChangeValueForKey:@"isExecuting"];
        });
        
    }
     */
}
- (void)main {
    @try {
         self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_uploadUrl] datas:@[fileData] fileNames:@[fileName] name:keyName];
        //感谢 : http://stackoverflow.com/questions/9684770/run-multiple-instances-of-nsoperation-with-nsurlconnection
            self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                              delegate:self
                                                      startImmediately:NO];
            
            [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                       forMode:NSRunLoopCommonModes];
            
            [self.connection start];
           }
    @catch(NSException *exception) {
    }
}

// all of my NSURLConnectionDataDelegate stuff here, for example, upon completion:


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
    NSError *error;
    NSDictionary *resultValue = [NSJSONSerialization JSONObjectWithData:mData options:NSJSONReadingMutableLeaves error:&error];
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    self.uploadDoneBlock([resultValue objectForKey:@"message"]);
    //完成时 手动维护kvo(注意，有一个非常重要的点需要引起我们的注意，那就是即使一个 operation 是被 cancel 掉了，我们仍然需要手动触发 isFinished 的 KVO 通知。因为当一个 operation 依赖其他 operation 时，它会观察所有其他 operation 的 isFinished 的值的变化，只有当它依赖的所有 operation 的 isFinished 的值为 YES 时，这个 operation 才能够开始执行。因此，如果一个我们自定义的 operation 被取消了但却没有手动触发 isFinished 的 KVO 通知的话，那么所有依赖它的 operation 都不会执行。)
    //sleep(1);//为了模拟"想要手动地执行一个 operation ，又想这个 operation 能够异步执行的话，你需要做一些额外的配置来让你的 operation 支持并发执行"的情况 防止网速太快看不到变化
   
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
    self.progressBlock(myProgress);
    
//    self.uoloadprogress.progress = myProgress;
}

@end
