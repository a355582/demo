//
//  HistoryTableView.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/25.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import UIKit

class HistoryTableView: UITableView {

    var maxHeight = UIScreen.main.bounds.size.height * 0.3
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }

}
