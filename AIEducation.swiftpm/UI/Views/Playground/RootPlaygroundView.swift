//
//  PlaygroundView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 13/11/2025.
//

import SwiftUI
import FoundationModels
import ImagePlayground
import PhotosUI
import SwiftData

struct PlaygroundView: View {
  @Query private var completedLessons: [CompletedLesson]
  
  enum CurrentView { case foundationModels, imagePlayground }
  
  @State private var selectedView: CurrentView = .foundationModels
  @State private var showPlayground: Bool = false
  
  var totalLessons: Int {
    LessonCourses.allCourses.flatMap { $0.lessons }.count
  }
  
  var completedLessonsCount: Int {
    completedLessons.count
  }
  
  var body: some View {
    VStack {
      if showPlayground {
        Picker("Select View", selection: $selectedView) {
          Text("LLM Playground").tag(CurrentView.foundationModels)
          Text("Image Generation Playground").tag(CurrentView.imagePlayground)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.top)
        
        //      Divider()
        
        switch selectedView {
        case .foundationModels:
          FoundationModelsPlayground()
        case .imagePlayground:
          ImagePlaygroundView()
        }
      } else {
        ContentUnavailableView {
          Label("Playground Locked", systemImage: "lock.fill")
        } description: {
          Text("Complete all lessons to unlock the playground features. You have completed \(completedLessonsCount) out of \(totalLessons) lessons.")
        }
      }
    }
    .onAppear {
      Task {
        showPlayground = CompletedLesson.areAllLessonsCompleted(completedLessons: completedLessons)
      }
    }
  }
}
