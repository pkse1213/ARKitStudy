//
//  ApplyingForcesViewController.swift
//  PlaneDetection
//
//  Created by 박세은 on 2018. 11. 22..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
import ARKit
import SceneKit



class ApplyingForcesViewController: UIViewController, ARSCNViewDelegate  {
    @IBOutlet weak var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    var boxes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.delegate = self
        let scene = SCNScene()
        self.sceneView.scene = scene
        self.sceneView.showsStatistics = false
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
      
        // double tap을 이용한 제스쳐
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2 // 2번 탭할 때라고 지정해주는 것
        
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc func doubleTapped(_ recognizer: UITapGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        // 이건 사용자 화면의 2d상의 터치값임
        let touch = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touch, options: [:])
        
        if !hitResults.isEmpty {
            guard let hitResult = hitResults.first else {return}
            
            // vector3은 방향을 정해 주는 것, asImplusesms는 공을 차는 것 같은 것
            // asImpluse : false일 때 가속화 하는 것
            
            let node = hitResult.node
//            node.physicsBody?.applyForce(SCNVector3(hitResult.worldCoordinates.x, hitResult.worldCoordinates.y, hitResult.worldCoordinates.z), asImpulse: true)
            
            // y를 2.0으로 함으로써 점핑되는 것!!
            node.physicsBody?.applyForce(SCNVector3(hitResult.worldCoordinates.x * Float(2.0), 2.0, hitResult.worldCoordinates.z * Float(2.0)), asImpulse: true)
        }
        
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {return}
            addBox(hitResult: hitResult)
        }
        
    }
    
    private func addBox(hitResult: ARHitTestResult) {
        let boxGeometry = SCNBox(width: 0.2, height: 0.2, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        boxGeometry.materials = [material]
        
        let boxNode = SCNNode(geometry: boxGeometry)
        
        // .dynamic .static .kinematic 이 있음
        // .dynamic의 경우 위에서 떨어지는데 각 node간의 충돌도 일어남
        boxNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        
        /*
         추가부분 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         서로 다른 categoryBitMask끼리는 서로 충돌이 일어난다
         각 node의 SCNPhysicsBody가 .static이면 그대로 멈춰있고 .dynamic이면 .static인 것에 부딪혀서 위에 올라가 있지 않는 한 떨어진다
         각 node의 physicsBody?.categoryBitMas가 다른 것 끼리는 충돌이 일어난다
         */
        boxNode.physicsBody?.categoryBitMask = BoxType.box.rawValue
        
        
        // y값에 + Float(boxGeometry.height/2)를 해줘야 평면ㅍ 위에 올라옴 안그러면 관통?함
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + Float(0.5), hitResult.worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    // renderer 함수 추가!!
    // didAdd fun는 어떤 anchor를 찾을 때마다 호출됨 (plane등등)
    // node와 anchor가 넘어옴
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { (plane) -> Bool in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil {
            return
        }
        // 만약에 원래 있는 plane이면 확장시켜서 update시키겠다!!
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    
}
