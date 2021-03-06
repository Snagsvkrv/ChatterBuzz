//
//  SignupViewController.swift
//  ChatterBuzz
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 sfm. All rights reserved.
//

import UIKit

class SignupViewController: BaseViewController {
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupButton: UIButton!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
    }

    override func viewDidLoad() {
        super.viewDidLoad(false)
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    @IBAction func signup() {
        self.performSegueWithIdentifier("profile", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

