//
//  CustomPopBoxView.swift
//  OuBiDemo
//
//  Created by 陈微 on 2018/12/20.
//  Copyright © 2018年 chenwei. All rights reserved.
//

import UIKit
import SnapKit

class CustomPopBoxView: UIView {
    
    class func showPopBoxView(menuArr:Array<String>, selectMenuIndex:Int, showInView:UIView,selectCallBack:@escaping (_ selectMenuIndex:Int,_ selectMenu:String)->()){
        let popView = CustomPopBoxView()
        showInView.addSubview(popView)
        popView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        popView.popMenuArr = menuArr
        popView.selectMenuCallBack = selectCallBack
        popView.selectMenuIndex = selectMenuIndex
        
        popView.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            popView.alpha = 1.0
        }
    }
    
    fileprivate var popMenuTable = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate var selectMenuIndex = 0 {
        didSet{
            if let callBack = selectMenuCallBack{
                callBack(selectMenuIndex,popMenuArr[selectMenuIndex])
            }
            popMenuTable.reloadData()
        }
    }
   fileprivate var popMenuArr: Array<String> = [] {
        didSet{
            let tableHeight = popMenuArr.count > 5 ? 330 : popMenuArr.count * 60
            popMenuTable.snp.updateConstraints({ (make) in
                make.height.equalTo(tableHeight)
            })
            popMenuTable.reloadData()
        }
    }
    
    fileprivate var selectMenuCallBack:((_ selectMenuIndex:Int,_ selectMenu:String)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 设置子视图
extension CustomPopBoxView{
    fileprivate func setSubView(){
        //设置背景色
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let tapBtn = UIButton(type: .custom)
        tapBtn.backgroundColor = UIColor.clear
        self.addSubview(tapBtn)
        tapBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        tapBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        popMenuTable.backgroundColor = UIColor.white
        self.addSubview(popMenuTable)
        popMenuTable.bounces = false
        popMenuTable.clipsToBounds = true
        popMenuTable.layer.cornerRadius = 5.0
        popMenuTable.separatorStyle = .singleLine
        popMenuTable.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        popMenuTable.snp.makeConstraints({ (make) in
            make.height.equalTo(330)
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.centerY.equalToSuperview()
        })
        
        popMenuTable.register(PopMenuCell.self, forCellReuseIdentifier: "PopMenuCell")
        
        popMenuTable.delegate = self
        popMenuTable.dataSource = self
        popMenuTable.bounces = false
        popMenuTable.showsVerticalScrollIndicator = false
    }
    
    @objc fileprivate func hideView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }) { (finish) in
            if(finish){
                self.removeFromSuperview()
            }
        }
    }
}

extension CustomPopBoxView: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return popMenuArr.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PopMenuCell = tableView.dequeueReusableCell(withIdentifier:"PopMenuCell" , for: indexPath) as! PopMenuCell
        cell.updateCell(menuText: popMenuArr[indexPath.row], isSelect: indexPath.row == selectMenuIndex)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMenuIndex = indexPath.row
        self.hideView()
    }
}


class PopMenuCell: UITableViewCell {
    
    var menuTitleLabel = UILabel()
    var selectImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        creatSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatSubView() {
        
        contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        menuTitleLabel.textColor = UIColor.black
        menuTitleLabel.font = UIFont.systemFont(ofSize: 16)
        menuTitleLabel.backgroundColor = UIColor.clear
        menuTitleLabel.numberOfLines = 0
        contentView.addSubview(menuTitleLabel)
        menuTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(30)
            make.right.equalTo(-60)
            make.centerY.equalTo(self.contentView)
        })
        
        selectImageView.backgroundColor = UIColor.red
        contentView.addSubview(selectImageView)
        selectImageView.snp.makeConstraints({ (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        })
    }
    
    func updateCell(menuText: String,isSelect: Bool) {
        menuTitleLabel.text = menuText
        selectImageView.isHidden = !isSelect
        contentView.backgroundColor = isSelect ? UIColor.init(red: 133.0/255, green: 157.0/255, blue: 185.0/255, alpha: 1.0) : UIColor.white
    }
}
