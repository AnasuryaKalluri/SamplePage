//
//  QRViewController.swift
//  Asset_Task
//
//  Created by Anasurya on 7/25/24.
//

import UIKit
import AVFoundation
import UIKit

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    //MARK: - Outlets
    @IBOutlet weak var sView: UIView!  // View
    
    //MARK: - Variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: QRCodebackDelegate? = nil
    var qrCodeFrameView:UIView?
    
    //MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    // MARK: - Camera Session
    func createSession(){
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = sView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        sView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    func failed() {
       print("Scanning not supported.Your device does not support scanning a code from an item. Please use a device with a camera.")
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }

    //MARK: - Found BARCODE
    func found(code: String) {
        print(code)
        if code != ""{
        print(code)
            delegate?.qrCodeBackTo(vehicle: code)
            self.navigationController?.popViewController(animated: true)// This is Barcode
        }else{
           self.captureSession.startRunning()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



protocol QRCodebackDelegate{
    func qrCodeBackTo(vehicle qrCode: String)
}
