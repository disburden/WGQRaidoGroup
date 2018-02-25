//
//  WGQRadioGroup.swift
//  WGQRadioGroup
//
//  Created by disburden on 2018/2/1.
//  Copyright © 2018年 disburden. All rights reserved.
//  email:disburden@gmail.com

import UIKit

struct RadioBaseInfo {
    var itemSize:CGSize = CGSize(width: 50, height: 50)
    var itemTitleFont = UIFont.systemFont(ofSize: 14)
    var itemTitle = "";
    var itemTitleNormalColor = UIColor.init(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    var itemTitleSelectColor = UIColor.init(red: 89/255, green: 136/255, blue: 160/255, alpha: 1);
    var normalImage:UIImage = {
        let imageData = Data.init(base64Encoded: Config.dotIamgeStr);
        let image = UIImage.init(data: imageData!);
        return image!;
    }()
    var selectImage:UIImage = {
        let imageData = Data.init(base64Encoded: Config.dotSelectStr);
        let image = UIImage.init(data: imageData!);
        return image!;
    }()
}

fileprivate var baseInfo:RadioBaseInfo?;

/// UICollectionCell 类
class RadioItem: UICollectionViewCell {
    let btn = UIButton();
    
    var optionTitle:String? {
        didSet {
            self.refresh()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);

        self.addSubview(btn);
        
        btn.translatesAutoresizingMaskIntoConstraints = false;
        self.translatesAutoresizingMaskIntoConstraints = false;
        let bandings = ["btn":btn];
        var constraints = [NSLayoutConstraint]();
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[btn]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bandings);
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[btn]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bandings);
        self.addConstraints(constraints);
        
        if let baseInfo = baseInfo {
            btn.titleLabel?.font = baseInfo.itemTitleFont;
            btn.setImage(baseInfo.normalImage, for: .normal);
            btn.setImage(baseInfo.selectImage, for: .selected);
            btn.setTitleColor(baseInfo.itemTitleNormalColor, for: .normal);
            btn.setTitleColor(baseInfo.itemTitleSelectColor, for: .selected);
        }
        
        
        btn.isSelected = self.isSelected;
        btn.isUserInteractionEnabled = false;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    }
    

    
    func refresh(){
        btn.setTitle(optionTitle, for: .normal);
    }
    
}



/// WGQRadioGroup 主类
protocol WGQRadioGroupProtocol {
    func valueDidChange(radioGroup:WGQRadioGroup, newIndex:Int);
}

class WGQRadioGroup: UIView {

    let collection:UICollectionView;
    private let options:[String]
    var delegate:WGQRadioGroupProtocol?
    
    private let itemIdentifier = "radioItem";
    
    private let layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        return layout;
    }()
    
    var selectIndex:Int = -1 {
        didSet {
            collection.reloadData();
        }
    };
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("big error");
    }
    
    init(baseInfomation:RadioBaseInfo,
         options:[String],
         delegate:WGQRadioGroupProtocol) {

        self.delegate = delegate;
        self.options = options;
        baseInfo = baseInfomation;
        layout.itemSize = baseInfo!.itemSize;
        
        self.collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        
        super.init(frame: CGRect.zero);
        setupViews();
        
    }
    
    private func setupViews()
    {
        addSubview(collection);
        
        collection.translatesAutoresizingMaskIntoConstraints = false;
        self.translatesAutoresizingMaskIntoConstraints = false;
        let bandings = ["view":collection];
        var constraints = [NSLayoutConstraint]();
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bandings);
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bandings);
        self.addConstraints(constraints);
        
        collection.backgroundColor = UIColor.clear
        collection.register(RadioItem.self, forCellWithReuseIdentifier: itemIdentifier);
        collection.delegate = self;
        collection.dataSource = self;
        
    }
}

extension WGQRadioGroup:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.options.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item:RadioItem = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath) as! RadioItem;
        item.optionTitle = self.options[indexPath.row];
        item.isSelected = indexPath.row == self.selectIndex;
        item.btn.isSelected = item.isSelected;
        return item;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row;
        self.delegate?.valueDidChange(radioGroup: self ,newIndex: self.selectIndex);
    }
}


