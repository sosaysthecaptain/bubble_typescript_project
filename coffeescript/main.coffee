initialJSON = require './students.json'
stringified = JSON.stringify(initialJSON)

testArray = ['one', 'two', 'three', 'four', 'five']

shuffle = (source_array) -> 
    for item, i in source_array
        j = i + Math.floor (Math.random() * source_array.length - i)
        temp = source_array[j]
        source_array[j] = source_array[i]
        source_array[i] = temp
    return source_array

instantiate_groups = ->
    ### 
    seeds each of the appropriate number of groups with one student who understands
    ###

    # create appropriate number of groups
    for i in [0...initialJSON.groups]
        groups.push []

    # add one student who understands to each group
    for group in groups
        group.push get_understands()

get_understands = ->
    ### 
    returns the first student that understands, removes from the array
    ###

    for student, index in json.students
        if student.understands
            json.students.splice index, 1
            return student

check_if_compatable = (name, input_group) ->
    ###
    Given a name and a list of students, returns true if name is compatable and doesn't create a group with more than two noisy students. Returns false if passed an empty array
    ###

    # build incompatable_list
    incompatable_list = []
    for student in input_group
        for entry in student.fights_with
            incompatable_list.push entry
    
    # if name in incompatable_list, return false
    if name in incompatable_list
        return false

    # if this makes the group have more than two noisy kids, return false
    noisy_count = get_noisy_count input_group

    # since we were passed the name of a student, we need to look this student up in the JSON to find out if noisy
    student_in_question = student for student in json.students when student.name == name

    if student_in_question.noisy
        noisy_count += 1
    if noisy_count > 2
        return false

    return true

get_noisy_count = (input_group) ->
    ###
    Returns number of noisy students in input_group
    ###
    noisy = 0
    for student in input_group
        if student.noisy
            noisy += 1
    return noisy

get_index_of_next_compatable = (input_group) ->
    ###
    Given a group of students, returns the index of the next unassigned compatable student.
    If no more compatable students, returns -1
    ###

    for student, i in json.students
        if check_if_compatable student.name, input_group
            return i
    return -1

assign_first_valid = (input_group) -> 
    ###
    Given a list representing a group, assigns the first student that satisfies the criteria of not fighting with anyone in the group and not causing the group to exceed two noisy children. Removes assigned child from available roster. Returns true if successful, false if failed because of lack of compatable students
    ###

    compatable_index = get_index_of_next_compatable input_group
    if compatable_index >= 0
        input_group.push json.students[compatable_index]
        json.students.splice compatable_index, 1


assign_remaining_students = ->
    ###
    Assigns one compatable student to each group, if possible
    ###
    loops_necessary = Math.ceil student_count / json.groups

    for i in [0...loops_necessary]
        for group in groups
            assign_first_valid group

print_results = ->
    ###
    prints remaining students, members of each group
    ###
    
    # print remaining names
    remaining = []
    remaining.push student.name for student in json.students
    remaining_names = '  Unassigned students remaining: '
    for name in remaining
        remaining_names += name + ' '
    console.log remaining_names

    # for each group, print list of names
    for group, i in groups
        names = []
        names.push student.name for student in group
        console.log '  Group ' + i + ': ' + names

printable_list = (input_group) ->
    ###
    Given list of student objects, returns string of names
    ###
    names = []
    names.push student.name for student in input_group
    return JSON.stringify(names)

##############################################################################################################
##############################################################################################################


groups = []
json = JSON.parse stringified
student_count = json.students.length

# Solve. For a reasonable number of tries, shuffle, instantiate, assign remaining. If none left, success
for i in [0...100]
    json = JSON.parse stringified
    json.students = shuffle(json.students)
    groups = []

    instantiate_groups()
    assign_remaining_students()

    if json.students.length == 0
        console.log 'SUCCESS on try ' + (i + 1)
        print_results()
        break

if json.students.length != 0
    console.log 'Failed to find a valid solution'
