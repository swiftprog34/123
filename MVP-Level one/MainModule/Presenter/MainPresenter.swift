//
//  MainPresenter.swift
//  MVP-Level one
//
//  Created by Виталий Емельянов on 19.11.2021.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol {
    init (view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getComments()
    var comments: [Comment]? {get set}
    
    func tapOnTheComment(comment: Comment?)
}

class MainPresentor: MainViewPresenterProtocol {
    var comments: [Comment]?
    var router: RouterProtocol?
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!

    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getComments()
    }
    
    func getComments() {
        networkService.getComments { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result{
                case .success(let comments) :
                    self.comments = comments!
                    self.view?.success()
                case .failure(let error) :
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func tapOnTheComment(comment: Comment?) {
        router?.showDetail(comment: comment)
    }
}


