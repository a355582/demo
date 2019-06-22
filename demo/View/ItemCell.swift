//
//  Cell.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/14.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    static let identifier = "ItemCellId"
    
    var imageView: UIImageView!
    
    var label: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        self.imageView = imageView
        self.addSubview(self.imageView)
        
        
        
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return label
        }()
        
        self.label = label
        self.addSubview(self.label)
        
        setupAutoLayout()
    
    }
    
    func setupAutoLayout() {
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        
        self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.label.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        self.label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.bounds.width * 0.5
        
        self.label.clipsToBounds = true
        self.label.layer.cornerRadius = self.bounds.width * 0.15
    }
    
    func update(item: Item?) {
        if let item = item {
            let image = UIImage(named: item.name)
            self.imageView.image = image
            self.label.text = "\(item.level)"
            
            if item.level == item.maxLevel {
                self.label.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                self.label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
        
    }
    
}
