//
//  MapSceneViewController.m
//  BackToPort
//
//  Created by MacBookPro on 13/01/2017.
//
//

#import "MapSceneViewController.h"

@interface MapSceneViewController ()
@end

@implementation MapSceneViewController


@synthesize lonMap, latMap, map;

- (void)viewDidLoad {
    
    locManThree = [[CLLocationManager alloc] init];
    locManThree.delegate = self;
    locManThree.desiredAccuracy = kCLLocationAccuracyBest;
    locManThree.distanceFilter = 500;
    
    [locManThree startUpdatingLocation];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        [manager stopUpdatingLocation];
        locManThree = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation.horizontalAccuracy >= 0) {
        latMap = newLocation.coordinate.latitude;
        lonMap = newLocation.coordinate.longitude;
    
        CLLocation *DisplayMap = [[CLLocation alloc] initWithLatitude:latMap longitude:lonMap];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(DisplayMap.coordinate, 1000, 1000);
        [map setRegion:region animated:YES];
    }
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
