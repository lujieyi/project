//
//  JMCollectionAndHistoryPageViewController.swift
//  news
//
//  Created by zhouweijie on 2018/12/24.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

@objcMembers class DatasourceDelegate: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var childs = [UIViewController]()
    
    var transitionIsComplete: Bool = false
    var pendingViewController: UIViewController?
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.childs.count == 1 {
            return nil
        } else {
            guard let index = self.childs.firstIndex(of: viewController) else {return nil}
            if (index==0) {
                return nil//self.childs[self.childs.count-1]
            } else {
                return self.childs[index-1]
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.childs.count == 1 {
            return nil
        } else {
            guard let index = self.childs.firstIndex(of: viewController) else {return nil}
            if (index == self.childs.count-1) {
                return nil//self.childs[self.childs.count-1]
            } else {
                return self.childs[index+1]
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            
        }
    }
    
    private func checkCurrentInde() -> Int{
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if pendingViewControllers.count > 0 {
            self.pendingViewController = pendingViewControllers[0]
        }
    }
}

@objcMembers class JMCollectionAndHistoryPageViewController: UIPageViewController {
    
    private var dataSourceDelegate = DatasourceDelegate.init()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: .horizontal, options: nil)
        self.delegate = self.dataSourceDelegate
        self.dataSource = self.dataSourceDelegate
        let collectionVC = JMCollectionAndHistoryViewController.init(nibName: nil, bundle: nil)
        collectionVC.viewDidApparBlock = {(index) -> Void in
            let currentVC = self.viewControllers![0] as! JMCollectionAndHistoryViewController
            if self.segmentView.selectedIndex != index {
                self.segmentView.setSelctedState(indexPath: IndexPath(item: index, section: 0))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: currentVC.editButton)
            }
        }
        let historyVC = JMBrowseHistoryViewController.init(nibName: nil, bundle: nil)
        historyVC.viewDidApparBlock = {(index) -> Void in
            let currentVC = self.viewControllers![0] as! JMCollectionAndHistoryViewController
            if self.segmentView.selectedIndex != index {
                self.segmentView.setSelctedState(indexPath: IndexPath(item: index, section: 0))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: currentVC.editButton)
            }
        }
        dataSourceDelegate.childs = [collectionVC, historyVC]
        var initializeViewController: JMCollectionAndHistoryViewController
        if JiemianUserManager.shareInstance()!.checkIsLogin() {
            initializeViewController = dataSourceDelegate.childs[0] as! JMCollectionAndHistoryViewController
            self.initializeIndex = 0
        } else {
            initializeViewController = dataSourceDelegate.childs[1] as! JMCollectionAndHistoryViewController
            self.initializeIndex = 1
        }
        self.setViewControllers([initializeViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: initializeViewController.editButton)

    }
    
    var initializeIndex: Int!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "top_navigation_back"), style: .plain, target: self, action: #selector(self.didClickBackItem))
        self.view.dk_backgroundColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xffffff), UIColor.hex(hexValue: 0x2A2A2B))
        self.navigationController?.navigationBar.dk_backgroundColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xffffff), UIColor.hex(hexValue: 0x2A2A2B))
    }
    
    @objc private func didClickBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        if DKNightVersionManager.isNight() {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.hex(hexValue: 0x2A2A2B)), for: .default)
        }
        else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.hex(hexValue: 0xffffff)), for: .default)
        }
    }
    
    private lazy var segmentView: JMSegmentView = {
        let view = JMSegmentView.init(titles: ["收藏","历史"], selectedIndex: self.initializeIndex)
        view.didSelectItem = {(indexPath: IndexPath) -> Void in
            if indexPath.row == 0 {
                let viewController = self.dataSourceDelegate.childs[0] as! JMCollectionAndHistoryViewController
                self.setViewControllers([viewController], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewController.editButton)
                
            } else if indexPath.row == 1 {
                let viewController = self.dataSourceDelegate.childs[1] as! JMCollectionAndHistoryViewController
                self.setViewControllers([viewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewController.editButton)
                
                JMTracker.event(with: .newsHistoryTabClick)
            }
        }
        return view
    }()

}
