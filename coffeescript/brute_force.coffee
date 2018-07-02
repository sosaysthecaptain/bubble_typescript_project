initialJSON = require './students.json'
stringified = JSON.stringify(initialJSON)

groups = []
json = JSON.parse stringified
student_count = json.students.length

shuffle = (source_array) -> 
    for item, i in source_array
        j = i + Math.floor (Math.random() * source_array.length - i)
        temp = source_array[j]
        source_array[j] = source_array[i]
        source_array[i] = temp
    return source_array

print_results = ->
    ###
    Prints remaining students, members of each group
    ###
    console.log 'Unassigned students remaining: ' + printable_list json.students
    for group, i in groups
        console.log 'Group ' + (i + 1) + ': ' + printable_list groups[i]

printable_list = (input_group) ->
    ###
    Given list of student objects, returns string of names
    ###
    names = []
    names.push student.name for student in input_group
    return JSON.stringify(names)

generate_random_groups = ->
    ###
    Populates groups randomly
    ###

    # instantiate correct number of groups
    for [0...json.groups]
        groups.push []

    # add students until no more
    while json.students.length > 0
        for group in groups
            if json.students.length > 0
                group.push json.students[0]
                json.students.splice 0, 1


reset_input = ->
    ###
    Generates a fresh, shuffled array of students
    ###
    groups = []
    json = JSON.parse stringified
    json.students = shuffle(json.students)

check_noisy = ->
    ###
    Checks each group for total count of noisy children, returns false if any one exceeds two, true otherwise.
    ###
    noisy_count = []
    for i in [0...json.groups]
        noisy_count.push 0
        for student in groups[i]
            if student.noisy
                noisy_count[i] += 1
        if noisy_count[i] > 2
            return false
    return true

check_compatability = ->
    ###
    Checks each group to see if anyone will fight
    ###

    # for each group, generate incompatable list
    for group, i in groups
        incompatable_list = []
        for student in group
            for entry in student.fights_with
                incompatable_list.push entry

        # ...and see if anyone in the group's on it
        for student in group
            if student.name in incompatable_list
                return false
    return true

check_understands = ->
    ###
    Check if at least one student per group who understands
    ###
    for group, i in groups
        understand_count = 0
        for student in group
            if student.understands
                understand_count += 1
        if understand_count == 0
            return false
    return true



####################################################################################################
####################################################################################################

flag = false

count = 0
while flag == false
    count += 1
    reset_input()
    generate_random_groups()
    flag1 = check_understands()
    flag2 = check_noisy()
    flag3 = check_compatability()
    if flag1 and flag2 and flag3
        flag = true

console.log 'SUCCESS, try ' + count
print_results()

console.log '  Passes noisy test: ' + check_noisy()
console.log '  Passes understands test: ' + check_understands()
console.log '  Passes compatability test: ' + check_compatability()
