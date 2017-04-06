//
//  BQSettingView.swift
//  YouTube
//
//  Created by xiupai on 2017/3/16.
//  Copyright © 2017年 QQLS. All rights reserved.
//

import UIKit

import SnapKit

private let reuseIdentifier = UITableViewCell.nameOfClass

protocol BQSettingViewDelegate: class {
    func switchSettingViewTo(hidden: Bool)
}

class BQSettingView: UIView {
    
    // Variate & Constant
    let rowHeight: Float = 45
    let items = ["设置", "条款和隐私政策", "反馈", "帮助", "切换账户", "取消"]
    let itemsImageName = [Asset.Settings.image, Asset.TermsPrivacyPolicy.image, Asset.SendFeedback.image, Asset.Help.image, Asset.SwithAccount.image, Asset.Cancel.image]
    weak var delegate: BQSettingViewDelegate?
    
    // MARK: - Lazy
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = CGFloat(self.rowHeight)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    private lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.alpha = 0
        bgView.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BQSettingView.dismiss))
        bgView.addGestureRecognizer(tapGesture)
        return bgView
    }()
    
    // MARK: - Action
    func show() {
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(-rowHeight * Float(items.count))
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0.5
            self.tableView.superview?.layoutIfNeeded()
        }) { (_) in
            self.tableView.reloadData()
        }
    }
    
    @objc fileprivate func dismiss() {
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(0)
        }
        UIView.animate(withDuration: 0.25, animations: { 
            self.bgView.alpha = 0
            self.tableView.superview?.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
            self.delegate?.switchSettingViewTo(hidden: true)
        }
    }
    
    // MARK: - Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        p_setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func p_setupView() {
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(rowHeight * Float(items.count))
        }
        // 下面的方法只有作用在父视图上才会起作用
        layoutIfNeeded()
    }
}

extension BQSettingView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.imageView?.image = itemsImageName[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension BQSettingView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
    }
}
