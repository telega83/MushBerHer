//
//  HerbsDetailsVC.swift
//  MushBerHer
//
//  Created by Oleg on 20/11/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import UIKit

class HerbsDetailsVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var itemTitle = String()
    var img = String()
    var text = String()
    
    var isZooming = false
    var originalImageCenter: CGPoint?
    
    func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            let currentScale = self.imgItem.frame.size.width / self.imgItem.bounds.size.width
            let newScale = currentScale*sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.imgItem.frame.size.width / self.imgItem.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imgItem.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                self.imgItem.transform = CGAffineTransform.identity
                self.imgItem.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.imgItem.superview)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.imgItem.addGestureRecognizer(pinch)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.delegate = self
        self.imgItem.addGestureRecognizer(pan)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imgItem.image = UIImage(named: img)
        lblTitle.text = itemTitle
        
        let attrText = TextFormatter(text: text).getAttributedText()
        txtDetails.attributedText = attrText
    }
}
