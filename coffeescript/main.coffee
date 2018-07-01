###
TODO:
-
###

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

# get_index_of_next_compatable = ->
#     ###
#     Returns the index of the next 
#     ###

check_if_compatable = (name, input_group) ->
    ###
    Given a name and a list of students, returns true if name is compatable.
    ###

    # TODO: THIS NEXT


# get_compatable = (input_group) ->
#     ###
#     Given a group, finds a child who doesn't fight, and who doesn't push the limit over two noisy children/group.
#     ###

#     # build incompatable_list
#     incompatable_list = []
#     for student in input_group
#         for entry in student.fights_with
#             incompatable_list.push entry
    
    


print_results = ->
    ###
    prints remaining students, members of each group
    ###
    remaining = []
    remaining.push student.name for student in json.students
    remaining_names = 'Remaining: '
    for name in remaining
        remaining_names += name + ' '
    console.log remaining_names

    for group, i in groups
        names = student.name for student in group
        console.log 'Group ' + i + ': ' + names
        

###

###

groups = []

json = JSON.parse stringified
#console.log json

instantiate_groups()
#print_results()

get_compatable(groups[0])


