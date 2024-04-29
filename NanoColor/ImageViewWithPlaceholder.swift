//
//  ImageViewWithPlaceholder.swift
//  NanoColor
//
//  Created by aditamairwan on 28/04/24.
//

import SwiftUI

struct ImageViewWithPlaceholder: View {
    var inputImage: UIImage?

    var body: some View {
        if let inputImage = inputImage {
            Image(uiImage: inputImage)
                .resizable()
                .aspectRatio(1, contentMode: .fit)  // Setting aspect ratio to 1:1
                .frame(maxWidth: 360, maxHeight: 600)  // Limiting size to make it visually consistent
        } else {
            Text("No image selected.")
                .frame(width: 360, height: 600)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}
