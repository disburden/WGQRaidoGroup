# WGQRadioGroup



##### 使用超方便的单选组
------------------------------------------------------------

## Requirements
- iOS 8+
- Xcode 8+


## Demo 

![demo列表](https://github.com/disburden/WGQRaidoGroup/blob/master/ScreenShots/screenshot1.png?raw=true)



## Installation 

> **手动拖入**
> 将 WGQRaidoGroup 文件夹拽入项目中即可使用

## How To Use

```swift
        var baseInfo = RadioBaseInfo();
        baseInfo.normalImage = baseInfo.normalImage.reSizeImage(reSize: CGSize(width: imageSideLength, height: imageSideLength));
        baseInfo.selectImage = baseInfo.selectImage.reSizeImage(reSize: CGSize(width: imageSideLength, height: imageSideLength));
        
        //添加音乐输入模式单选组
        let inputRadioOptions = ["VOD","BGM","OPT"];
        inputRadioGroup = WGQRadioGroup(baseInfomation: baseInfo, options: inputRadioOptions,columnCount:1, delegate: self);
        if let radioGroup = inputRadioGroup
        {
            self.view.addSubview(radioGroup);
            radioGroup.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        //添加布局
        let metrics = ["inputH":150,
                       "inputW":91,
                       ...]
 
        let bindings = ["inputRadioGroup":inputRadioGroup!,"effectRadioGroup":effectRadioGroup!];  
        var constraints = [NSLayoutConstraint]();  
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[inputRadioGroup(inputH)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings);
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-42-[inputRadioGroup(inputW)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings);
        constraints += .....
                       
                       
```

代理方法  

```swift
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
```
  
# 下一步  
约束按钮的image为正方形

# Contact me
- Email:  disburden@gmail.com
- blog: http://blog.wgq.name

# License

WGQRaidoGroup is available under the MIT license. See the LICENSE file for more info.


