//
//  PlaygroundView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 13/11/2025.
//

import FoundationModels
import ImagePlayground
import PhotosUI
import SwiftData
import SwiftUI

struct PlaygroundView: View {
  @Environment(ImageCreatorService.self) private var imageCreatorService
  
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

  #if DEBUG
    @Environment(\.modelContext) private var modelContext
  #endif

  var body: some View {
    VStack {
      if showPlayground {
        HorizontalView {
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
            if let isSupported = imageCreatorService.isSupported,
               isSupported {
              ImagePlaygroundView()
            } else {
              ContentUnavailableView {
                Label("Image Generation Not Supported", systemImage: "apple.intelligence.badge.xmark")
              } description: {
                Text("Image Generation powered by Apple Intelligence is not supported on your device.")
#if targetEnvironment(simulator)
                Text("Image Playground is not supported in the simulator :), Please test on a real device.")
#endif
              }
            }
          }
        } placeholder: {
          ContentUnavailableView {
            Label("Please Rotate Your Device", systemImage: "iphone.landscape")
          }
        }
      } else {
        ContentUnavailableView {
          Label("Playground Locked", systemImage: "lock.fill")
        } description: {
          Text(
            "Complete all labs to unlock the Playground. You have completed \(completedLessonsCount) out of \(totalLessons)"
          )
        }
        #if DEBUG
          .overlay(
            Button("Unlock Playground") {
              showPlayground = true
            }
          )
        #endif
      }
    }
    .onAppear {
      Task {
        showPlayground = CompletedLesson.areAllLessonsCompleted(
          completedLessons: completedLessons
        )
      }
    }
  }
}
