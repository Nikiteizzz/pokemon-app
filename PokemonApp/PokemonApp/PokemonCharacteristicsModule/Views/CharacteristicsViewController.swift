//
//  CharacteristicsViewController.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 27.10.22.
//

import UIKit
import SnapKit
import Rswift

class CharacteristicsViewController: UIViewController {
    
    weak var appCoordinator: CoordinatorProtocol?
    var presenter: CharacteristicsViewPresenterProtocol?
    
    let pokemonImage: UIImageView = {
        let pokemonImage = UIImageView()
        pokemonImage.image = R.image.noPhotoImage()
        pokemonImage.isHidden = true
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        return pokemonImage
    }()
    
    let pokemonNameLabel: UILabel = {
        let pokemonNameLabel = UILabel()
        pokemonNameLabel.font = UIFont.boldSystemFont(ofSize: 35)
        pokemonNameLabel.text = "jajaja"
        pokemonNameLabel.textColor = .black
        pokemonNameLabel.textAlignment = .center
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNameLabel.isHidden = true
        return pokemonNameLabel
    }()
    
    let weightLabel: UILabel = {
        let weightLabel = UILabel()
        weightLabel.textAlignment = .left
        weightLabel.textColor = .black
        weightLabel.font = UIFont.systemFont(ofSize: 20)
        weightLabel.textAlignment = .center
        weightLabel.isHidden = true
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        return weightLabel
    }()
    
    let heightLabel: UILabel = {
        let heightLabel = UILabel()
        heightLabel.textAlignment = .left
        heightLabel.textColor = .black
        heightLabel.font = UIFont.systemFont(ofSize: 20)
        heightLabel.textAlignment = .center
        heightLabel.isHidden = true
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        return heightLabel
    }()
    
    let typesTable: UITableView = {
        let typesTable = UITableView()
        typesTable.rowHeight = 40
        typesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        typesTable.isHidden = true
        typesTable.backgroundColor = .white
        typesTable.translatesAutoresizingMaskIntoConstraints = false
        return typesTable
    }()
    
    let tableTitle: UILabel = {
        let tableTitle = UILabel()
        tableTitle.font = UIFont.boldSystemFont(ofSize: 20)
        tableTitle.text = "Types"
        tableTitle.textColor = .black
        tableTitle.isHidden = true
        tableTitle.textAlignment = .left
        tableTitle.translatesAutoresizingMaskIntoConstraints = false
        return tableTitle
    }()
    
    let downloadIndicator: UIActivityIndicatorView = {
        let downloadIndicator = UIActivityIndicatorView()
        downloadIndicator.color = .black
        downloadIndicator.isHidden = false
        downloadIndicator.startAnimating()
        return downloadIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addSubviews()
        addSubviewsConstraints()
    }
}

extension CharacteristicsViewController: CharacteristicsViewProtocol {
    func showSavedPokemon(pokemon: PokemonSave) {
        downloadIndicator.isHidden = true
        pokemonImage.isHidden = false
        pokemonNameLabel.isHidden = false
        pokemonNameLabel.text = pokemon.name
        weightLabel.isHidden = false
        weightLabel.text = "Weight: \(Double(pokemon.weight) / 10) kg"
        heightLabel.isHidden = false
        heightLabel.text = "Height: \(pokemon.height * 10) cm"
        typesTable.isHidden = false
        tableTitle.isHidden = false
        typesTable.reloadData()
    }
    
    func showSuccessAlert(message: String, resultHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) {
            _ in
            if resultHandler != nil {
                resultHandler!()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showFailAlert(message: String, resultHandler: (()->Void)?) {
        let alert = UIAlertController(title: "Something wrong!", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) {
            _ in
            if resultHandler != nil {
                resultHandler!()
            }
            self.dismiss(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func setImage(image: UIImage?) {
        if image != nil {
            pokemonImage.image = image!
        }
    }
    
    func success() {
        downloadIndicator.isHidden = true
        pokemonImage.isHidden = false
        pokemonNameLabel.isHidden = false
        pokemonNameLabel.text = presenter?.pokemonCharacteristics?.name
        weightLabel.isHidden = false
        weightLabel.text = "Weight: \(presenter?.pokemonCharacteristics?.weight ?? 0 / 10) kg"
        heightLabel.isHidden = false
        heightLabel.text = "Height: \(presenter?.pokemonCharacteristics?.height ?? 0 * 10) cm"
        tableTitle.isHidden = false
        typesTable.isHidden = false
        typesTable.reloadData()
        presenter?.getPokemonImage()
    }
    
}

extension CharacteristicsViewController {
    func configureView() {
        view.backgroundColor = .white
        typesTable.dataSource = self
        typesTable.delegate = self
    }
    
    func addSubviews() {
        view.addSubview(downloadIndicator)
        view.addSubview(pokemonImage)
        view.addSubview(pokemonNameLabel)
        view.addSubview(weightLabel)
        view.addSubview(heightLabel)
        view.addSubview(typesTable)
        view.addSubview(tableTitle)
    }
    
    func addSubviewsConstraints() {
        downloadIndicator.snp.makeConstraints {
            element in
            element.center.equalToSuperview()
        }
        
        pokemonNameLabel.snp.makeConstraints {
            element in
            element.top.equalToSuperview()
            element.centerX.equalToSuperview()
            element.height.equalToSuperview().multipliedBy(0.1)
        }
        
        pokemonImage.snp.makeConstraints {
            element in
            element.right.equalTo(view.snp.centerX)
            element.top.equalTo(pokemonNameLabel.snp.bottom).offset(20)
            element.width.height.equalTo(view.snp.width).multipliedBy(0.4)
        }
        
        weightLabel.snp.makeConstraints {
            element in
            element.left.equalTo(pokemonImage.snp.right).inset(10)
            element.bottom.equalTo(pokemonImage.snp.centerY)
            element.width.equalToSuperview().multipliedBy(0.5)
            element.height.equalToSuperview().multipliedBy(0.05)
        }
        
        heightLabel.snp.makeConstraints {
            element in
            element.left.equalTo(pokemonImage.snp.right).inset(10)
            element.top.equalTo(pokemonImage.snp.centerY)
            element.width.equalToSuperview().multipliedBy(0.5)
            element.height.equalToSuperview().multipliedBy(0.05)
        }
        
        tableTitle.snp.makeConstraints {
            element in
            element.centerX.equalToSuperview()
            element.top.equalTo(pokemonImage.snp.bottom).offset(20)
            element.width.equalToSuperview().multipliedBy(0.8)
            element.height.equalToSuperview().multipliedBy(0.05)
        }
        
        typesTable.snp.makeConstraints {
            element in
            element.centerX.equalToSuperview()
            element.top.equalTo(tableTitle.snp.bottom)
            element.width.equalToSuperview().multipliedBy(0.8)
            element.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}

extension CharacteristicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = typesTable.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = presenter?.pokemonCharacteristics?.types[indexPath.row].type.name
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.pokemonCharacteristics?.types.count ?? 0
    }
}
