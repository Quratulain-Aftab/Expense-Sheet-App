//
//  SummaryViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SummaryViewController.h"
#import "Utilities.h"
#import "Model.h"
#import "SummaryCell.h"

@interface SummaryViewController ()
@property NSMutableArray *slices;
@property(nonatomic, strong) NSArray *sliceColors;
@end

@implementation SummaryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.pieChart reloadData];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark === Configuring View ===
#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)makeUIAdjustments
{
    
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    
    // make chart
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }
    self.pieChart.backgroundColor=[UIColor clearColor];
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
 //   [self.pieChart setPieCenter:CGPointMake(240, 240)];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    
   // [self.percentageLabel.layer setCornerRadius:90];
    
//    self.sliceColors =[NSArray arrayWithObjects:
//                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
//                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
//                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
//                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
//                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    
    UIColor *color1= [[Utilities shareManager]backgroundColorWithAlpha:0.2];
    UIColor *color2= [[Utilities shareManager]backgroundColorWithAlpha:0.4];
    UIColor *color3= [[Utilities shareManager]backgroundColorWithAlpha:0.6];
    UIColor *color4= [[Utilities shareManager]backgroundColorWithAlpha:0.8];
    UIColor *color5= [[Utilities shareManager]backgroundColorWithAlpha:1.0];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       color1,
                       color2,color3,color4,color5,nil];

    
    
    //rotate up arrow
   // self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
    
    // table
    
    

}
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)backButtonAction:(id)sender {
    
      [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
   // if(pieChart == self.pieChart) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SummaryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
    
    UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    cell.selectedBackgroundView=selectedBackgorundView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}


@end
