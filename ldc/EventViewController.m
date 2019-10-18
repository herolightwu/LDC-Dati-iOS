//
//  EventViewController.m
//  ldc
//
//  Created by meixiang wu on 10/15/19.
//  Copyright © 2019 cube. All rights reserved.
//

#import "EventViewController.h"
#import "LMJDropdownMenu/LMJDropdownMenu.h"
#import "AppDelegate.h"
#import "common/Config.h"
#import "common/NetworkManager.h"
#import "common/XMLReader.h"
#import "models/Vaccine.h"
#import "models/AddrModel.h"
#import <SVProgressHUD.h>
#import "BackBarButtonItem.h"

@interface EventViewController () <LMJDropdownMenuDataSource,LMJDropdownMenuDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    LMJDropdownMenu * menuEvent;
    UIDatePicker* picker;
    UIPickerView *vaccinepicker;
    UIPickerView *addresspicker;
    UIToolbar *toolbar, *addrTool, *vaccineTool;
    NSString* event_type;
    NSString* vaccineId;
    Boolean bSDate, bDatePicker;
    NSString *sDTime, *eDTime, *nDTime;
}
//@property (weak, nonatomic) IBOutlet BackBarButtonItem *backBarButtonItem;


@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.backBarButtonItem.delegate = self;
    
    self.typeArray = @[event_type_1, event_type_5, event_type_6, event_type_7, event_type_8, event_type_9, event_type_10, event_type_14, event_type_15];
    
    self.mKeptCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.mKeptView addSubview:self.mKeptCheck];
    self.mKeptCheck.on = NO;
    //self.mCheckBox.onFillColor = YELLOW_COLOR;
    self.mKeptCheck.onTintColor = T_HEADER_TEXT_COLOR;
    self.mKeptCheck.tintColor = T_HEADER_TEXT_COLOR;
    self.mKeptCheck.onCheckColor = T_HEADER_TEXT_COLOR;
    self.mKeptCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mKeptCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mKeptCheck.boxType = BEMBoxTypeSquare;
    
    CALayer *imageLayer = self.mCommentText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mCertText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mDetailText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAddrCodeText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    imageLayer = self.mIsoCodeText.layer;
    [imageLayer setCornerRadius:3];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    self.addrArray = [[NSMutableArray alloc] init];
    self.vaccineArray = [[NSMutableArray alloc] init];
    
    [self.mDetailText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    event_type = @"";
    bSDate = NO;
    bDatePicker = NO;
}
    
- (void)createMenu{
    CGRect rc0 = self.mParentView.frame;
    CGRect rc = self.mTypeView.frame;
    rc.origin.x += rc0.origin.x;
    rc.origin.y += rc0.origin.y;
    menuEvent = [[LMJDropdownMenu alloc] init];
    [menuEvent setFrame:rc];
    menuEvent.dataSource = self;
    menuEvent.delegate   = self;
    
    menuEvent.layer.borderColor  = [UIColor whiteColor].CGColor;
    menuEvent.layer.borderWidth  = 1;
    menuEvent.layer.cornerRadius = 1;
    
    menuEvent.title           = event_type_prompt;
    menuEvent.titleBgColor    = T_HEADER_TEXT_COLOR;//[UIColor colorWithRed:202/255.f green:201/255.f blue:207/255.f alpha:1];
    menuEvent.titleFont       = [UIFont systemFontOfSize:16];
    menuEvent.titleColor      = [UIColor whiteColor];
    menuEvent.titleAlignment  = NSTextAlignmentCenter;
    menuEvent.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    //menu1.rotateIcon      = [UIImage imageNamed:@"arrowIcon3"];
    //menu1.rotateIconSize  = CGSizeMake(15, 15);
    
    menuEvent.optionBgColor       = [UIColor whiteColor];//[UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
    menuEvent.optionFont          = [UIFont systemFontOfSize:16];
    menuEvent.optionTextColor     = T_HEADER_TEXT_COLOR;//[UIColor blackColor];
    menuEvent.optionTextAlignment = NSTextAlignmentLeft;
    menuEvent.optionNumberOfLines = 0;
    menuEvent.optionLineColor     = CONTROLL_EDGE_COLOR;
    menuEvent.optionIconSize      = CGSizeMake(15, 15);
    
    [self.view addSubview:menuEvent];
}
    
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat width = 0.95 * self.view.frame.size.width;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    contentView.backgroundColor = [UIColor clearColor];

    CGRect titleRect = contentView.frame;
    titleRect.origin.y = 0;
    titleRect.size.height = 40;
    titleRect.size.width -= 64;

    UILabel *titleView = [[UILabel alloc] initWithFrame:titleRect];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:18.0];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor colorWithRed:83/255.f green:86/255.f blue:101/255.f alpha:1.0];
    titleView.text = @"AAS Notikumu Reģistrācija";
    [contentView addSubview:titleView];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.navigationItem.titleView = contentView;
    
    [self createBackButton];
    
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dtFmt = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dtFmt setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString *formattedDate = [dtFormatter stringFromDate:[NSDate date]];
    sDTime = [[NSString alloc]initWithString:formattedDate];
    NSString *formattedDate1 = [dtFmt stringFromDate:[NSDate date]];
    NSString *strdate=[[NSString alloc]initWithString:formattedDate1];
    self.mStartDateTxt.text = strdate;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *someDate = [cal dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate date] options:0];
    formattedDate = [dtFormatter stringFromDate:someDate];
    eDTime = [[NSString alloc]initWithString:formattedDate];
    formattedDate1 = [dtFmt stringFromDate:someDate];
    strdate=[[NSString alloc]initWithString:formattedDate1];
    self.mEndDateTxt.text = strdate;
    
    NSCalendar *calNext = [NSCalendar currentCalendar];
    NSDate *nextDate = [calNext dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:0];
    formattedDate = [dtFormatter stringFromDate:nextDate];
    nDTime=[[NSString alloc]initWithString:formattedDate];
    formattedDate1 = [dtFmt stringFromDate:nextDate];
    strdate=[[NSString alloc]initWithString:formattedDate1];
    self.mNextDateTxt.text = strdate;
    
    self.mVardsLb.text = self.animalObj.name;
    
    self.mIdLb.text = self.animalObj.idString;
    
    self.mCertText.text = g_user.certificate;
    
    [self loadVaccines];
    [self createMenu];
    [self refreshLayout];
}

-(void)createBackButton{
    UIImage* image3 = [UIImage imageNamed:@"ic_nav_back.png"];
    CGRect frameimg = CGRectMake(5,7, 16,16);

    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(Back_btn:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];

    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem =mailbutton;
}

-(IBAction)Back_btn:(id)sender
{
    if([SVProgressHUD isVisible]) return;
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

-(void)refreshLayout{
    [UIView animateWithDuration:0.25f animations:^{
        self.mTableView.alpha = 0;
    }];
    
    CGRect rcComment = self.mCommentText.frame;
    rcComment.origin.x = 32;
    rcComment.origin.y = 118;
    if([event_type isEqualToString:event_type_8]){
        [UIView animateWithDuration:0.25f animations:^{
            self.mDangerView.alpha = 1;
            self.mVaccineView.alpha = 0;
            self.mAddrView.alpha = 0;
        }];
        CGRect rcD = self.mDangerView.frame;
        rcComment.origin.y += (rcD.size.height + 16);
    } else if([event_type isEqualToString:event_type_9]){
        [UIView animateWithDuration:0.25f animations:^{
            self.mDangerView.alpha = 0;
            self.mVaccineView.alpha = 1;
            self.mAddrView.alpha = 0;
        }];
        //[self createVaccineMenu];
        CGRect rcV = self.mVaccineView.frame;
        rcComment.origin.y += (rcV.size.height + 16);
        CGRect rctb = self.mTableView.frame;
        rctb.origin.y = 142;
        self.mTableView.frame = rctb;
    } else if ([event_type isEqualToString:event_type_10]){
        [UIView animateWithDuration:0.25f animations:^{
            self.mDangerView.alpha = 0;
            self.mVaccineView.alpha = 0;
            self.mAddrView.alpha = 1;
            if(self.mKeptCheck.on){
                self.mIsoCodeText.alpha = 1;
                self.mAddrCodeText.alpha = 0;
            } else{
                self.mIsoCodeText.alpha = 0;
                self.mAddrCodeText.alpha = 1;
            }
        }];
        CGRect rcA = self.mAddrView.frame;
        rcComment.origin.y += (rcA.size.height + 16);
        CGRect rctb = self.mTableView.frame;
        rctb.origin.y = 186;
        self.mTableView.frame = rctb;
    } else{
        [UIView animateWithDuration:0.25f animations:^{
            self.mDangerView.alpha = 0;
            self.mVaccineView.alpha = 0;
            self.mAddrView.alpha = 0;
        }];
    }
    self.mCommentText.frame = rcComment;
    
    if(bDatePicker){
        [self onDoneButtonClick];
    }
}

-(void)loadVaccines{
    self.vaccineArray = [[NSMutableArray alloc] init];
    [NetworkManager getVaccines:g_user.sessionId success:^(NSData *data){
        NSError *parseError = nil;
        NSDictionary *dict  = [XMLReader dictionaryForXMLData:data error:&parseError];
        if(parseError == nil){
            NSDictionary *allDic = [dict objectForKey:@"s:Envelope"];
            NSDictionary *bodyDic = [allDic objectForKey:@"s:Body"];
            NSDictionary *resDic = [bodyDic objectForKey:@"GetVakcinasResponse"];
            NSDictionary *resultDic = [resDic objectForKey:@"GetVakcinasResult"];
            if(resultDic)
            {
                NSMutableArray *vac_array = [resultDic objectForKey:@"b:VakcinasDati"];
                for (NSDictionary *d in vac_array) {
                    Vaccine *one = [[Vaccine alloc] initWithDictionary:d];
                    [self.vaccineArray addObject:one];
                }
            }
        } else{
            //[self showAlertView:[TSLanguageManager localizedString:@"Error"] Message:parseError.localizedDescription];
        }
        
    }
      failure:^(NSError *err){
          
      }];
}

-(void)textFieldDidChange :(UITextField *) textField{
    if(textField == self.mDetailText){
        NSString *prefix = self.mDetailText.text;
        if([prefix length] > 3){
            [self searchAddress:prefix];
            self.mDetailText.userInteractionEnabled = NO;
        }
    }
    if(bDatePicker){
        [self onDoneButtonClick];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(bDatePicker){
        [self onDoneButtonClick];
    }
}

//Tableview Delegate, DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([event_type isEqualToString:event_type_9]) return self.vaccineArray.count;
    else if([event_type isEqualToString:event_type_10]) return self.addrArray.count;
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 30;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if([event_type isEqualToString:event_type_9]){
        Vaccine *one = self.vaccineArray[indexPath.row];
        UITableViewCell* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_ItemCell" forIndexPath:indexPath];
        UILabel* titlelb = [tvc viewWithTag:1];
        titlelb.text = one.vName;
        cell = tvc;
        return cell;
    } else if([event_type isEqualToString:event_type_10]){
        AddrModel *one = self.addrArray[indexPath.row];
        UITableViewCell* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_ItemCell" forIndexPath:indexPath];
        UILabel* titlelb = [tvc viewWithTag:1];
        titlelb.text = one.nosaukum;
        cell = tvc;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([event_type isEqualToString:event_type_9]){
        Vaccine *one = self.vaccineArray[indexPath.row];
        self.mVaccineTypeLb.text = one.vName;
        vaccineId = one.vId;
    } else if([event_type isEqualToString:event_type_10]){
        AddrModel *one = self.addrArray[indexPath.row];
        self.mDetailText.text = one.nosaukum;
        if(self.mKeptCheck.on){
            self.mIsoCodeText.text = one.kods;
        } else{
            self.mAddrCodeText.text = one.kods;
        }
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.mTableView.alpha = 0;
    }];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
 {
     return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     if(pickerView == vaccinepicker){
         return self.vaccineArray.count;
     } else if(pickerView == addresspicker){
         return self.addrArray.count;
     } else{
         return 0;
     }
}
// The data to return for the row and component (column) that's being passed in
 - (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == vaccinepicker){
        Vaccine *one = self.vaccineArray[row];
        return one.vName;
    } else if(pickerView == addresspicker){
        AddrModel *one = self.addrArray[row];
        return one.nosaukum;
    } else{
        return nil;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == vaccinepicker) {
        Vaccine *one = self.vaccineArray[row];
        vaccineId = one.vId;
        self.mVaccineTypeLb.text = one.vName;
    } else if(pickerView == addresspicker){
        AddrModel *one = self.addrArray[row];
        self.mDetailText.text = one.nosaukum;
        if(self.mKeptCheck.on){
            self.mIsoCodeText.text = one.kods;
        } else{
            self.mAddrCodeText.text = one.kods;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showVaccinePicker{
    if(bDatePicker){
        [self onDoneButtonClick];
    }
    vaccinepicker = [[UIPickerView alloc] init];
    vaccinepicker.delegate = self;
    vaccinepicker.dataSource = self;
    vaccinepicker.showsSelectionIndicator = YES;
    vaccinepicker.backgroundColor = [UIColor whiteColor];
    [vaccinepicker setValue:[UIColor blackColor] forKey:@"textColor"];
    vaccinepicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    vaccinepicker.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:vaccinepicker];
    vaccineTool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 50)];
    vaccineTool.barStyle = UIBarStyleDefault;
    vaccineTool.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onChooseVaccineClick)]];
    [vaccineTool sizeToFit];
    [self.view addSubview:vaccineTool];
}

-(void)onChooseVaccineClick{
    [vaccineTool removeFromSuperview];
    [vaccinepicker removeFromSuperview];
}

-(void)showAddressPicker{
    if(bDatePicker){
        [self onDoneButtonClick];
    }
    addresspicker = [[UIPickerView alloc] init];
    addresspicker.delegate = self;
    addresspicker.dataSource = self;
    addresspicker.showsSelectionIndicator = YES;
    addresspicker.backgroundColor = [UIColor whiteColor];
    [addresspicker setValue:[UIColor blackColor] forKey:@"textColor"];
    addresspicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    addresspicker.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:addresspicker];
    addrTool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 50)];
    addrTool.barStyle = UIBarStyleDefault;
    addrTool.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onChooseAddressClick)]];
    [addrTool sizeToFit];
    [self.view addSubview:addrTool];
}

-(void)onChooseAddressClick {
    [addrTool removeFromSuperview];
    [addresspicker removeFromSuperview];
}

-(void)showDatePicker{

    picker = [[UIDatePicker alloc] init];
    picker.backgroundColor = [UIColor whiteColor];
    [picker setValue:[UIColor blackColor] forKey:@"textColor"];

    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.minuteInterval = 30;
    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"lv"];
    if(bSDate){
        [picker setDate:[NSDate date]];
    } else if([event_type isEqualToString:event_type_8]){
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *someDate = [cal dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate date] options:0];
        [picker setDate:someDate];
        [picker setMinimumDate:[NSDate date]];
    } else if([event_type isEqualToString:event_type_9]){
        NSCalendar *calNext = [NSCalendar currentCalendar];
        NSDate *nextDate = [calNext dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:0];
        NSDate *limitDate = [calNext dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
        [picker setDate:nextDate];
        [picker setMinimumDate:limitDate];
    }    

    [picker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    picker.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:picker];

    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 50)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButtonClick)]];
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
    bDatePicker = YES;
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dtFmt = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dtFmt setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString *formattedDate1 = [dateFormatter1 stringFromDate:picker.date];
    NSString *strdate=[[NSString alloc]initWithString:formattedDate1];
    NSString *fmtDate = [dtFmt stringFromDate:picker.date];
    NSString *sdate=[[NSString alloc]initWithString:fmtDate];

    if(bSDate){
        self.mStartDateTxt.text = sdate;
        sDTime = strdate;
    } else if([event_type isEqualToString:event_type_8]){
        self.mEndDateTxt.text = sdate;
        eDTime = strdate;
    } else if([event_type isEqualToString:event_type_9]){
        self.mNextDateTxt.text = sdate;
        nDTime = strdate;
    }
}

-(void)onDoneButtonClick {
    [toolbar removeFromSuperview];
    [picker removeFromSuperview];
    bSDate = NO;
    bDatePicker = NO;
}

- (void)searchAddress:(NSString *)prefix{
    [NetworkManager getAddresses:g_user.sessionId preTxt:prefix success:^(NSData *data){
        NSError *parseError = nil;
        NSDictionary *dict  = [XMLReader dictionaryForXMLData:data error:&parseError];
        if(parseError == nil){
            NSDictionary *allDic = [dict objectForKey:@"s:Envelope"];
            NSDictionary *bodyDic = [allDic objectForKey:@"s:Body"];
            NSDictionary *resDic = [bodyDic objectForKey:@"MekletAdresiResponse"];
            NSDictionary *resultDic = [resDic objectForKey:@"MekletAdresiResult"];
            if(resultDic)
            {
                [self.addrArray removeAllObjects];
                NSArray *addr_array = [resultDic objectForKey:@"b:AdresesDati"];
                for (NSDictionary *d in addr_array) {
                    AddrModel *one = [[AddrModel alloc] initWithDictionary:d];
                    [self.addrArray addObject:one];
                }
                if([self.addrArray count] > 0){
                    /*[self.mTableView reloadData];
                    [UIView animateWithDuration:0.25f animations:^{
                        self.mTableView.alpha = 1;
                    }];*/
                    [self showAddressPicker];
                } else{
                    self.mDetailText.userInteractionEnabled = YES;
                }
            }
            
        }
    } failure:^(NSError *err){
        self.mDetailText.userInteractionEnabled = YES;
    }];
}
    
- (IBAction)onSaveClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reģistrēt notikumu"
                                                                   message:@"Nospiežot Jā, tiks reģistrēts aizpildītais notikums. Val vēlaties reģistrēt notikumu?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Jā"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self registerAnimalEvent];
                                                       }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Nē"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           [self refreshLayout];
                                                       }];
    [alert addAction:noAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)registerAnimalEvent{
    if([self.animalObj.idString length] > 0){
         NSArray *str_array = [self.animalObj.idString componentsSeparatedByString:@" - "];
        [SVProgressHUD show];
        [NetworkManager createEventRequest:g_user.sessionId animalId:str_array[0] eventType:event_type eventStart:sDTime eventEnd:eDTime eventNext:nDTime vaccineType:vaccineId certId:self.mCertText.text keptBoard:self.mKeptCheck.on isoCode:self.mIsoCodeText.text addrCode:self.mAddrCodeText.text addrDetail:self.mDetailText.text comment:self.mCommentText.text success:^(NSData *data){
            [SVProgressHUD dismiss];
            NSError *parseError = nil;
            NSDictionary *dict  = [XMLReader dictionaryForXMLData:data error:&parseError];
            if(parseError == nil){
                NSDictionary *allDic = [dict objectForKey:@"s:Envelope"];
                NSDictionary *bodyDic = [allDic objectForKey:@"s:Body"];
                NSDictionary *resDic = [bodyDic objectForKey:@"IzveidotNotikumuResponse"];
                NSDictionary *resultDic = [resDic objectForKey:@"IzveidotNotikumuResult"];
                if(resultDic)
                {
                    /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:@"Notikums ir pievienots un veiksmīgi saglabāts."
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"jā"
                                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                           NSLog(@"You pressed button one");
                                                                       }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];*/
                    g_homemode = HOME_AAS;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } else{
                //[self showAlertView:[TSLanguageManager localizedString:@"Error"] Message:parseError.localizedDescription];
            }
            
        }
          failure:^(NSError *err){
              [SVProgressHUD dismiss];
              NSData *errData = [err.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
              NSError *parseError = nil;
              NSDictionary *errDic  = [XMLReader dictionaryForXMLData:errData error:&parseError];
              if(parseError == nil){
                  NSDictionary *allErr = [errDic objectForKey:@"s:Envelope"];
                  NSDictionary *bodyErr = [allErr objectForKey:@"s:Body"];
                  NSDictionary *faultErr = [bodyErr objectForKey:@"s:Fault"];
                  //NSDictionary *codeErr = [faultErr objectForKey:@"s:Code"];
                  //NSDictionary *valErr = [codeErr objectForKey:@"s:Value"];
                  //NSString *errCode = [valErr objectForKey:@"text"];
                  NSDictionary *reasonErr = [faultErr objectForKey:@"s:Reason"];
                  NSDictionary *reason = [reasonErr objectForKey:@"s:Text"];
                  NSString *reasonTxt = [reason objectForKey:@"text"];
                  //NSString *errTxt = [NSString stringWithFormat:@"%@\n%@", errCode, reasonTxt];
                  if(reasonTxt == nil){
                      reasonTxt = @"Taimauta";
                      [self showAlertView:SERVER_URL Message:reasonTxt];
                      return ;
                  }
                  [self showErrorMsg:reasonTxt];
              } else{
                  [self showAlertView:@"Kļūda" Message:err.localizedDescription];
                  //[self showAlertView:SERVER_URL Message:err.localizedDescription];
              }
          }];
    }
}
    
- (IBAction)onCancelClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Atcelt notikuma reģistrēšanu"
                                                                   message:@"Nospiežot Jā, notikuma reģistrēšana tiks atcelts. Val vēlaties atcelt notikumu?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Jā"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           /*event_type = event_type_1;
                                                           self.mStartDateTxt.text = @"";
                                                           self.mEndDateTxt.text = @"";
                                                           self.mNextDateTxt.text = @"";
                                                           self.mCertText.text = @"";
                                                           [self.mKeptCheck setOn:NO];
                                                           self.mIsoCodeText.text = @"";
                                                           self.mAddrCodeText.text = @"";
                                                           self.mDetailText.text = @"";
                                                           self.mCommentText.text = @"";
                                                           [self refreshLayout];*/
                                                            g_homemode = HOME_AAS;
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                       }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Nē"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           [self refreshLayout];
                                                       }];
    [alert addAction:noAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onKeptClick:(id)sender {
    if(self.mKeptCheck.on){
        [self.mKeptCheck setOn:NO];
    } else{
        [self.mKeptCheck setOn:YES];
    }
    [self refreshLayout];
}

- (IBAction)onSDateClick:(id)sender {
    bSDate = YES;
    [self showDatePicker];
}

- (IBAction)onEDateClick:(id)sender {
    [self showDatePicker];
}

- (IBAction)onVaccineClick:(id)sender {
    if(self.vaccineArray.count > 0){
        /*[self.mTableView reloadData];
        [UIView animateWithDuration:0.25f animations:^{
            self.mTableView.alpha = 1;
        }];*/
        [self showVaccinePicker];
    }
}

- (IBAction)onNDateClick:(id)sender {
    [self showDatePicker];
}

- (IBAction)onEditCancel:(id)sender {
    [addrTool removeFromSuperview];
    [addresspicker removeFromSuperview];
    
    self.mDetailText.userInteractionEnabled = YES;
    self.mDetailText.text = @"";
}

#pragma mark - LMJDropdownMenu DataSource
- (NSUInteger)numberOfOptionsInDropdownMenu:(LMJDropdownMenu *)menu{
    if (menu == menuEvent) {
        return self.typeArray.count;
    } else {
        return 0;
    }
}
- (CGFloat)dropdownMenu:(LMJDropdownMenu *)menu heightForOptionAtIndex:(NSUInteger)index{
    if (menu == menuEvent) {
        return 36;
    } else {
        return 0;
    }
}
- (NSString *)dropdownMenu:(LMJDropdownMenu *)menu titleForOptionAtIndex:(NSUInteger)index{
    if (menu == menuEvent) {
        return self.typeArray[index];
    } else {
        return @"";
    }
}
- (UIImage *)dropdownMenu:(LMJDropdownMenu *)menu iconForOptionAtIndex:(NSUInteger)index{
    return nil;
}
#pragma mark - LMJDropdownMenu Delegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{
    if (menu == menuEvent) {
        //NSLog(@"你选择了(you selected)：menu1，index: %ld - title: %@", index, title);
        event_type = self.typeArray[index];
        [self refreshLayout];
    }
}
    
- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    
}
    
- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    
}

- (void) showAlertView:(NSString*)title
               Message:(NSString*)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"labi"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           NSLog(@"You pressed button one");
                                                       }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showErrorMsg:(NSString*)errCode{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Kļūda" message:errCode preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"labi" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // action 1
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
