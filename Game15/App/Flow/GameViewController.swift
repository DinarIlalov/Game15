//
//  ViewController.swift
//  Game15
//
//  Created by Dinar Ilalov on 10/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameFieldView: BoxView!
    private var chipViews: [ChipView] = []
    
    private var game = Game()
    
    private let fieldBorderWidth: Int = 8
    private var fieldWidth: CGFloat = 0
    private var chipWidth: Int = 0
    
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    
    var currentMove: ChipMove?
    
    var panGestureActiveChip: ChipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidLayoutSubviews() {
        game.new()
        buildGameField()
    }
    
    private func buildGameField() {
        
        currentMove = nil
        startPoint = .zero
        endPoint = .zero
        panGestureActiveChip = nil
        
        chipViews.forEach { $0.removeFromSuperview() }
        chipViews.removeAll()
        
        fieldWidth = gameFieldView.bounds.width - 2*CGFloat(fieldBorderWidth)
        
        chipWidth = Int(fieldWidth/CGFloat(Game.gameGridCount))
        
        for chip in game.chips {
            
            if chip.number == 0 {
                continue
            }
            let chipView = ChipView(frame: CGRect(x: chip.placeInMatrix.columnIndex*chipWidth + fieldBorderWidth,
                                                  y: chip.placeInMatrix.rowIndex*chipWidth + fieldBorderWidth,
                                                  width: chipWidth-1,
                                                  height: chipWidth-1))
            
            chipView.chipModel = chip
                
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleChipPan(recognizer:)))
            chipView.addGestureRecognizer(panGestureRecognizer)
            
            self.gameFieldView.addSubview(chipView)
            
            chipViews.append(chipView)
            
        }
    }
    
    // MARK: - Actions
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        game.new()
        buildGameField()
    }
    
    @objc func handleChipPan(recognizer: UIPanGestureRecognizer) {
        guard let chipView = recognizer.view as? ChipView else { return }
        
        // multiple chips view touching prevention
        if panGestureActiveChip != nil, panGestureActiveChip != chipView {
            return
        }
        
        panGestureActiveChip = chipView
        
        if recognizer.state == .began {
            
            startPoint = chipView.center
            
            currentMove = game.chipsMove(from: chipView.chipModel.placeInMatrix)
            currentMove?.setViewsToMove(allViews: chipViews)
            
            guard let moveDirection = currentMove?.moveDirection
                else {
                    startPoint = .zero
                    endPoint = .zero
                    panGestureActiveChip = nil
                    currentMove = nil
                    return
            }
            
            switch moveDirection {
            case .down:
                endPoint = CGPoint(x: startPoint.x, y: startPoint.y + CGFloat(chipWidth))
            case .up:
                endPoint = CGPoint(x: startPoint.x, y: startPoint.y - CGFloat(chipWidth))
            case .right:
                endPoint = CGPoint(x: startPoint.x + CGFloat(chipWidth), y: startPoint.y)
            case .left:
                endPoint = CGPoint(x: startPoint.x - CGFloat(chipWidth), y: startPoint.y)
            default:
                startPoint = .zero
                endPoint = .zero
                panGestureActiveChip = nil
                currentMove = nil
                return
            }
            
            return
            
        } else if recognizer.state == .ended {
            
            guard let moveDirection = currentMove?.moveDirection
                else {
                    startPoint = .zero
                    endPoint = .zero
                    panGestureActiveChip = nil
                    currentMove = nil
                    return
            }
            
            var finalPoint: CGPoint
            switch moveDirection {
            case .down:
                if chipView.center.y > endPoint.y - CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
                
            case .up:
                if chipView.center.y < endPoint.y + CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
            case .right:
                if chipView.center.x > endPoint.x - CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
            case .left:
                if chipView.center.x < endPoint.x + CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
            default:
                return
            }
            
            if finalPoint == endPoint, currentMove != nil {
                game.moveChipToZero(currentMove!)
            }
            
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            switch moveDirection {
                            case .up:
                                for (viewIndex, view) in (self.currentMove?.chipViews ?? []).enumerated() {
                                    view.center = CGPoint(x: finalPoint.x,
                                                          y: finalPoint.y - CGFloat(self.chipWidth*viewIndex))
                                }
                            case .down:
                                for (viewIndex, view) in (self.currentMove?.chipViews ?? []).enumerated() {
                                    view.center = CGPoint(x: finalPoint.x,
                                                          y: finalPoint.y + CGFloat(self.chipWidth*viewIndex))
                                }
                            case .right:
                                for (viewIndex, view) in (self.currentMove?.chipViews ?? []).enumerated() {
                                    view.center = CGPoint(x: finalPoint.x + CGFloat(self.chipWidth*viewIndex),
                                                          y: finalPoint.y)
                                }
                            case .left:
                                for (viewIndex, view) in (self.currentMove?.chipViews ?? []).enumerated() {
                                    view.center = CGPoint(x: finalPoint.x - CGFloat(self.chipWidth*viewIndex),
                                                          y: finalPoint.y)
                                }
                            default:
                                break
                            }
                            
            },
                           completion: { _ in
                            self.currentMove = nil
                            self.startPoint = .zero
                            self.endPoint = .zero
                            self.panGestureActiveChip = nil
                            
            })
            
            
            if game.isDone {
                let alert = UIAlertController(title: "You are win!", message: "Congratulations!", preferredStyle: .alert)
                let okeyButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okeyButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        let translation = recognizer.translation(in: self.view)
        
        guard let chipsToMove = currentMove?.chipViews else {
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            self.currentMove = nil
            self.startPoint = .zero
            self.endPoint = .zero
            self.panGestureActiveChip = nil
            return
        }
        
        for (chipIndex, view) in chipsToMove.enumerated() {
            move(view, withIndex: chipIndex, to: currentMove?.moveDirection, with: translation)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    private func move(_ chipView: ChipView, withIndex chipIndex: Int, to direction: AvailableMoveDirection?, with translation: CGPoint) {
        guard let moveDirection = direction, moveDirection != .none else { return }
        
        switch moveDirection {
        case .down:
            if chipView.center.y + translation.y > endPoint.y + CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: endPoint.x,
                                          y: endPoint.y + CGFloat(chipWidth*chipIndex))
            } else if chipView.center.y + translation.y < startPoint.y + CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: startPoint.x,
                                          y: startPoint.y + CGFloat(chipWidth*chipIndex))
            } else {
                chipView.center = CGPoint(x: chipView.center.x,
                                          y: chipView.center.y + translation.y)
            }
        case .up:
            if chipView.center.y + translation.y < endPoint.y - CGFloat(chipWidth*chipIndex){
                chipView.center = CGPoint(x: endPoint.x,
                                          y: endPoint.y - CGFloat(chipWidth*chipIndex))
            } else if chipView.center.y + translation.y > startPoint.y - CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: startPoint.x,
                                          y: startPoint.y - CGFloat(chipWidth*chipIndex))
            } else {
                chipView.center = CGPoint(x: chipView.center.x,
                                          y: chipView.center.y + translation.y)
            }
        case .right:
            if chipView.center.x + translation.x > endPoint.x + CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: endPoint.x + CGFloat(chipWidth*chipIndex),
                                          y: endPoint.y)
            } else if chipView.center.x + translation.x < startPoint.x + CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: startPoint.x + CGFloat(chipWidth*chipIndex),
                                          y: startPoint.y)
            } else {
                chipView.center = CGPoint(x: chipView.center.x + translation.x,
                                          y: chipView.center.y)
            }
        case .left:
            if chipView.center.x + translation.x < endPoint.x - CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: endPoint.x - CGFloat(chipWidth*chipIndex),
                                          y: endPoint.y)
            } else if chipView.center.x + translation.x > startPoint.x - CGFloat(chipWidth*chipIndex) {
                chipView.center = CGPoint(x: startPoint.x - CGFloat(chipWidth*chipIndex),
                                          y: startPoint.y)
            } else {
                chipView.center = CGPoint(x: chipView.center.x + translation.x,
                                          y: chipView.center.y)
            }
        default:
            break
        }
    }
}

