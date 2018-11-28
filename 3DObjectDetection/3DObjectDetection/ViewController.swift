//
//  ViewController.swift
//  3DObjectDetection
//
//  Created by 박세은 on 2018. 11. 28..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARObjectAnchor {
            print("찾았당"
            )
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("ar이미지를 찾을 수 없음")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = referenceObjects
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
