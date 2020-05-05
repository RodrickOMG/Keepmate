//
//  ViewController.swift
//  PoseEstimation-CoreML
//
//  Created by GwakDoyoung on 05/07/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import SwiftUI
import UIKit
import Vision
import CoreMedia
import AVFoundation

let screenFrame = UIScreen.main.bounds
let screenWidth = screenFrame.size.width
let screenHeight = screenFrame.size.height

class JointViewController: UIViewController {
    public typealias DetectObjectsCompletion = ([PredictedPoint?]?, Error?) -> Void
    
    // MARK: - UI Properties
    @IBOutlet weak var videoPreview: UIView!
    
    @IBOutlet weak var labelsTableView: UITableView!
    
    @IBOutlet weak var inferenceLabel: UILabel!
    @IBOutlet weak var etimeLabel: UILabel!
    @IBOutlet weak var fpsLabel: UILabel!
    
    
    // MARK: - Performance Measurement Property
    let 👨‍🔧 = 📏()
    
    var delegate : CameraViewDelegate?
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    
    // MARK: - ML Properties
    // Core ML model
    typealias EstimationModel = model_cpm
    
    // Preprocess and Inference
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    // Postprocess
    var postProcessor: HeatmapPostProcessor = HeatmapPostProcessor()
    var mvfilters: [MovingAverageFilter] = []
    
    // Inference Result Data
    private var tableData: [PredictedPoint?] = []
    
    //
    var bodyPoints: [PredictedPoint?] = []
    var standardPoints: [CapturedPoint?] = []
    var standardPointsTest: [PredictedPoint?] = []
    var standardFlag = false
    var standardIndex = 0
    var standardPassFlag = false
    var standardCounsequentCount = 0
    var scoreSum = 0.0
    var tempScore: [Double] = [0.0, 0.0]
    var motionCount = 0
    var startTime = CFAbsoluteTimeGetCurrent()
    public var finishFlag = false
    
    public var name: String = String("Cossack Squat")
    
    lazy var jointView: DrawingJointView! = {
        let view = DrawingJointView()
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
        view.frame = self.view.frame
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(capturePoints), for: .touchUpInside)
        return button
    }()
    
    lazy var matchingValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Courier", size: 25)
        return label
    }()
    
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the model
        setUpModel()
        
        // setup camera
        setUpCamera()
        
        // setup tableview datasource on bottom
        
        loadWorkoutInfo()
        //labelsTableView.dataSource = self
        
        // setup delegate for performance measurement
        👨‍🔧.delegate = self
        
        view.addSubview(jointView)
        jointView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        view.addSubview(backButton)
        backButton.anchor(top: jointView.topAnchor, paddingTop: 4)
        view.addSubview(matchingValueLabel)
        matchingValueLabel.anchor(top: jointView.topAnchor, paddingTop: (screenHeight - screenWidth) / 2, paddingLeft: screenWidth / 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: EstimationModel().model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("cannot load the ml model")
        }
    }
    
    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                // add preview view on the layer
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.videoCapture.captureSession)
                previewLayer.frame = self.view.frame
                previewLayer.position = CGPoint(x: screenWidth / 2, y: (screenHeight - screenWidth) / 2)
                self.view.layer.addSublayer(previewLayer)

                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    func loadWorkoutInfo() {
        let path = Bundle.main.path(forResource: "Cossack Squat", ofType: "plist")
        let data = NSDictionary(contentsOfFile: path!)
        let arr: NSArray = data!["process"] as! NSArray
        motionCount = arr.count
    }
    
    @objc func capturePoints() {
//        let vc = UIHostingController(rootView: TabBarHomeView())s
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        //print(self.jointView.bodyPoints[0]?.maxPoint)
        let predictedPoints = jointView.bodyPoints
        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
            guard let predictedPoint = predictedPoint else { return nil }
            return CapturedPoint(predictedPoint: predictedPoint)
        }
        standardPoints = capturedPoints
        print(predictedPoints)
    }
    
    func compareWithStandardPoints() {
        if standardPassFlag {
            standardIndex += 1
        }
        
        if standardIndex < motionCount {
            standardPoints = Utilities.Gossack_Squat(standardIndex)
            if standardFlag {
                //print(standardPoints.matchVector(with: predictedPoints))
                //print(Utilities.judgePoints(predictedPoints, standardPointsTest))
                standardPassFlag = false
                let matchValue = standardPoints.matchVector(with: self.jointView.bodyPoints)
                if matchValue > 0.8 {
                    standardCounsequentCount += 1
                    if standardCounsequentCount >= 3 {
                        standardPassFlag = true
                        standardCounsequentCount = 0
                        scoreSum += tempScore[0] + tempScore[1] + Double(matchValue) * 100
                        tempScore = [0.0, 0.0]
                        print("hhh")
                    } else {
                        tempScore[standardCounsequentCount-1] = Double(matchValue) * 100
                    }
                } else {
                    standardCounsequentCount = 0
                }
                self.matchingValueLabel.text = String(format: "%.2f%", matchValue * 100) + "%"
            }
        } else {
            print("Finish!!!")
            finishFlag = true
            standardFlag = false
            let score = scoreSum / Double((motionCount * 3))
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            print("Score: ", score)
            print("Duration: ", duration)
            delegate?.CameraViewDidFinished(self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = self.view.bounds
    }
    
    func begin() {
        standardFlag = true
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func pause() {
        standardFlag = false
    }
}

// MARK: - VideoCaptureDelegate
extension JointViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if let pixelBuffer = pixelBuffer {
            // start of measure
            self.👨‍🔧.🎬👏()
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension JointViewController {
    // MARK: - Inferencing
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    // MARK: - Postprocessing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.👨‍🔧.🏷(with: "endInference")
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmaps = observations.first?.featureValue.multiArrayValue {
            
            /* =================================================================== */
            /* ========================= post-processing ========================= */
            
            /* ------------------ convert heatmap to point array ----------------- */
            var predictedPoints = postProcessor.convertToPredictedPoints(from: heatmaps)
            
            /* --------------------- moving average filter ----------------------- */
            if predictedPoints.count != mvfilters.count {
                mvfilters = predictedPoints.map { _ in MovingAverageFilter(limit: 3) }
            }
            for (predictedPoint, filter) in zip(predictedPoints, mvfilters) {
                filter.add(element: predictedPoint)
            }
            predictedPoints = mvfilters.map { $0.averagedValue() }
            /* =================================================================== */
            
            /* =================================================================== */
            /* ======================= display the results ======================= */
            DispatchQueue.main.sync {
                // draw line
                //print(predictedPoints)
                self.jointView.bodyPoints = predictedPoints
                if !finishFlag {
                    compareWithStandardPoints()
                }
                // show key points description
                //self.showKeypointsDescription(with: predictedPoints)
                
                // end of measure
                self.👨‍🔧.🎬🤚()
            }
            /* =================================================================== */
        } else {
            // end of measure
            self.👨‍🔧.🎬🤚()
        }
    }
    
    func showKeypointsDescription(with n_kpoints: [PredictedPoint?]) {
        self.tableData = n_kpoints
        self.labelsTableView.reloadData()
    }
}

// MARK: - UITableView Data Source
extension JointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count// > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = PoseEstimationForMobileConstant.pointLabels[indexPath.row]
        if let body_point = tableData[indexPath.row] {
            let pointText: String = "\(String(format: "%.3f", body_point.maxPoint.x)), \(String(format: "%.3f", body_point.maxPoint.y))"
            cell.detailTextLabel?.text = "(\(pointText)), [\(String(format: "%.3f", body_point.maxConfidence))]"
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
}

// MARK: - 📏(Performance Measurement) Delegate
extension JointViewController: 📏Delegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int) {
        //self.inferenceLabel.text = "inference: \(Int(inferenceTime*1000.0)) ms"
        //self.etimeLabel.text = "execution: \(Int(executionTime*1000.0)) ms"
        //self.fpsLabel.text = "fps: \(fps)"
    }
}


