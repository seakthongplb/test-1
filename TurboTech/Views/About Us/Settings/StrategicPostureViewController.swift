//
//  StrategicPostureViewController.swift
//  TurboTech
//
//  Created by sq on 7/17/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class StrategicPostureViewController: UIViewController {
    
    @IBOutlet weak var missionLabel : UILabel!
    @IBOutlet weak var visionLabel : UILabel!
    @IBOutlet weak var valueLabel : UILabel!
    @IBOutlet weak var missionTextView : UITextView!
    @IBOutlet weak var visionTextView : UITextView!
    @IBOutlet weak var valueTextView : UITextView!
    @IBOutlet weak var missionHeaderView : UIView!
    @IBOutlet weak var missionContainerView : UIView!
    @IBOutlet weak var visionHeaderView : UIView!
    @IBOutlet weak var visionContainerView : UIView!
    @IBOutlet weak var valueHeaderView : UIView!
    @IBOutlet weak var valueContainerView : UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setup()
    }
    
    private func setup() {
        visionHeaderView.layer.cornerRadius = SIZE.RADIUS_CARD
        missionHeaderView.layer.cornerRadius = SIZE.RADIUS_CARD
        valueHeaderView.layer.cornerRadius = SIZE.RADIUS_CARD
        
        visionContainerView.layer.cornerRadius = SIZE.RADIUS_CARD
        missionContainerView.layer.cornerRadius = SIZE.RADIUS_CARD
        valueContainerView.layer.cornerRadius = SIZE.RADIUS_CARD
        
        visionContainerView.layer.borderWidth = 1.0
        visionContainerView.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        missionContainerView.layer.borderWidth = 1.0
        missionContainerView.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        valueContainerView.layer.borderWidth = 1.0
        valueContainerView.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
    }
    
    private func setData() {
        visionLabel.text = "mission".localized
        missionLabel.text = "vision".localized
        valueLabel.text = "value".localized
        visionTextView.text = "strategic posture mission".localized
        missionTextView.text = "strategic posture vision".localized
        valueTextView.text = "strategic posture value".localized
    }
}
