//
//  ViewController.swift
//  ARAds
//
//  Created by Mohammad Azam on 3/26/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARImageAnchor {
            
            let phoneScene = SCNScene(named: "Phone_01.scn")!
            let phoneNode = phoneScene.rootNode.childNode(withName: "parentNode", recursively: true)!
            
            phoneNode.position = SCNVector3(anchor.transform.columns.3.x,anchor.transform.columns.3.y,anchor.transform.columns.3.z)
            
            // sceneview의 루트 노드에 추가하는 것이 아니라 발견된 anchor에 childNode를 추가한다
            node.addChildNode(phoneNode)
            
//            self.sceneView.scene.rootNode.addChildNode(phoneNode)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let configuration = ARWorldTrackingConfiguration()
        // ARImageTrackingConfiguration는 arkit2부터 가능!
        let configuration = ARImageTrackingConfiguration()
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        //configuration.detectionImages = referenceImages
        configuration.trackingImages = referenceImages
        
        // 최대 갯수도 설정 가능
        // configuration.maximumNumberOfTrackedImages = 3
       
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}
