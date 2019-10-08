import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: Properties
    var users: [User] = [] {
        didSet {
            usersCollectionView.reloadData()
        }
    }
    
    lazy var usersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 200, height: 200)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "userCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()

    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(usersCollectionView)
        loadUsers()
        
    }
    
    //MARK: Custom Functions
    private func loadUsers() {
        UsersFetchingService.manager.getUsers { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let usersInfo):
                DispatchQueue.main.async {
                    self.users = usersInfo
                }
            }
        }
    }

    //MARK: CollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = usersCollectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
        let currentUser = users[indexPath.row]
        DispatchQueue.main.async {
            guard let url = URL(string: currentUser.picture.large) else { return }
            ImageHelper.shared.getImage(url: url) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let profilePic):
                    DispatchQueue.main.async {
                        cell.profileImageView.image = profilePic
                    }
                }
            }
        }
        cell.nameLabel.text = currentUser.name.first + " " + currentUser.name.last
        return cell
    }
    
    //MARK: CollectionView Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 4)
    }
    
    //MARK: CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.user = users[indexPath.row]
        present(detailVC, animated: true)
    }
}

