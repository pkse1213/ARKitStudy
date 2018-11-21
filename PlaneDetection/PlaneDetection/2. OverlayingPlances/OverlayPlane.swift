//
//  OverlayPlane.swift
//  PlaneDetection
//
//  Created by 박세은 on 2018. 11. 21..
//  Copyright © 2018년 박세은. All rights reserved.
//
import Foundation
import ARKit
import SceneKit


class OverlayPlane: SCNNode {
    
    // ARAnchor는 arkit과 scenekit에 의해 발견되는 하나의 점
    // 가상 객체에 대한 실제 세계의 위치를 의미하며 각 객체를 구별할 수 있음
    var anchor :ARPlaneAnchor
    var planeGeometry :SCNPlane!
    
    init(anchor :ARPlaneAnchor) {
        
        self.anchor = anchor
        super.init()
        setup()
    }
    
    func update(anchor :ARPlaneAnchor) {
        
        self.planeGeometry.width = CGFloat(anchor.extent.x);
        self.planeGeometry.height = CGFloat(anchor.extent.z);
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
    }
    
    private func setup() {
        
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"overlay_grid.png")
        
        self.planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        
        // shape: nil일 수 있지만 Plane은 계속해서 커지므로 SCNPhysicsShape(geometry: self.planeGeometry, options: nil)로 해준다
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        planeNode.categoryBitMask = BoxType.plane.rawValue
        
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
        
        // add to the parent
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



