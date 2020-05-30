//
//  PostsCollectionPresenter.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 29.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

protocol PostListViewProtocol: AnyObject {
    func reloadData()
    func reloadItem(at index: Int)
}

protocol PostCollectionPresenterProtocol {
    func getPosts()
    func setInsightsState(with flag: Bool)
    func showInsights() -> Bool
    func postsCount() -> Int
    func post(at index: Int) -> Post
    func postView(at index: Int) -> PostView
    func getPostInfo(at index: Int)
    func getInsights (at index: Int)
    func didEndDisplaying(at index: Int)
}

final class PostsCollectionPresenter: PostCollectionPresenterProtocol {
    weak var view: PostListViewProtocol?
    private var postListModel: PostListModel!
    
    init(_ profile: Profile, _ view: PostListViewProtocol) {
        postListModel = PostListModel(with: profile, delegat: self)
        self.view = view
    }
    
    func getPosts() {
        postListModel.getPosts()
    }
    
    func setInsightsState(with flag: Bool){
        postListModel.setInsightsState(with: flag)
    }
    
    func showInsights() -> Bool {
        postListModel.showInsightsState()
    }
    
    func postsCount() -> Int {
        postListModel.postsCount
    }
    
    func post(at index: Int) -> Post {
        postListModel.post(at: index)
    }
    
    func postView(at index: Int) -> PostView {
        postListModel.postView(at: index)
    }
    
    func getPostInfo (at index: Int) {
        postListModel.getPostInfo(at: index)
    }
    
    func getInsights(at index: Int) {
        postListModel.getInsights(at: index)
    }
    
    func didEndDisplaying(at index: Int) {
        let postV = postListModel.postView(at: index)
        postV.cancelLoadImage()
    }
    
    func sortBy(_ criterion: sortCriterion, _ direction: sortDirection) {
        postListModel.sortBy(criterion, direction)
    }
}

extension PostsCollectionPresenter: PostListModelDelegate {
    func postViewsLoaded() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadData()
        }
    }
    
    func postViewDidChange(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadItem(at: index)
        }
    }
}
