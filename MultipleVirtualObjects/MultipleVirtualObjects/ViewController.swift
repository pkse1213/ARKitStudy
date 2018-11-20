//
//  ViewController.swift
//  MultipleVirtualObjects
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
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0 )
        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
        
        // box의 재질을 나무 이미지로!!!!!
        material.diffuse.contents = UIImage(named: "wood.jpeg")
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, -0.5)
        
        // SCNBox는 6면이 있으므로 material이 배열이다!!!!!!!!!!!!!
        boxNode.geometry?.materials = [material] // box.metarial과 같은 의미
        
        let sphere = SCNSphere(radius: 0.3)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth.jpg")
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0.5, 0, -0.5)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        
        
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
