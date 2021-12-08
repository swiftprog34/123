//
//  MainPresenter.swift
//  MVP-Level one
//
//  Created by Виталий Емельянов on 19.11.2021.
//

import Foundation
import CoreData

protocol MainViewProtocol: AnyObject {
    func success()
}

protocol MainViewPresenterProtocol {
    init (view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, context: NSManagedObjectContext)
    func getComments()
    var comments: [Comment]? {get set}
    
    func tapOnTheComment(comment: Comment?)
    func saveContext()
    func deleteContext()
}

class MainPresentor: MainViewPresenterProtocol {
    var comments: [Comment]?
    var router: RouterProtocol?
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    let context: NSManagedObjectContext!
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, context: NSManagedObjectContext) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.context = context
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
                    self.deleteContext()
                    for i in 0...comments!.count - 1 {
                        let savedComment = SavedComments(context: self.context)
                        savedComment.id = Int64(comments![i].id)
                        savedComment.postId = Int64(comments![i].postId)
                        savedComment.email = comments?[i].email
                        savedComment.name = comments?[i].name
                        savedComment.body = comments?[i].body
                        self.saveContext()
                    }
                    
                case .failure(_) :
                    let fetchRequest: NSFetchRequest<SavedComments> = SavedComments.fetchRequest()
                    do {
                        let savedComments = try self.context.fetch(fetchRequest)
                        var obj: [Comment] = []
                        for i in 0...savedComments.count - 1 {
                            guard let name = savedComments[i].name,
                                  let email = savedComments[i].email,
                                  let body = savedComments[i].body else {
                                      return
                                  }
                            obj.append(Comment(
                                postId: Int(savedComments[i].postId),
                                id: Int(savedComments[i].id),
                                name: name,
                                email: email,
                                body: body
                            ))
                        }
                        self.comments = obj
                        self.view?.success()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func tapOnTheComment(comment: Comment?) {
        router?.showDetail(comment: comment)
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteContext() {
        let fetchRequest: NSFetchRequest<SavedComments> = SavedComments.fetchRequest()
        do {
            let savedComments = try self.context.fetch(fetchRequest)
            if(savedComments.count > 0) {
                for i in 0...savedComments.count - 1 {
                    context.delete(savedComments[i])
                }
                self.saveContext()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


