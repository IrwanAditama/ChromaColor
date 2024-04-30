//
//  ContentView1.swift
//  NanoColor
//
//  Created by aditamairwan on 25/04/24.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    
    let onCapture: (UIImage) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer() // Pushes the VStack to the top
                    
                    CameraPreview(session: viewModel.session)
                    
                    VStack(spacing: 24) {
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                print("Close")
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            .padding(.bottom, 16) // Add padding to adjust position
                            
                            Spacer()
                            
                            
                            CaptureButton{
                                // Call the capture methodh
                                viewModel.captureImage()
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // Call method to on/off flash light
//                            viewModel.toggleFlash()
                            }) {
                                Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                    .font(.system(size: 24, weight: .medium, design: .default))
                                    .foregroundColor(viewModel.isFlashOn ? .yellow : .white)
                                
                            }
                            .padding(.bottom, 16) // Add padding to adjust position
                        }
                        .padding(.horizontal, 16) // Add horizontal padding to the HStack
                        
                       
                        
                        PhotoThumbnail(image: viewModel.capturedImage ?? UIImage())
                    }
                    .padding(.horizontal, 16) // Add horizontal padding to the VStack
                    .padding(.bottom, 16) // Add bottom padding to the VStack
                }
            }
        }
        .alert(isPresented: $viewModel.showSettingAlert) {
            Alert(title: Text("Warning"), message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."), dismissButton: .default(Text("Go to settings"), action: {
                self.openSettings()
            }))
        }
        .onAppear {
            viewModel.setupBindings()
            viewModel.checkForDevicePermission()
        }
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.capturedImage) { image in
            if let image = image {
                onCapture(image)
                dismiss()
            }
        }
    }
    
    
    
                       
                    
                
    
    
    // use to open app's setting
        func openSettings() {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:])
            }
        }
    
    struct PhotoThumbnail: View {
        let image: UIImage
        
        var body: some View {
            ZStack {
                // if we have Image then we'll show image
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                // else just show black view
                Rectangle()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.black)
            }
        }
    }
    
    struct CaptureButton: View {
        
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Circle()
                    .foregroundColor(.blue)
                
                    .frame(width: 70, height: 70, alignment: .center)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.8), lineWidth: 2)
                            .frame(width: 59, height: 59, alignment: .center)
                    )
            }
        }
    }
    //
    //struct CameraSwitchButton: View {
    //
    //  var action: () -> Void
    //
    //  var body: some View {
    //      Button(action: action) {
    //         Circle()
    //           .foregroundColor(Color.gray.opacity(0.2))
    //           .frame(width: 45, height: 45, alignment: .center)
    //           .overlay(
    //               Image(systemName: "camera.rotate.fill")
    //                  .foregroundColor(.white))
    //      }
    //   }
    //}
}
