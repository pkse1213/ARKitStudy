//
//  LoadingModelsViewController.swift
//  PlaneDetection
//
//  Created by 박세은 on 2018. 11. 22..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class LoadingModelsViewController: UIViewController, ARSCNViewDelegate  {
    @IBOutlet weak var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    
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
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {return}
            addTable(hitResult: hitResult)
        }
        
    }
    
    private func addTable(hitResult: ARHitTestResult) {
        // plnae위에 table 올리기
        // table위를 터치 할 것이다
        let tableScene = SCNScene(named: "art.scnassets/bench.dae")
        let tableNode = tableScene?.rootNode.childNode(withName: "SketchUp", recursively: true)
        // hitResult는 planeNode 위에 존재하는 터치값이므로 그 터치값의 위치를 positoin으로 설정해준다
        tableNode?.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        tableNode?.scale = SCNVector3(0.5,0.5,0.5)
        
        self.sceneView.scene.rootNode.addChildNode(tableNode!)
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

