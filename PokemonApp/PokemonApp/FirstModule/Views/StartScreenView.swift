//
//  StartView.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import UIKit
import SnapKit

class StartScreenView: UIView { //будет появлятся, когда идёт загрузка списка покемонов
    
    private let pokebolImageView: UIImageView = {
        let pokebolImageView = UIImageView()
        pokebolImageView.image = UIImage(named: "pokebol-image")
        pokebolImageView.translatesAutoresizingMaskIntoConstraints = false
        return pokebolImageView
    }()
    
    private let downloadingMessgaeLabel: UILabel = {
        let downloadingMessageLabel = UILabel()
        downloadingMessageLabel.font = UIFont(name: "Muller-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
        downloadingMessageLabel.text = "Идёт получение данных..."
        downloadingMessageLabel.textColor = .black
        downloadingMessageLabel.textAlignment = .center
        downloadingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        return downloadingMessageLabel
    }()
    
    private let downloadIndicator: UIActivityIndicatorView = {
        let downloadIndicator = UIActivityIndicatorView()
        downloadIndicator.isHidden = false
        downloadIndicator.color = .black
        downloadIndicator.startAnimating()
        downloadIndicator.translatesAutoresizingMaskIntoConstraints = false
        return downloadIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addSubviewsConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StartScreenView {
    private func addSubviews() {
        addSubview(pokebolImageView)
        addSubview(downloadIndicator)
        addSubview(downloadingMessgaeLabel)
    }
    
    private func addSubviewsConstraints() {
        pokebolImageView.snp.makeConstraints() {
            element in
            element.center.equalToSuperview()
            element.width.height.equalTo(self.snp.width).multipliedBy(0.6)
        }
        downloadingMessgaeLabel.snp.makeConstraints() {
            element in
            element.top.equalTo(pokebolImageView.snp.bottom).offset(20)
            element.centerX.equalToSuperview()
            element.width.equalToSuperview().multipliedBy(0.8)
            element.height.equalToSuperview().multipliedBy(0.1)
        }
        downloadIndicator.snp.makeConstraints() {
            element in
            element.top.equalTo(downloadingMessgaeLabel.snp.bottom).offset(50)
            element.centerX.equalToSuperview()
        }
    }
}
