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
    var blueView: UIView!

    override func loadView() {
        view = arView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView = UIView()
        blueView.backgroundColor = .red
        blueView.layer.cornerRadius = 5
        
        
        arView.session.delegate = self
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARWorldTrackingConfiguration is not supported on this device")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        
//        setUpPeopleOcclusion(for: configuration)
        arView.autoresizesSubviews = false
        arView.translatesAutoresizingMaskIntoConstraints = false
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        arView.session.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Снимок экрана 2019-10-04 в 20.26.50"))
        imageView.alpha = 0.35
        arView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalTo: arView.widthAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: arView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: arView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: arView.widthAnchor, multiplier: 1.7074).isActive = true
        imageView.addSubview(blueView)
//
//
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        print("\(Int(position.x)), \(Int(position.y)), \(Int(position.z)), \(Int(position.w))")
//
        var cgframe = CGRect(x: 111.664611, y: 482.9593, width: 10, height: 10)
        cgframe.origin.x += CGFloat(10.869565 * frame.camera.transform.columns.3.x)
        cgframe.origin.y += CGFloat(10.869565 * frame.camera.transform.columns.3.z)
//        print("x: \(Int(frame.camera.transform.columns.3.x)), y: \(Int(frame.camera.transform.columns.3.y)), z: \(frame.camera.transform.columns.3.z), w: \(frame.camera.transform.columns.3.w)")
        blueView.frame = cgframe
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        if let imageAnchor = anchors.first(where: { $0 is ARImageAnchor }) {
            session.setWorldOrigin(relativeTransform: imageAnchor.transform)
//            let source = DispatchSource.makeTimerSource()
//            source.setEventHandler {
//
//            }
//            source.schedule(deadline: .now() + 1, repeating: 1)
//            source.resume()
//            [1.47, 3.82, 5.72, 6.97].forEach {
//                let anchor = try! Experience.loadBox()
//
//                arView.scene.addAnchor(anchor)
//                anchor.reanchor(.world(transform: imageAnchor.transform),preservingWorldTransform: false)
//
//                let text = MeshResource.generateText(
//                    "\($0)",
//                    extrusionDepth: 0.1,
//                    font: .systemFont(ofSize: 0.1),
//                    containerFrame: CGRect.zero,
//                    alignment: .left,
//                    lineBreakMode: .byTruncatingTail
//                )
//
//                anchor.keg!.children[0].children[0].components[ModelComponent.self]?.mesh = text
//
//                let position: SIMD3<Float> = anchor.position
//                //-13.37
//                anchor.setPosition(position + SIMD3<Float>(0.87, 1.5, -Float($0) - 0.3), relativeTo: nil)
//            }
            
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
