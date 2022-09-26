//
//  File.swift
//  
//
//  Created by Ульяна Гритчина on 26.09.2022.
//

import SwiftUI

@available(iOS 14.0, *)
class QRCodeViewModel: ObservableObject {
    
    @Published var qrImageData: Data = Data()
    
    var string: String = ""
    var foregroundColor: Color = .black
    var backgroundColor: Color = .white
    var width: CGFloat = 200
    var height: CGFloat = 200
    var radius: CGFloat = 0
    
    init(string: String,
         foregroundColor: Color? = .black,
         backgroundColor: Color? = .white,
         width: CGFloat? = 200,
         height: CGFloat? = 200,
         cornerRadius: CGFloat? = 0) {
        self.string = string
        self.foregroundColor = foregroundColor ?? .black
        self.backgroundColor = backgroundColor ?? .white
        self.width = width ?? 200
        self.height = height ?? 200
        self.radius = cornerRadius ?? 0
    }
    
    func generateQRCode() {
        let foregroundColor = UIColor(foregroundColor)
        let backgroundColor = UIColor(backgroundColor)
        let data = string.data(using: String.Encoding.utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return  }
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1") // Background
            colorFilter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0") // Foreground
            guard let outputImage = colorFilter.outputImage else { return }
            let transform = CGAffineTransform(scaleX: 20, y: 20)
            let scaledCIImage = outputImage.transformed(by: transform)
            qrImageData = UIImage(ciImage: scaledCIImage).pngData() ?? Data()
        }
    }
    
}
