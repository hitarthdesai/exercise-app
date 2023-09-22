import SwiftUI

struct WorkoutItem {
    var exercise: Exercise
    var sets: [ExerciseSet]
}

struct AddNewWorkoutView: View {
    @ObservedObject var addNewWorkoutVM = AddNewWorkoutViewModel()
    @ObservedObject var appVM = AppViewModel()

    fileprivate func AddedExercises(exercises: [Exercise]) -> some View {
        Text("Number of Exercises: \(addNewWorkoutVM.exercisesForTargetBodyPart.count)")
    }
    
    fileprivate func WorkoutNameInput(exercises: [Exercise]) -> some View {
        HStack(alignment: .center) {
            Text("Workout Name:")
            TextField("", text: $addNewWorkoutVM.workoutName)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
                .padding(.top, 10)
        }
    }
    
    var body: some View {
        VStack {
            if addNewWorkoutVM.isAddingExercise {
                AddNewExerciseView()
            } else {
                Button("Add an Exercise") {
                    addNewWorkoutVM.isAddingExercise = true
                }
                Spacer()
                AddedExercises(exercises: addNewWorkoutVM.addedExercises)
                Button("Done") {
                    appVM.isAddingNewWorkout = false
                }
            }
        }
        .padding()
    }
}

struct Stuff: PreviewProvider {
    static var previews: some View {
        AddNewWorkoutView()
    }
}
