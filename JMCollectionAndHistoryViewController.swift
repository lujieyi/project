//
//  JMCollectionAndHistoryViewController.swift
//  news
//
//  Created by zhouweijie on 2018/12/15.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

@objcMembers class JMCollectionAndHistoryViewController: JMViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    weak var pageViewController: JMCollectionAndHistoryPageViewController!
    private var checkedIndexPaths = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.showTypeTipsView(self.tableView, logoType: self.getLogoType())
        self.setUpRefreshHeaderAndFooter()
        self.loadData(loadMore: false)
        self.view.addSubview(bottomBar)
    }
    
    func getLogoType() -> LogoType {
        return LogoType.collection
    }
    
    lazy var editButton: UIButton = {
        let button = UIButton.init()
        button.setTitle("编辑", for: UIControl.State.normal)
        button.setTitle("取消", for: UIControl.State.selected)
        button.titleLabel?.font = UIFont.jm_regularFont(ofSize: 16)
        button.dk_setTitleColorPicker(DKColorPickerWithColors(UIColor.hex(hexValue: 0x333333), UIColor.hex(hexValue: 0x868687)), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(self.didClickEditingItem), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(origin: CGPoint.zero, size: button.intrinsicContentSize)
        //        let item = UIBarButtonItem(customView: button)
        //        self.navigationItem.rightBarButtonItem  = item
        return button
    }()
    
    @objc private func didClickEditingItem() -> Void {
        if self.models.count == 0 && editButton.isSelected == false {
            return
        }
        editButton.isSelected = !editButton.isSelected
        self.bottomBar.isHidden = !editButton.isSelected
        self.selectAllButton.isSelected = !editButton.isSelected
        self.batchDeleteButton.isSelected = !editButton.isSelected
        if self.bottomBar.isHidden {
            self.tableView.frame = self.view.bounds
        } else {
            var frame = self.tableView.frame
            frame.size.height -= self.bottomBarHeight
            self.tableView.frame = frame
            self.batchDeleteButton.dk_backgroundColorPicker = self.batchDeleteButtonDefaultColorPicker
        }
        self.tableView.setEditing(editButton.isSelected, animated: true)
    }
    
    private var batchDeleteButtonDefaultColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0x999999), UIColor.hex(hexValue: 0x666666))
    private var batchDeleteButtonSeletedColorpicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xF12B15), UIColor.hex(hexValue: 0xC22514))
    
    private var bottomBarHeight: CGFloat {
        get {
            if UIScreen.main.bounds.height >= 812 {
                return 74.0
            } else {
                return 50.0
            }
        }
    }
    
    private lazy var bottomBar: UIView = {
        let bar = UIView.init()
        bar.isHidden = true
        bar.addSubview(selectAllButton)
        bar.addSubview(batchDeleteButton)
        return bar
    }()
    
    private lazy var selectAllButton: UIButton = {
        let button = UIButton.init()
        button.dk_setImage(DKImagePickerWithNames(["collectionViewAndHistory/deleteUnCheck","collectionViewAndHistory/deleteUnCheck_night"]), for: UIControl.State.normal)
        button.dk_setImage(DKImagePickerWithNames(["collectionViewAndHistory/deleteCheck","collectionViewAndHistory/deleteCheck_night"]), for: UIControl.State.selected)
        button.setTitle("全选", for: UIControl.State.normal)
        button.dk_setTitleColorPicker(DKColorPickerWithColors(UIColor.hex(hexValue: 0x333333), UIColor.hex(hexValue: 0x868687)), for: UIControl.State.normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.jm_regularFont(ofSize: 16)
        button.frame = CGRect(origin: CGPoint(x: 15, y: 14), size: button.intrinsicContentSize)
        button.addTarget(self, action: #selector(self.didSelectAllButton(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var batchDeleteButton: UIButton = {
        let button = UIButton.init()
        button.setTitle("批量删除", for: UIControl.State.normal)
        button.dk_setTitleColorPicker(DKColorPickerWithColors(UIColor.hex(hexValue: 0xffffff), UIColor.hex(hexValue: 0xb7b7b7)), for: UIControl.State.normal)
        button.dk_setTitleColorPicker(DKColorPickerWithColors(UIColor.hex(hexValue: 0xffffff), UIColor.hex(hexValue: 0xffffff)), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(self.didClickBatchDeleteButton(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc private func didClickBatchDeleteButton(button: UIButton) {
        if button.isSelected {
            self.deleteRows(rows: Array(self.checkedIndexPaths))
            self.didClickEditingItem()
        }
    }
    
    private func deleteRows(rows: [IndexPath]) {
        let indexPaths = rows.sorted { (path0, path1) -> Bool in
            if path0.section >= path1.section {
                if path0.row > path1.row {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        for indexPath in indexPaths {
            let model: JMDataFlowModel = self.models[indexPath.row]
            JMCollectionManager.shareInstance()?.sendDeleteRequest(byId: model.getJM_id(), type: model.typeString, completionBlock: nil)
            self.models.remove(at: indexPath.row)
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.left)
        tableView.endUpdates()
        self.checkedIndexPaths = []
        self.models = self.cleanModels(models: self.models)
        self.tableView.reloadData()
        if self.models.count == 0 {
            self.showNoDataView()
        }
    }
    
    private func showNoDataView() {
        self.tipsView?.setTip(TypeTipsStyle.noData)
        self.tableView.mj_footer.isHidden = true
        self.tableView.separatorStyle = .none
    }
    
    private func cleanModels(models: [JMDataFlowModel]) -> [JMDataFlowModel]{
        var tempModel = Array.init(models)
        var counter: Int = 0
        for index: Int in (0..<models.count).reversed() {
            if models[index].type == JMListTypeDate {
                if counter == 0 {
                    tempModel.remove(at: index)
                } else {
                    counter = 0
                }
            } else {
                counter += 1
            }
        }
        return tempModel
    }
    
    @objc private func didSelectAllButton(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            batchDeleteButton.isSelected = true
            batchDeleteButton.dk_backgroundColorPicker = batchDeleteButtonSeletedColorpicker
            guard let visibleIndexpaths = self.tableView.indexPathsForVisibleRows else {return}
            for indexPath: IndexPath in visibleIndexpaths {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
            for index: Int in 0..<self.models.count {
                if self.models[index].type != JMListTypeDate {
                    self.checkedIndexPaths.insert(IndexPath(row: index, section: 0))
                }
            }
        } else {
            batchDeleteButton.isSelected = false
            batchDeleteButton.dk_backgroundColorPicker = batchDeleteButtonDefaultColorPicker
            guard let visibleIndexpaths = self.tableView.indexPathsForVisibleRows else {return}
            for indexPath: IndexPath in visibleIndexpaths {
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
            self.checkedIndexPaths = []
        }
    }
    
    private func setUpRefreshHeaderAndFooter() {
        let refreshHeader: MJRefreshGifHeader = MJRefreshGifHeader {
            self.loadData(loadMore: false)
            if self.tableView.isEditing {
                self.checkedIndexPaths = []
                self.didClickEditingItem()
            }
        }
        tableView.mj_header = refreshHeader
        
        let refreshFooter: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter {
            self.loadData(loadMore: true)
        }
        refreshFooter.triggerAutomaticallyRefreshPercent = 0
        tableView.mj_footer = refreshFooter
        
    }
    
    var viewDidApparBlock: ((Int) -> Void)?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getViewDidAppearBlock()
    }
    
    func getViewDidAppearBlock() {
        if self.viewDidApparBlock != nil {
            self.viewDidApparBlock!(0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !tableView.isEditing {
            tableView.frame = view.bounds
            bottomBar.frame = CGRect(x: 0, y: self.view.bounds.maxY-bottomBarHeight, width: self.view.bounds.size.width, height: bottomBarHeight)
            batchDeleteButton.frame = CGRect(origin: CGPoint(x: bottomBar.frame.maxX-130, y: 0), size: CGSize(width: 130, height: 50))
            self.tipsView.frame = tableView.bounds
        }
    }

    var currentPage: UInt = 1
    private var totalPageCount: UInt = 1
    var lastTime: String?
    var models: [JMDataFlowModel] = []
    
    func loadLocalData() {
        
    }
    
    private func loadData(loadMore: Bool) {
        guard let loginState = JiemianUserManager.shareInstance()?.checkIsLogin() else {
            self.showNoDataView()
            return
        }
        if !loginState && !self.getAPI().isHistory {
//            if !self.getAPI().canLoadLocalData {
                self.showNoDataView()
//            } else {
//                self.loadLocalData()
//                if self.models.count == 0 {
//                    self.showNoDataView()
//                }
//            }
            tableView.mj_footer.endRefreshingWithNoMoreData()
            tableView.mj_header.endRefreshing()
            return
        }
        if loadMore {
            if currentPage+1 > totalPageCount {
                tableView.mj_footer.endRefreshingWithNoMoreData()
                tableView.mj_header.endRefreshing()
                return
            } else {
                self.currentPage += 1
            }
        } else {
            self.currentPage = 1
        }
        let collectionAPI = self.getAPI().requst
        collectionAPI.start { (request, error) in
            if (error == nil) {
                self.tipsView?.isHidden = true
                let responseDic:NSDictionary = request!.responseJSONObject as! NSDictionary
                guard let model = JMHomePageDataModel.yy_model(withJSON: responseDic["result"]!) else {
                    self.showNoDataView()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                if loadMore {
                    self.insterRows(models: model.list)
                } else {
                    self.models = model.list
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.resetNoMoreData()
                }
                if model.list != nil {
                    self.currentPage = UInt(model.page)
                    self.totalPageCount = UInt(model.totalPage)
                    self.lastTime = model.lastTime
                    if self.currentPage+1 > self.totalPageCount {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                if self.models.count == 0 {
                    self.showNoDataView()
                } else {
                    self.tableView.mj_footer.isHidden = false
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                }
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                if loadMore {
                    self.currentPage -= 1
                }
                if !loadMore && self.tableView.visibleCells.count == 0{
                    self.showNoDataView()
                }
            }
        }
    }
    
    func getAPI() -> (requst: JMRequest2018,isHistory: Bool) {
        return (MyCollectionAPI.init(page: self.currentPage),false)
    }
    
    private func insterRows(models: [JMDataFlowModel]) {
        var indexPaths: [IndexPath] = []
        var index: Int = self.models.count
        for _ in 0..<models.count {
            indexPaths.append(IndexPath(row: index, section: 0))
            index += 1
        }
        self.models.append(contentsOf:models)
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        tableView.mj_footer.endRefreshing()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.dk_backgroundColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xffffff), UIColor.hex(hexValue: 0x2A2A2B))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()
        tableView.dk_separatorColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xf3f3f3), UIColor.hex(hexValue: 0x36363a))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UINib(nibName: "JMRightSmallImageTableViewCell", bundle: nil), forCellReuseIdentifier: JMRightSmallImageTableViewCellReusedID)
        tableView.register(JMDataFlowDateTableViewCell.self, forCellReuseIdentifier: JMDataFlowDateTableViewCellReUsedId)
        return tableView
    }()
    
    override func reloadCurrentData() {
        self.tableView.mj_header.beginRefreshing()
    }
}

extension JMCollectionAndHistoryViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.row]
        if model.type == JMListTypeDate {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: JMDataFlowDateTableViewCellReUsedId, for: indexPath) as! JMDataFlowDateTableViewCell
            dateCell.updateCellWithDataFlowModel(model: model)
            return dateCell
        } else {
            let rightSmallCell = tableView.dequeueReusableCell(withIdentifier: JMRightSmallImageTableViewCellReusedID, for: indexPath) as! JMRightSmallImageTableViewCell
            if !self.getAPI().isHistory {
                self.setUpSwipeAction(cell: rightSmallCell)
            }
            if !checkedIndexPaths.contains(indexPath) {
                tableView.deselectRow(at: indexPath, animated: false)
            } else {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            rightSmallCell.updateCellWithDataFlowModel(model: model)
            return rightSmallCell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.models[indexPath.row]
        if model.type == JMListTypeDate {
            return 39
        } else {
            return 127
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            checkedIndexPaths.insert(indexPath)
            if checkedIndexPaths.count != 0 {
                self.batchDeleteButton.isSelected = true
                self.batchDeleteButton.dk_backgroundColorPicker = batchDeleteButtonSeletedColorpicker
            } else {
                self.batchDeleteButton.isSelected = false
                self.batchDeleteButton.dk_backgroundColorPicker = batchDeleteButtonDefaultColorPicker
            }
            return
        }
        let model = self.models[indexPath.row]
        self.pushToViewController(with: model)
        ///添加阅读记忆
        let isRead = JiemianReaderManager.shareInstance()?.addNewsReaded(with: model) ?? false
        if !isRead {
            let cell: JMRightSmallImageTableViewCell = tableView.cellForRow(at: indexPath) as! JMRightSmallImageTableViewCell
            cell.markCurrentNodeToRead()
        }
        
        JMTracker .event(with: .newsHistoryListClick)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let index = checkedIndexPaths.firstIndex(of: indexPath) else {return}
        checkedIndexPaths.remove(at: index)
        if checkedIndexPaths.count != 0 {
            self.batchDeleteButton.isSelected = true
            self.batchDeleteButton.dk_backgroundColorPicker = batchDeleteButtonSeletedColorpicker
        } else {
            self.batchDeleteButton.isSelected = false
            self.batchDeleteButton.dk_backgroundColorPicker = batchDeleteButtonDefaultColorPicker
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = self.models[indexPath.row]
        if model.type == JMListTypeDate {
            return false
        } else {
            return true
        }
    }
    
    private func setUpSwipeAction(cell: MGSwipeTableCell) {
        let rightMGButton = MGSwipeButton(title: "", icon: UIImage(named: "collectionViewAndHistory/delete"), backgroundColor: nil, callback: { (cell) -> Bool in
            guard let indePath = self.tableView.indexPath(for: cell) else {return true}
            self.deleteRows(rows: [indePath])
            return true
        })
        rightMGButton.dk_setImage(DKImagePickerWithNames(["collectionViewAndHistory/delete","collectionViewAndHistory/delete_night"]), for: UIControl.State.normal)
        rightMGButton.dk_backgroundColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xF3F3F3), UIColor.hex(hexValue: 0x171717))
        cell.rightButtons = [rightMGButton]
        cell.rightSwipeSettings.transition = .static
        cell.rightSwipeSettings.enableSwipeBounces = false
    }
}

