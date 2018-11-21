//
//  OverlayingPlaneViewController.swift
//  PlaneDetection
//
//  Created by 박세은 on 2018. 11. 21..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class OverlayingPlaneViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView = ARSCNView(frame: self.view.frame)
//        self.view.addSubview(self.sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        
        // feture point랑 좌표계를 보여줌
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        // 평면을 탐색하려면 !!
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
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
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
