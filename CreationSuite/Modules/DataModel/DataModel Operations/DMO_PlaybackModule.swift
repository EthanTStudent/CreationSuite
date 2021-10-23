//
//  DMO_PlaybackModule.swift
//  CreationSuite
//
//  Created by Ethan Treiman on 10/18/21.
//

import Foundation
import UIKit
import AVFoundation

// DataModel Operations for PlaybackModule
extension DataModelOperations {
    
    func beginFirstPlayback() {
        model.playbackModule!.currentAsset = model.videoClipAttributes[model.focusedIndex].videoClip
    }
    
    func switchClipPlayback() {
        model.playbackModule!.currentAsset = model.videoClipAttributes[model.focusedIndex].videoClip
    }
    
    func seekModuleToTime() {
        let fullLength = model.videoClipAttributes[model.focusedIndex].clipLengthInSeconds
        model.playbackModule!.player.seek(to:  CMTime(value: CMTimeValue(fullLength! * model.percentageThroughFocused * 600), timescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func playerTimeHasUpdated(percent: CGFloat) {
        if model.isPlaying {
            model.percentageThroughFocused = percent
            let newOffset = model.cellAttributes[model.focusedIndex].collectionViewFocusedWidthOfCell * percent + model.cellAttributes[model.focusedIndex].collectionViewLeftOfCell
            model.collectionView!.changeOffsetFromDataModelDirection(newOffset: newOffset)
        }
    }
    
    func pausePlayback(){
        model.isPlaying = false
        model.creationController.playbackModule!.player.pause()
        print("PAUSING!")
        model.creationController.editingOverlay!.playPauseButton.setTitle("Play", for: .normal)
        model.creationController.editingOverlay!.playPauseButton.backgroundColor = .green
    }
    
    func playPlayback(){
        if model.percentageThroughFocused == 1 {
            model.percentageThroughFocused = 0
            model.operations!.seekModuleToTime()
        }
        model.isPlaying = true
        print("PLAYING!")
        model.creationController.playbackModule!.player.play()
        model.creationController.editingOverlay!.playPauseButton.setTitle("Pause", for: .normal)
        model.creationController.editingOverlay!.playPauseButton.backgroundColor = .red
    }
 
    func reachedEndOfClip(){
        print("?? end?")
        if !hasReachedEnd {
            hasReachedEnd = true
            if model.currPlaybackMethod == .autoContinue{
                print("reached end, continuing hehe")
                if model.focusedIndex != model.cellAttributes.count - 1 {
                    model.collectionView!.jumpToLeftEndOfCell(index: model.focusedIndex + 1)
                } else {
                    if cellUpdateDetected(index: model.focusedIndex) == 1 {
                        pausePlayback()
                        model.percentageThroughFocused = 1
                        model.operations!.seekModuleToTime()
                    }
                }
            } else if model.currPlaybackMethod == .looping {
                print("reached end, looping though xD")
                if cellUpdateDetected(index: model.focusedIndex) == 1 {
                    model.percentageThroughFocused = 0
                    model.operations!.seekModuleToTime()
                }
            } else if model.currPlaybackMethod == .none {
                print("reached end, Stoppinnggg!! !")
                if cellUpdateDetected(index: model.focusedIndex) == 1 {
                    pausePlayback()
                    model.percentageThroughFocused = 1
                    model.operations!.seekModuleToTime()
                }
            }
        }
    }
    
    func switchIsPlaying() {
        if !model.isPlaying {
            playPlayback()
        } else {
            pausePlayback()
        }
    }
    
    func switchPlaybackMethod() {
        switch model.currPlaybackMethod {
        case .none:
            model.currPlaybackMethod = .autoContinue
            model.creationController.editingOverlay!.playbackMethodButton.setTitle("Auto-Continuing", for: .normal)
            model.creationController.editingOverlay!.playbackMethodButton.backgroundColor = .blue
            model.creationController.editingOverlay!.playbackMethodButton.titleLabel!.textColor = .white
        case .autoContinue:
            model.currPlaybackMethod = .looping
            model.creationController.editingOverlay!.playbackMethodButton.setTitle("Looping", for: .normal)
            model.creationController.editingOverlay!.playbackMethodButton.backgroundColor = .purple
        case .looping:
            model.currPlaybackMethod = .none
            model.creationController.editingOverlay!.playbackMethodButton.setTitle("None", for: .normal)
            model.creationController.editingOverlay!.playbackMethodButton.backgroundColor = .black
        }
    }
    
}
