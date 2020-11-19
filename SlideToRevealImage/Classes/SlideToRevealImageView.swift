import UIKit
import Foundation

@IBDesignable
public class SlideToRevealImageView: UIView {
    
    fileprivate var trailingAnchors: [NSLayoutConstraint] = [NSLayoutConstraint]()
    fileprivate var lastXs: [CGFloat] = [CGFloat]()
    
    fileprivate var imageViews: [UIImageView] = [UIImageView]()
    fileprivate var imageWrappers: [UIView] = [UIView]()
    
    fileprivate var thumbViews: [UIImageView] = [UIImageView]()
    fileprivate var thumbWrappers: [UIView] = [UIView]()
    
    fileprivate var startPercentages: [CGFloat] = [CGFloat]()
    
    fileprivate var imageViewBase: UIImageView = UIImageView()
    
    fileprivate var _thumbAtBottom: Bool = false
    
    open func setBaseImage(image: UIImage) {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = image
        imageViewBase = iv
    }
    
    open func setThumbAtBottom(boolean: Bool) {
        _thumbAtBottom = boolean
    }
    
    open func addImage(image : UIImage, thumb: UIImage, startPercentage: CGFloat) {
        
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = image
        imageViews.append(iv)
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        imageWrappers.append(v)
        
        trailingAnchors.append(NSLayoutConstraint())
        lastXs.append(CGFloat())
        
        let thumbView = UIImageView()
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.contentMode = .scaleAspectFit
        thumbView.clipsToBounds = true
        thumbView.image = thumb
        thumbViews.append(thumbView)
        
        let thumbWrapper = UIView()
        thumbWrapper.translatesAutoresizingMaskIntoConstraints = false
        thumbWrapper.clipsToBounds = true
        thumbWrappers.append(thumbWrapper)
        
        startPercentages.append(startPercentage)
    }
    
    var _setupTrailingAndLastX:Bool = false
    
    fileprivate var setupTrailingAndLastX: Bool {
        if(_setupTrailingAndLastX == false){
            for i in 0 ..< imageViews.count {
                trailingAnchors[i].constant = -(self.frame.width * startPercentages[i] / 100.0)
            }
            self.layoutIfNeeded()
            
            for i in 0 ..< imageViews.count {
                lastXs[i] = abs(trailingAnchors[i].constant)
            }
            _setupTrailingAndLastX = true
        }
        return _setupTrailingAndLastX
    }
        
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            _ = setupTrailingAndLastX
        }
        
        open func clean(){
            for i in 0 ..< imageViews.count {
                imageViews[i].removeFromSuperview()
                imageWrappers[i].removeFromSuperview()
                
                thumbViews[i].removeFromSuperview()
                thumbWrappers[i].gestureRecognizers?.forEach{
                    thumbWrappers[i].removeGestureRecognizer($0)
                }
                thumbWrappers[i].removeFromSuperview()
            }
            
            imageViewBase.constraints.forEach{
                imageViewBase.removeConstraint($0)
            }
            imageViewBase.removeFromSuperview()
            
            trailingAnchors = [NSLayoutConstraint]()
            lastXs = [CGFloat]()
            
            imageViews = [UIImageView]()
            imageWrappers = [UIView]()
            
            thumbViews = [UIImageView]()
            thumbWrappers = [UIView]()
            
            startPercentages = [CGFloat]()
            
            imageViewBase = UIImageView()
            
            _setupTrailingAndLastX = false
        }
        
        open func initialize() {
            
            addSubview(imageViewBase)
            
            for i in 0 ..< imageViews.count {
                imageWrappers[i].addSubview(imageViews[i])
                addSubview(imageWrappers[i])
            }
            
            for i in 0 ..< imageViews.count {
                thumbWrappers[i].addSubview(thumbViews[i])
                addSubview(thumbWrappers[i])
            }
            
            NSLayoutConstraint.activate([
                imageViewBase.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                imageViewBase.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                imageViewBase.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                imageViewBase.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
                ])
            
            
            
            for i in 0 ..< imageViews.count {
                
                let imageWrapper = imageWrappers[i]
                trailingAnchors[i] = imageWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
                
                NSLayoutConstraint.activate([
                    imageWrapper.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                    imageWrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                    imageWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                    trailingAnchors[i]
                    ])
                
                let imageView = imageViews[i]
                
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: imageWrapper.topAnchor, constant: 0),
                    imageView.bottomAnchor.constraint(equalTo: imageWrapper.bottomAnchor, constant: 0),
                    imageView.leadingAnchor.constraint(equalTo: imageWrapper.leadingAnchor, constant: 0)
                    ])
                
                let thumbWrapper = thumbWrappers[i]
                
                let topAnchor: NSLayoutConstraint
                
                if (i == 0) {
                    topAnchor = thumbWrapper.topAnchor.constraint(equalTo: imageWrapper.topAnchor, constant: 0)
                }
                else {
                    topAnchor = thumbWrapper.topAnchor.constraint(equalTo: thumbWrappers[i-1].bottomAnchor, constant: 0)
                }
                
                let thumb = thumbViews[i]
                
                if(_thumbAtBottom) {
                    NSLayoutConstraint.activate([
                                       thumbWrapper.bottomAnchor.constraint(equalTo: imageWrapper.bottomAnchor, constant: 0),
                                       thumbWrapper.heightAnchor.constraint(equalToConstant: (thumb.image?.size.height)!),
                                       thumbWrapper.trailingAnchor.constraint(equalTo: imageWrapper.trailingAnchor, constant: 20),
                                       thumbWrapper.widthAnchor.constraint(equalToConstant: 40)
                                       ])
                } else {
                    NSLayoutConstraint.activate([
                        topAnchor,
                        thumbWrapper.heightAnchor.constraint(equalTo: imageWrapper.heightAnchor, multiplier: CGFloat(CGFloat(1)/CGFloat(imageViews.count))),
                        thumbWrapper.trailingAnchor.constraint(equalTo: imageWrapper.trailingAnchor, constant: 20),
                        thumbWrapper.widthAnchor.constraint(equalToConstant: 40)
                        ])
                }
                
                
                NSLayoutConstraint.activate([
                    thumb.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0),
                    thumb.centerYAnchor.constraint(equalTo: thumbWrapper.centerYAnchor, constant: 0),
                    thumb.widthAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1),
                    thumb.heightAnchor.constraint(equalTo: thumbWrapper.heightAnchor, multiplier: 1)
                    ])
                
            }
            
            for i in 0 ..< imageViews.count {
                trailingAnchors[i].constant = 0
            }
            
            for i in 0 ..< imageViews.count {
                imageViews[i].widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
            }
            
            for i in 0 ..< imageViews.count {
                let thumbWrapper = thumbWrappers[i]
                
                let tap = CustomGesture(target: self, action: #selector(gesture(sender:)))
                tap.sliderIndex = i
                thumbWrapper.isUserInteractionEnabled = true
                thumbWrapper.addGestureRecognizer(tap)
            }
        }
        
        
        @objc func gesture(sender: CustomGesture) {
            
            let trailing = trailingAnchors[sender.sliderIndex]
            let lastX = lastXs[sender.sliderIndex]
            
            
            let translation = sender.translation(in: self)
            switch sender.state {
            case .began, .changed:
                
                var newTrailing = -(lastX - translation.x)
                newTrailing = min(newTrailing, 0)
                newTrailing = max(-frame.width, newTrailing)
                trailing.constant = newTrailing
                
                layoutIfNeeded()
            case .ended, .cancelled:
                lastXs[sender.sliderIndex] = abs(trailing.constant)
            default: break
            }
        }
    }
    
    
    class CustomGesture: UIPanGestureRecognizer {
        var sliderIndex: Int!
}
