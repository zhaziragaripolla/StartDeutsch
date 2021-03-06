//
//  LoadingOverlay.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/28/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    public func showOverlay(view: UIView) {

        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        overlayView.center = view.center
        overlayView.alpha = 0.7
        overlayView.backgroundColor = .black
        overlayView.clipsToBounds = true

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)

        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
    }

    public func hideOverlayView() {
        DispatchQueue.main.async {
             self.activityIndicator.stopAnimating()
        }
        if overlayView.superview != nil {
           overlayView.removeFromSuperview()
        }
    }
}

public class ConnectionFailOverlay {
    
    var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var label: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .systemGray6
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    class var shared: ConnectionFailOverlay {
        struct Static {
            static let instance: ConnectionFailOverlay = ConnectionFailOverlay()
        }
        return Static.instance
    }

    public func showOverlay(view: UIView, message: String) {
        overlayView.addSubview(label)
        label.text = message
        label.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        })
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        })
    }

    public func hideOverlayView() {
        if overlayView.superview != nil {
            overlayView.removeFromSuperview()
        }
    }
}

