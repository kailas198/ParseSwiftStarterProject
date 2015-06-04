//
//  DetailViewController.swift
//  ParseStarterProject
//
//  Created by Mat on 31/05/2015.
//  Copyright (c) 2015 Parse. All rights reserved.
//



import UIKit

let imageScrollLargeImageName = PFImageView()
let imageScrollSmallImageName = PFImageView()

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    
    // Some text fields
    @IBOutlet weak var nameCondition: UILabel!
    //@IBOutlet weak var nameTreatment: UILabel!
   // @IBOutlet weak var capital: UITextField!
   // @IBOutlet weak var currencyCode: UITextField!
        @IBOutlet weak var image: PFImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!

    
    
     @IBOutlet weak var imageSizeToggleButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var lastZoomScale: CGFloat = -1
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        
     
    
        
        scrollView.delegate = self
        
        updateZoom()
        
        
        
        // Unwrap the current object object
        if let object = currentObject {
       //     nameCondition.text = object["nameCondition"] as! String
         //   nameTreatment.text = object["nameTreatment"] as! String
            //capital.text = object["capital"] as! String
           // currencyCode.text = object["currencyCode"] as! String
            
            var imageView = UIImage(named: "question")
            image.image = imageView
            println(image)
            if let UIImageView = object["image"] as? PFFile {
                image.file = UIImageView
                image.loadInBackground()
            var imageView = PFImageView(frame: CGRectMake(self.view.frame.width, 0, self.view.frame.width, 200))
                imageView.backgroundColor = UIColor.blackColor()
                imageView.clipsToBounds = true
                imageView.userInteractionEnabled = true
                
                imageView.contentMode = .Center
                imageView.contentMode = .ScaleAspectFill
                imageView.autoresizingMask = (.FlexibleBottomMargin | .FlexibleHeight | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin | .FlexibleWidth)
                

           
                
                
                
            }
            updateZoom()
           

        }
        updateZoom()
        
    
    }
    
 
    
    override func willAnimateRotationToInterfaceOrientation(
        toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
            
            super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            updateZoom()
    }
    
   
    
    func updateConstraints() {
        if let image = image.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
       
            let viewWidth = view.bounds.size.width
            let viewHeight = view.bounds.size.height
            
            // center image if it is smaller than screen
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }
    // Zoom to show as much image as possible unless image is smaller than screen
    private func updateZoom() {
        if let image = image.image {
            var minZoom = min(view.bounds.size.width / image.size.width,
                view.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
            
        }
    }
    
    
    
    @IBAction func onImageSizeToggleButtonTapped(sender: AnyObject) {
        imageSizeToggleButton.selected = !imageSizeToggleButton.selected
        imageSizeToggleButton.invalidateIntrinsicContentSize()
        
        let fileName = imageSizeToggleButton.selected ?
            imageScrollSmallImageName : imageScrollLargeImageName
        
        image.image = UIImage()
        updateZoom()
    }
    
   

    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return image
    }


  
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}