//
//  MHMutilImagePickerViewController.h
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHImagePickerMutilSelectorDelegate <NSObject>

-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)urlAndimageArray;

@end

@interface MHImagePickerMutilSelector : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView* selectedPan;
    UILabel* textlabel;
    UIImagePickerController*    imagePicker;
    UITableView*    tbv;
    NSMutableArray* assetUrls;
    NSMutableArray* photosContents;
    id<MHImagePickerMutilSelectorDelegate>delegate;
    int imageNum;
}

@property (nonatomic,retain)UIImagePickerController*imagePicker;
@property(nonatomic,retain)id<MHImagePickerMutilSelectorDelegate>   delegate;

+(void)showInViewController:(UIViewController<UIImagePickerControllerDelegate,MHImagePickerMutilSelectorDelegate> *)vc init:(NSArray* )aseturls :(NSArray* )photosContent :(int)aImageNum;

@end
