var initialJSON = require('./students.json');
var stringified = JSON.stringify(initialJSON);

//var success = false;

for (var i = 0; i < 100; i++) {
    var json = JSON.parse(stringified);
    var groups = [];

    json.students = shuffle(json.students);
    instantiateGroups();
    for (var j = 0; j < json.groups; j++) {
        addRound();
    }
    if (json.students.length == 0) {
        success = true;
        console.log('SUCCESS');
        printResults();
        break
    }
    if (i == 99) {
        console.log('Failed to find suitable arrangement after a reasonable number of tries');
    }
}

/*
FUNCTIONS
*/

function shuffle(sourceArray) {
    for (var i = 0; i < sourceArray.length - 1; i++) {
        var j = i + Math.floor(Math.random() * (sourceArray.length - i));

        var temp = sourceArray[j];
        sourceArray[j] = sourceArray[i];
        sourceArray[i] = temp;
    }
    return sourceArray;
}
function instantiateGroups() {
    /*
    Seeds each of the appropriate number of groups with one student who understands
    */

    // create appropriate number of groups
    for(var i = 0; i < json.groups; i++) {
        groups.push([]);
    }
    
    // for each group, add one student who understands
    for(var i = 0; i < groups.length; i++) {
        groups[i].push(getUnderstands());
    }
}

function addRound() {
    /*
    For each group, adds first compatable student.
    */
    for (var i = 0; i < groups.length; i++) {
        assignFirstValid(groups[i]);
    }
}

function getCompatable(inputGroup) {
    /*
    Given a group, finds a child who doesn't fight, and who doesn't push the limit over two noisy children/group.
    */

    // populate incompatableList
    var incompatableList = [];
    // for student in the given group
    for (var i = 0; i < inputGroup.length; i++) {

        // add each student they fight with
        for (var j = 0; j < inputGroup[i].fights_with.length; j++) {
            incompatableList.push(inputGroup[i].fights_with[j]);
            
        }
    }

    // for each student, check against incompatable list, return true if incompatable
    for (var i = 0; i < json.students.length; i++) {
        for (var j = 0; j < incompatableList.length; j++) {
            var incompatable = false;
            if (json.students[i].name == incompatableList[j]) {
                incompatable = true
            }
            console.log(incompatable)

            if (!incompatable) {
                console.log(json.students[i].name + ' is not in ' + incompatableList);
                return
            }
        }
    }
}

function getUnderstands() {
    /*
    Returns first student who understands, removes from array
    */
   for(var i = 0; i < json.students.length; i++) {
        // add one student who understands to each group
        if (json.students[i].understands) {
            var student = json.students[i];
            json.students.splice(i, 1);
            return student;
        }
    }
}

function printResults() {
    /*
    Console logs the groups and remaining unassigned students.
    */
    
    var remaining = [];

    // students remaining
    for (var i = 0; i < json.students.length; i++) {
        remaining.push(' ' + json.students[i].name);
    }
    console.log('Remaining: ' + remaining);

    // for each group, print students in group
    for (var i = 0; i < groups.length; i++) {
        // for each group, construct and print a string of all the students in that group
        var printString = "Group ";
        printString += ((i + 1) + ': ');

        for (var j = 0; j < groups[i].length; j++) {
            printString += (groups[i][j].name);
            if (j < groups[i].length - 1) {
                printString += ', ';
            }
        }
        console.log(printString);
    }
}

function assignFirstValid(givenList) {
    /*
    Given a list representing a group, assigns the first student that satisfies the criteria of not fighting with anyone in the group and not causing the group to exceed two noisy children. Removes assigned child from available roster. If unable to do so 
    */

    var noisyCount = getNoisyCount(givenList);
    var foundIndex = -1

    for (var i = 0; i < json.students.length; i++) {
        foundIndex = getIndexOfNextCompatable(givenList);

        // handle too many noisy kids case
        if (foundIndex != -2) {
            if ((noisyCount == 2) && (json.students[foundIndex].noisy == true)) {
                foundIndex = -1
            }
        }

        // assign and return if done
        if (foundIndex >= 0) {
            givenList.push(json.students[foundIndex]);
            json.students.splice(foundIndex, 1);
            return
        }
    }
}

//     while (foundIndex == -1) {
//         console.log('while loop running');
//         foundIndex = getIndexOfNextCompatable(givenList);

//         // handle no more available students case
//         if (foundIndex == -2) {                                         // we use -2 to break the loop
//             console.log('no more valid options, exiting while loop');
//             return
//         }

//         // handle too many noisy kids case
//         if (foundIndex != -2) {
//             if ((noisyCount == 2) && (json.students[foundIndex].noisy == true)) {
//                 foundIndex = -1
//             }
//         }
//     }

//     // assign student, remove from roster
//     if (foundIndex != -2) {
//         givenList.push(json.students[foundIndex]);
//         json.students.splice(foundIndex, 1);
//     }
// }

function getNoisyCount(givenList) {
    /*
    Returns number of noisy students in a given list.
    */
   var noisy = 0;
   for (var i = 0; i < givenList.length; i++) {
       if (givenList[i] != undefined) {
            if (givenList[i].noisy == true) {
                noisy += 1;
            }
       }
   }
   return noisy;
}

function getIndexOfNextCompatable(givenList) {
    /*
    Given a list of students, returns the index of the first unassigned student compatable. If no more compatable students, returns -1. 
    */
    // for unassigned student, return if compatable
    for (var i = 0; i < json.students.length; i++) {
        if (checkIfCompatable(json.students[i].name, givenList)) {
            return i;
        }
    }
    return -2;
}


function checkIfCompatable(name, givenList) {
    /* 
    Given a name and a list of students, returns true if name is compatable.
    */

    // check for undefined
    if (givenList[0] == undefined) {
        return false;
    }
    //console.log(givenList);

    // iterate through students
    for (var i = 0; i < givenList.length; i++) {
        // iterate through student's enemies
        for (var j = 0; j < givenList[i].fights_with.length; j++) {
            if (name == givenList[i].fights_with[j]) {
                return false
            }
        }
    }
    return true;
}

function printRemainingStudents() {
    /*
    DEBUG: prints names of remaining students
    */
   var remaining = '   ';
   for (var i = 0; i < json.students.length; i++) {
       remaining += (' ' + json.students[i].name);
   }
   console.log(remaining);
}
