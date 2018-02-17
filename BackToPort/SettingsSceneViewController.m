//
//  SettingsSceneViewController.m
//  BackToPort
//
//  Created by MacBookPro on 12/01/2017.
//
//

#import "SettingsSceneViewController.h"

#define kHomeLatitude @"SavedHomeLat"
#define kHomeLongitude @"SavedHomeLon"
#define kTwoLatitude @"SavedTwoLat"
#define kTwoLongitude @"SavedTwoLon"
#define kThreeLatitude @"SavedThreeLat"
#define kThreeLongitude @"SavedThreeLon"
#define kHeadingToggle @"HeadingOnOff"

@interface SettingsSceneViewController ()
@end

@implementation SettingsSceneViewController

@synthesize SaveButton, HomeOtherToggle, HeadingSwitch;
@synthesize lat, lon;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locManTwo = [[CLLocationManager alloc] init];
    locManTwo.delegate = self;
    locManTwo.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locManTwo.distanceFilter = 500;
    
    [locManTwo startUpdatingLocation];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    HeadingSwitch.on = [userDefaults boolForKey:kHeadingToggle];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        [manager stopUpdatingLocation];
        //[locManTwo release];
        locManTwo = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation.horizontalAccuracy >= 0) {
        lat = newLocation.coordinate.latitude;
        lon = newLocation.coordinate.longitude;
    }
}

- (IBAction)SaveHeading:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:HeadingSwitch.on forKey:kHeadingToggle];
}


- (IBAction)SaveLocation:(id)sender {
    
    NSString *title;
    
    if (HomeOtherToggle.selectedSegmentIndex == 0) {
        title = @"Save Home Port Location";
    } else if (HomeOtherToggle.selectedSegmentIndex == 1) {
        title = @"Save Port Two Location";
    } else if (HomeOtherToggle.selectedSegmentIndex == 2) {
        title = @"Save Port Three Location";
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:@"Are You Sure?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:  UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self saveCurrentLocation];
                                                       }];
    [alert addAction:defaultAction];
    [alert addAction:saveAction];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)saveCurrentLocation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (HomeOtherToggle.selectedSegmentIndex == 0) {
        [userDefaults setDouble:lat forKey:kHomeLatitude];
        [userDefaults setDouble:lon forKey:kHomeLongitude];
        [userDefaults synchronize];
    } else if (HomeOtherToggle.selectedSegmentIndex == 1) {
        [userDefaults setDouble:lat forKey:kTwoLatitude];
        [userDefaults setDouble:lon forKey:kTwoLongitude];
        [userDefaults synchronize];
    } else if (HomeOtherToggle.selectedSegmentIndex == 2) {
        [userDefaults setDouble:lat forKey:kThreeLatitude];
        [userDefaults setDouble:lon forKey:kThreeLongitude];
        [userDefaults synchronize];
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Back To Port"
                                                                   message:@"Location Saved"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Continue" style:  UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
