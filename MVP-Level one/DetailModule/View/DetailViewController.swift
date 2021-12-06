//
//  DetailViewController.swift
//  MVP-Level one
//
//  Created by Виталий Емельянов on 19.11.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var commentLabel: UILabel!
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setComment()
    }

    @IBAction func tapAction(_ sender: Any) {
        presenter.tap()
    }
}

extension DetailViewController:  DetailViewProtocol {
    func setComment(comment: Comment?) {
        commentLabel.text = comment?.body
    }
}
