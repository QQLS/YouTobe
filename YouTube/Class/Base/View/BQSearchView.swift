//
//  BQSearchView.swift
//  YouTube
//
//  Created by xiupai on 2017/3/16.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import Alamofire

private let reuseIdentifier = SearchResultCell.nameOfClass

protocol BQSearchViewDelegate: class {
    func searchViewSwitchTo(hidden: Bool)
}

class BQSearchView: UIView {
    
    // MARK: - Variate & Constant
    let kSearchBarHeight = 68
    var items = [String]()
    weak var delegate: BQSearchViewDelegate?
    
    // MARK: - Lazy
    private lazy var statusBar: UIView = {
        let statusBar = UIView()
        statusBar.backgroundColor = .black
        statusBar.alpha = 0.15
        return statusBar
    } ()
    
    private lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        searchView.alpha = 0
        return searchView
    } ()
    
    private lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.alpha = 0
        bgView.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        bgView.addGestureRecognizer(tapGesture)
        return bgView
    } ()
    
    private lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setBackgroundImage(Asset.Cancel.image, for: [])
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return cancelBtn
    }()
    
    fileprivate lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.delegate = self
        searchBar.placeholder = "搜索🔍"
        searchBar.keyboardAppearance = .dark
        return searchBar
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = CGFloat(self.kSearchBarHeight) - kStatusBarHeight
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Action
    func show() {
        UIView.animate(withDuration: 0.25) { 
            self.bgView.alpha = 0.5
            self.searchView.alpha = 1
            self.searchBar.becomeFirstResponder()
        }
    }
    
    @objc fileprivate func dismiss() {
        searchBar.text = nil
        items.removeAll()
        tableView.removeFromSuperview()
        UIView.animate(withDuration: 0.25, animations: { 
            self.bgView.alpha = 0
            self.searchView.alpha = 0
            self.searchBar.resignFirstResponder()
        }) { (_) in
            self.removeFromSuperview()
            self.delegate?.searchViewSwitchTo(hidden: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        p_setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func p_setupView() {
        addSubview(bgView)
        addSubview(searchView)
        searchView.addSubview(cancelBtn)
        searchView.addSubview(searchBar)
        addSubview(statusBar)
        addSubview(tableView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        searchView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(kSearchBarHeight)
        }
        // 设置取消按钮内容固定,拉伸其他控件
        cancelBtn.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
        }
        searchBar.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(cancelBtn.snp.right)
            make.centerY.equalTo(cancelBtn.snp.centerY)
        }
        statusBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kStatusBarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension BQSearchView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
        cell.resultLabel.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BQSearchView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = items[indexPath.row]
    }
}

// MARK: - UITextFieldDelegate
extension BQSearchView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let keyword = textField.text, keyword.characters.count != 0 else {
            self.items.removeAll()
            self.tableView.reloadData()
            return true
        }
        
        request(URLLink.requestSuggestions(for: keyword), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let resultArr = (response.value as? [Any]),
                resultArr.count > 0,
                let items = (resultArr[1] as? [String]) else {
                return
            }
            self.items = items
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss()
        return true
    }
}


// MARK: - Cell
class SearchResultCell: UITableViewCell {
    lazy var resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.textColor = .gray
        return resultLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
