//
//  ViewController.m
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking/AFNetworking.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "ActivityView.h"
#import "BluetoothBarButtonItem.h"
#import "UserBarButtonItem.h"
#import "EADSessionController.h"
#import "ScannerViewController.h"
#import "API.h"
#import "common/Config.h"
#import "AppDelegate.h"
#import "common/Common.h"
#import "EventViewController.h"
#import "common/NetworkManager.h"
#import <SVProgressHUD.h>
#import <SHXMLParser.h>
#import "common/XMLReader.h"
//Models
#import "AnimalObject.h"
#import "AnimalObj.h"

@interface HomeViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
    BluetoothBarButtonItemDelegate, UserBarButtonItemDelegate, ScannerViewControllerDelegate>{
        BOOL bAAS;
        NSInteger nSection;
        NSInteger nOldMode;
    }
    
//IB
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet ActivityView *activityView;
@property (weak, nonatomic) IBOutlet UserBarButtonItem *userBarButtonItem;
@property (weak, nonatomic) IBOutlet BluetoothBarButtonItem *bluetoothBarButtonItem;
//Variables
@property (nonatomic) NSMutableArray *tableData;
@property (nonatomic) EADSessionController *EASessionController;
@property (nonatomic) RLMResults *animalObjects;

//Flags
@property (nonatomic) BOOL deviceConnected;
@property (nonatomic) BOOL useFlash;
@property (nonatomic) BOOL bHomeAnimal;


@end

@implementation HomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.userBarButtonItem.delegate = self;
    g_userBarButtonItem = self.userBarButtonItem;
    g_homemode = HOME_INIT;
    nOldMode = HOME_INIT;
    self.bHomeAnimal = NO;
	[self setupController];
}

-(void)viewDidAppear:(BOOL)animated
{
    bAAS = NO;
    nSection = 0;
    [self refreshLayout];
	self.EASessionController = [EADSessionController sharedController];
	NSArray *connectedAccessories = [EAAccessoryManager sharedAccessoryManager].connectedAccessories;
	for (int i = 0; i < connectedAccessories.count; i++) {
		EAAccessory *dict = connectedAccessories[i];
		if (dict.manufacturer && [dict.manufacturer containsString:@"Allflex"]) {
			self.deviceConnected = YES;
			EAAccessory *connectedAccessory = dict;
			[self.EASessionController setupControllerForAccessory:connectedAccessory
											   withProtocolString:@"com.allflex-europe.lpr"];
			[self.bluetoothBarButtonItem setCustomState:YES];
		}
	}

	if (self.useFlash) {
		Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
		if (captureDeviceClass != nil) {
			AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
			if ([device hasTorch] && [device hasFlash]){
				[device lockForConfiguration:nil];
				[device setTorchMode:AVCaptureTorchModeOn];
				[device setFlashMode:AVCaptureFlashModeOn];
				[device unlockForConfiguration];
			}
		}
	}
}

-(void)refreshLayout{
    //user login state
    if(g_bLogin){
        [self.userBarButtonItem setCustomState:YES];
    } else{
        [self.userBarButtonItem setCustomState:NO];
    }
    
    if(g_homemode == HOME_INIT){
        self.searchBar.text = @"";
        [UIView animateWithDuration:0.25f animations:^{
            self.contentView.alpha = 1;
            self.mResultView.alpha = 0;
            self.mLoginView.alpha = 0;
        }];
    }else if(g_homemode == HOME_AAS){
        [UIView animateWithDuration:0.25f animations:^{
            self.contentView.alpha = 0;
            self.mResultView.alpha = 1;
            self.mLoginView.alpha = 0;
            if(g_bLogin && self.bHomeAnimal){
                [self.mAASBtn setHidden:NO];
            } else{
                [self.mAASBtn setHidden:YES];
            }
        }];
    } else if(g_homemode == HOME_LOGIN){
        [UIView animateWithDuration:0.25f animations:^{
            self.contentView.alpha = 0;
            self.mResultView.alpha = 0;
            self.mLoginView.alpha = 1;
        }];
        [self.mCancelBtn setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Targets
- (IBAction)footerButtonPressed:(UIButton *)sender {
	[self performSegueWithIdentifier:@"homeToScanner" sender:nil];
}

-(void)accessoryDidConnect:(NSNotification *)notification
{
	self.deviceConnected = YES;
	EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
	[self.EASessionController setupControllerForAccessory:connectedAccessory
								   withProtocolString:@"com.allflex-europe.lpr"];
	[self.bluetoothBarButtonItem setCustomState:YES];
}

-(void)accessoryDidDisconnect:(NSNotification *)notification
{
	self.deviceConnected = NO;
	[self.EASessionController closeSession];
	[self.bluetoothBarButtonItem setCustomState:NO];
}

-(void)sessionDataReceived:(NSNotification *)notification
{
	
	self.searchBar.text = @"";
	NSString *processedString = @"";
	if (notification.userInfo && notification.userInfo[@"string"]) {
		processedString = [self processIDString:notification.userInfo[@"string"] shouldTrim:YES];
	}

	self.searchBar.text = processedString;
	//[self.searchBar setShowsCancelButton:YES animated:NO];

	if(g_bLogin){
        [self getAnimalWithCodeOnSoap:self.searchBar.text];
    } else{
        [self requestAnimalWithCode:self.searchBar.text];
    }
	[self.searchBar resignFirstResponder];

	//UIButton *btnCancel = [self.searchBar valueForKey:@"_cancelButton"];
	//[btnCancel setEnabled:YES];
}

#pragma mark - UserButton delegate
-(void)userButtonDidPressButton:(UIButton *)button
{
    if([SVProgressHUD isVisible]) return;
    if(g_bLogin){
        NSString *msg = [NSString stringWithFormat:@"Jūs esat veiksmīgi autorizēts. Jūsu licences numurs %@", g_user.certificate];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:g_user.personName
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Atcelt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Beigt sessiju" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self logoutRequest];
        }];
        [alert addAction:okAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        nOldMode = g_homemode;
        if([[Common getValueKey:@"remember"] isEqualToString:@"1"]){
            self.mUsername.text = [Common getValueKey:@"remember_user"];
            self.mPassword.text = [Common getValueKey:@"remember_pass"];
        }
        g_homemode = HOME_LOGIN;
        [self refreshLayout];
    }
}

#pragma mark - BluetoothButton delegate
-(void)bluetoothButtonDidPressButton:(UIButton *)button
{
    if([SVProgressHUD isVisible]) return;
	if (!self.deviceConnected) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
																	   message:@"Viedtālrunī ir izslēgts bluetooth vai savienojums ar Allflex skeneri nav iespējams izveidot	"
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Labi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
		[alert addAction:okAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
}

#pragma mark - Search bar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	//[self.searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    nOldMode = g_homemode;
    g_homemode = HOME_INIT;
    [self refreshLayout];
	//[self.searchBar setShowsCancelButton:NO animated:NO];
	self.searchBar.text = nil;
	[self.searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(g_bLogin){
        [self getAnimalWithCodeOnSoap:searchBar.text];
    } else{
        [self requestAnimalWithCode:searchBar.text];
    }
	[self.searchBar resignFirstResponder];

	//UIButton *btnCancel = [self.searchBar valueForKey:@"_cancelButton"];
	//[btnCancel setEnabled:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
}

#pragma mark - Data
-(void)requestAnimalWithCode:(NSString *)code
{
    self.bHomeAnimal = NO;
	[self.activityView startAnimatingAnimated:YES delay:0];
	//Create urlString and postData
    NSString *urlString = @"https://193.84.184.14:8443/ajax/w_ajax_lv.php";//www.ldc.gov.lv
	NSDictionary *postData = [[Globals sharedGlobals] defaultPostDataWithAnimalCode:code];

	//Error message;
	__block NSString *errorMessage = @"";

	//Create request
	AFHTTPSessionManager *manager = [[API sharedManager] networkManager];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
	manager.requestSerializer = [AFHTTPRequestSerializer serializer];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //[manager.requestSerializer setTimeoutInterval:10];

	[manager POST:urlString parameters:postData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSData *data = [[NSData alloc]initWithData:responseObject];
		NSError *error;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
															 options:kNilOptions
															   error:&error];
		[self.activityView stopAnimatingAnimated:YES delay:0];
		if (json[@"error"]) {
			[self alertViewWithTitle:@"Kļūda" text:json[@"error"]];
		} else {
			[self parseData:json];

			self.animalObjects = nil;
			[self reloadTableViewAndShow:YES];
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		if (error.code == NSURLErrorNotConnectedToInternet) {
			errorMessage = @"Lai lietototu aplikāciju, lūdzu, aktivizējiet internetu";
		} else if (error.code == NSURLErrorTimedOut) {
			errorMessage = @"Vājš interneta pieslēgums vai arī LDC sistēma šobrīd nav pieejama. Lūdzu, mēģiniet vēlreiz";
		} else {
			errorMessage = @"Notika kļūda, lūdzu, mēģiniet vēlreiz";
		}

		//[self alertViewWithTitle:@"Kļūda" text:errorMessage];
        [self alertViewWithTitle:urlString text:errorMessage];

		[self.activityView stopAnimatingAnimated:YES delay:0];
	}];
}

-(void)getAnimalWithCodeOnSoap:(NSString *)code{
    self.bHomeAnimal = NO;
    //Error message;
    __block NSString *errorMessage = @"";
    
    [SVProgressHUD show];
    [NetworkManager getAnimalData:g_user.sessionId AnimalID:code success:^(NSData *data){
        [SVProgressHUD dismiss];
        [self.activityView stopAnimatingAnimated:YES delay:0];
        NSError *parseError = nil;
        NSDictionary *dict  = [XMLReader dictionaryForXMLData:data error:&parseError];
        if(parseError == nil){
            NSDictionary *allDic = [dict objectForKey:@"s:Envelope"];
            if(allDic == nil){
                [self showAlertView:@"Kļūda" Message:@"Servera savienojuma kļūda!"];
            } else{
                NSDictionary *bodyDic = [allDic objectForKey:@"s:Body"];
                NSDictionary *responseDic = [bodyDic objectForKey:@"GetDzivniekaDatiResponse"];
                NSDictionary *resultDic = [responseDic objectForKey:@"GetDzivniekaDatiResult"];
                AnimalObj* oneObj = [[AnimalObj alloc] initWithData:resultDic];
                
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteAllObjects];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                
                oneObj.uniqueID = 0;
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] addObject:oneObj];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                
                if([oneObj.animalType.lowercaseString isEqualToString:@"suns"] ||
                   [oneObj.animalType.lowercaseString isEqualToString:@"kaķis"] ||
                   [oneObj.animalType.lowercaseString isEqualToString:@"sesks"]) //"suns"", or "kaķis" or "sesks"
                {
                    self.bHomeAnimal = YES;
                }
                self.animalObjects = nil;
                [self reloadTableViewAndShow:YES];
                return;
            }
            
        } else{
            [self showAlertView:@"Kļūda" Message:parseError.localizedDescription];
        }
    } failure:^(NSError *err){
        [self.activityView stopAnimatingAnimated:YES delay:0];
          [SVProgressHUD dismiss];
        NSData *errData = [err.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
          NSError *parseError = nil;
          NSDictionary *errDic  = [XMLReader dictionaryForXMLData:errData error:&parseError];
          if(parseError == nil){
              NSDictionary *allErr = [errDic objectForKey:@"s:Envelope"];
              NSDictionary *bodyErr = [allErr objectForKey:@"s:Body"];
              NSDictionary *faultErr = [bodyErr objectForKey:@"s:Fault"];
              NSDictionary *reasonErr = [faultErr objectForKey:@"s:Reason"];
              NSDictionary *reason = [reasonErr objectForKey:@"s:Text"];
              NSString *reasonTxt = [reason objectForKey:@"text"];
              [self showErrorMsg:reasonTxt];
          } else{
              if (err.code == NSURLErrorNotConnectedToInternet) {
                  errorMessage = @"Lai lietototu aplikāciju, lūdzu, aktivizējiet internetu";
              } else if (err.code == NSURLErrorTimedOut) {
                  errorMessage = @"Vājš interneta pieslēgums vai arī LDC sistēma šobrīd nav pieejama. Lūdzu, mēģiniet vēlreiz";
              } else {
                  errorMessage = @"Notika kļūda, lūdzu, mēģiniet vēlreiz";
              }

              [self alertViewWithTitle:getAnimal_header text:errorMessage];
          }
    }];
}

#pragma mark - TableView

-(void)reloadTableViewAndShow:(BOOL)show
{
	[self.tableView reloadData];

    NSString * msg = [NSString stringWithFormat:@"Atrasti dzīvnieki: %ld", self.animalObjects.count];
    self.mResultLabel.text = msg;
	if (show) {
		nOldMode = g_homemode;
        g_homemode = HOME_AAS;
        [self refreshLayout];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(g_bLogin) {
        if(section == 0)
            return 0;
        return 80.0;
    }
	AnimalObject *object = self.animalObjects[section];

	if (section == 0 && !object.isDangerAnimal) {
		return 0;
	}

	return 80.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if(g_bLogin){
        //UIView *headerView = [UIView new];
        //headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
        //headerView.backgroundColor = [UIColor whiteColor];
        return nil;
    } else{
        AnimalObject *object = self.animalObjects[section];

        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
        headerView.backgroundColor = [UIColor whiteColor];

        if (object.isDangerAnimal) {
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor redColor];
            label.text = object.offensive;
            [headerView addSubview:label];
        }

        return headerView;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.animalObjects.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(g_bLogin){
        AnimalObj *object = self.animalObjects[section];
        return object.publicRows.count;
    } else{
        AnimalObject *object = self.animalObjects[section];
        return object.publicRows.count;
    }
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
 
    if(g_bLogin){
        AnimalObj *object = [self.animalObjects objectAtIndex:indexPath.section];
        NSDictionary *dict = object.publicRows[indexPath.row];

        ((UILabel *)[cell.contentView viewWithTag:1]).text = dict[@"title"];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = dict[@"value"];
    } else{
        AnimalObject *object = [self.animalObjects objectAtIndex:indexPath.section];
        NSDictionary *dict = object.publicRows[indexPath.row];

        ((UILabel *)[cell.contentView viewWithTag:1]).text = dict[@"title"];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = dict[@"value"];
    }

	return cell;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nSection = [indexPath section];
}

#pragma mark - ScannerViewController delegate
-(void)scannerViewcontroller:(ScannerViewController *)viewController didCompleteScanningWithResults:(NSString *)results
{
	self.searchBar.text = @"";
	self.searchBar.text = [self processIDString:results shouldTrim:NO];
	[self.searchBar setShowsCancelButton:YES animated:NO];
	
	if(g_bLogin){
        [self getAnimalWithCodeOnSoap:self.searchBar.text];
    } else{
        [self requestAnimalWithCode:self.searchBar.text];
    }
	[self.searchBar resignFirstResponder];

	//UIButton *btnCancel = [self.searchBar valueForKey:@"_cancelButton"];
	//[btnCancel setEnabled:YES];
}

-(void)scannerViewcontroller:(ScannerViewController *)viewController shouldUseFlash:(BOOL)torch
{
	self.useFlash = torch;
}

- (void)parseData:(NSDictionary *)data
{

	//if ([AnimalObject allObjects].count) {
		[[RLMRealm defaultRealm] beginWriteTransaction];
		[[RLMRealm defaultRealm] deleteAllObjects];
		[[RLMRealm defaultRealm] commitWriteTransaction];
	//}

	NSArray *items = data[@"rows"];
	NSInteger uniqueID = 0;
	for (NSDictionary *item in items) {
		[[RLMRealm defaultRealm] beginWriteTransaction];
		AnimalObject *object = [[AnimalObject alloc] initWithData:item];
		object.uniqueID = uniqueID;
        if([object.animalType isEqualToString:@"suns"] ||
           [object.animalType isEqualToString:@"kaķis"] ||
           [object.animalType isEqualToString:@"sesks"]) //"suns"", or "kaķis" or "sesks"
            self.bHomeAnimal = YES;
		[[RLMRealm defaultRealm] addObject:object];
		[[RLMRealm defaultRealm] commitWriteTransaction];

		uniqueID++;
	}
}

#pragma mark - Navigaton
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	ScannerViewController *destinationVC = segue.destinationViewController;
	destinationVC.delegate = self;
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ([device hasTorch] && [device hasFlash]){
		if (device.torchMode == AVCaptureTorchModeOn) {
			destinationVC.torchON = YES;
		} else if (device.torchMode == AVCaptureTorchModeOff) {
			destinationVC.torchON = NO;
		} else {
			destinationVC.torchON = NO;
		}
	}
}

#pragma mark - Lazy load

-(RLMResults *)animalObjects
{
	if (!_animalObjects) {
		_animalObjects = [AnimalObject allObjects];
    }
    if(_animalObjects.count == 0){
        _animalObjects = [AnimalObj allObjects];
    }

	return _animalObjects;
}

#pragma mark - Helpers

-(NSString *)processIDString:(NSString *)idString shouldTrim:(BOOL)trim
{
	NSString *processedString = @"";

	if (trim) {
		idString = [idString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
		idString = [idString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		idString = [idString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
		processedString = idString;
	} else {
		processedString = idString;
	}

	if (idString.length == 22) {
		processedString = [idString substringFromIndex:7];
	}
	
	if (idString.length == 16) {
		processedString = [idString substringFromIndex:1];
	}

	NSString *firstLetter = [idString substringToIndex:1];
	if (idString.length == 12 && [firstLetter isEqualToString:@"0"]) {
		processedString = [NSString stringWithFormat:@"LV%@", idString];
	}

	return processedString;
}

-(void)alertViewWithTitle:(NSString *)title text:(NSString *)text
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
																   message:text
															preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Labi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void)setupController
{
	//Searchbar
	self.searchBar.delegate = self;
	//[self.searchBar setValue:@"Atpakaļ" forKey:@"_cancelButtonText"];

	//Tableview data
	self.tableData = [NSMutableArray new];

	//EA
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];
	[[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];

	self.bluetoothBarButtonItem.delegate = self;

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0;
}
- (IBAction)onLoginCancelClick:(id)sender {
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    g_homemode = nOldMode;
    [self refreshLayout];
}

- (IBAction)onAASClick:(id)sender {
    if(g_bLogin){
        if([self.animalObjects count] > 0){
            AnimalObj *object = self.animalObjects[nSection];
            EventViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_EventViewController"];
            mVC.animalObj = object;
            [self.navigationController pushViewController:mVC animated:YES];
        }
        
    } else{
        if([[Common getValueKey:@"remember"] isEqualToString:@"1"]){
            self.mUsername.text = [Common getValueKey:@"remember_user"];
            self.mPassword.text = [Common getValueKey:@"remember_pass"];
        }
        
        nOldMode = g_homemode;
        g_homemode = HOME_LOGIN;
        [self refreshLayout];
        bAAS = YES;
        //debug
        //EventViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_EventViewController"];
        //[self.navigationController pushViewController:mVC animated:YES];
    }
}
    
- (IBAction)onLoginClick:(id)sender {
    if([self.mUsername.text length]==0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Brīdinājums!"
                                      message:@"Ir jāievada lietotājvārds."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"labi"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    if([self.mPassword.text length]==0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Brīdinājums!"
                                      message:@"Jums jāievada parole."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"labi"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self loginRequest];
}

-(void)loginRequest
{
    [self.mCancelBtn setHidden:YES];
    [SVProgressHUD show];
    [NetworkManager sendLoginRequest:self.mUsername.text Password:self.mPassword.text success:^(NSData *data){
        [SVProgressHUD dismiss];
        NSError *parseError = nil;
        NSDictionary *dict  = [XMLReader dictionaryForXMLData:data error:&parseError];
        if(parseError == nil){
            NSDictionary *allDic = [dict objectForKey:@"s:Envelope"];
            if(allDic == nil){
                [self showAlertView:@"Kļūda" Message:@"Servera savienojuma kļūda!"];
            } else{
                g_bLogin = YES;
                [Common saveValueKey:@"remember" Value:@"1"];
                [Common saveValueKey:@"remember_user" Value:self.mUsername.text];
                [Common saveValueKey:@"remember_pass" Value:self.mPassword.text];
                [self.userBarButtonItem setCustomState:YES];
                    
                NSDictionary *bodyDic = [allDic objectForKey:@"s:Body"];
                NSDictionary *loginDic = [bodyDic objectForKey:@"LoginResponse"];
                NSDictionary *resultDic = [loginDic objectForKey:@"LoginResult"];
                NSDictionary *sessionDic = [resultDic objectForKey:@"b:SessionId"];
                g_user.sessionId = [sessionDic objectForKey:@"text"];
                NSDictionary *personDic = [resultDic objectForKey:@"b:PersonId"];
                g_user.personId = [personDic objectForKey:@"text"];
                NSDictionary *nameDic = [resultDic objectForKey:@"b:PersonName"];
                g_user.personName = [nameDic objectForKey:@"text"];
                NSDictionary *roleDic = [resultDic objectForKey:@"b:UserRole"];
                g_user.userRole = [roleDic objectForKey:@"text"];
                NSDictionary *certDic = [resultDic objectForKey:@"b:CertificateNumber"];
                g_user.certificate = [certDic objectForKey:@"text"];
                
                /*if([self.animalObjects count] > 0 && bAAS){
                    g_homemode = nOldMode;
                    AnimalObject *object = self.animalObjects[nSection];
                    EventViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_EventViewController"];
                    mVC.animalObj = object;
                    [self.navigationController pushViewController:mVC animated:YES];
                } else{*/
                    if([self.searchBar.text length] > 0){
                        [self getAnimalWithCodeOnSoap:self.searchBar.text];
                        return ;
                    }
                    g_homemode = nOldMode;
                    [self refreshLayout];
                //}
                return;
            }
            
        } else{
            [self showAlertView:@"Kļūda" Message:parseError.localizedDescription];
        }
        [Common saveValueKey:@"remember" Value:@"0"];
        [self.mCancelBtn setHidden:NO];
    }
     failure:^(NSError *err){
         [SVProgressHUD dismiss];
         [Common saveValueKey:@"remember" Value:@"0"];
        [self.mCancelBtn setHidden:NO];
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

-(void)logoutRequest{
    [SVProgressHUD show];
    [NetworkManager logoutRequest:g_user.sessionId success:^(NSData *data){
        [SVProgressHUD dismiss];
        NSError *parseError = nil;
        NSDictionary *dict  = [XMLReader dictionaryForXMLData:data error:&parseError];
        if(parseError == nil){
            NSDictionary *allDic = [dict objectForKey:@"s:Envelope"];
            NSDictionary *bodyDic = [allDic objectForKey:@"s:Body"];
            NSDictionary *resDic = [bodyDic objectForKey:@"LogoutResponse"];
            NSDictionary *resultDic = [resDic objectForKey:@"LogoutResult"];
            if(resultDic)
            {
                g_bLogin = false;
                g_homemode = HOME_INIT;
                [self refreshLayout];
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
              [self showErrorMsg:reasonTxt];
          } else{
              //[self showAlertView:[TSLanguageManager localizedString:@"Error"] Message:err.localizedDescription];
          }
      }];
}

- (void) showAlertView:(NSString*)title
               Message:(NSString*)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
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
