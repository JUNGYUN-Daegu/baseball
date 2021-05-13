//
//  ScoreViewController.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/04.
//

import UIKit
import Combine

enum ScoreSection: CaseIterable {
    case main
}

class ScoreViewController: UIViewController {
    @IBOutlet weak var playerListCollectionView: UICollectionView!
 
    var viewModel: ScoreViewModel!
    var dataSource: UICollectionViewDiffableDataSource<ScoreSection, Player>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerListCollectionView.register(UINib(nibName: "PlayerListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerListCollectionViewCell")

        playerListCollectionView.register(UINib(nibName: "PlayerListCollectionViewHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayerListCollectionViewHeaderView.reuseIdentifier)
        
        playerListCollectionView.dataSource = self.dataSource
        playerListCollectionView.delegate = self
        
        self.dataSource = configureDataSource()

        bind()
    }
    
    func depend(viewModel: ScoreViewModel) {
        self.viewModel = viewModel
    }
    
    func bind() {
        viewModel.fetchGameInfo()
        viewModel.didUpdateGameInfo { (game) in
            self.updateSnapshot(with: game)
        }
    }
        
    func configureDataSource() -> UICollectionViewDiffableDataSource<ScoreSection, Player> {
        let dataSource = UICollectionViewDiffableDataSource<ScoreSection, Player>(collectionView: playerListCollectionView) { (collectionView, indexPath, player) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerListCollectionViewCell", for: indexPath) as! PlayerListCollectionViewCell
            cell.configureCell(with: player)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlayerListCollectionViewHeaderView.reuseIdentifier, for: indexPath)
                return headerView
            case UICollectionView.elementKindSectionFooter:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlayerListCollectionViewHeaderView.reuseIdentifier, for: indexPath)
                return headerView
            default: assert(false, "False Section") }
        }
        return dataSource
    }
    
    func updateSnapshot(with game: Game) {
        var snapshot = NSDiffableDataSourceSnapshot<ScoreSection, Player>()
        snapshot.appendSections(ScoreSection.allCases)
        snapshot.appendItems(game.myTeam.players, toSection: ScoreSection.main)
        dataSource.apply(snapshot)
    }
}

extension ScoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.playerListCollectionView.frame.width, height: self.playerListCollectionView.frame.height / 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.playerListCollectionView.frame.height / 16)
    }
}
