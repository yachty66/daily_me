import SwiftUI
import AVFoundation
import AppKit
import Foundation

struct ContentView: View {
    @State private var capturedImage: NSImage? = nil

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Click the button!")
            Button(action: {
                captureImage()
            }) {
                Text("Capture Image")
            }
            if let img = capturedImage {
                Image(nsImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding()
    }
    
func captureImage() {
    // Define capture session
    let captureSession = AVCaptureSession()
    // Begin configuration
    captureSession.beginConfiguration()
    // Try to get the device with which you want to capture
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
          captureSession.canAddInput(videoDeviceInput) else {
        print("Error: Unable to create video device input")
        return
    }                                                   
    // Add video input to session                                                                  
    captureSession.addInput(videoDeviceInput)                                                                 
    // Create photo output and add it to the session                                                           
    let photoOutput = AVCapturePhotoOutput()
    guard captureSession.canAddOutput(photoOutput) else {
        print("Error: Unable to add photo output")
        return
    }
    captureSession.sessionPreset = .photo
    captureSession.addOutput(photoOutput)
    // Commit configuration
    captureSession.commitConfiguration()
    // Create photo settings and delegate
    let photoSettings = AVCapturePhotoSettings()
    let delegate = PhotoCaptureDelegate() // You need to define this class
    // Capture photo
    photoOutput.capturePhoto(with: photoSettings, delegate: delegate)
    // Start running the session
    captureSession.startRunning()
}
class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Photo has been processed")
        // Handle the captured photo here
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
