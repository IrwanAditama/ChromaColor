////
////  ColorView.swift
////  NanoColor
////
////  Created by aditamairwan on 27/04/24.
////
//
//import SwiftUI
//
//struct ColorView: View {
//    @State private var selectedColor: Color = .blue
//    
//    var body: some View {
//        VStack {
//            ColorPicker(selectedColor: $selectedColor)
//            Spacer()
//            
//            Circle()
//                .frame(width: 30, height: 30)
//                .cornerRadius(20)
//                .foregroundColor(selectedColor)
////            Text("\(selectedColor.description)")
////                .font(.system(size: 12, design: .rounded))
//            
//            Spacer()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorView()
//    }
//}
