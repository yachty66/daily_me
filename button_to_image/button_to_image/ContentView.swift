import SwiftUI
import AVFoundation
import AppKit

struct ContentView: View {
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
        }
        .padding()
    }
    
    func captureImage() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let output = AVCapturePhotoOutput()
        captureSession.addOutput(output)
        
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: PhotoCaptureDelegate())
    }
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = NSImage(data: imageData) else { return }
    // Save the image to your desired location here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}