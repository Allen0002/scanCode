//
//  ScanManager.swift
//  ScanCode
//
//  Created by wu ning on 2019/2/27.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanManagerDelegate:NSObjectProtocol {
    func metadataOutput(_ model:BarcodeModel,error:ScanError?)
}

enum ScanError:Error {
    case invalidDevice
    case captureInputError(description:String)
    case responseDataNil
    case responseNotReadableCodeObject
}

class ScanManager:NSObject {
    //MARK:-- interface API
    
    weak var delegate:ScanManagerDelegate?
    ///start to capture the session
    /*
     @param previewLayer: the capture session to be previewed
     @param rectOfScan: Specifies a rectangle of scaning
     */
    init(_ previewLayer:CALayer, rectOfScan:CGRect) {
        super.init()
        try? self.captureSession(previewLayer, rectOfScan: rectOfScan)
    }
    
    func startScan() {
        if let session = self.scanSession, !session.isRunning {
            session.startRunning()
        }
    }
    
    func stopScan() {
        if let session = self.scanSession, session.isRunning {
            session.stopRunning()
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    //MARK: -- private API
    private func captureSession(_ previewLayer:CALayer, rectOfScan:CGRect) throws{
        let device = AVCaptureDevice.default(for: .video)
        guard let dev = device else {
            throw ScanError.invalidDevice
        }
        var input: AVCaptureDeviceInput?
        do {
           input = try AVCaptureDeviceInput(device: dev)
        }catch let error{
            throw ScanError.captureInputError(description: error.localizedDescription)
        }
        let output = AVCaptureMetadataOutput()
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        let  scanSession = AVCaptureSession()
        scanSession.canSetSessionPreset(.high)
        
        if scanSession.canAddInput(input!)
        {
            scanSession.addInput(input!)
        }
        
        if scanSession.canAddOutput(output)
        {
            scanSession.addOutput(output)
        }
        output.metadataObjectTypes = [.qr,.code128,.code39,.code39Mod43,.ean8,.code93,.ean13]
        let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
        scanPreviewLayer.videoGravity = .resizeAspectFill
        scanPreviewLayer.frame = previewLayer.bounds
        previewLayer.insertSublayer(scanPreviewLayer, at: 0)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
            output.rectOfInterest = (scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: rectOfScan))
        })
        
        self.scanSession = scanSession
    }
    
    private var scanSession:AVCaptureSession?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ScanManager:AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanSession?.stopRunning()
        if metadataObjects.count > 0
        {
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            {
                let model = BarcodeModel.init(Date(), code: resultObj.stringValue ?? "")
                self.delegate?.metadataOutput(model, error: nil)
            }else{
                self.delegate?.metadataOutput(BarcodeModel(Date(), code: ""), error: ScanError.responseNotReadableCodeObject)
            }
        }else{
            self.delegate?.metadataOutput(BarcodeModel(Date(), code: ""), error: ScanError.responseDataNil)
        }
    }
}

