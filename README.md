# AssetsPickerToUpLoad
媒体(文件)上传 IOS客户端 (带PHP脚本测试)
#说明
项目使用的NSOperation 和 NSOperationQueue 来进行封装网络上传请求库
主要模拟了两种情况 串行和并发的上传效果
#演示

#上传图片模拟串行
 ![](https://github.com/HotWordland/AssetsPickerToUpLoad/blob/master/演示说明/orderTask.gif)
##因为网速太快 所以添加了alertView的显示 可以看见 是一个一个任务有序进行上传

#上传图片模拟并发
 ![](https://github.com/HotWordland/AssetsPickerToUpLoad/blob/master/演示说明/complicationTask.gif)
##可以看见 所有任务是同时进行上传


#上传视频模拟串行
 ![](https://github.com/HotWordland/AssetsPickerToUpLoad/blob/master/演示说明/orderVideoTask.gif)
##和串行上传图片一样 是一个一个任务有序进行上传 最后一个没有上传上去是因为上传文件容量超过了服务器限制了大小

#上传视频模拟并发
 ![](https://github.com/HotWordland/AssetsPickerToUpLoad/blob/master/演示说明/complicationVideoTask.gif)
##可以看见 所有任务是同时进行上传 不分先后

##项目封装了上传方法  
```
-(void)executeUploadWithFileUploadUrl:(NSString *)uploadUrl files:(NSArray *)filesParamArray fileNames:(NSArray *)filesNames KeyName:(NSString *)keyName upLoadProgress:(void(^)(float progress,int uploadIndex))progressBlock uploadDone:(void(^)(NSString *message,int uploadIndex))uploadDoneBlock uploadType:(UploadTaskType)uploadType;
```
