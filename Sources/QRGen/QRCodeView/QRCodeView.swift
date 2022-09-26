//
//  SwiftUIView.swift
//  
//
//  Created by Ульяна Гритчина on 26.09.2022.
//


import SwiftUI
@available(iOS 14.0, *)
@available(macOS 10.15, *)

struct QRCodeView: View {
    @ObservedObject var vm: QRCodeViewModel
    public init(string: String,
         foregroundColor: Color? = .black,
         backgroundColor: Color? = .white,
         width: CGFloat? = 200,
         height: CGFloat? = 200,
         cornerRadius: CGFloat? = 0) {
        vm = QRCodeViewModel(string: string,
                             foregroundColor: foregroundColor,
                             backgroundColor: backgroundColor,
                             width: width,
                             height: height,
                             cornerRadius: cornerRadius)
    }
    public var body: some View {
        VStack {
            if let image = UIImage(data: vm.qrImageData) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: vm.width, height: vm.height)
                    .cornerRadius(vm.radius)
            }
            
        }
        .onAppear { vm.generateQRCode() }
    }
    
}


@available(iOS 14.0, *)
@available(macOS 10.15, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(string: "fff", backgroundColor: .blue, cornerRadius: 20)
    }
}
