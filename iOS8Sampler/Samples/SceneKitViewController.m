//
//  SceneKitViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/17.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Simplified and refactored the Apple's sample "SceneKit State of the Union demo"
//  https://developer.apple.com/wwdc/resources/sample-code/#//apple_ref/doc/uid/TP40014550


#import "SceneKitViewController.h"
@import SceneKit;
@import SpriteKit;


#define kLogoSize 30
#define kLogoPositionZ 1000


@interface SceneKitViewController ()
@property (nonatomic, strong) SCNNode *childNode;
@end


@implementation SceneKitViewController
{
@private
    //references to nodes for manipulation
    SCNNode *_cameraHandle;
    SCNNode *_cameraOrientation;
    SCNNode *_cameraNode;
    SCNNode *_spotLightParentNode;
    SCNNode *_spotLightNode;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setupSceneView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self fadeIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// =============================================================================
#pragma mark - Private

- (void)setupSceneView
{
    SCNView *sceneView = (SCNView *)self.view;
    
    //setup the scene & present it
    sceneView.scene = [self setupScene];
    
    sceneView.backgroundColor = [SKColor blackColor];
    sceneView.jitteringEnabled = YES;
    
    //initial point of view
    sceneView.pointOfView = _cameraNode;
}

- (SCNScene *)setupScene
{
    SCNScene *scene = [SCNScene scene];
    
    // setup emvironments
    [self setupCameraForScene:scene];
    [self setupSpotLight];
    [self setupFloorForScene:scene];
    
    // configure the lighting for the introduction (dark lighting)
    _spotLightNode.light.color = [SKColor blackColor];
    _spotLightNode.position = SCNVector3Make(50, 90, -50);
    _spotLightNode.eulerAngles = SCNVector3Make(-M_PI_2*0.75, M_PI_4*0.5, 0);
    
    [self createChildNodeForScene:scene];
    
    return scene;
}

- (void)setupCameraForScene:(SCNScene *)scene
{
    // |_   cameraHandle
    //   |_   cameraOrientation
    //     |_   cameraNode
    
    //create a main camera
    _cameraNode = [SCNNode node];
    _cameraNode.position = SCNVector3Make(0, 0, 120);
    
    //create a node to manipulate the camera orientation
    _cameraHandle = [SCNNode node];
    _cameraHandle.position = SCNVector3Make(0, 60, 0);
    
    _cameraOrientation = [SCNNode node];
    
    [scene.rootNode addChildNode:_cameraHandle];
    [_cameraHandle addChildNode:_cameraOrientation];
    [_cameraOrientation addChildNode:_cameraNode];
    
    _cameraNode.camera = [SCNCamera camera];
    _cameraNode.camera.zFar = 800;
    _cameraNode.camera.yFov = 55;

    _cameraNode.position = SCNVector3Make(200, -20, kLogoPositionZ+150);
    _cameraNode.eulerAngles = SCNVector3Make(-M_PI_2*0.06, 0, 0);
}

//add a key light to the scene
- (void)setupSpotLight {

    _spotLightParentNode = [SCNNode node];
    _spotLightParentNode.position = SCNVector3Make(0, 90, 20);
    
    _spotLightNode = [SCNNode node];
    _spotLightNode.rotation = SCNVector4Make(1,0,0,-M_PI_4);
    
    _spotLightNode.light = [SCNLight light];
    _spotLightNode.light.type = SCNLightTypeSpot;
    _spotLightNode.light.color = [SKColor colorWithWhite:1.0 alpha:1.0];
    _spotLightNode.light.castsShadow = YES;
    _spotLightNode.light.shadowColor = [SKColor colorWithWhite:0 alpha:0.5];
    _spotLightNode.light.zNear = 30;
    _spotLightNode.light.zFar = 800;
    _spotLightNode.light.shadowRadius = 1.0;
    _spotLightNode.light.spotInnerAngle = 15;
    _spotLightNode.light.spotOuterAngle = 70;
    
    [_cameraNode addChildNode:_spotLightParentNode];
    [_spotLightParentNode addChildNode:_spotLightNode];
}

- (void)setupFloorForScene:(SCNScene *)scene {

    SCNFloor *floor = [SCNFloor floor];
    floor.reflectionFalloffEnd = 0;
    floor.reflectivity = 0;
    
    SCNNode *floorNode = [SCNNode node];
    floorNode.geometry = floor;
    floorNode.geometry.firstMaterial.diffuse.contents = @"wood.png";
    floorNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
    floorNode.geometry.firstMaterial.diffuse.wrapS = SCNWrapModeRepeat;
    floorNode.geometry.firstMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    floorNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    
    [scene.rootNode addChildNode:floorNode];
}

- (void)createChildNodeForScene:(SCNScene *)scene
{
    SCNNode *childNode = [SCNNode nodeWithGeometry:[SCNPlane planeWithWidth:kLogoSize height:kLogoSize]];
    childNode.geometry.firstMaterial.diffuse.contents = @"SamplerIcon.png";
    childNode.geometry.firstMaterial.emission.contents = @"SamplerIcon.png";
    childNode.geometry.firstMaterial.emission.intensity = 0;
    
    childNode.position = SCNVector3Make(200, kLogoSize/2, kLogoPositionZ);
    
    [scene.rootNode addChildNode:childNode];
    
    self.childNode = childNode;
}

//wait, then fade in light
- (void)fadeIn {

    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:1.0];
    [SCNTransaction setCompletionBlock:^{
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:2.5];
        
        _spotLightNode.light.color = [SKColor colorWithWhite:1 alpha:1];
        self.childNode.geometry.firstMaterial.emission.intensity = 0.75;
        
        [SCNTransaction commit];
    }];
    
    _spotLightNode.light.color = [SKColor colorWithWhite:0.001 alpha:1];
    
    [SCNTransaction commit];
}

@end
