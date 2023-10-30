//
//  ReaderView.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import AVFoundation
import RealmSwift
import CryptoKit

enum ReaderStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: AnyObject {
    func readerComplete(status: ReaderStatus)
    func presentAlertController(_ alertController: UIAlertController)
    func readerViewDidCancel()
}

class ReaderView: UIView {
    weak var delegate: ReaderViewDelegate?
    
    var userEmail: String = " "
    var myMoney: Int = UserDefaults.standard.integer(forKey: "money")
    private var isQRCodeProcessed = false
    
    // 카메라 화면을 보여줄 Layer
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    
    private var cornerLength: CGFloat = 20
    private var cornerLineWidth: CGFloat = 6
    private var rectOfInterest: CGRect {
        CGRect(x: (bounds.width / 2) - (200 / 2),
               y: (bounds.height / 2) - (200 / 2),
               width: 200, height: 200)
    }
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        return captureSession.isRunning
    }
    
    // 촬영 시 어떤 데이터를 검사할건지? - QRCode
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetupView()
    }
    
    /// AVCaptureSession을 실행하는 화면을 구성 후 실행합니다.
    private func initialSetupView() {
        self.clipsToBounds = true
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        let videoInput: AVCaptureInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
            
        } else {
            self.fail()
            return
        }
        
        self.setPreviewLayer()
        self.setFocusZoneCornerLayer()
        /*
         // QRCode 인식 범위 설정하기
         metadataOutput.rectOfInterest 는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정합니다.
         !! 단 해당 값은 먼저 AVCaptureSession를 running 상태로 만든 후 지정해주어야 정상적으로 작동합니다 !!
         */
        self.start()
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    /// 중앙에 사각형의 Focus Zone Layer을 설정합니다.
    private func setPreviewLayer() {
        let readingRect = rectOfInterest.offsetBy(dx: 0, dy: -50)
        
        guard let captureSession = self.captureSession else {
            return
        }
        
        /*
         AVCaptureVideoPreviewLayer를 구성.
         */
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds
        
        // MARK: - Scan Focus Mask
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(readingRect)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        maskLayer.fillRule = .evenOdd
        
        previewLayer.addSublayer(maskLayer)
        
        
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    
    // MARK: - Focus Edge Layer
    private func setFocusZoneCornerLayer() {
        var cornerRadius = previewLayer?.cornerRadius ?? CALayer().cornerRadius
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > rectOfInterest.width / 2 { cornerLength = rectOfInterest.width / 2 }
        
        // Focus Zone의 각 모서리 point
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2 - 50)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2 - 50)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2 - 50)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2 - 50)
        
        // 각 모서리를 중심으로 한 Edge를 그림
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                                radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        
        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
        
        // 그려진 UIBezierPath를 묶어서 CAShapeLayer에 path를 추가 후 화면에 추가
        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = UIColor(named: "Button2Color")?.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cornerLineWidth
        shapeLayer.lineCap = .round
        
        self.previewLayer!.addSublayer(shapeLayer)
    }
}

// MARK: - ReaderView Running Method
extension ReaderView {
    func start() {
        print("# AVCaptureSession Start Running")
        self.captureSession?.startRunning()
    }
    
    func stop(isButtonTap: Bool) {
        self.captureSession?.stopRunning()
        
        if let delegate = self.delegate {
                delegate.readerComplete(status: .stop(isButtonTap))
                delegate.readerViewDidCancel()
        }
    }
    
    func fail() {
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) {
        self.stop(isButtonTap: false)
        self.delegate?.readerComplete(status: .success(code))
    }
}

// MARK: - AVCapture Output
extension ReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard !isQRCodeProcessed,
              let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }
        
        if let qrCodeURL = URL(string: stringValue),
           let queryItems = URLComponents(url: qrCodeURL, resolvingAgainstBaseURL: false)?.queryItems {
            var price: String?
            var quantity: String?
            var menu: String?
            var number: String?
            
            for queryItem in queryItems {
                if queryItem.name == "price" {
                    price = queryItem.value
                } else if queryItem.name == "quantity" {
                    quantity = queryItem.value
                } else if queryItem.name == "item" {
                    menu = queryItem.value
                } else if queryItem.name == "number" {
                    number = queryItem.value
                }
            }
            
            print("price: \(price ?? "")")
            print("quantity: \(quantity ?? "")")
            print("menu: \(menu ?? "")")
            print("number: \(number ?? "")")
            
            isQRCodeProcessed = true
            
            DispatchQueue.main.async {
                self.showResultDialog(price: price, quantity: quantity, menu: menu, number:number)
            }
        }
    }
    
    private func showResultDialog(price: String?, quantity: String?, menu: String?, number: String?) {
        let alertController = UIAlertController(title: "\(price ?? "")원", message: "\(menu ?? "") \(quantity ?? "")개를 구매하시려는게 맞습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in
            self.delegate?.readerViewDidCancel()
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (_) in
            let priceInt = Int(price ?? "") ?? 0
            let quantityInt = Int(quantity ?? "") ?? 0
            let numberInt = Int(number ?? "") ?? 0
            
            if priceInt * quantityInt > self.myMoney {
                let paymentFailedAlertController = UIAlertController(title: "결제 실패", message: "잔액이 부족합니다", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (_) in
                    self?.delegate?.readerViewDidCancel()
                }
                paymentFailedAlertController.addAction(okAction)
                
                self.delegate?.presentAlertController(paymentFailedAlertController)
            }
            else {
                QRPayment(email: self.userEmail, balance: self.myMoney, menu: menu ?? "", price: priceInt, quantity: quantityInt, number: numberInt){ [weak self] _ in
                    guard let self else {
                        return
                    }
                    
                    let paymentAlertController = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (_) in

                        let realm = try! Realm()
                        
                        let currentMoney = UserDefaults.standard.integer(forKey: "money")
                        
                        let balance = currentMoney - priceInt
                        
                        UserDefaults.standard.setValue(balance, forKey: "money")
                        
                        let payment = PaymentRealmEntity(emailHash: SHA256.hash(data: self.userEmail.data(using: .utf8)!).compactMap { String(format: "%02x", $0)}.joined(), menu: menu ?? " ", price: "\(priceInt)", quantity: "\(quantityInt)", balance: "\(balance)")
                        
                        try! realm.write {
                            realm.add(payment)
                        }
                        
                        self.delegate?.readerViewDidCancel()
                    }
                    paymentAlertController.addAction(okAction)
                    
                    self.delegate?.presentAlertController(paymentAlertController)
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        delegate?.presentAlertController(alertController)
    }
}

internal extension CGPoint {
    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
