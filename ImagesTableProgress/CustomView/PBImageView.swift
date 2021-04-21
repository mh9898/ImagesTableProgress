//
//  PBImageView.swift
//  ImagesTableProgress
//
//  Created by MiciH on 4/20/21.
//

import UIKit

class PBImageView: UIImageView {
    
    let placeHolderImage = UIImage(systemName: "photo")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = placeHolderImage
        contentMode = .scaleAspectFit
    }
    
}
