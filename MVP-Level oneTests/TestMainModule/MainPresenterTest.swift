//
//  MainPresenterTest.swift
//  MVP-Level oneTests
//
//  Created by Виталий Емельянов on 19.11.2021.
//

import XCTest
@testable import MVP_Level_one

class MockView: MainViewProtocol {
    func success() {}
    func failure(error: Error) {}
}

class MockNetworkService: NetworkServiceProtocol {
    var comments: [Comment]!
    init(){}
    convenience init(comments: [Comment]?) {
        self.init()
        self.comments = comments
    }
    func getComments(completion: @escaping (Result<[Comment]?, Error>) -> Void) {
        if let comments = comments {
            completion(.success(comments))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}

class MainPresenterTest: XCTestCase {
    
    var view: MockView!
    var presenter: MainPresentor!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var comments = [Comment]()
    
    let nav = UINavigationController()
    let assemblyBuilder = AssemblyBuilder()
    
    override func setUpWithError() throws {
        router = Router(navigationController: nav, assemblyBuilder: assemblyBuilder)
    }
    
    override func tearDownWithError() throws {
        view = nil
        networkService = nil
        presenter = nil
    }
    
    func testGetuccessComments() {
        let comment = Comment(postId: 1, id: 2, name: "Bar", email: "Baz", body: "Foo")
        comments.append(comment)
        
        view = MockView()
        networkService = MockNetworkService(comments: comments)
        presenter = MainPresentor(view: view, networkService: networkService, router: router)
        
        var catchComments: [Comment]?
        
        networkService.getComments { result in
            switch result {
            case .success( let comments):
                catchComments = comments
            case .failure(let error):
                print(error)
            }
        }
        
        XCTAssertNotEqual(catchComments?.count, 0)
    }
    
    func testGetFailureComments() {
        let comment = Comment(postId: 1, id: 2, name: "Bar", email: "Baz", body: "Foo")
        comments.append(comment)
        
        view = MockView()
        networkService = MockNetworkService()
        presenter = MainPresentor(view: view, networkService: networkService, router: router)
        
        
        var catchedError: Error?
        
        networkService.getComments { result in
            switch result {
            case .success( let comments): break
            case .failure(let error): catchedError = error
            }
        }
        
        XCTAssertNotNil(catchedError)
    }
}
