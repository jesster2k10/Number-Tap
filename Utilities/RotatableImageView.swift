//
//  RotatableImageView.swift
//  Number Tap Universal
//
//  Created by Jesse on 21/10/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//



import UIKit

@IBDesignable
class RotatableImageView: UIImageView {
    
    @IBInspectable
    var degrees: CGFloat = 0 {
        didSet {
            let radians = self.degreesToRadians(degrees)
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    @IBInspectable
    var crop: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.image = cropToBounds(size: crop)
        }
    }
    
    let degreesToRadians: (CGFloat) -> CGFloat = {
        return $0 / 180.0 * CGFloat(M_PI)
    }
    
    func cropToBounds(size: CGSize) -> UIImage {
        
        let width = size.width
        let height = size.height
        
        let contextImage: UIImage = UIImage(cgImage: image!.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let aImage: UIImage = UIImage(cgImage: imageRef, scale: image!.scale, orientation: image!.imageOrientation)
        
        return aImage
        
    }
    
    func cropSize(to:CGSize) -> UIImage {
        guard let cgimage : CGImage = self.image!.cgImage! else {
            return self.image!
        }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        let contextSize: CGSize = contextImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        
        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.image!.scale, orientation: self.image!.imageOrientation)
        
        UIGraphicsBeginImageContextWithOptions(to, true, self.image!.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
