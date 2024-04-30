//
//  ColorExtractor.swift
//  NanoColor
//
//  Created by aditamairwan on 24/04/24.
//

import SwiftUI

import SwiftUI

struct ColorExtractor: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var colors: [Color] = []
    @State private var selectedColor: Color = .white
    
    var body: some View {
        
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
                
            ZStack{
                  
                Rectangle()
                    .fill(Color.gray)
                
                Image("Gunung")
                    .resizable()
                    .frame(width: 361, height: 313)
                    .colorMultiply(selectedColor)
//                    .ignoresSafeArea()
                    
                
                }
                
                
                
                
                
                // Display colors below the image
                ColorPaletteView(image: $inputImage, colors: $colors, selectedColor: $selectedColor)
            }
        
        Spacer()
        
        ZStack{
            Rectangle()
                .fill(Color.white)
                .opacity(0.2)
                .frame(width: 24, height: 24)
            
            VStack{
                NavigationLink {
                    CameraView(
                        onCapture: { image in
                            inputImage = image
                        }
                    )
                } label: {
                    Image(systemName: "camera.fill")
                }
                
                .font(.system(size: 32))
                .frame(width: 80, height: 55)
                .background(.purple)
                .cornerRadius(12.4)
                .foregroundColor(.white)
                .padding()
                
                
                Button {
                    showingImagePicker = true
                } label: {
                    Image(systemName: "photo")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 356, height: 55)
                        .background(.purple)
                        .cornerRadius(12.4)
                    
                }
            }
            Spacer()
        }
        
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


struct ColorPaletteView: View {
    @Binding var image: UIImage?
    @Binding var colors: [Color]
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack {
            if colors.isEmpty {
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .opacity(0.2)
                        .frame(width: 393, height: 80)
                    
                    HStack(spacing: 12)  {
                        Spacer()
                        ForEach(colors, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                Rectangle()
                                    .fill(color)
                                    .frame(width: 48, height: 48)
                                    .border(
                                        selectedColor == color ? .red : color,
                                        width: 1
                                    )
                                    .cornerRadius(2.6)
                            }.foregroundColor(Color.gray)
                        }
                        Spacer()
                        
                        
                    }
                }
            }
        }
        .onChange(of: image) { newImage in
            if let image = newImage {
                extractColors(from: image)
            }
        }
    }
    
    private func extractColors(from image: UIImage) {
        guard let resizedImage = image.resized(to: CGSize(width: 1, height: 5)), // Changing resizing for better clarity
              let cgImage = resizedImage.cgImage else {
            print("Failed to get cgImage from resized image.")
            return
        }
        
        var colorSet: [Color] = []
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        
        // Ensuring to read the color data properly using direct access with context
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelBuffer = context?.data else {
            print("Failed to get pixel buffer.")
            return
        }
        
        let data = pixelBuffer.assumingMemoryBound(to: UInt8.self)
        
        for x in 0..<width {
            for y in 0..<height {
                let pixelIndex = ((width * y) + x) * bytesPerPixel
                let r = CGFloat(data[pixelIndex]) / 255.0
                let g = CGFloat(data[pixelIndex+1]) / 255.0
                let b = CGFloat(data[pixelIndex+2]) / 255.0
                colorSet.append(Color(red: r, green: g, blue: b))
            }
        }
        
        DispatchQueue.main.async {
            self.colors = Array(Set(colorSet))  // Removing duplicated colors, though in some cases you might get more than expected
        }
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

#Preview {
    ColorExtractor()
}
