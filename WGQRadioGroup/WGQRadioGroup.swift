//
//  WGQRadioGroup.swift
//  WGQRadioGroup
//
//  Created by disburden on 2018/2/1.
//  Copyright © 2018年 disburden. All rights reserved.
//  email:disburden@gmail.com

import UIKit

struct RadioBaseInfo {
    var backgroundColor:UIColor = UIColor.init(red: 39/255, green: 40/255, blue: 42/255, alpha: 1);
    
    var groupTitle:String? = "";
    var groupTitleFont:UIFont = UIFont.systemFont(ofSize: 17);

    var groupTitleTextColor:UIColor = UIColor.init(red: 89/255, green: 136/255, blue: 160/255, alpha: 1);
    var groupTitleLeftGap:CGFloat = 4;
    var groupTitleCenterX:Bool = false;
    
    var borderColor:UIColor = UIColor.init(red: 89/255, green: 136/255, blue: 160/255, alpha: 1);
    var borderWidth:CGFloat = 0.5;
    var cornerRadius:CGFloat = 4;
    
    var itemSize:CGSize = CGSize(width: 1, height: 1)
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
    func valueShouldChange(radioGroup:WGQRadioGroup, newIndex:Int) -> Bool;
    func valueDidChange(radioGroup:WGQRadioGroup, newIndex:Int);
}

class WGQRadioGroup: UIView {

    private let  collection:UICollectionView;
    private let  columnCount:Int;
    private let options:[String]
    private let itemIdentifier = "radioItem";
    private let titleLabel:UILabel = UILabel();
    private let container:UIView = UIView();
    private var labelSize:CGSize = CGSize.zero;
    var delegate:WGQRadioGroupProtocol?
    
    
    
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
         columnCount:Int,
         delegate:WGQRadioGroupProtocol) {

        self.delegate = delegate;
        self.options = options;
        self.columnCount = columnCount;
        baseInfo = baseInfomation;
        layout.itemSize = baseInfo!.itemSize;
        
        self.collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        
        super.init(frame: CGRect.zero);
        setupViews();
        
    }
    

    
    private func setupViews()
    {
        self.backgroundColor = baseInfo?.backgroundColor;
        self.translatesAutoresizingMaskIntoConstraints = false;
        container.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        var collectionViewTop:CGFloat = 0.0;
        if (baseInfo?.groupTitle?.isEmpty == false) ||
            (baseInfo?.groupTitle == ""){
            //先计算出label的尺寸
            titleLabel.font = baseInfo?.groupTitleFont;
            titleLabel.text = baseInfo?.groupTitle;
            titleLabel.textColor = baseInfo?.groupTitleTextColor;
            labelSize = titleLabel.sizeThatFits(CGSize.zero);
            print(labelSize);
            titleLabel.backgroundColor = baseInfo?.backgroundColor;
            
            
            collectionViewTop = labelSize.height;
            //添加容器
            addSubview(container);
            container.backgroundColor = baseInfo?.backgroundColor
            addSubview(titleLabel);
            
            container.layer.borderColor = baseInfo?.borderColor.cgColor;
            container.layer.borderWidth = (baseInfo?.borderWidth)!;
            container.layer.cornerRadius = (baseInfo?.cornerRadius)!;
            let bandings = ["container":container,"titleLabel":titleLabel,"self":self];
            let metrics = ["top":(labelSize.height / 2.0),
                           "labelW":labelSize.width,
                           "labelH":labelSize.height,
                           "leftGap":baseInfo!.groupTitleLeftGap];
            var constraints = [NSLayoutConstraint]();
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[container]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bandings);
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bandings);
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel(labelH)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bandings);
            if (baseInfo?.groupTitleCenterX)! {
                let constraintCenterX = NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0);
                self.addConstraint(constraintCenterX);
            } else
            {
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftGap-[titleLabel(labelW)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bandings);
            }
            self.addConstraints(constraints);
            
            
        } else {
            print("no titile")
        }
        
        
        addSubview(collection);
        collection.translatesAutoresizingMaskIntoConstraints = false;
        self.translatesAutoresizingMaskIntoConstraints = false;
        let bandings = ["view":collection];
        let metrics = ["top":collectionViewTop];
        var constraints = [NSLayoutConstraint]();
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bandings);
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.delegate{
            return (delegate.valueShouldChange(radioGroup: self, newIndex: indexPath.row));
        }
        return true;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row;
        self.delegate?.valueDidChange(radioGroup: self ,newIndex: self.selectIndex);
    }
}

extension WGQRadioGroup:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowCount = ceil(Double(self.options.count / self.columnCount))
        return CGSize(width: collectionView.frame.size.width / CGFloat(self.columnCount),
                          height: collectionView.frame.size.height / CGFloat(rowCount));
    }
}



