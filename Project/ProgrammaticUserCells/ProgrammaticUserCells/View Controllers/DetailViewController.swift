//
//  DetailViewController.swift
//  ProgrammaticUserCells
//
//  Created by Jason Ruan on 10/8/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: Properties
    var user: User! {
        didSet {
            setUpViews()
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.textColor = .magenta
        return label
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = .init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        return imageView
    }()
    
    var userInfoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 25)
        textView.textAlignment = .center
        return textView
    }()

    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        addSubViews()
        configureAllConstraints()
    }
    
    
    //MARK: Custom Functions
    private func addSubViews() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(profileImageView)
        self.view.addSubview(userInfoTextView)
    }
    
    private func configureAllConstraints() {
        configureLabelConstraints()
        configureImageViewConstraints()
        configureTextViewConstraints()
    }
    
    private func setUpViews() {
        nameLabel.text = user.name.first + " " + user.name.last
    
        DispatchQueue.main.async {
            guard let url = URL(string: self.user.picture.large) else { return }
            ImageHelper.shared.getImage(url: url) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let profilePic):
                    DispatchQueue.main.async {
                        self.profileImageView.image = profilePic
                    }
                }
            }
        }
        
        userInfoTextView.text = """
                Location: \(user.location.street), \(user.location.city), \(user.location.state)
                \nEmail: \(user.email)
                \nDOB: \(user.dob.date)
                \nPhone: \(user.phone)
                \nCell: \(user.cell)
            """
    }
    
    private func configureImageViewConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant:  150).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 4).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
    }
    
    private func configureLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 30).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.profileImageView.centerXAnchor).isActive = true
    }
    
    private func configureTextViewConstraints() {
        userInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        userInfoTextView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 30).isActive = true
        userInfoTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userInfoTextView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        userInfoTextView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
    }
    
}
