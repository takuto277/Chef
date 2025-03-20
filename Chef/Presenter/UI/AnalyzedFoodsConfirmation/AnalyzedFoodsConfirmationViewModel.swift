//
//  AnalyzedFoodsConfirmationViewModel.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/20.
//

import SwiftUI
import Combine
import Observation

extension AnalyzedFoodsConfirmationViewModel {
    struct Input {
        let tappedAddButton: AnyPublisher<Void, Never>
        let addNewFood: AnyPublisher<SegmentedFood, Never>
        let updateFoodQuantity: AnyPublisher<(UUID, Int), Never>
        let tappedImage: AnyPublisher<SegmentedFood, Never>
    }
    
    @Observable
    internal class Output: ObservableObject {
        var showAddSeet: Bool = false
        var segmentedFoods: [SegmentedFood] = []
        var currentSelectSegmentedFood: SegmentedFood?
        var showSelectAlert: Bool = false
    }
}

@MainActor
internal final class AnalyzedFoodsConfirmationViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var output = Output()
    
    internal func setup(segmentedFoods: [SegmentedFood]) {
        output.segmentedFoods = segmentedFoods
    }
    
    internal func subscribe(input: Input) -> Output {
        input.tappedAddButton
            .sink { [weak self] in
                guard let self else { return }
                self.output.showAddSeet = true
            }
            .store(in: &cancellables)
        input.addNewFood
            .sink { [weak self] newFood in
                guard let self else { return }
                if let index = self.output.segmentedFoods.firstIndex(where: { $0.id == newFood.id }) {
                    self.output.segmentedFoods[index] = newFood
                } else {
                    // TODO: imageが空なら自動的に画像を入れる
                    self.output.segmentedFoods.append(newFood)
                }
            }
            .store(in: &cancellables)
        input.updateFoodQuantity
            .sink { [weak self] uuid, quantity in
                guard let self else { return }
                if let index = self.output.segmentedFoods.firstIndex(where: { $0.id == uuid }) {
                      self.output.segmentedFoods[index].quantity = "\(quantity)"
                  }
            }
            .store(in: &cancellables)
        input.updateFoodQuantity
            .sink { [weak self] uuid, quantity in
                guard let self else { return }
                if let index = self.output.segmentedFoods.firstIndex(where: { $0.id == uuid }) {
                      self.output.segmentedFoods[index].quantity = "\(quantity)"
                  }
            }
            .store(in: &cancellables)
        input.tappedImage
            .sink { [weak self] food in
                guard let self else { return }
                self.output.currentSelectSegmentedFood = food
                self.output.showSelectAlert = true
            }
            .store(in: &cancellables)
        return output
    }
}
