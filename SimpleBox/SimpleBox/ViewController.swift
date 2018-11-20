//
//  ViewController.swift
//  SimpleBox
//
//  Created by 박세은 on 2018. 11. 21..
//  Copyright © 2018년 박세은. All rights reserved.
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
        
        // 네모 박스를 만들 것임
        // 일단 먼저 geometry를 만들어 보자!
        // chamferRadius는 둥글게 깍는 것을 의미
        // 0.3 -> 단위 : meter
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        // 이제 네모상자를 둘러쌓을 재질을 만들어보자
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        box .materials = [material]
        
        // real world에 올릴 Node를 생성해야해
        let boxNode = SCNNode(geometry: box)
        
        // z는 나로부터 얼마나 멀리 있는지를 의미
        // y = 위 아래 , x = 좌 우
        boxNode.position = SCNVector3(0, 0, -0.5)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
}
