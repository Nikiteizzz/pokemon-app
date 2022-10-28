//
//  ViewController.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 21.10.22.
//

import UIKit

class StartViewController: UIViewController {
    
    weak var appCoordinator: CoordinatorProtocol?
    var mainPresenter: StartViewPresenterProtocol!
    
    private let pokemonsTable: UITableView = {
        let pokemonsTable = UITableView()
        pokemonsTable.backgroundColor = .white
        pokemonsTable.rowHeight = 70
        pokemonsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        pokemonsTable.isHidden = true
        return pokemonsTable
    }()
    
    private let pageNameLabel: UILabel = {
        let pageNameLabel = UILabel()
        pageNameLabel.text = "Pokemons"
        pageNameLabel.textAlignment = .center
        pageNameLabel.textColor = .black
        pageNameLabel.font = UIFont.boldSystemFont(ofSize: 35)
        pageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pageNameLabel.isHidden = true
        return pageNameLabel
    }()
    
    private let startScreenView: StartScreenView = {
        let startScreenView = StartScreenView()
        return startScreenView
    }()
    
    private let prevButton: UIButton = {
        let prevButton = UIButton()
        prevButton.setBackgroundImage(UIImage(named: "left-arrow") ?? UIImage(), for: .normal)
        prevButton.addTarget(nil, action: #selector(getPrevList), for: .touchUpInside)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.isHidden = true
        return prevButton
    }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setBackgroundImage(UIImage(named: "right-arrow") ?? UIImage(), for: .normal)
        nextButton.addTarget(nil, action: #selector(getNextList), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isHidden = true
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addSubviews()
        addSubviewsConstraints()
    }


}

extension StartViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureView() {
        view.backgroundColor = .white
        pokemonsTable.delegate = self
        pokemonsTable.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(startScreenView)
        view.addSubview(pokemonsTable)
        view.addSubview(pageNameLabel)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
    }
    
    private func addSubviewsConstraints() {
        startScreenView.snp.makeConstraints() {
            element in
            element.center.size.equalToSuperview()
        }
        pageNameLabel.snp.makeConstraints {
            element in
            element.top.equalToSuperview().offset(60)
            element.centerX.equalToSuperview()
            element.height.equalToSuperview().multipliedBy(0.1)
        }
        
        pokemonsTable.snp.makeConstraints {
            element in
            element.top.equalTo(pageNameLabel.snp.bottom).offset(20)
            element.centerX.equalToSuperview()
            element.height.equalToSuperview().multipliedBy(0.6)
            element.width.equalToSuperview().multipliedBy(0.9)
        }
        prevButton.snp.makeConstraints {
            element in
            element.top.equalTo(pokemonsTable.snp.bottom).offset(30)
            element.left.equalTo(pokemonsTable.snp.left)
            element.width.height.equalTo(view.snp.width).multipliedBy(0.15)
        }
        nextButton.snp.makeConstraints {
            element in
            element.top.equalTo(pokemonsTable.snp.bottom).offset(30)
            element.right.equalTo(pokemonsTable.snp.right)
            element.width.height.equalTo(view.snp.width).multipliedBy(0.15)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainPresenter.internerStatus {
            return mainPresenter.pokemonsData?.listOfPokemons.count ?? 0
        } else {
            return mainPresenter.savedPokemons?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pokemonsTable.dequeueReusableCell(withIdentifier: "cell")
        if mainPresenter.internerStatus {
            cell?.textLabel?.text = mainPresenter.pokemonsData?.listOfPokemons[indexPath.row].name
        } else {
            cell?.textLabel?.text = mainPresenter.savedPokemons![indexPath.row].name
        }
        cell?.textLabel?.textColor = .black
        cell?.selectionStyle = .none
        cell?.backgroundColor = .white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainPresenter.internerStatus {
            let pokemon = mainPresenter.pokemonsData?.listOfPokemons[indexPath.row]
            mainPresenter.showPokemonCharacteristics(pokemon: pokemon!)
        } else {
            let pokemon = mainPresenter.savedPokemons?[indexPath.row]
            mainPresenter.showSavedPokemonCharacteristics(pokemon: pokemon!)
        }
    }
}

extension StartViewController: StartViewProtocol {
    func success() {
        self.startScreenView.isHidden = true
        self.pokemonsTable.isHidden = false
        self.pageNameLabel.isHidden = false
        self.pokemonsTable.reloadData()
        self.prevButton.isHidden = self.mainPresenter.pokemonsData?.prevURL != nil ? false : true
        self.nextButton.isHidden = self.mainPresenter.pokemonsData?.nextURL != nil ? false : true
    }
    
    func error(errorMessgae: String) {
        pageNameLabel.isHidden = false
        pokemonsTable.isHidden = false
        prevButton.isHidden = true
        nextButton.isHidden = true
        pokemonsTable.reloadData()
        startScreenView.isHidden = true
        let alert = UIAlertController(title: "Something wrong!", message: errorMessgae, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension StartViewController {
    @objc func getNextList() {
        startScreenView.isHidden = false
        pokemonsTable.isHidden = true
        pageNameLabel.isHidden = true
        prevButton.isHidden = true
        nextButton.isHidden = true
        mainPresenter.getNextList()
    }
    
    @objc func getPrevList() {
        startScreenView.isHidden = false
        pokemonsTable.isHidden = true
        pageNameLabel.isHidden = true
        prevButton.isHidden = true
        nextButton.isHidden = true
        mainPresenter.getPrevList()
    }
}
