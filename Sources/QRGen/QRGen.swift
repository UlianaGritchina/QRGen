import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI

public struct QRGen {
    public private(set) var text = "Hello, World!"
    
    public init() {
    }
    
    public func generateQR(string: String) -> CIImage? {
        let data = string.data(using: String.Encoding.utf8)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let outputImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 20, y: 20)
        let scaledCIImage = outputImage.transformed(by: transform)
        return scaledCIImage
    }
    
    public func generateCustomQR() {
        
    }
    
}
