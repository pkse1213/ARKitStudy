//
//  ViewController.swift
//  PlayingVideo
//
//  Created by 박세은 on 2018. 11. 26..
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
        
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer ) {
        guard let currentFrame = self.sceneView.session.currentFrame  else {return}
        
        // 비디오 node 생성
        let videoNode = SKVideoNode(fileNamed: "big_buck_bunny.mp4")
        videoNode.play()
        
        // Sprite Scene
        let skScene = SKScene(size: CGSize(width: 640, height: 480))
        skScene.addChild(videoNode)
        
        // Sprite Scene의 가운데에 videoNode 올리기
        videoNode.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
        videoNode.size = skScene.size
        
        // 어떻게 Sprite Scene을 sceneview에 올릴 수 있을까???
        let tvPlane = SCNPlane(width: 1.0, height: 0.75)
        tvPlane.firstMaterial?.diffuse.contents = skScene // 이렇게 하면 됨!!!
        // plane의 반대 면도 볼 수 있음
        tvPlane.firstMaterial?.isDoubleSided = true
        
        let tvPlaneNode = SCNNode(geometry: tvPlane)
        
        var translation = matrix_identity_float4x4
        // 나와 더 멀리
        translation.columns.3.z = -1.0
       
        tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        tvPlaneNode.eulerAngles = SCNVector3(Double.pi, 0, 0)
        
        self.sceneView.scene.rootNode.addChildNode(tvPlaneNode)
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

}
