//
//  ViewController.m
//  BaiduMap
//
//  Created by Edward on 16/9/28.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "CustomAnnotationView.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<BMKMapViewDelegate>
/**
 *  添加自定义标注的按钮
 */
@property (nonatomic) UIButton *testButton;
/**
 *  控制自定义标注view旋转的按钮
 */
@property (nonatomic) UIButton *rotationButton;

@end

@implementation ViewController{
    BMKMapView * _mapView;
    BMKPointAnnotation *customAnnotation;
    CustomAnnotationView *newAnnotationView;
}

#pragma mark - BMKMapView Delegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{

}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        return polygonView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (annotation == customAnnotation) {
        newAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        return newAnnotationView;
    }
    return nil;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [self testButton];
    [self rotationButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 methods

- (void)createOverlay{
    CLLocationCoordinate2D annotationCoor = {39.92,116.46};
    customAnnotation = [[BMKPointAnnotation alloc] init];
     customAnnotation.coordinate = annotationCoor;
    [_mapView addAnnotation:customAnnotation];
}

- (void)randonRotation{
    newAnnotationView.imageView.transform = CGAffineTransformMakeRotation(rand() % 360 - 180);
}

#pragma mark - lazy load

- (UIButton *)testButton {
	if(_testButton == nil) {
		_testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(10, 30, 200, 50);
        _testButton.frame = frame;
        [self.view addSubview:_testButton];
        [_testButton setTitle:@"添加自定义标注" forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_testButton setBackgroundColor:[UIColor purpleColor]];
        [_testButton addTarget:self action:@selector(createOverlay) forControlEvents:UIControlEventTouchUpInside];
        
	}
	return _testButton;
}

- (UIButton *)rotationButton {
	if(_rotationButton == nil) {
        _rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(230, 30, 100, 50);
        _rotationButton.frame = frame;
        [self.view addSubview:_rotationButton];
        [_rotationButton setTitle:@"随便旋转" forState:UIControlStateNormal];
        [_rotationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotationButton setBackgroundColor:[UIColor purpleColor]];
        [_rotationButton addTarget:self action:@selector(randonRotation) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rotationButton;
}

@end
