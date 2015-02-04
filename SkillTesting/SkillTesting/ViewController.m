//
//  ViewController.m
//  SkillTesting
//
//  Created by LoveStar_PC on 2/4/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

#import "Define_Global.h"
#import "DataModelForPins.h"
#import "PinView.h"

@interface ViewController ()<GMSMapViewDelegate, CLLocationManagerDelegate>
{
    UIScrollView * scrollView;
    NSMutableArray *arrayViewsForPin;
    
}
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView * imgBack = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgBack.image = [UIImage imageNamed:@"BG - Blur.jpg"];
    [self.view addSubview:imgBack];

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:51.055
                                                            longitude:-113.96
                                                                 zoom:10];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 20, SCREEN_WIDTH * 0.95, SCREEN_HEIGHT * 2 / 3 - 20) camera:camera];
    self.mapView.center = CGPointMake(SCREEN_WIDTH / 2, self.mapView.center.y);
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.view addSubview:self.mapView];
    
    
    ///////////// Test Pins //////////////////
    for (NSInteger i = 0; i < 4; i ++) {
        GMSMarker *marker_test = [[GMSMarker alloc] init];
        marker_test.position = CLLocationCoordinate2DMake(52.494516 + i * 0.1, -2.170441 + i / 2 * 0.1);
        marker_test.title = @"Test";
        marker_test.snippet = [NSString stringWithFormat:@"%d", i];
        marker_test.map = self.mapView;

    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    //    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    self.locationManager.delegate = self;
    //    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 3)];
    scrollView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - scrollView.frame.size.height / 2);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    [scrollView setShowsHorizontalScrollIndicator:YES];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.height * arrayViewsForPin.count, scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    
    arrayViewsForPin = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    NSLog(@"lat = %f", position.target.latitude);
    NSLog(@"long = %f", position.target.longitude);
    
}

- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    //    NSLog(@"lat = %f", mapView.camera.target.latitude);
    //    NSLog(@"long = %f", mapView.camera.target.longitude);
}
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 * MULTIPLY_VALUE, 150 * MULTIPLY_VALUE)];
//    view.backgroundColor = [UIColor whiteColor];
//    view.alpha = 0.8;
//    view.layer.cornerRadius = 10 * MULTIPLY_VALUE;
//    
//    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * MULTIPLY_VALUE, 20 * MULTIPLY_VALUE)];
//    [title setText:marker.title];
//    [title setFont:[UIFont systemFontOfSize:18.0 * MULTIPLY_VALUE]];
//    [title setTextAlignment:NSTextAlignmentCenter];
//    [title setTextColor:[UIColor brownColor]];
//    
//    
//    [view addSubview:title];
//    
//    //    [view setBackgroundColor:[UIColor whiteColor]];
//    return view;
//}/**/
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
//    BOOL flagExist = NO;
//    for ( NSInteger i = 0; i < arrayViewsForPin.count; i ++) {
//        PinView * theView = arrayViewsForPin[i];
//        
//        if (theView.pinID == marker.snippet.integerValue) {
//            [theView setSelectedWithFlag:YES];
//            flagExist = YES;
//        }
//        else
//        {
//            [theView setSelectedWithFlag:NO];
//        }
//    }
    if (![self setSelectWithIndex:marker.snippet.integerValue]) {
        GMSGeocoder *geocoder = [GMSGeocoder geocoder];
        [geocoder reverseGeocodeCoordinate:marker.position
                         completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
                             
                             DataModelForPins * newDataForPins = [[DataModelForPins alloc] init];
                             newDataForPins.streetAddress = response.firstResult.thoroughfare;
                             newDataForPins.city = response.firstResult.locality;
                             newDataForPins.state = response.firstResult.administrativeArea;
                             newDataForPins.title = @"UK Headquarters";
                             newDataForPins.phoneNumber = @"+44 (0) 1202 621511";
                             
                             if (![self setSelectWithIndex:marker.snippet.integerValue]) {
                                 PinView * newPin = [[PinView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT / 3, SCREEN_WIDTH / 3)];
                                 newPin.center = CGPointMake(newPin.frame.size.width * (arrayViewsForPin.count + 0.5), newPin.frame.size.height / 2);
                                 newPin.pinID = marker.snippet.integerValue;
                                 [newPin setContentWithData:newDataForPins];
                                 [scrollView addSubview:newPin];
                                 [arrayViewsForPin addObject:newPin];
                                 
                                 [self setSelectWithIndex:marker.snippet.integerValue];
                                 scrollView.contentSize = CGSizeMake(scrollView.frame.size.height * arrayViewsForPin.count, scrollView.frame.size.height);
                             }
                         }];
    }
    return NO;
}
- (BOOL) setSelectWithIndex:(NSInteger) selectID
{
    BOOL resultExist = NO;
    for (PinView * theView in arrayViewsForPin) {
        if (theView.pinID == selectID) {
            [theView setSelectedWithFlag:YES];
            resultExist = YES;
            [UIView animateWithDuration:0.6 animations:^{
                [scrollView setContentOffset:CGPointMake([arrayViewsForPin indexOfObject:theView] * theView.frame.size.width, 0) animated:YES]; 
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [theView setSelectedWithFlag:NO];
        }
    }
    return resultExist;
}
/*- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker
 {
 UIView * view = [[UIView alloc] init];
 
 return view;
 
 }*/

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}


- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    
    CLLocationCoordinate2D myLocation = self.mapView.myLocation.coordinate;
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.0f];  // 3 second animation
    
    GMSCameraPosition *camera =
    [[GMSCameraPosition alloc] initWithTarget:myLocation
                                         zoom:16
                                      bearing:50
                                 viewingAngle:60];
    [mapView animateToCameraPosition:camera];
    [CATransaction commit];
    
    return YES;
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    NSLog(@"didUpdateToLocation: %@", newLocation);
    //    CLLocation *currentLocation = newLocation;
    //    return;
    static BOOL flagInit = NO;
    
    if (!flagInit)
    {
        flagInit = YES;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:3.0f];  // 3 second animation
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:12.0];
        [self.mapView animateToCameraPosition:camera];
        [CATransaction commit];
        
        [self.locationManager stopUpdatingLocation];
    }
}

@end
