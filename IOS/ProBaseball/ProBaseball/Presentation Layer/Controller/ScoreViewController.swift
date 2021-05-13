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
    @IBOutlet weak var teamSelectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scoreBoardContainerView: UIView!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamTotalScoreLabel: UILabel!
    @IBOutlet weak var awayTeamTotalScoreLabel: UILabel!
    
    var viewModel: ScoreViewModel!
    var dataSource: UICollectionViewDiffableDataSource<ScoreSection, Player>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "baseBallPattern-small")!)
        
        homeTeamNameLabel.font = UIFont(name: "AmericanCaptain", size: 40)
        awayTeamNameLabel.font = UIFont(name: "AmericanCaptain", size: 40)
        
        let font: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name: "AmericanCaptain", size: 30)!]
            teamSelectSegmentedControl.setTitleTextAttributes(font, for: .normal)
        
        playerListCollectionView.register(UINib(nibName: "PlayerListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerListCollectionViewCell")

        playerListCollectionView.register(UINib(nibName: "PlayerListCollectionViewHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayerListCollectionViewHeaderView.reuseIdentifier)
        
        playerListCollectionView.register(UINib(nibName: "PlayerListCollectionViewFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PlayerListCollectionViewFooterView.reuseIdentifier)
        
        playerListCollectionView.dataSource = self.dataSource
        playerListCollectionView.delegate = self
        
        self.dataSource = configureDataSource(index: 0)

        bind()
    }

    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        guard let game = viewModel.game else { return }
        self.dataSource = configureDataSource(index: sender.selectedSegmentIndex)
        updateSnapshot(with: game, index: sender.selectedSegmentIndex)
    }
    
    func updateSegConLabels(with game: Game) {
        DispatchQueue.main.async {
            self.teamSelectSegmentedControl.setTitle(game.myTeam.name, forSegmentAt: 0)
            self.teamSelectSegmentedControl.setTitle(game.opponentTeam.name, forSegmentAt: 1)
        }
    }
    
    func depend(viewModel: ScoreViewModel) {
        self.viewModel = viewModel
    }
    
    func bind() {
        viewModel.fetchGameInfo()
        viewModel.didUpdateGameInfo { (game) in
            self.updateSnapshot(with: game, index: 0)
            self.updateSegConLabels(with: game)
            self.updateScoreDisplay(with: game)
        }
    }
    
    func updateScoreDisplay(with game: Game) {
        DispatchQueue.main.async {
            self.homeTeamNameLabel.text = game.myTeam.name
            self.awayTeamNameLabel.text = game.opponentTeam.name
            self.homeTeamTotalScoreLabel.text = "\(game.myTeam.score)"
            self.awayTeamTotalScoreLabel.text = "\(game.opponentTeam.score)"
        }
    }
    
    func configureDataSource(index: Int) -> UICollectionViewDiffableDataSource<ScoreSection, Player> {
        let dataSource = UICollectionViewDiffableDataSource<ScoreSection, Player>(collectionView: playerListCollectionView) { (collectionView, indexPath, player) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerListCollectionViewCell", for: indexPath) as! PlayerListCollectionViewCell
            cell.configureCell(with: player)
            return cell
        }
        
        configureHeaderFooter(with: dataSource, index: index)
        return dataSource
    }
    
    func configureHeaderFooter(with dataSource: UICollectionViewDiffableDataSource<ScoreSection, Player>, index: Int) {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlayerListCollectionViewHeaderView.reuseIdentifier, for: indexPath)
                return headerView
            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlayerListCollectionViewFooterView.reuseIdentifier, for: indexPath) as! PlayerListCollectionViewFooterView
                
                if index == 0 {
                    footerView.baLabel.text = "\(self.viewModel.statistics[0][0])"
                    footerView.hLabel.text = "\(self.viewModel.statistics[0][1])"
                    footerView.outLabel.text = "\(self.viewModel.statistics[0][2])"
                } else {
                    footerView.baLabel.text = "\(self.viewModel.statistics[1][0])"
                    footerView.hLabel.text = "\(self.viewModel.statistics[1][1])"
                    footerView.outLabel.text = "\(self.viewModel.statistics[1][2])"
                }
                
                return footerView
            default: assert(false, "False Section") }
        }
    }
    
    func updateSnapshot(with game: Game, index: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<ScoreSection, Player>()
        snapshot.appendSections(ScoreSection.allCases)
        
        if index == 0 {
            snapshot.appendItems(game.myTeam.players, toSection: ScoreSection.main)
        } else {
            snapshot.appendItems(game.opponentTeam.players, toSection: ScoreSection.main)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.playerListCollectionView.frame.height / 16)
    }
}
