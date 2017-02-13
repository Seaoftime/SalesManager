//
//  GetCAMPhotoURL.m
//  Photourl
//
//  Created by tianjing on 13-10-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "GetCAMPhotoURL.h"

@interface GetCAMPhotoURL ()

@end

@implementation GetCAMPhotoURL
@synthesize imagePicker;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id)standardSelector
{
    return [[GetCAMPhotoURL alloc] init];
}
- (id)init
{
    self = [super init];
    if (self) {
            [self.view setBackgroundColor:[UIColor blackColor]];
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)doneHandler
{
    if (delegate && [delegate respondsToSelector:@selector(imagePickerGetCAMPhotoURL:thumbimage:)]) {
        [delegate performSelector:@selector(imagePickerGetCAMPhotoURL:thumbimage:)  withObject:camphotourl withObject:thumbnailimage];
    }
    [self close];
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    [picker dismissModalViewControllerAnimated:YES];
    [SVProgressHUD showWithStatus:@"图片处理中..."];
    // Recover the snapped image
    
    
     NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 处理静态照片
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 1/.5) == kCFCompareEqualTo)
    {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save the image to the album
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:
(NSError *)error contextInfo:(void *)contextInfo;
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                if (index == totalnum-1) {
                camphotourl=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                NSLog(@"takephotourl is:%@",camphotourl);
                thumbnailimage = [UIImage imageWithCGImage:result.thumbnail];
                /*result.defaultRepresentation.fullScreenImage//图片的大图
                 result.thumbnail                             //图片的缩略图小图
                 //                    NSRange range1=[urlstr rangeOfString:@"id="];
                 //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                 //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                 */
                   [self doneHandler];
            }
            }
          
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
                if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"] || [g2 isEqualToString:@"相机胶卷"]) {
                    totalnum = [group numberOfAssets];
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
                }
                                   }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        [library release];
       
    });
    [pool release];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self close];
}

-(void)close
{
    [SVProgressHUD dismiss];
    [imagePicker dismissModalViewControllerAnimated:YES];
    [self release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [delegate release],delegate=nil;
    [imagePicker release],imagePicker=nil;
    [super dealloc];
}
+(void)showInViewController:(UIViewController<UIImagePickerControllerDelegate,GetCAMPhotoURLDelegate> *)vc
{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"sorry, no camera or camera is unavailable.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"相机无法启用，请检查设置！" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    //获得相机模式下支持的媒体类型
    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakePicture = NO;
    for (NSString* mediaType in availableMediaTypes)
    {
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage])
        {
            //支持拍照
            canTakePicture = YES;
            break;
        }
    }
    //检查是否支持拍照
    if (!canTakePicture)
    {
        NSLog(@"sorry, taking picture is not supported.");
        return;
    }

    GetCAMPhotoURL* imagePickerMutilSelector=[[GetCAMPhotoURL alloc] init];//自动释放
    imagePickerMutilSelector.delegate=vc;//设置代理
    UIImagePickerController* picker=[[UIImagePickerController alloc] init];
    picker.delegate=imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
    [picker setAllowsEditing:NO];
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    picker.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
    picker.navigationController.delegate=imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector
    imagePickerMutilSelector.imagePicker=picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
    [vc presentModalViewController:picker animated:YES];
    [picker release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
