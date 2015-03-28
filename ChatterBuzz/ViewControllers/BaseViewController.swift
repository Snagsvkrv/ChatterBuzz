//
//  BaseViewController.swift
//  swiggy
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Atul Manwar. All rights reserved.
//

import UIKit
import CoreLocation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

class BaseViewController: UIViewController {
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
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        self.view.insertSubview(activityIndicator, atIndex: 5)
        
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "GeezaPro", size: 15)!]
        stopActivty()
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: (244/255.0), green: (67/255.0), blue: (54/255.0), alpha: 1.0)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.translucent = false
    }
    
    func sendRequest(requestType: RequestType, httpMethod: HTTPMethod, queryString: NSString, data: NSData, completionHandler handler: (NSDictionary!, NSError!) -> Void) {
        self.startActivity()
        var queryParams = "\(queryString)"
        
        //TODO: remove when using a device
//        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied {
//            queryParams += "&lat=\(locationManager.location.coordinate.latitude)&lng=\(locationManager.location.coordinate.latitude)"
//        }
        var url = "\(requestType.rawValue)\(queryParams)"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
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
