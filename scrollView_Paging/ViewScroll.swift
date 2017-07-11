//
//  ViewScroll.swift
//  scrollView_Paging
//
//  Created by Tung on 7/5/17.
//  Copyright © 2017 Tung. All rights reserved.
//

import UIKit

class ViewScroll: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    var pageImages : [String] = []
    var photo : [UIImageView] = []
    var frontScrollViews : [UIScrollView] = []
    
    var first = false
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImages = ["dog_1","dog_2","dog_3"]
        pageController.currentPage = 0
        pageController.numberOfPages = pageImages.count
        view.bringSubview(toFront: pageController)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        if !first {
            first = true
            let pagesScrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: 0)
            for i in 0 ..< pageImages.count
            {
                let imgView = UIImageView(image: UIImage(named: pageImages[i] + ".jpg"))
                imgView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
                imgView.contentMode = .scaleAspectFit
                
                imgView.isUserInteractionEnabled = true
                imgView.isMultipleTouchEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                tap.require(toFail: doubleTap)
                
                photo.append(imgView)
                
                let frontScrollView = UIScrollView(frame: CGRect(x: CGFloat(i) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                frontScrollView.minimumZoomScale = 1
                frontScrollView.maximumZoomScale = 2
                frontScrollView.delegate = self
                frontScrollView.contentSize = imgView.bounds.size
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
                self.scrollView.addSubview(frontScrollView)
            }
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return photo[pageController.currentPage]
    }
    func tapImg(_ gesture: UITapGestureRecognizer)
    {
        let position = gesture.location(in: photo[pageController.currentPage])
        zoomRectForScale(frontScrollViews[pageController.currentPage].zoomScale * 1.5, center: position)
    }
    func doubleTapImg(_ gesture: UITapGestureRecognizer)
    {
        let position = gesture.location(in: photo[pageController.currentPage])
        zoomRectForScale(frontScrollViews[pageController.currentPage].zoomScale * 0.5, center: position)
    }
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint){
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        frontScrollViews[pageController.currentPage].zoom(to: zoomRect, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Truyền đến tham số sau mỗi lần chuyển động
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        pageController.currentPage = Int(pageIndex)
//    }
    
    //Kiểm tra xem chuyển động đã kết thúc chưa
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
    @IBAction func onChange(_ sender: UIPageControl) {
        scrollView.contentOffset = CGPoint(x: CGFloat(pageController.currentPage) * scrollView.frame.size.width, y: 0)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
