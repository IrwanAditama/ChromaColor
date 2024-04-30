//
//  ColorPicker.swift
//  NanoColor
//
//  Created by aditamairwan on 27/04/24.
//

//import SwiftUI
//
//struct ColorPicker: View {
//    @Binding var selectedColor: Color
//    
//    
//  
//    private let colors:[Color] = [.red, .yellow, .orange, .purple, .blue]
//    
//
//    var body: some View {
//        //        ScrollView(.horizontal) {
//        
//        VStack{
//            Spacer()
//            
//            HStack {
//                ForEach(colors, id: \.self) { color in
//                    Rectangle()
//                        .foregroundColor(color)
//                        .frame(width: 48, height: 48)
//                        .opacity(color == selectedColor ? 0.5 : 1.0)
//                        .scaleEffect(color == selectedColor ? 1.1 : 1.0)
//                        .onTapGesture {
//                            selectedColor = color
//                        }
//                }
//            }
//            .padding()
//            //            .background(.thinMaterial)
//            .frame(width: 356, height: 55)
//            .cornerRadius(20)
//            .padding(.horizontal)
//            
//        }
//    }
//    }
//
//struct ColorPicker_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        VStack{
//            ColorPicker(selectedColor: .constant(.blue))
//            Spacer()
//        }
//    }
//}
