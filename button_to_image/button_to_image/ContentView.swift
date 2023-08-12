import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var cameraController = CameraController()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button(action: {
                cameraController.captureImage()
            }) {
                Text("Capture Image")
            }
        }
        .padding()
    }
}

class CameraController: NSObject, NSViewControllerRepresentable, AVCapturePhotoCaptureDelegate {
    private let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    func makeNSViewController(context: Context) -> NSViewController {
        let viewController = NSViewController()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        viewController.view.layer?.addSublayer(previewLayer)
        previewLayer.frame = viewController.view.bounds
        captureSession.startRunning()
        return viewController
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // Update the view controller if needed
    }
    
    private func setupCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
    
    func captureImage() {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Here you can use the captured image data
            print("Image captured!")
        }
    }
}