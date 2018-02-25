//
//  ViewController.swift
//  WGQRadioGroupDemo
//
//  Created by disburden on 2018/2/23.
//  Copyright © 2018年 disburden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: define
    
    var inputRadioGroup:WGQRadioGroup?
    var effectRadioGroup:WGQRadioGroup?
    
    // MARK: lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initParameters()
        self.setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: private
    
    func initParameters() {
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = UIColor.init(red: 39/255, green: 40/255, blue: 42/255, alpha: 1);
    }
    
    func setupViews() {
        
        //初始化一些参数
        let imageSideLength = 23;
        var baseInfo = RadioBaseInfo();
        baseInfo.itemSize = CGSize(width: 91, height: 50);
        baseInfo.normalImage = baseInfo.normalImage.reSizeImage(reSize: CGSize(width: imageSideLength, height: imageSideLength));
        baseInfo.selectImage = baseInfo.selectImage.reSizeImage(reSize: CGSize(width: imageSideLength, height: imageSideLength));
        
        //添加音乐输入模式单选组
        let inputRadioOptions = ["VOD","BGM","OPT"];
        inputRadioGroup = WGQRadioGroup(baseInfomation: baseInfo, options: inputRadioOptions, delegate: self);
        if let radioGroup = inputRadioGroup
        {
            self.view.addSubview(radioGroup);
            radioGroup.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        //添加效果模式单选组
        //如果需要不同的选项样式可以重新创建一个BaseInfo
        let effectRadioOptions = ["唱将","通俗","美声","专业"];
        effectRadioGroup = WGQRadioGroup(baseInfomation: baseInfo, options: effectRadioOptions, delegate: self);
        if let radioGroup = effectRadioGroup
        {
            self.view.addSubview(radioGroup);
            radioGroup.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        //约束布局
        let bindings = ["inputRadioGroup":inputRadioGroup!,"effectRadioGroup":effectRadioGroup!];
        var constraints = [NSLayoutConstraint]();
        let metrics = ["inputH":CGFloat(inputRadioOptions.count) * baseInfo.itemSize.height,
                       "inputW":baseInfo.itemSize.width,
                       "effectH":baseInfo.itemSize.height*2,
                       "effectW":baseInfo.itemSize.width*2]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[inputRadioGroup(inputH)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings);
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-42-[inputRadioGroup(inputW)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings);
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[effectRadioGroup(effectH)]", options: NSLayoutFormatOptions(rawValue: 1), metrics: metrics, views: bindings);
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[inputRadioGroup]-38-[effectRadioGroup(effectW)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings);
        self.view.addConstraints(constraints);
    }
    
    // MARK: actions
    
    func leftButtonClicked(sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: help methords

}

extension UIImage {
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
}

extension ViewController:WGQRadioGroupProtocol {
    func valueDidChange(radioGroup: WGQRadioGroup, newIndex: Int) {
        if radioGroup == inputRadioGroup {
            print("更换音乐输入模式为:\(newIndex)")
        }
        
        if radioGroup == effectRadioGroup {
            print("更换效果模式为:\(newIndex)")
        }
    }
}

