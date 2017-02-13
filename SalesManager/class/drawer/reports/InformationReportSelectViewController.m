//
//  InformationReportSelectViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "InformationReportSelectViewController.h"
#import "ILBarButtonItem.h"

@interface InformationReportSelectViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIView *lineV;




- (IBAction)backToTop:(id)sender;

@end

@implementation InformationReportSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataArray = [[NSArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    /* Left bar button item */
//    ILBarButtonItem *leftBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"back"]
//                                                   selectedImage:nil
//                                                          target:self
//                                                          action:@selector(backToTop:)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
    
    [self setTitle:[_titleString substringToIndex:4]];
    
    [self.label setText:_titleString];
    
//    self.dataArray = [[NSMutableArray alloc] initWithArray:@[@"sdfsdsfsa",@"dfsfsfsd",@"dfsfdsfd",@"dfsfdsfd",@"dfsfdsfd"]];
    
    CGFloat y = 50;
    
    for (int i = 0; i < self.dataArray.count; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 270, 11)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:[UIColor colorWithWhite:0.388 alpha:1.000]];
        [label setText:[NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:i]]];
        [self.backgroudView addSubview:label];
        
        y += 26;
    }
    
    
    [self.lineV setFrame:CGRectMake(0, self.lineV.frame.origin.y, kDeviceWidth, 0.5)];
    self.lineV.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    [self.backgroudView setFrame:CGRectMake(0, 10, kDeviceWidth, y)];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToTop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
