import SwiftUI

struct WorkoutItem {
    var exercise: Exercise
    var sets: [ExerciseSet]
    //    var units
}

struct AddNewWorkoutView: View {
    @ObservedObject var addNewWorkoutVM = AddNewWorkoutViewModel()
    @ObservedObject var appVM = AppViewModel()
    
    @State private var workoutItemToAdd : WorkoutItem = WorkoutItem(exercise: exercise_app.Exercise(id: UUID(), name: ""), sets: [ExerciseSet(id: UUID(), numberOfUnits: -1)])
    
    @State private var isAddingSet: Bool = false
    @State private var numberOfUnits: Int = 0
    
    fileprivate func Sets(sets: [ExerciseSet]) -> some View {
        VStack {
            ForEach(Array(sets.enumerated()), id: \.offset) { index, element in
                if(element.numberOfUnits == -1) {} else {
                    HStack {
                        Image(systemName: "\(index+1).circle.fill")
                        Spacer()
                        if(workoutItemToAdd.exercise.unitType == ExerciseUnitType.repetitions) {
                            Text("\(element.numberOfUnits) Repetitions")
                        } else {
                            Text("\(element.numberOfUnits / 60) Minutes and \(element.numberOfUnits % 60) Seconds")
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func AddNewSetView() -> some View {
        VStack {
            if workoutItemToAdd.exercise.unitType == ExerciseUnitType.repetitions {
                Stepper("Number of Repitions: \(numberOfUnits)", value: $numberOfUnits, in: 0...500)
            } else {
                Stepper("Number of Minutes: \(numberOfUnits / 60)", value: $numberOfUnits, in: 0...3600, step: 60)
                Stepper("Number of Seconds: \(numberOfUnits % 60)", value: $numberOfUnits, in: 0...3600, step: 1)
            }
            Button("Add Set") {
                let setToAdd = ExerciseSet(id:  UUID(), numberOfUnits: numberOfUnits)
                if(workoutItemToAdd.sets[0].numberOfUnits == -1) {
                    workoutItemToAdd.sets.removeAll()
                }
                workoutItemToAdd.sets.append(setToAdd)
                isAddingSet = false
            }
        }
    }
    
    @State private var hasSelectedExercise : Bool = false
    fileprivate func Exercise(exercise: Exercise) -> some View {
        HStack() {
            Image(systemName: "dumbbell.fill")
            Text(exercise.name.capitalized)
            Spacer()
        }
        .padding()
        .border(.gray)
        .onTapGesture {
            hasSelectedExercise = true
            workoutItemToAdd.exercise = exercise
        }
    }
    
    fileprivate func ExerciseMenu() -> some View {
        ForEach(addNewWorkoutVM.exercisesForTargetBodyPart, id: \.id) { exercise in
            Exercise(exercise: exercise)
        }
    }
    
    @State private var isAddingNewExercise: Bool = true // should be false
    fileprivate func AddNewExerciseView() -> some View {
        VStack {
            if hasSelectedExercise {
                Text("Exercise: \(workoutItemToAdd.exercise.name.capitalized)")
                    .font(.title3)
                    .padding(.bottom, 20)
                if isAddingSet {
                    AddNewSetView()
                } else {
                    Sets(sets: workoutItemToAdd.sets)
                    Button("Add a Set") {
                        isAddingSet = true
                    }
                }
                Spacer()
            } else {
                Text("Adding New Exercise")
                    .font(.title)
                HStack {
                    Text("Target Body Part:")
                    Spacer()
                    Picker("", selection: $addNewWorkoutVM.targetBodyPart) {
                        Text("Abs").tag(AddNewWorkoutViewModel.TargetBodyPart.abs)
                        Text("Arms").tag(AddNewWorkoutViewModel.TargetBodyPart.arms)
                        Text("Back").tag(AddNewWorkoutViewModel.TargetBodyPart.back)
                        Text("Cardio").tag(AddNewWorkoutViewModel.TargetBodyPart.cardio)
                        Text("Chest").tag(AddNewWorkoutViewModel.TargetBodyPart.chest)
                        Text("Legs").tag(AddNewWorkoutViewModel.TargetBodyPart.legs)
                        Text("Shoulders").tag(AddNewWorkoutViewModel.TargetBodyPart.shoulders)
                    }
                }
                
                ScrollView {
                    ExerciseMenu()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            HStack {
                Button("Cancel") {
                    isAddingNewExercise = false
                }
                Spacer()
                Button("Done") {
                    isAddingNewExercise = false
                }
            }.padding(.horizontal, 30)
        }
    }
    
    
    
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
            if isAddingNewExercise {
                AddNewExerciseView()
            } else {
                Button("Add an Exercise") {
                    isAddingNewExercise = true
                }
                Spacer()
                AddedExercises(exercises: addNewWorkoutVM.addedExercises)
                Button("Done") {
                    appVM.isAddingNewWorkout = false
                }
            }
        }
        .padding()
        .onAppear {
            addNewWorkoutVM.targetBodyPart = AddNewWorkoutViewModel.TargetBodyPart.abs
        }
    }
}

struct Stuff: PreviewProvider {
    static var previews: some View {
        AddNewWorkoutView()
    }
}
