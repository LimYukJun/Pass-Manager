//
//  ScannerView.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    let onScan: (String) -> Void

    func makeUIViewController(context: Context) -> ScannerVC {
        let vc = ScannerVC()
        vc.onScan = onScan
        return vc
    }

    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
}

final class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var onScan: ((String) -> Void)?

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Camera preview must be on main thread
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.bounds
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)

        // Session configuration must be on ONE serial queue
        sessionQueue.async {
            self.session.beginConfiguration()

            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input) else {
                self.session.commitConfiguration()
                return
            }

            let output = AVCaptureMetadataOutput()
            guard self.session.canAddOutput(output) else {
                self.session.commitConfiguration()
                return
            }

            self.session.addInput(input)
            self.session.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: self.sessionQueue)
            output.metadataObjectTypes = [.pdf417, .qr, .code128]

            self.session.commitConfiguration()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = obj.stringValue else { return }

        sessionQueue.async {
            self.session.stopRunning()
        }

        DispatchQueue.main.async {
            self.onScan?(value)
        }
    }
}

    
