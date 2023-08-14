//
//  ViewController.swift
//

import AVFoundation
import Cocoa
import AppKit


//next i want to make the app run in the background and every minute a image should be taken. the image should be saved with the current date and minute and with .jpg extension in the end

class ViewController: NSViewController, AVCapturePhotoCaptureDelegate {
    // MARK: - Properties
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var captureConnection: AVCaptureConnection?
    var cameraDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var mouseLocation: NSPoint { NSEvent.mouseLocation }

    var captureTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareCamera()
        startSession()
        // Start the timer
        captureTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(capturePhoto), userInfo: nil, repeats: true)
    }
    // MARK: - UtilityFunctions
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func button(_ sender: Any) {
        capturePhoto()
    }
    
    func startSession() {
        if let videoSession = captureSession {
            if !videoSession.isRunning {
                videoSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if let videoSession = captureSession {
            if videoSession.isRunning {
                videoSession.stopRunning()
            }
        }
    }
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("willBeginCaptureFor")
    }
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    print("didFinishProcessingPhoto")

    if let error = error {
        print("Error capturing photo: \(error)")
    } else if let data = photo.fileDataRepresentation() {
        let image = NSImage(data: data)

        // Generate a file name based on the current date and minute
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let fileName = dateFormatter.string(from: Date()) + ".jpg"

        // Get the user's Documents directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]

        // Create the full file URL
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print("fileUrl")
        print(fileURL)
        // Save the photo
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving photo: \(error)")
        }
    }
    }
    
    @IBAction func butttonTapped(_ sender: Any) {
        print("hello world")
        capturePhoto()
        
    }

    @objc func capturePhoto() {
        print(captureConnection?.isActive)
        let photoSettings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    /*func capturePhoto() {
        print(captureConnection?.isActive)
        let photoSettings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }*/
    
    func prepareCamera() {
        photoOutput = AVCapturePhotoOutput()
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        do {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front)
            let cameraDevice = deviceDiscoverySession.devices[0]
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice)
            captureSession!.beginConfiguration()
            if captureSession!.canAddInput(videoInput) {
                print("Adding videoInput to captureSession")
                captureSession!.addInput(videoInput)
            } else {
                print("Unable to add videoInput to captureSession")
            }
            if captureSession!.canAddOutput(photoOutput!) {
                captureSession!.addOutput(photoOutput!)
                print("Adding videoOutput to captureSession")
            } else {
                print("Unable to add videoOutput to captureSession")
            }
            captureConnection = AVCaptureConnection(inputPorts: videoInput.ports, output: photoOutput!)
            captureSession!.commitConfiguration()
            if let previewLayer = previewLayer {
                if ((previewLayer.connection?.isVideoMirroringSupported) != nil) {
                    previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
                    previewLayer.connection?.isVideoMirrored = true
                }
                previewLayer.frame = view.bounds
                view.layer = previewLayer
                view.wantsLayer = true
            }
            captureSession!.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }

}
