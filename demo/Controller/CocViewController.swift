//
//  ViewController.swift
//  demo
//
//  Created by Chun yu Tung on 2019/4/22.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import UIKit
import WebKit
import SQLite
import SafariServices

class CocViewController: UIViewController {

    var errorMessageLabel: UILabel!
    var activityIndicatorView: UIActivityIndicatorView!
    var searchController: UISearchController!
    
    let defaults = UserDefaults.standard
    var histories: [String]!
    
    
    // UserDefaults key
    struct Keys {
        static let histories = "histories"
    }
    
    var networkManager = NetworkManager()
    
    
    // declare a null dictionary
    var showList = [String:Array<String>]()
    
    var showListKeys = ["Details","heroes","troops","spells"]
    
    var cocImageView: UIImageView!
    var collectionView: UICollectionView!
    var historiesListView: HistoryTableView!
    var tagSearchBar: UISearchBar!
    
    var playerDetails: PlayerDetail?
    var originSearchBarX: CGFloat = 0
    var originSearchBarY: CGFloat = 0
    
    var db = DBManager()
    
    override func viewDidLayoutSubviews() {
        originSearchBarX = tagSearchBar.frame.origin.x
        originSearchBarY = tagSearchBar.frame.origin.y
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyBoard))
        view.addGestureRecognizer(tap)
        tap.delegate = self
        
        histories = defaults.object(forKey: Keys.histories) as? [String] ?? [String]()
        // database connect
        db.getConnection()
//        db.deleteTable()
        db.createTable()
        
    
        setupUI()
        setupAutoLayout()
    }
    
    @objc func DismissKeyBoard(_ gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
        if historiesListView != nil, historiesListView.isHidden == false {
            historiesListView.isHidden = true
        }
    }

    
    private func setShowList() {
        guard let player = playerDetails else { return }
        showList["heroes"] = player.heroes!.map( { $0.name} )
        showList["troops"] = player.troops!.map( { $0.name} )
        showList["spells"] = player.spells!.map( { $0.name} )
    }
    
    
    
    
    private func setupUI() {
        
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.cocImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "cocImage")
            imageView.clipsToBounds = false
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
       
        
        self.tagSearchBar = {
            let searchBar = UISearchBar()
            
            searchBar.placeholder = "#R8GJVV2C"
            searchBar.text = "#R8GJVV2C"
            searchBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            searchBar.delegate = self
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.searchBarStyle = .prominent
            searchBar.isTranslucent = false
            
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.textColor = .white
                textField.backgroundColor = self.view.backgroundColor
            }
            return searchBar
        }()
        
      
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        self.collectionView = {
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
            collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.identifier)
            collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.identifier)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = view.backgroundColor
            collectionView.isHidden = true
            return collectionView
        }()
        
        
        
        self.historiesListView = {
            let tableView = HistoryTableView()
            tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            tableView.isHidden = true
            tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: FooterView.identifier)
            
            //close self-sizing *
            tableView.estimatedRowHeight = 0.0
            tableView.estimatedSectionHeaderHeight = 0.0
            tableView.estimatedSectionFooterHeight = 0.0
            tableView.sectionFooterHeight = tableView.maxHeight * 0.1
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        // setup activityIndicatorView
        self.activityIndicatorView = {
            let activityView = UIActivityIndicatorView()
            activityView.style = UIActivityIndicatorView.Style.whiteLarge
            activityView.translatesAutoresizingMaskIntoConstraints = false
            return activityView
        }()
        
        self.errorMessageLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isHidden = true
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        
        
        // add to subview
        self.view.addSubview(self.cocImageView)
        self.view.addSubview(self.tagSearchBar)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.historiesListView)
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.errorMessageLabel)
        
    }
    
    
    private func setupAutoLayout() {
        //cocImageView
        cocImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cocImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cocImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        cocImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    
        // tagSearchBar
        tagSearchBar.topAnchor.constraint(equalTo: cocImageView.bottomAnchor).isActive = true
        tagSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tagSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //activityView
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
        // collection view
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: tagSearchBar.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // table view
        historiesListView.topAnchor.constraint(equalTo: tagSearchBar.bottomAnchor).isActive = true
        historiesListView.leadingAnchor.constraint(equalTo: tagSearchBar.leadingAnchor).isActive = true
        historiesListView.trailingAnchor.constraint(equalTo: tagSearchBar.trailingAnchor).isActive = true
    
        
        // errorMessageLabel
        errorMessageLabel.topAnchor.constraint(equalTo: self.collectionView.topAnchor).isActive = true
        errorMessageLabel.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        errorMessageLabel.leadingAnchor.constraint(equalTo: self.collectionView.leadingAnchor).isActive = true
        errorMessageLabel.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor).isActive = true
        
    }

}

extension CocViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = playerDetails else { return 0 }
        switch section {
            case 0:
                return 1
            default:
                return showList[showListKeys[section]]!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.identifier, for: indexPath) as! DetailCell
            guard let player = playerDetails else { return cell }
            
            if let urlStr = player.league?.iconUrls.small {
                networkManager.getImageDataFromUrl(urlStr: urlStr) { (data, error) in
                    if let error = error {
                        print(error)
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.update(player: player, image: UIImage(data: data))
                        }
                    }
                }
            } else {
                cell.update(player: player, image: UIImage(named: "72130c4"))
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            guard let player = playerDetails else { return cell }
            
            var item: Item?
            
            switch indexPath.section {
            case 1:
                item = player.heroes?[indexPath.row]
            case 2:
                item = player.troops?[indexPath.row]
            case 3:
                item = player.spells?[indexPath.row]
            default:
                item = nil
            }
            
            //long tap
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell))
            cell.addGestureRecognizer(longPressGesture)
            
            cell.update(item: item)
            return cell
        }
      
    }

    @objc func longPressCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let player = playerDetails else { return }
        let cell = gestureRecognizer.view as! ItemCell
        let indexPath: IndexPath! = collectionView?.indexPath(for: cell)
        var item: Item?
        switch indexPath.section {
        case 1:
            item = player.heroes?[indexPath.row]
        case 2:
            item = player.troops?[indexPath.row]
        case 3:
            item = player.spells?[indexPath.row]
        default:
            item = nil
        }
        
        if gestureRecognizer.state == .began {
            let pathStr = item?.name.replacingOccurrences(of: " ", with: "_")
            let urlStr = "https://clashofclans.fandom.com/wiki/"+"\(pathStr!)"
            let url = URL(string: urlStr)
            if let url = url {
                let safariVC = SFSafariViewController(url: url)
                safariVC.delegate = self
                self.present(safariVC, animated: true, completion: nil)
                
            }
            
        }

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.width * 0.3 )
        } else {
            return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.width * 0.2)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return showListKeys.count
    }
    
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell
            else {
                fatalError("Invalid view type")
            }
            
            header.backgroundColor = view.backgroundColor
            
            header.updateLabelText(text: showListKeys[indexPath.section])
            return header

        default:
            assert(false, "Invalid element type")
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.1)
    }
    

    
}

extension CocViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historiesListView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        
        cell.selectionStyle = .none
        cell.update(text: histories[indexPath.row])
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tagSearchBar.text = histories[indexPath.row]
        self.historiesListView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = self.historiesListView.dequeueReusableHeaderFooterView(
                            withIdentifier: FooterView.identifier) as? FooterView else { return nil }
        
        view.button.addTarget(self, action: #selector(clearHistoriesButtonClicked), for: .touchUpInside)
        return view
    }

    @objc func clearHistoriesButtonClicked(_ sender: UIButton) {
        histories = [String]()
        defaults.set(histories, forKey: Keys.histories)
        self.historiesListView.isHidden = true
    }
    
}

extension CocViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if histories.count > 0 {
            if let text = tagSearchBar.text, text.count > 0 {
                historiesListView.isHidden = true
            } else {
                historiesListView.isHidden = false
            }
        } else {
            historiesListView.isHidden = true
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if histories.count > 0 {
            if let text = tagSearchBar.text,text.count > 0 {
                historiesListView.isHidden = true
            } else {
                historiesListView.isHidden = false
            }
        } else {
            historiesListView.isHidden = true
       
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let tag = searchBar.text else { return }
        
        // use regex check tag
        let range = NSRange(location: 0, length: tag.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^#[A-Z0-9]{8}", options: [])
        guard regex.firstMatch(in: tag, options: [], range: range) != nil else {
            let alertController = UIAlertController(title: "tag格式錯誤，請重新查詢!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController,animated: true,completion: nil)
            return
        }
        
        activityIndicatorView.startAnimating()
        
        
        if let date = self.db.getLastUpdateDate(tag: tag), -date.timeIntervalSinceNow < 120 {
            print("load data from database")
            // load data from database :
            let data = self.db.loadDataToPlayer(tag: tag)
            
            do {
                self.playerDetails = try JSONDecoder().decode(PlayerDetail.self, from: data)
                if self.playerDetails != nil {
                    self.setShowList()
                    self.activityIndicatorView.stopAnimating()
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = false
                    self.errorMessageLabel.isHidden = true
                }
            } catch {
                print(error)
            }
        } else {
            // download data from internet :
            print("download data from internet")
            self.networkManager.getPlayerData(tag: tag) { (data, error) in
                if let error = error {
                    print("error")
                    DispatchQueue.main.async{
                        self.errorMessageLabel.text = "\(error)"
                        self.errorMessageLabel.isHidden = false
                        self.collectionView.isHidden = true
                        self.errorMessageLabel.isHidden = false
                        self.activityIndicatorView.stopAnimating()
                    }
                }
                if let data = data {
                    self.db.updateDownloadedDataToDatabase(tag: tag, data: data)
                    DispatchQueue.main.async {
                        do {
                            self.playerDetails = try JSONDecoder().decode(PlayerDetail.self, from: data)
                            if self.playerDetails != nil {
                                self.setShowList()
                                self.activityIndicatorView.stopAnimating()
                                self.collectionView.reloadData()
                                self.collectionView.isHidden = false
                                self.errorMessageLabel.isHidden = true
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                }
            
            }
        }
        
        //set history
        if !histories.contains(tag) {
            histories.append(tag)
            defaults.set(histories,forKey: Keys.histories)
            self.historiesListView.reloadData()
        }
        
        // close keyboard
        self.tagSearchBar.resignFirstResponder()
        
        
        //隱藏歷史查詢
        self.historiesListView.isHidden = true
    }
}



extension CocViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var view = touch.view
        while view != nil  {
            if view is UITableView {
                return false
            } else {
                view = view!.superview
            }
        }
        return true
    }
    
}

extension CocViewController: SFSafariViewControllerDelegate {
    
}

