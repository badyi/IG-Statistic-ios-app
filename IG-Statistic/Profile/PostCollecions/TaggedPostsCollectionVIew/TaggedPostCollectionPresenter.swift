//
//  TaggedPostCollectionPresenter.swift
//  IG-Statistic
//
//  Created by и on 23.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import ResourceNetworking

final class TaggedPostsCollectionPresenter: PostCollectionPresenterProtocol {
    weak var view: PostListViewProtocol?
    private var postListModel: PostListModel!
    
    init(_ profile: Profile, _ view: PostListViewProtocol) {
        postListModel = PostListModel(with: profile, delegat: self)
        self.view = view
    }
    
    func getPosts() {
        postListModel.getTaggedPosts()
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
        #warning("insights on ttagged post")
        //postListModel.getInsights(at: index)
    }
    
    func didEndDisplaying(at index: Int) {
        let postV = postListModel.postView(at: index)
        postV.cancelLoadImage()
    }
    
    func sortBy(_ criterion: sortCriterion, _ direction: sortDirection) {
        postListModel.sortBy(criterion, direction)
    }
}

extension TaggedPostsCollectionPresenter: PostListModelDelegate {
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
