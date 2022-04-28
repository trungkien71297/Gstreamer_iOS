//
//  ViewController.swift
//  G2
//
//  Created by MAC013 on 4/28/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!
    var gstBackend : GstBackend?
    override func viewDidLoad() {
        super.viewDidLoad()
        gstBackend = GstBackend.init(preview: previewView)
        // Do any additional setup after loading the view.
    }
    @IBAction func play(sender: UIButton) {
        gstBackend?.play();
    }


}

