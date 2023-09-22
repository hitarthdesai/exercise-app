import SwiftUI

struct AddNewExerciseView: View {
    @ObservedObject var addNewWorkoutVM = AddNewWorkoutViewModel()
    
    fileprivate func Sets(sets: [ExerciseSet]) -> some View {
        VStack {
            ForEach(Array(sets.enumerated()), id: \.offset) { index, element in
                if(element.numberOfUnits == -1) {} else {
                    HStack {
                        HStack {
                            Image(systemName: "\(index+1).circle")
                            Spacer()
                            if addNewWorkoutVM.workoutItemToAdd.exercise.unitType == ExerciseUnitType.repetitions {
                                Text("\(element.numberOfUnits) Repetitions")
                            } else {
                                Text("\(element.numberOfUnits / 60) Minutes and \(element.numberOfUnits % 60) Seconds")
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(200)
                    .background(.gray)
                }
            }
        }
    }
    
    fileprivate func AddNewSetView() -> some View {
        VStack {
            if addNewWorkoutVM.workoutItemToAdd.exercise.unitType == ExerciseUnitType.repetitions {
                Stepper("Number of Repitions: \(addNewWorkoutVM.numberOfUnits)", value: $addNewWorkoutVM.numberOfUnits, in: 0...500)
            } else {
                Stepper("Number of Minutes: \(addNewWorkoutVM.numberOfUnits / 60)", value: $addNewWorkoutVM.numberOfUnits, in: 0...3600, step: 60)
                Stepper("Number of Seconds: \(addNewWorkoutVM.numberOfUnits % 60)", value: $addNewWorkoutVM.numberOfUnits, in: 0...3600, step: 1)
            }
            VStack {
                Text("Add Set")
                    .frame(maxWidth: .infinity)
                    .cornerRadius(100)
                    .padding()
            }
            .onTapGesture {
                let setToAdd = ExerciseSet(id:  UUID(), numberOfUnits: addNewWorkoutVM.numberOfUnits)
                if(addNewWorkoutVM.workoutItemToAdd.sets[0].numberOfUnits == -1) {
                    addNewWorkoutVM.workoutItemToAdd.sets.removeAll()
                }
                addNewWorkoutVM.workoutItemToAdd.sets.append(setToAdd)
                addNewWorkoutVM.isAddingSet = false
            }
        }
    }
    
    fileprivate func ExerciseView(exercise: Exercise) -> some View {
        HStack() {
            Image(systemName: "dumbbell.fill")
            Text(exercise.name.capitalized)
            Spacer()
        }
        .padding()
        .border(.gray)
        .onTapGesture {
            addNewWorkoutVM.hasSelectedExercise = true
            addNewWorkoutVM.workoutItemToAdd.exercise = exercise
        }
    }
    
    fileprivate func ExerciseMenu(exercises: [Exercise]) -> some View {
        ScrollView {
            VStack {
                ForEach(exercises, id: \.id) { exercise in
                    ExerciseView(exercise: exercise)
                }
            }.frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        VStack {
            if addNewWorkoutVM.hasSelectedExercise {
                Text("Exercise: \(addNewWorkoutVM.workoutItemToAdd.exercise.name.capitalized)")
                    .font(.title3)
                    .padding(.bottom, 20)
                if addNewWorkoutVM.isAddingSet {
                    AddNewSetView()
                } else {
                    Sets(sets: addNewWorkoutVM.workoutItemToAdd.sets)
                    HStack {
                        HStack {
                            Text("Add a set")
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(200)
                    .border(.gray)
                    .onTapGesture {
                        addNewWorkoutVM.isAddingSet = true
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
                
                ExerciseMenu(exercises: addNewWorkoutVM.exercisesForTargetBodyPart)
            }
            
            HStack {
                Button("Cancel") {
                    addNewWorkoutVM.isAddingExercise = false
                    addNewWorkoutVM.workoutItemToAdd = WorkoutItem(exercise: exercise_app.Exercise(id: UUID(), name: ""), sets: [ExerciseSet(id: UUID(), numberOfUnits: -1)])
                    addNewWorkoutVM.hasSelectedExercise = false
                    addNewWorkoutVM.isAddingSet = false
                    addNewWorkoutVM.numberOfUnits = 0
                }
                Spacer()
                Button("Done") {
                    addNewWorkoutVM.isAddingExercise = false
                }
            }.padding(.horizontal, 30)
        }
        .onAppear {
            addNewWorkoutVM.targetBodyPart = AddNewWorkoutViewModel.TargetBodyPart.abs
        }
    }
}

struct Stuff2: PreviewProvider {
    static var previews: some View {
        AddNewExerciseView()
    }
}
