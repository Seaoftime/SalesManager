//
//  SetSuggestionVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSuggestionVC : YWbaseVC<UITextViewDelegate>
@property(nonatomic,strong) IBOutlet UITextView *suggestionText;
@property(nonatomic,strong) IBOutlet UILabel *holderLabel;
@end
