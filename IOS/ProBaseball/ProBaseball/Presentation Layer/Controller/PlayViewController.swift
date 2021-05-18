//
//  PlayViewController.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/04.
//

import UIKit
import Foundation

enum BallCountSection: CaseIterable {
    case main
}

class PlayViewController: UIViewController {
    @IBOutlet weak var currentPitcher: UILabel!
    @IBOutlet weak var currentBatter: UILabel!
    @IBOutlet weak var currentPitcherNum: UILabel!
    @IBOutlet weak var strikeStackView: UIStackView!
    @IBOutlet weak var ballStackView: UIStackView!
    @IBOutlet weak var outStackView: UIStackView!
    @IBOutlet weak var currentBatterDescription: UILabel!
    @IBOutlet weak var inningLabel: UILabel!
    @IBOutlet weak var offenseOrDefense: UILabel!
    @IBOutlet weak var ballCountCollectionView: UICollectionView!
    lazy var dataSource = configureDataSource()
    
    @IBOutlet weak var playBackgroundView: PlayBackgroundView!
    var playerView: PlayerIconView!
    @IBOutlet weak var baseBall: UIImageView!
    var viewModel: PlayViewModel!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamTotalScoreLabel: UILabel!
    @IBOutlet weak var awayTeamTotalScoreLabel: UILabel!
    @IBOutlet var strikeCount: [UIImageView]!
    @IBOutlet var ballCount: [UIImageView]!
    @IBOutlet var outCount: [UIImageView]!
    
    @IBOutlet weak var pitcherLabel: UILabel!
    @IBOutlet weak var batterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchGame()
        self.bind()
        ballCountCollectionView.register(UINib(nibName: BallCountCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BallCountCollectionViewCell.identifier)
        ballCountCollectionView.dataSource = dataSource
        ballCountCollectionView.delegate = self
        addBatterView()
        runToFirstBase()
        throwBall()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "baseBallPattern-small")!)
        homeTeamNameLabel.font = UIFont(name: "AmericanCaptain", size: 40)
        awayTeamNameLabel.font = UIFont(name: "AmericanCaptain", size: 40)
        inningLabel.font = UIFont(name: "AmericanCaptain", size: 25)
        offenseOrDefense.font = UIFont(name: "AmericanCaptain", size: 25)
        pitcherLabel.font = UIFont(name: "AmericanCaptain", size: 20)
        batterLabel.font = UIFont(name: "AmericanCaptain", size: 20)
        currentPitcher.font = UIFont(name: "AmericanCaptain", size: 20)
        currentBatter.font = UIFont(name: "AmericanCaptain", size: 20)
        
    }
    
    func depend(viewModel: PlayViewModel) {
        self.viewModel = viewModel
    }
    
    func addBatterView() {
        playerView = PlayerIconView(frame: CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.maxY-20, width: 60, height: 60))
        playerView.backgroundColor = .clear
        self.playBackgroundView.playView.addSubview(playerView)
    }
    
    func PitchAnimation() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
            self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.maxY-20, width: 60, height: 60)
        },
        completion: { _ in self.runToSecondBase()})
    }
    
    func position(path: UIBezierPath, duration: Double, repeatCount: Float) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path.cgPath
        animation.duration = duration
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        animation.repeatCount = repeatCount
        return animation
   }
    
    func updateScoreDisplay(with game: Game) {
        DispatchQueue.main.async {
            self.homeTeamNameLabel.text = game.myTeam.name
            self.awayTeamNameLabel.text = game.opponentTeam.name
            self.homeTeamTotalScoreLabel.text = "\(game.myTeam.score)"
            self.awayTeamTotalScoreLabel.text = "\(game.opponentTeam.score)"
        }
    }
    
    func throwBall() {
        
        let path = UIBezierPath()
        let line = CAShapeLayer()
 
        line.path = path.cgPath
        line.strokeColor = UIColor.blue.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 2.0
        baseBall.layer.addSublayer(line)

        path.move(to: CGPoint(x: baseBall.frame.midX, y: baseBall.frame.midY))
        path.addQuadCurve(to: CGPoint(x: playBackgroundView.playView.frame.midX, y: playBackgroundView.playView.frame.maxY), controlPoint: CGPoint(x: 220, y: 200))
        self.baseBall.layer.add(position(path: path, duration: 1.5, repeatCount: 3), forKey: "position")
        
    }
    
    func runToFirstBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
            self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.maxX-20, y: self.playBackgroundView.playView.bounds.midY-20, width: 60, height: 60)
        },
        completion: { _ in self.runToSecondBase()})
    }
    
    func runToSecondBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
        self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.minY-20, width: 60, height: 60)
        },
        completion: { _ in self.runToThirdBase()})
    }
    
    func runToThirdBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
        self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.minX-20, y: self.playBackgroundView.playView.bounds.midY-20, width: 60, height: 60)
        },
        completion: { _ in self.runToHomeBase() })
    }
    
    func runToHomeBase() {
        UIView.animate(withDuration:1,
        delay: 0,
        options: [],
        animations: {
        self.playerView.frame = CGRect(x: self.playBackgroundView.playView.bounds.midX-20, y: self.playBackgroundView.playView.bounds.maxY-20, width: 60, height: 60)
        },
        completion: nil)
    }
    
    private func fetchGame() {
        self.viewModel.fetchGame()
    }
    
    func bind() {
        viewModel.didUpdateGame { [weak self] (game) in
            self?.updateSnapshot(with: game)
            
            if game.myTeam.isAttack == true {
                //현재타자
                self?.currentBatter.text = game.myTeam.currentBatsman.name
                //현재투수
                self?.currentPitcher.text = game.opponentTeam.currentPitcher.name
                //투구수
                self?.currentPitcherNum.text = "#\(game.opponentTeam.currentPitcher.numberOfPitches)"
                //1타석 0안타
                self?.currentBatterDescription.text = "\(game.myTeam.currentBatsman.plateAppearance) PA \(game.myTeam.currentBatsman.hitsNumbers) H"
                self?.offenseOrDefense.text = "ATTACK⚔️"
            } else {
                self?.currentBatter.text = game.opponentTeam.currentBatsman.name
                self?.currentPitcher.text = game.myTeam.currentPitcher.name
                self?.currentPitcherNum.text = "#\(game.myTeam.currentPitcher.numberOfPitches)"
                self?.currentBatterDescription.text = "\(game.opponentTeam.currentBatsman.plateAppearance) PA \(game.opponentTeam.currentBatsman.hitsNumbers) H"
                self?.offenseOrDefense.text = "DEFENSE🛡"
            }
            (0..<game.ballCount.strike).forEach{ i in
                self?.strikeCount[i].isHidden = false
            }
            (0..<game.ballCount.ball).forEach{ i in
                self?.ballCount[i].isHidden = false
            }
            (0..<game.ballCount.out).forEach{ i in
                self?.outCount[i].isHidden = false
            }
            
            self?.strikeStackView.addSubview(UIView())
            self?.ballStackView.addSubview(UIView())
            self?.outStackView.addSubview(UIView())
            
            //2회초
            if game.inning.status == "top" {
                self?.inningLabel.text = "\(game.inning.inningNum)TH TOP"
            } else {
                self?.inningLabel.text = "\(game.inning.inningNum)TH BOTTOM"
            }

            self?.updateScoreDisplay(with: game)
        }
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<BallCountSection, Game> {
        let dataSource = UICollectionViewDiffableDataSource<BallCountSection, Game>(collectionView: ballCountCollectionView) { (collectionView, indexPath, game) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BallCountCollectionViewCell", for: indexPath) as! BallCountCollectionViewCell
            cell.ballState.text = "Strike"
            cell.cellCount.setTitle(String(indexPath.row), for: .normal)
            cell.ballStateHistoryNum.text = "\(game.ballCount.strike)-\(game.ballCount.ball)"
            return cell
        }
        return dataSource
    }
    
    func updateSnapshot(with game: Game) {
        var snapshot = NSDiffableDataSourceSnapshot<BallCountSection, Game>()
        snapshot.appendSections(BallCountSection.allCases)
        snapshot.appendItems([game], toSection: BallCountSection.main)
 
        dataSource.apply(snapshot)
    }
}

extension PlayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.ballCountCollectionView.frame.width, height: self.ballCountCollectionView.frame.height / 6)
    }
}
