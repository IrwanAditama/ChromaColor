//
//  CameraViewModel.swift
//  NanoColor
//
//  Created by aditamairwan on 25/04/24.
//

import Foundation
import AVFoundation
import SwiftUI
import Combine

class CameraViewModel: ObservableObject {
 
  // Reference to the CameraManager.
  @ObservedObject var cameraManager = CameraManager()
 
  // Published properties to trigger UI updates.
  @Published var isFlashOn = false
  @Published var showAlertError = false
  @Published var showSettingAlert = false
  @Published var isPermissionGranted: Bool = false
    @Published var capturedImage: UIImage? = nil
    @Published var permissionGranted: Bool = false
    
 
//  var alertError: AlertError!

  // Reference to the AVCaptureSession.
  var session: AVCaptureSession = .init()

  // Cancellable storage for Combine subscribers.
  private var cancelables = Set<AnyCancellable>()
 
  init() {
    // Initialize the session with the cameraManager's session.
    session = cameraManager.session
  }

  deinit {
    // Deinitializer to stop capturing when the ViewModel is deallocated.
    cameraManager.stopCapturing()
  }
 
  // Setup Combine bindings for handling publisher's emit values
//  func setupBindings() {
//    cameraManager.$shouldShowAlertView.sink { [weak self] value in
//      // Update alertError and showAlertError based on cameraManager's state.
//      self?.alertError = self?.cameraManager.alertError
//      self?.showAlertError = value
//    }
//    .store(in: &cancelables)
//  }
 
    
    // Setup Combine bindings for handling publisher's emit values
         func setupBindings() {
            cameraManager.$showErrorAlert.sink { [weak self] value in
//                self?.error = self?.cameraManager.error
//                self?.showErrorAlert = value
            }
            .store(in: &cancelables)
            
            cameraManager.$capturedImage.sink { [weak self] image in
                self?.capturedImage = image
            }.store(in: &cancelables)
        }
        
        // Check for camera device permission.
         func checkForDevicePermission() {
            let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if videoStatus == .authorized {
                // If Permission granted, configure the camera.
                permissionGranted = true
                configureCamera()
            } else if videoStatus == .notDetermined {
                // In case the user has not been asked to grant access we request permission
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
            } else if videoStatus == .denied {
                // If Permission denied, show a setting alert.
                permissionGranted = false
//                state.showSettingAlert = true
            }
        }
        
         func requestCameraPermission() {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] isGranted in
                guard let self else { return }
                if isGranted {
                    self.configureCamera()
                    DispatchQueue.main.async {
                        self.permissionGranted = true
                    }
                }
            }
        }
        
         func configureCamera() {
    //        checkForDevicePermission()
            cameraManager.configureCaptureSession()
        }
}
