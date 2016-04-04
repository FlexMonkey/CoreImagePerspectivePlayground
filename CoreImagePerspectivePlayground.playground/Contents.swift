//: # Core Image Perspective Playground
//: ## Simon Gladman | April 4, 2016
//: [http://flexmonkey.blogspot.co.uk](http://flexmonkey.blogspot.co.uk)

import UIKit
import CoreImage

let composite = CIFilter(name: "CISourceAtopCompositing")!
let perspectiveTransform = CIFilter(name: "CIPerspectiveTransform")!
let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")!

let monaLisa = CIImage(image: UIImage(named: "monalisa.jpg")!)!
let backgroundImage = CIImage(image: UIImage(named: "background.jpg")!)!

let ciContext =  CIContext()

let detector = CIDetector(ofType: CIDetectorTypeRectangle,
    context: ciContext,
    options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

let rect = detector.featuresInImage(backgroundImage).first as! CIRectangleFeature

//: ## Transform Only

perspectiveTransform.setValue(CIVector(CGPoint:rect.topLeft),
                              forKey: "inputTopLeft")
perspectiveTransform.setValue(CIVector(CGPoint:rect.topRight),
                              forKey: "inputTopRight")
perspectiveTransform.setValue(CIVector(CGPoint:rect.bottomRight),
                              forKey: "inputBottomRight")
perspectiveTransform.setValue(CIVector(CGPoint:rect.bottomLeft),
                              forKey: "inputBottomLeft")
perspectiveTransform.setValue(monaLisa,
                              forKey: kCIInputImageKey)

composite.setValue(backgroundImage,
                   forKey: kCIInputBackgroundImageKey)
composite.setValue(perspectiveTransform.outputImage!,
                   forKey: kCIInputImageKey)

let transformOnlyFinal = composite.outputImage!

//: ## Correction & Transform 

perspectiveCorrection.setValue(CIVector(CGPoint:rect.topLeft),
                               forKey: "inputTopLeft")
perspectiveCorrection.setValue(CIVector(CGPoint:rect.topRight),
                               forKey: "inputTopRight")
perspectiveCorrection.setValue(CIVector(CGPoint:rect.bottomRight),
                               forKey: "inputBottomRight")
perspectiveCorrection.setValue(CIVector(CGPoint:rect.bottomLeft),
                               forKey: "inputBottomLeft")
perspectiveCorrection.setValue(monaLisa,
                               forKey: kCIInputImageKey)

let perspectiveCorrectionRect = perspectiveCorrection.outputImage!.extent
let cropRect = perspectiveCorrection.outputImage!.extent.offsetBy(
    dx: monaLisa.extent.midX - perspectiveCorrectionRect.midX,
    dy: monaLisa.extent.midY - perspectiveCorrectionRect.midY)

let croppedMonaLisa = monaLisa.imageByCroppingToRect(cropRect)

perspectiveTransform.setValue(croppedMonaLisa,
                              forKey: kCIInputImageKey)

composite.setValue(perspectiveTransform.outputImage!,
                   forKey: kCIInputImageKey)

let correctAndTransformFinal = composite.outputImage!





