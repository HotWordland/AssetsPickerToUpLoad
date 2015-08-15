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
##可以根据alertView的显示看到顺序是乱的 所有任务是同时进行上传


#上传视频模拟串行
 ![](https://github.com/HotWordland/AssetsPickerToUpLoad/blob/master/演示说明/orderVideoTask.gif)
##和串行上传图片一样 是一个一个任务有序进行上传 最后一个没有上传上去是因为上传文件容量超过了服务器限制了大小

#上传视频模拟并发
 ![](https://github.com/HotWordland/AssetsPickerToUpLoad/blob/master/演示说明/complicationVideoTask.gif)
##可以看见 所有任务是同时进行上传 不分先后

##项目封装了上传的Factory Method 注意因为演示所以没有对上传的视频进行压缩 正式情况下是要压缩视频再上传 工程内提供了压缩视频的方法和上传的逻辑是分开的 有兴趣的朋友可以再fork封装下 完善壮大 因为项目演示的原因 有几张gif文件(因为自己没有稳定的服务器) 容量有点大 但是工程不大
```
+(void)executeUploadWithFileUploadUrl:(NSString *)uploadUrl files:(NSArray *)filesParamArray fileNames:(NSArray *)filesNames KeyName:(NSString *)keyName upLoadProgress:(void(^)(float progress,int uploadIndex))progressBlock uploadDone:(void(^)(NSString *message,int uploadIndex))uploadDoneBlock uploadType:(UploadTaskType)uploadType;
```

##LonLonStudio - WL -(重庆途尔旅行ios开发者巫龙 ^_^)
