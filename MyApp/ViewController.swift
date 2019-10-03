//
//  ViewController.swift
//  MyApp
//
//  Created by Тимофей Солонин on 27/09/2019.
//  Copyright © 2019 tbd. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Vision

class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {

    let arView = ARView(frame: .zero)
    
     var qrRequests = [VNRequest]()
     var detectedDataAnchor: ARAnchor?
     var processing = false

    override func loadView() {
        view = arView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.session.delegate = self
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARWorldTrackingConfiguration is not supported on this device")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        
        setUpPeopleOcclusion(for: configuration)
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

//        startQrCodeDetection()
    }
    
    func setUpPeopleOcclusion(for configuration: ARConfiguration) {
        guard let configuration = configuration as? ARWorldTrackingConfiguration,
            ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else
        {
            print("PersonSegmentationWithDepth is not available on this device")
            return
        }
        configuration.frameSemantics.insert(.personSegmentationWithDepth)
        print("PeopleOcclusion ON")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        if let imageAnchor = anchors.first(where: { $0 is ARImageAnchor }) {
            let anchor = try! Experience.loadBox()
            
            arView.scene.addAnchor(anchor)
            anchor.reanchor(
                .world(transform: imageAnchor.transform),
                preservingWorldTransform: false
            )
            
            let text = MeshResource.generateText(
                "hello!",
                extrusionDepth: 0.1,
                font: .systemFont(ofSize: 0.1),
                containerFrame: CGRect.zero,
                alignment: .left,
                lineBreakMode: .byTruncatingTail
            )
            
            anchor.keg!.children[0].children[0].components[ModelComponent.self]?.mesh = text
            
            let position: SIMD3<Float> = anchor.position
            anchor.setPosition(position + SIMD3<Float>(0, 0, 0), relativeTo: nil)
//            let orientation: simd_quatf = anchor.orientation
//            anchor.setOrientation(orientation + simd_quatf(angle: 0.5, axis: orientation.axis), relativeTo: nil)
//            anchor.set
//            anchor.transform.setPosition()
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let imageAnchor = anchor as? ARImageAnchor else { return }
//        let anchor = try! Experience.loadBox()
////        anchor.transform = imageAnchor.transform
//        arView.scene. .add(anchor: anchor)
//        anchor.
//        let referenceImage = imageAnchor.referenceImage
////        updateQueue.async {
//
//            // Create a plane to visualize the initial position of the detected image.
//            let plane = SCNPlane(width: referenceImage.physicalSize.width,
//                                 height: referenceImage.physicalSize.height)
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.opacity = 1
//
//            /*
//             `SCNPlane` is vertically oriented in its local coordinate space, but
//             `ARImageAnchor` assumes the image is horizontal in its local space, so
//             rotate the plane to match.
//             */
//            planeNode.eulerAngles.x = -.pi / 2
//
//            /*
//             Image anchors are not tracked after initial detection, so create an
//             animation that limits the duration for which the plane visualization appears.
//             */
////            planeNode.runAction(self.imageHighlightAction)
//
//            // Add the plane visualization to the scene.
//            node.addChildNode(planeNode)
////        }
//    }
    
//    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                if self.processing {
//                  return
//                }
//                self.processing = true
//                // Create a request handler using the captured image from the ARFrame
//                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage,
//                                                                options: [:])
//                // Process the request
//                try imageRequestHandler.perform(self.qrRequests)
//            } catch {
//
//            }
//        }
//    }

//     func startQrCodeDetection() {
//        // Create a Barcode Detection Request
//        let request = VNDetectBarcodesRequest(completionHandler: self.requestHandler)
//        // Set it to recognize QR code only
//        request.symbologies = [.QR]
//        self.qrRequests = [request]
//    }
//
//    func requestHandler(request: VNRequest, error: Error?) {
//        // Get the first result out of the results, if there are any
//        if let results = request.results, let result = results.first as? VNBarcodeObservation {
//            guard result.payloadStringValue != nil else { return }
//            // Get the bounding box for the bar code and find the center
//            var rect = result.boundingBox
//            // Flip coordinates
//            rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
//            rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
//            // Get center
//            let center = CGPoint(x: rect.midX, y: rect.midY)
//
//            DispatchQueue.main.async {
//                self.hitTestQrCode(center: center)
//                self.processing = false
//            }
//        } else {
//            self.processing = false
//        }
//    }
//
//     func hitTestQrCode(center: CGPoint) {
//        if let hitTestResults = arView.session.currentFrame?.hitTest(center, types: [.featurePoint] ),
//            let hitTestResult = hitTestResults.first {
//            if let detectedDataAnchor = self.detectedDataAnchor,
//                let node = self.arView.node(for: detectedDataAnchor) {
//                let previousQrPosition = node.position
//                node.setWorldTransform(SCNMatrix4(hitTestResult.worldTransform))
//
//            } else {
//                // Create an anchor. The node will be created in delegate methods
//                self.detectedDataAnchor = ARAnchor(transform: hitTestResult.worldTransform)
//                self.arView.session.add(anchor: self.detectedDataAnchor!)
//            }
//        }
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//
//        // If this is our anchor, create a node
//        if self.detectedDataAnchor?.identifier == anchor.identifier {
//            let sphere = SCNSphere(radius: 0.01)
//            sphere.firstMaterial?.diffuse.contents = UIColor.red
//            let sphereNode = SCNNode(geometry: sphere)
//            sphereNode.setWorldTransform(SCNMatrix4(anchor.transform))
//            return sphereNode
//        }
//        return nil
//    }
    
//    func makeUIView(context: Context) -> ARView {
//
//        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
//
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
//
//        return arView
//
//    }
    
}
