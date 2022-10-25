//
//  ViewController.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 21.10.22.
//

import UIKit

class StartViewController: UIViewController {
    
    weak var appCoordinator: CoordinatorProtocol?
    var mainPresenter: MainViewPresenterProtocol!
    
    private let startScreenView: StartScreenView = {
        let startScreenView = StartScreenView()
        return startScreenView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addSubviews()
        addSubviewsConstraints()
    }


}

extension StartViewController {
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(startScreenView)
    }
    
    private func addSubviewsConstraints() {
        startScreenView.snp.makeConstraints() {
            element in
            element.center.size.equalToSuperview()
        }
    }
}

extension StartViewController: MainViewProtocol {
    func success() {
        let alert = UIAlertController(title: "Всё заебись", message: "Данные есть", preferredStyle: .alert)
        present(alert, animated: true)
        print("cho")
        print(mainPresenter.pokemonsData)
    }
    
    func error(errorMessgae: String) {
        let alert = UIAlertController(title: "Всё хуёво", message: "Данных нет", preferredStyle: .alert)
        present(alert, animated: true)
        print(errorMessgae)
    }
}
