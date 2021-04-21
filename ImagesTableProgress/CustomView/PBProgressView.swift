//
//  PBProgressView.swift
//  ProgressBarTest
//
//  Created by MiciH on 4/18/21.
//

import UIKit

class PBProgressView: UIProgressView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        trackTintColor = .gray
        progressTintColor = .systemRed
        translatesAutoresizingMaskIntoConstraints = false
        progressViewStyle = .bar
    }
}
