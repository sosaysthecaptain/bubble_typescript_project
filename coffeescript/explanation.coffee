###
Compiling coffeescript:
$ coffee --compile my-script.coffee

(then, can do node filename.js for testing)
so
coffee --compile demo.coffee ; node demo.js
###

###
DECLARING VARIABLES & FUNCTIONS
###
new_variable = "foo"

# variables are all local. If you want something to be global, do it like this:
exports = this                                  # dump everything to global object
exports.another_variable = "foo-bar"

# functions. Functions are all saved to variables in coffeescript

func = -> "bar"

#which is the same as 
func2 = ->
    # extra line
    "bar"

###
OBJECT LITERALS
###
object1 = {one: 1, two: 2}

object2 = one: 1, two: 2

object3 = 
    one: 1
    two: 2

array1 = [1, 2, 3]

array2 = [
    1
    2
    3
]

array3 = [1,2,3,]

###
FLOW CONTROL
###
if true == true
    console.log "we're ok"

if true == true then console.log "we're ok"

if 1 > 0 then console.log "ok" else console.log "not ok"

if not true then console.log "panic"

# "is" works like ===
if true is 1
    "type coercion fail!"

if true isnt true
    console.log "opposite day!"

# string interpolation
to_insert = "two"
full_string = "one #{to_insert} three"

###
LOOPS & COMPREHENSIONS
###
for name in ["joe", "roger", "jane"]
    console.log name

# if you need the index
for name, i in ["joe", "roger", "jane"]
    console.log i + ': ' + name

# can iterate on one line 
console.log name for name in ["joe", "roger", "jane"]

# can filter
console.log name for name in ["joe", "roger", "jane"] when name[0] is "j"

# can use comprehensions for iterating over properties in objects
num = 6
while num -= 1
    console.log num + " Brave Sir Robin ran away"

###
ARRAYS
###

# this will get [1, 2, 3, 4, 5]
console.log range = [1..5]

# and this will get [1, 2, 3, 4]
console.log range = [1...5]

# to print the first two,
firstTwo = ["one", "two", "three"][0..1]
console.log firstTwo

# replacing part of an array
numbers = [0..9]
numbers[3..5] = [-3, -4, -5]
console.log numbers

# can slice like this
output = "my string"[0..1]
console.log output

# checking to see if a value exists inside an array
words = ["rattled", "roudy", "rebbles", "ranks"]
console.log "Stop wagging me" if "ranks" in words

###
ALIASES AND THE EXISTENTIAL OPERATOR
###

# @ is used in palce of this.

# :: is an alias for the prototype (what does this mean?)

# null checks with ? - if variable were undefined, wouldn't log
variable = 1
console.log 'yes' if variable?

velocity = southern ? 40            # returns 40 cuz southern isn't defined

# can use this to access a property that may not exist
blackKnight.getLegs()?.kick()       # null check before accessing property
blackKnight.getLegs().kick?()       # to check if property is actually a function, and callable. 
# if doesn't exist or isn't callable, won't get called

########################################################################################################################
########################################################################################################################
###
COFFEESCRIPT CLASSES
###

# can instantiate classes with the 'new' operator
animal = new Animal

# classes and constructors--like __init__ in python
class Animal
    constructor: (name) ->
        @name = name

# by prefixing arguments with @, CoffeeScropt will automatically set arguments as instance properties in the constructor
# this also works on normal functions outside classes. This is equivalent to the above
class Animal
    constructor: (@name) ->

animal = new Animal("Parrot")
console.log("animal is a #{animal.name}")       # prints "animal is a Parrot"

###
INSTANCE PROPERTIES
###
class Animal
    price: 5

    sell: (customer) ->
        console.log "#{customer}, give me #{@price} shillings!"

animal = new Animal
animal.sell("joe")

###
INHERITANCE AND SUPER
###

# unless you over 
# this returns true:
class Animal
    constructor: (@name) ->

    alive: -> 
        false

class Parrot extends Animal
    constructor: ->
        super("Parrot")
    dead: ->
        not @alive()
     
parrot = new Parrot
console.log parrot.dead()

# lots more here...

########################################################################################################################
########################################################################################################################
###
COFFEESCRIPT IDIOMS
###

# Each - like forEach() in JS
myFunction = (arg) ->
    return arg + '!'

array = ['one', 'two', 'three', 'four']

console.log myFunction(item) for item in array

