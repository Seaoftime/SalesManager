//
//  GetCAMPhotoURL.h
//  Photourl
//
//  Created by tianjing on 13-10-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol GetCAMPhotoURLDelegate <NSObject>

@optional
-(void)imagePickerGetCAMPhotoURL:(NSString*)CAMPhotoURL thumbimage:(UIImage*)thumbnail;

@end


@interface GetCAMPhotoURL : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController*    imagePicker;
    id<GetCAMPhotoURLDelegate>  delegate;
    NSString *camphotourl;
    UIImage *thumbnailimage;
    int totalnum;
}

@property (nonatomic,retain)UIImagePickerController*    imagePicker;
@property(nonatomic,retain)id<GetCAMPhotoURLDelegate>   delegate;

+(void)showInViewController:(UIViewController<GetCAMPhotoURLDelegate>*)vc;

@end
