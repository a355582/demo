//
//  HeaderCell.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/20.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    static let identifier = "headerCellId"
    
    var headerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        
        self.addSubview(label)
        self.headerLabel = label
        self.headerLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.headerLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.headerLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    func updateLabelText(text: String) {
        self.headerLabel.text = text
    }
    
}
