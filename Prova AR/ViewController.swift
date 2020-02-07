//
//  ViewController.swift
//  Prova AR
//
//  Created by Antonella Cirma on 05/02/2020.
//  Copyright © 2020 Antonella Cirma. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var heartNode: SCNNode?
    var diamondNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let heartScene = SCNScene(named: "art.scnassets/heart.scn")
        let diamondScene = SCNScene(named: "art.scnassets/diamond.scn")
        heartNode = heartScene?.rootNode
        diamondNode = diamondScene?.rootNode
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "photos", bundle: Bundle.main) {
            configuration.detectionImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 2
            
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchoe = anchor as? ARImageAnchor {
            
            let size = imageAnchoe.referenceImage.physicalSize
            let plane = SCNPlane (width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode (geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode (planeNode)
            
            var shapeNode: SCNNode?
            switch imageAnchoe.referenceImage.name! {
            case camera.badge.rawValue:
                shapeNode = heartNode
            case camera.book.rawValue:
                shapeNode = diamondNode
            default:
                break
            }
            
            
            guard let shape = shapeNode else {
                
                return nil
                
            }
            node.addChildNode (shape)
        }
        
        return node
    }
    enum camera: String {
        case badge = "Badge"
        case book = "Book"
    }
}

