//
//  Detailpresenter.swift
//  MVP-Level one
//
//  Created by Виталий Емельянов on 19.11.2021.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func setComment(comment: Comment?)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init (view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, comment: Comment?)
    func setComment()
    func tap()
}

class DetailPresenter: DetailViewPresenterProtocol {
    var comment: Comment?
    var router: RouterProtocol?
    weak var view: DetailViewProtocol?
    let networkService: NetworkServiceProtocol!
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, comment: Comment?) {
        self.comment = comment
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    public func setComment() {
        self.view?.setComment(comment: comment)
    }
    
    public func tap() {
        router?.popToRoot()
    }
}
