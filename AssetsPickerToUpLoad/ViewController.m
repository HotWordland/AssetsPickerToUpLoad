//
//  ViewController.m
//  AssetsPickerToUpLoad
//
//  Created by Ronaldinho on 15/8/10.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import "ViewController.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <CTAssetsPickerController/CTAssetsPageViewController.h>
#import "AssetsToUploadVC.h"
@interface ViewController ()<CTAssetsPickerControllerDelegate>
{
    FileType fileType;
}
@property (nonatomic, copy) NSArray *assets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"媒体上传DEMO"];
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"选择相片";

        }
            break;
            case 1:
        {
            cell.textLabel.text = @"选择视频";

        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
           
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // init picker
                    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                    
                    // set delegate
                    picker.delegate = self;
                    
                    // create options for fetching photo only
                    PHFetchOptions *fetchOptions = [PHFetchOptions new];
                    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];

                    // assign options
                    picker.assetsFetchOptions = fetchOptions;

                    // to present picker as a form sheet in iPad
                    picker.modalPresentationStyle = UIModalPresentationFormSheet;
                    
                    // present picker
                    [self presentViewController:picker animated:YES completion:nil];
                    
                });
            }];
            fileType = Photo;

        }
            break;
        case 1:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // init picker
                    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                    
                    // set delegate
                    picker.delegate = self;
                    
                    // create options for fetching photo only
                    PHFetchOptions *fetchOptions = [PHFetchOptions new];
                    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
                    
                    // assign options
                    picker.assetsFetchOptions = fetchOptions;

                    // to present picker as a form sheet in iPad
                    picker.modalPresentationStyle = UIModalPresentationFormSheet;
                    
                    // present picker
                    [self presentViewController:picker animated:YES completion:nil];
                    
                });
            }];
            fileType = Video;
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.assets = [NSMutableArray arrayWithArray:assets];
    [self performSegueWithIdentifier:@"AssetsToUploadVCSegue" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AssetsToUploadVCSegue"]) 
    {
      id theSegue = segue.destinationViewController;
        [theSegue setValue:self.assets forKey:@"assets"];
        [theSegue setValue:[NSNumber numberWithInt:fileType] forKey:@"fileTypeObj"];
     }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
