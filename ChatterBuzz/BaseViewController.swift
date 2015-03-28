//
//  BaseViewController.swift
//  swiggy
//
//  Created by Atul Manwar on 11/03/15.
//  Copyright (c) 2015 www.swiggy.in. All rights reserved.
//

import UIKit
import CoreLocation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

//enum ServerURL: NSString {
//    case STAGING = "http://api.swiggy.in"
//}

private let readFromFile = false

class BaseViewController: UIViewController, CheckoutButtonDelegate {
    var activityIndicator: UIActivityIndicatorView!
    private let queue:NSOperationQueue = NSOperationQueue()

    weak var locationManager: CLLocationManager!
    private var rightBarButtonItem: UIBarButtonItem!
    private var backBarButtonItem: UIBarButtonItem!
//    private var serverURL = ServerURL.STAGING
    
    var hideToolbar: Bool = false {
        didSet {
            self.navigationController?.setToolbarHidden(hideToolbar, animated: true)
        }
    }
    
    func viewDidLoad(customBackButton: Bool) {
        super.viewDidLoad()
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        var backButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        backButton.backgroundColor = UIColor.clearColor()
        backButton.addTarget(self, action: "backButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if customBackButton {
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.leftBarButtonItem = backBarButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
            self.navigationItem.hidesBackButton = true
        }
        locationManager = appDelegate.locationManager
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        self.view.insertSubview(activityIndicator, atIndex: 5)
        
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "GeezaPro", size: 15)!]
        stopActivty()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (244/255.0), green: (67/255.0), blue: (54/255.0), alpha: 1.0)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.translucent = false
    }
    
    func configureRightButton() {
        rightBarButtonItem = UIBarButtonItem(customView: CheckoutButton.sharedInstance)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        CheckoutButton.sharedInstance.delegate = self
    }
    
    func proceedToCheckout() {
    }
    
    func sendRequest(requestType: RequestType, httpMethod: HTTPMethod, queryString: NSString, data: NSData, completionHandler handler: (NSDictionary!, NSError!) -> Void) {
        startActivity()
        var queryParams = "\(queryString)"
        
        //TODO: remove when using a device
//        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied {
//            queryParams += "&lat=\(locationManager.location.coordinate.latitude)&lng=\(locationManager.location.coordinate.latitude)"
//        }
        if readFromFile == true {
            let path = NSBundle.mainBundle().pathForResource(requestType.jsonFileName(), ofType: "json")
            let jsonData = NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let responseJSON = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            handler(responseJSON, nil)
        } else {
            var url = "http://52.74.55.161\(requestType.rawValue)\(queryParams)" //test.swiggy.in
            var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
            request.setValue("swiggy_iOS", forHTTPHeaderField: "user-agent")
            request.setValue(iOSVersion, forHTTPHeaderField: "os_version")
            request.setValue(device, forHTTPHeaderField: "device")
            request.setValue(appVersion, forHTTPHeaderField: "appVersion")
            request.setValue(SwUser.sharedUserInstance.authKey, forHTTPHeaderField: "tid")
            request.HTTPMethod = httpMethod.rawValue
            
            if httpMethod == HTTPMethod.POST {
                request.HTTPBody = data
            }

            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                /* Your code */
                var err: NSError?
                NSLog("%@", request.URL!)
                NSLog("%@", NSString(data: data, encoding: NSUTF8StringEncoding)!)
                let responseJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
                dispatch_async( dispatch_get_main_queue(), {
                    handler(responseJSON, err)
                })
            })
        }
    }
    
    func cancelAllOperations() {
        queue.cancelAllOperations()
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func startActivity() {
        hideKeyboard()
        for subView:UIView in self.view.subviews as [UIView] {
            subView.hidden = true
        }
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func stopActivty() {
        for subView:UIView in self.view.subviews as [UIView] {
            subView.hidden = false
        }
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func updateViewUsingData(jsonResult: NSDictionary, requestType: RequestType) {
        stopActivty()
    }
    
    func showError(error: NSError, requestType: RequestType) {
        stopActivty()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SwUtility.saveData()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
