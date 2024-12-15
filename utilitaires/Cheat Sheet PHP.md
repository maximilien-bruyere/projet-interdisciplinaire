
# PHP Cheatsheet

## Including PHP in a file
```
<?php
    // place PHP code here
?>
```

## Comments
```
// — Denotes comments that only span one line
# — Another way of producing single-line comments
/*...*/ — Everything between /* and */ is not executed, also works across several lines
```

## Basic Naming Conventions

```
$firstName = 'Mike'  # variables
function updateProduct() # function names
class ProductItem # class names
const ACCESS_KEY = '123abc'; # constants
```

## Basic Output

```
echo 'Hello PHP';

# Debug output
var_dump($some_var);
print_r($products);
```

## Variables

### Variable Declarations

```
$name = 'Joe';     # string
$isActive = false; # boolean
$number = 32;      # integer
$amount = 91.90;   # floating-point
```
### Pre-defined variables

* <code>$GLOBALS</code> — Used to access global variables from anywhere inside a PHP script
* <code>$_SERVER</code> — Contains information about the locations of headers, paths, and scripts
* <code>$_GET</code> — Can collect data that was sent in the URL or submitted in an HTML form
* <code>$_POST</code> — Used to gather data from an HTML form and to pass variables
* <code>$_REQUEST</code> — Also collects data after submitting an HTML form

### Variable Handling Functions

* <code>boolval</code> — Used to retrieve the boolean value of a variable
* <code>debug_zval_dump</code> — Outputs a string representation of an internal zend value
* <code>empty</code> — Checks whether a variable is empty or not
* <code>floatval</code> — Get the float value of a variable (doubleval is another possibility)
* <code>get_defined_vars</code> — Returns an array of all defined variables
* <code>get_resource_type</code> — Returns the resource type
* <code>gettype</code> — Retrieves the variable type
* <code>import_request_variables</code> — Import GET/POST/Cookie variables into the global scope
* <code>intval</code> — Find the integer value of a variable
* <code>is_array</code> — Checks whether a variable is an array
* <code>is_bool</code> — Finds out if a variable is a boolean
* <code>is_callable</code> — Verify whether you can call the contents of a variable as a function
* <code>is_countable</code> — Check whether the contents of a variable are countable
* <code>is_float</code> — Find out if the type of a variable is float, alternatives: is_double and is_real
* <code>is_int</code> — Check if the type of a variable is an integer, is_integer and is_long also works
* <code>is_iterable</code> — Verify that a variable’s content is an iterable value
* <code>is_null</code> — Checks whether a variable’s value is NULL
* <code>is_numeric</code> — Find out if a variable is a number or a numeric string
* <code>is_object</code> — Determines whether a variable is an object
* <code>is_resource</code> — Check if a variable is a resource
* <code>is_scalar</code> — Tests if a variable is a scalar
* <code>is_string</code> — Find out whether the type of a variable is a string
* <code>isset</code> — Determine if a variable has been set and is not NULL
* <code>print_r</code> — Provides human-readable information about a variable
* <code>serialize</code> — Generates a representation of a value that is storable
* <code>settype</code> — Sets a variable’s type
* <code>strval</code> — Retrieves the string value of a variable
* <code>unserialize</code> — Creates a PHP value from a stored representation
* <code>unset</code> — Unsets a variable
* <code>var_dump</code> — Dumps information about a variable
* <code>var_export</code> — Outputs or returns a string representation of a variable that can be parsed

### Defining Constants

```
define(name, value, case_sensitive_true_false);
```

#### Default PHP Constants

* <code>__LINE__</code> — Denotes the number of the current line in a file
* <code>__FILE__</code> — Is the full path and filename of the file
* <code>__DIR__</code> — The directory of the file
* <code>__FUNCTION__</code> — Name of the function
* <code>__CLASS__</code> — Class name, includes the namespace it was declared in
* <code>__TRAIT__</code> — The trait name, also includes the namespace
* <code>__METHOD__</code> —  The class method name
* <code>__NAMESPACE__</code> — Name of the current namespace

## PHP Operators

### Arithmetic Operators

* <code>+</code> — Addition
* <code>-</code> — Subtraction
* <code>*</code> — Multiplication
* <code>/</code> — Division
* <code>%</code> — Modulo (the remainder of value divided by another)
* <code>**</code> — Exponentiation

### Assignment Operators

* <code>+=</code> — a += b is the same as a = a + b
* <code>-=</code> — a -= b is the same as a = a – b
* <code>*=</code> — a *= b is the same as a = a * b
* <code>/=</code> — a /= b is the same as a = a / b
* <code>%=</code> — a %= b is the same as a = a % b

### Comparison Operators

* <code>==</code> — Equal
* <code>===</code> — Identical
* <code>!=</code> — Not equal
* <code><></code> — Not equal
* <code>!==</code> — Not identical
* <code><</code> — Less than
* <code>></code> — Greater than
* <code><=</code> — Less than or equal to
* <code>>=</code> — Greater than or equal to
* <code><=></code> — Less than, equal to, or greater than

### Logical Operators

* <code>and</code> — And
* <code>or</code> — Or
* <code>xor</code> — Exclusive or
* <code>!</code> — Not
* <code>&&</code> — And
* <code>||</code> — Or

### Bitwise Operators

* <code>&</code> — And
* <code>|</code> — Or (inclusive or)
* <code>^</code> — Xor (exclusive or)
* <code>~</code> — Not
* <code><<</code> — Shift left
* <code>>></code> — Shift right

### Error Control Operator

The @ sign can be used to prevent expressions from generating error messages.

### Execution Operator

PHP supports one execution operator, which is `` (backticks). PHP will attempt to execute the contents of the backticks as a shell command.

### Increment/Decrement Operators

* <code>++$v</code> — Increments a variable by one, then returns it
* <code>$v++</code> — Returns a variable, then increments it by one
* <code>--$v</code> — Decrements the variable by one, returns it afterward
* <code>$v--</code> — Returns the variable then decrements it by one

### String Operators

* <code>.</code> — Used to concatenate (mean combine) arguments
* <code>.=</code> — Used to append the argument on the right to the left-side argument

## PHP String Types

* Single quotes — This is the simplest way. Just wrap your text in ' markers and PHP will handle it as a string.
* Double quotes — As an alternative you can use ". When you do, it’s possible to use the escape characters below to display special characters.
* heredoc — Begin a string with <<< and an identifier, then put the string in a new line. Close it in another line by repeating the identifier. heredoc behaves like double-quoted strings.
* nowdoc — Is what heredoc is for double-quoted strings but for single quotes. It works the same way and eliminates the need for escape characters.

NOTE: Strings can contain variables, arrays, and objects.

### String Usage Examples

```
# String concatenation
echo 'Hello ' . $name;

# String escape characters \n new line  \t tab  \\ backslash
echo "Hello Joe\nHello Jimmy";

# String interpolation
echo "Hello $name";

# String length
echo strlen($name);

# Remove space(s) before and after
echo trim($text);

# Convert to lowercase / uppercase
echo strtolower($email);
echo strtoupper($name);

# Converts the first character to uppercase
echo ucfirst($name);  # 'Joe'

# Replace text c by text d in $text
echo str_replace('c', 'd', $text);

# String Contains (PHP 8)
echo str_contains($name, 'oe')  # true
```

### String Escape Characters

* <code>\n</code> — Linefeed
* <code>\r</code> — Carriage return
* <code>\t</code> — Horizontal tab
* <code>\v</code> — Vertical tab
* <code>\e</code> — Escape
* <code>\f</code> — Form feed
* <code>\\</code> — Backslash
* <code>\$</code> — Dollar sign
* <code>/'</code> — Single quote
* <code>\"</code> — Double quote
* <code>\[0-7]{1,3}</code> — Character in octal notation
* <code>\x[0-9A-Fa-f]{1,2}</code> — Character in hexadecimal notation
* <code>\u{[0-9A-Fa-f]+}</code> — String as UTF-8 representation

### PHP String Functions

* <code>addcslashes</code> — Returns a string with backslashes in front of specified characters
* <code>addslashes</code> — Returns a string with backslashes in front of characters that need to be escaped
* <code>bin2hex</code> — Converts a string of ASCII characters to hexadecimal values
* <code>chop</code> — Removes space or other characters from the right end of a string
* <code>chr</code> — Returns a character from a specified ASCII value
* <code>chunk_split</code> — Splits a string into a series of smaller chunks
* <code>convert_cyr_string</code> — Converts a string from a Cyrillic character set to another
* <code>convert_uudecode</code> — Decodes a uuencoded string
* <code>convert_uuencode</code> — Encodes a string using uuencode
* <code>count_chars</code> — Returns information about the characters in a string
* <code>crc32</code> — Calculates a 32-bit CRC for a string
* <code>crypt</code> — Returns a hashed string
* <code>echo or echo ''</code> — Outputs one or several strings
* <code>explode</code> — Breaks down a string into an array
* <code>fprintf</code> — Writes a formatted string to a specified output stream
* <code>get_html_translation_table</code> — Returns the translation table used by htmlspecialchars() and htmlentities()
* <code>hebrev</code> — Transforms Hebrew text to visual text
* <code>hebrevc</code> — Converts Hebrew text to visual text and implements HTML line breaks
* <code>hex2bin</code> — Translate hexadecimal values to ASCII characters
* <code>html_entity_decode</code> — Turns HTML entities to characters
* <code>htmlentities</code> — Converts characters to HTML entities
* <code>htmlspecialchars_decode</code> — Transforms special HTML entities to characters
* <code>htmlspecialchars</code> — Switches predefined characters to HTML entities
* <code>implode</code> — Retrieves a string from the elements of an array, same as join
* <code>lcfirst</code> — Changes a string’s first character to lowercase
* <code>levenshtein</code> — Calculates the Levenshtein distance between two strings
* <code>localeconv</code> — Returns information about numeric and monetary formatting for the locale
* <code>ltrim</code> — Removes spaces or other characters from the left side of a string
* <code>md5</code> — Calculates the MD5 hash of a string and returns it
* <code>md5_file</code> — Calculates the MD5 hash of a file
* <code>metaphone</code> — Provides the metaphone key of a string
* <code>money_format</code> — Returns a string as a currency string
* <code>nl_langinfo</code> — Gives specific locale information
* <code>nl2br</code> — Inserts HTML line breaks for each new line in a string
* <code>number_format</code> — Formats a number including grouped thousands
* <code>ord</code> — Returns the ASCII value of a string’s first character
* <code>parse_str</code> — Parses a string into variables
* <code>print</code> — Outputs one or several strings
* <code>printf</code> — Outputs a formatted string
* <code>quoted_printable_decode</code> — Converts a quoted-printable string to 8-bit binary
* <code>quoted_printable_encode</code> — Goes from 8-bit string to a quoted-printable string
* <code>quotemeta</code> — Returns a string with a backslash before metacharacters
* <code>rtrim</code> — Strips whitespace or other characters from the right side of a string
* <code>setlocale</code> — Sets locale information
* <code>sha1</code> — Calculates a string’s SHA-1 hash
* <code>sha1_file</code> — Does the same for a file
* <code>similar_text</code> — Determines the similarity between two strings
* <code>soundex</code> — Calculates the soundex key of a string
* <code>sprintf</code> — Returns a formatted string
* <code>sscanf</code> — Parses input from a string according to a specified format
* <code>str_getcsv</code> — Parses a CSV string into an array
* <code>str_ireplace</code> — Replaces specified characters in a string with specified replacements (case-insensitive)
* <code>str_pad</code> — Pads a string to a specified length
* <code>str_repeat</code> — Repeats a string a preset number of times
* <code>str_replace</code> — Replaces specified characters in a string (case-sensitive)
* <code>str_rot13</code> — Performs ROT13 encoding on a string
* <code>str_shuffle</code> — Randomly shuffles the characters in a string
* <code>str_split</code> — Splits strings into arrays
* <code>str_word_count</code> — Returns the number of words in a string
* <code>strcasecmp</code> — Case-insensitive comparison of two strings
* <code>strcmp</code> — Binary safe string comparison (case sensitive)
* <code>strcoll</code> — Compares two strings based on locale
* <code>strcspn</code> — Returns the number of characters found in a string before the occurrence of specified characters
* <code>strip_tags</code> — Removes HTML and PHP tags from a string
* <code>stripcslashes</code> — Opposite of addcslashes()
* <code>stripslashes</code> — Opposite of addslashes()
* <code>stripos</code> — Finds the position of the first occurrence of a substring within a string (case insensitive)
* <code>stristr</code> — Case-insensitive version of strstr()
* <code>strlen</code> — Returns the length of a string
* <code>strnatcasecmp</code> — Case-insensitive comparison of two strings using a “natural order” algorithm
* <code>strnatcmp</code> — Same as the aforementioned but case sensitive
* <code>strncasecmp</code> — String comparison of a defined number of characters (case insensitive)
* <code>strncmp</code> — Same as above but case-sensitive
* <code>strpbrk</code> — Searches a string for any number of characters
* <code>strpos</code> — Returns the position of the first occurrence of a substring in a string (case sensitive)
* <code>strrchr</code> — Finds the last occurrence of a string within another string
* <code>strrev</code> — Reverses a string
* <code>strripos</code> — Finds the position of the last occurrence of a string’s substring (case insensitive)
* <code>strrpos</code> — Same as strripos but case sensitive
* <code>strspn</code> — The number of characters in a string with only characters from a specified list
* <code>strstr</code> — Case-sensitive search for the first occurrence of a string inside another string
* <code>strtok</code> — Splits a string into smaller chunks
* <code>strtolower</code> — Converts all characters in a string to lowercase
* <code>strtoupper</code> — Same but for uppercase letters
* <code>strtr</code> — Translates certain characters in a string, alternative: strchr
* <code>substr</code> — Returns a specified part of a string
* <code>substr_compare</code> — Compares two strings from a specified start position up to a certain length, optionally case sensitive
* <code>substr_count</code> — Counts the number of times a substring occurs within a string
* <code>substr_replace</code> — Replaces a substring with something else
* <code>trim</code> — Removes space or other characters from both sides of a string
* <code>ucfirst</code> — Transforms the first character of a string to uppercase
* <code>ucwords</code> — Converts the first character of every word in a string to uppercase
* <code>vfprintf</code> — Writes a formatted string to a specified output stream
* <code>vprintf</code> — Outputs a formatted string
* <code>vsprintf</code> — Writes a formatted string to a variable
* <code>wordwrap</code> — Shortens a string to a given number of characters

## Numbers

```
$ Check if numeric
echo is_numeric('12.99'); # true

$ Round a number
echo(round(0.75));  # returns 1
echo(round(0.40));  # returns 0

# Output a random number
echo(rand(10, 100)); # 32
```

## Conditionals

```
# Ternary operator (true : false)
echo $isValid ? 'user valid' : 'user not valid';

# Null Coalesce Operator
echo $name ?? 'Joe';  # output 'Joe' if $name is null

# Null Coalesce Assignment
$name ??= 'Joe';

# Null Safe Operator (PHP 8) will return null if one ? is null
echo $user?->profile?->activate();

# Null Safe + Null Coalesce (if null will return 'No user profile')
echo $user?->profile?->activate() ?? 'Not applicable';

# Spaceship operator returns -1 0 1
$names = ['Mike', 'Paul', 'John']
usort($names, function($a, $b) {
    return $a <=> $b;
}
# ['John', 'Mike', 'Paul']

# Will return false when convert as boolean
false, 0, 0.0, null, unset, '0', '', []

# Conditionals
if ($condition == 20) {
    echo 'condition 20';
} elseif  ($condition == 10) {
    echo 'condition 10';
} else {
    echo 'anything except 20 and 10';
}

# Everything on one line
if ($isActive) return true;

# Switch Statement
switch (n) {
    case x:
        code to execute if n=x;
        break;
    case y:
        code to execute if n=y;
        break;
    case z:
        code to execute if n=z;
        break;
    // add more cases as needed
    default:
        code to execute if n is neither of the above;
}

# Match Expression (PHP 8)
$type = match($color) {
    'red' => 'danger',
    'yellow', 'orange' => 'warning',
    'green' => 'success',
    default => 'unknown'
};
```

## Looping

```
# for loop

for ($i = 0; $i < 20; $i++) {
    echo "i value = " . i;
}

# while loop

$number = 1;
while ($num < 10) {
    echo 'value : ' . $num;
    $num += 1;
}

# do while

$num = 1;
do {
    echo 'value : ' . $num;
    $num += 1;
} while ($num < 10);

# foreach with break / continue example

$values = ['one', 'two', 'three'];

foreach ($values as $val) {
    if ($val === 'two') {
        break; # exit loop
    } elseif ($val === 'three') {
        continue; # next loop iteration
    }
}
```

## PHP Arrays

### Declaring an array

```
$languages = array("C++", "Java", "PHP");
echo "What is your favorite Language? Is it " . $languages[0] . ", " . $languages[1] . " or " . $languages[2] . "?";
```

### Different Types of Arrays in PHP:

* Indexed arrays – Arrays that have a numeric index
* Associative arrays – Arrays where the keys are named
* Multidimensional arrays – Arrays that contain one or more other arrays

### Array Examples

```
# Array declaration
$names = ['Joe', 'James', 'Peter', 'Zeus'];

# Append to array
$names[] = 'Jessie';

# Array merge
$array3 = array_merge($array1, $array2);

# Array Concat with Spread Operator
$names = ['Joe', 'James', 'Peter'];
$people = ['John', ...$names]; // ['John', 'Joe', 'James', 'Peter'];

# Remove array entry
unset($names['Joe']);

# Array to string
echo implode(', ', $names) // output James, Peter

# String to Array
echo explode(',', $text);

# Direct access
echo $names[1] # output James

# Loop for each array entry
foreach($names as $name) {
   echo 'Hello ' . $name;
}

# Number of items in a Array
echo count($names);  

# Associative array:
$person = ['age' => 32, 'gender' => 'female'];

# Add to associative array:
$person['name'] = 'Amanda';

# Loop through associative array key => value:
foreach($names as $key => $value) {
   echo $key . ' : ' . $value;
}

# Check if a specific key exist
echo array_key_exist('age', $person);

# Return keys
echo array_keys($person); # ['age', 'gender']

# Return values
echo array_values($person) # [32, 'female']

# Array filter (return a filtered array)
$filteredPeople = array_filter($people, function ($person) {
    return $names->active;
})

# Array map (return transform array):
$onlyNames = array_map(function($person) {
    return [‘name’ => $person->name];
}, $people);

# Search associative array
$items = [
        ['id' => '100', 'name' => 'product 1'],
        ['id' => '200', 'name' => 'product 2'],
        ['id' => '300', 'name' => 'product 3'],
        ['id' => '400', 'name' => 'product 4'],
];

# search all value in the 'name' column
$found_key = array_search('product 4', array_column($items, 'name'));

```

### Array Functions

* <code>array_change_key_case</code> — Changes all keys in an array to uppercase or lowercase
* <code>array_chunk</code> — Splits an array into chunks
* <code>array_column</code> — Retrieves the values from a single column in an array
* <code>array_combine</code> — Merges the keys from one array and the values from another into a new array
* <code>array_count_values</code> — Counts all values in an array
* <code>array_diff</code> — Compares arrays, returns the difference (values only)
* <code>array_diff_assoc</code> — Compares arrays, returns the difference (values and keys)
* <code>array_diff_key</code> — Compares arrays, returns the difference (keys only)
* <code>array_diff_uassoc</code> — Compares arrays (keys and values) through a user callback function
* <code>array_diff_ukey</code> — Compares arrays (keys only) through a user callback function
* <code>array_fill</code> — Fills an array with values
* <code>array_fill_keys</code> — Fills an array with values, specifying keys
* <code>array_filter</code> — Filters the elements of an array via a callback function
* <code>array_flip</code> — Exchanges all keys in an array with their associated values
* <code>array_intersect</code> — Compare arrays and return their matches (values only)
* <code>array_intersect_assoc</code> — Compare arrays and return their matches (keys and values)
* <code>array_intersect_key</code> — Compare arrays and return their matches (keys only)
* <code>array_intersect_uassoc</code> — Compare arrays via a user-defined callback function (keys and values)
* <code>array_intersect_ukey</code> — Compare arrays via a user-defined callback function (keys only)
* <code>array_key_exists</code> — Checks if a specified key exists in an array, alternative: key_exists
* <code>array_keys</code> — Returns all keys or a subset of keys in an array
* <code>array_map</code> — Applies a callback to the elements of a given array
* <code>array_merge</code> — Merge one or several arrays
* <code>array_merge_recursive</code> — Merge one or more arrays recursively
* <code>array_multisort</code> — Sorts of multiple or multi-dimensional arrays
* <code>array_pad</code> — Inserts a specified number of items (with a specified value) into an array
* <code>array_pop</code> — Deletes an element from the end of an array
* <code>array_product</code> — Calculate the product of all values in an array
* <code>array_push</code> — Push one or several elements to the end of the array
* <code>array_rand</code> — Pick one or more random entries out of an array
* <code>array_reduce</code> — Reduce the array to a single string using a user-defined function
* <code>array_replace</code> — Replaces elements in the first array with values from following arrays
* <code>array_replace_recursive</code> — Recursively replaces elements from later arrays into the first array
* <code>array_reverse</code> — Returns an array in reverse order
* <code>array_search</code> — Searches the array for a given value and returns the first key if successful
* <code>array_shift</code> — Shifts an element from the beginning of an array
* <code>array_slice</code> — Extracts a slice of an array
* <code>array_splice</code> — Removes a portion of the array and replaces it
* <code>array_sum</code> — Calculate the sum of the values in an array
* <code>array_udiff</code> — Compare arrays and return the difference using a user function (values only)
* <code>array_udiff_assoc</code> — Compare arrays and return the difference using default and a user function (keys and values)
* <code>array_udiff_uassoc</code> — Compare arrays and return the difference using two user functions (values and keys)
* <code>array_uintersect</code> — Compare arrays and return the matches via user function (values only)
* <code>array_uintersect_assoc</code> — Compare arrays and return the matches via a default user function (keys and values)
* <code>array_uintersect_uassoc</code> — Compare arrays and return the matches via two user functions (keys and values)
* <code>array_unique</code> — Removes duplicate values from an array
* <code>array_unshift</code> — Adds one or more elements to the beginning of an array
* <code>array_values</code> — Returns all values of an array
* <code>array_walk</code> — Applies a user function to every element in an array
* <code>array_walk_recursive</code> — Recursively applies a user function to every element of an array
* <code>arsort</code> — Sorts an associative array in descending order according to the value
* <code>asort</code> — Sorts an associative array in ascending order according to the value
* <code>compact</code> — Create an array containing variables and their values
* <code>count</code> — Count all elements in an array, alternatively use sizeof
* <code>current</code> — Returns the current element in an array, an alternative is pos
* <code>each</code> — Return the current key and value pair from an array
* <code>end</code> — Set the internal pointer to the last element of an array
* <code>extract</code> — Import variables from an array into the current symbol table
* <code>in_array</code> — Checks if a value exists in an array
* <code>key</code> — Fetches a key from an array
* <code>krsort</code> — Sorts an associative array by key in reverse order
* <code>ksort</code> — Sorts an associative array by key
* <code>list</code> — Assigns variables as if they were an array
* <code>natcasesort</code> — Sorts an array using a “natural order” algorithm independent of case
* <code>natsort</code> — Sorts an array using a “natural order” algorithm
* <code>next</code> — Advance the internal pointer of an array
* <code>prev</code> — Move the internal array pointer backward
* <code>range</code> — Creates an array from a range of elements
* <code>reset</code> — Set the internal array pointer to its first element
* <code>rsort</code> — Sort an array in reverse order
* <code>shuffle</code> — Shuffle an array
* <code>sort</code> — Sorts an indexed array in ascending order
* <code>uasort</code> — Sorts an array with a user-defined comparison function
* <code>uksort</code> — Arrange an array by keys using a user-defined comparison function
* <code>usort</code> — Categorize an array by values using a comparison function defined by the user

## Function Examples

```
# Function declaration
function name($firstName, $lastName = 'defaultvalue') {
    return "$firstName $lastName"
}

# Function call
name('John', 'Smith');

# Function call with named parameters (PHP 8)
name(firstName: 'John', lastName: 'Smith'); # order can change

# Function variables params
function name(...$params) {
    return $params[0] . “ “ . params[1];
}

# Closure function
Route::get('/', function () {
     return view('welcome');
});

# Arrow functions
Route::get('/', fn () => view('welcome');
```

## Files

```
# Open a file to read
$file = fopen("foo.txt", "r");

# Output lines until EOF is reached
while(! feof($file)) {
  $line = fgets($file);
  echo $line. "<br>";
}

fclose($file);

# File write
$file = fopen('test.csv', 'a');
$array = ['name' => 'Mike', 'age' => 45];

# Write key name as csv header
fputcsv($file, array_keys($array[0]));

# Write lines (format as csv)
foreach ($array as $row) {
    fputcsv($file, $row);
}

fclose($file);
```

## Errors

### Error Examples

```
# Throw an error
if (someCondition) {
    throw new Exception('error');
}

# Catch the Error
try {
  $obj->check($data);

} catch (Exception $e) {
    echo $e->getMessage();
}
```

### Error Functions

* <code>debug_backtrace</code> — Used to generate a backtrace
* <code>debug_print_backtrace</code> — Prints a backtrace
* <code>error_get_last</code> — Gets the last error that occurred
* <code>error_log</code> — Sends an error message to the web server’s log, a file or a mail account
* <code>error_reporting</code> — Specifies which PHP errors are reported
* <code>restore_error_handler</code> — Reverts to the previous error handler function
* <code>restore_exception_handler</code> — Goes back to the previous exception handler
* <code>set_error_handler</code> — Sets a user-defined function to handle script errors
* <code>set_exception_handler</code> — Sets an exception handler function defined by the user
* <code>trigger_error</code> — Generates a user-level error message, you can also use <code>user_error()</code>

### Error Constants

* <code>E_ERROR</code> — Fatal run-time errors that cause the halting of the script and can’t be recovered from
* <code>E_WARNING</code> — Non-fatal run-time errors, execution of the script continues
* <code>E_PARSE</code> — Compile-time parse errors, should only be generated by the parser
* <code>E_NOTICE</code> — Run-time notices that indicate a possible error
* <code>E_CORE_ERROR</code> — Fatal errors at PHP initialization, like an <code>E_ERROR</code> in PHP core
* <code>E_CORE_WARNING</code> — Non-fatal errors at PHP startup, similar to <code>E_WARNING</code> but in PHP core
* <code>E_COMPILE_ERROR </code>— Fatal compile-time errors generated by the Zend Scripting Engine
* <code>E_COMPILE_WARNING</code> — Non-fatal compile-time errors by the Zend Scripting Engine
* <code>E_USER_ERROR</code> — Fatal user-generated error, set by the programmer using <code>trigger_error()</code>
* <code>E_USER_WARNING</code> — Non-fatal user-generated warning
* <code>E_USER_NOTICE</code> — User-generated notice by <code>trigger_error()</code>
* <code>E_STRICT</code> — Suggestions by PHP to improve your code (needs to be enabled)
* <code>E_RECOVERABLE_ERROR</code> — Catchable fatal error caught by a user-defined handle
* <code>E_DEPRECATED</code> — Enable this to receive warnings about a code which is not future-proof
* <code>E_USER_DEPRECATED</code> — User-generated warning for deprecated code
* <code>E_ALL</code> — All errors and warnings except <code>E_STRICT</code>

## OOP (Object Oriented Programming)

```
# Basic class declaration
class Person {
  # ...
}

# object instantiation
$user = new User

# Class properties and constructor
class User {

   protected $userName;
   protected $userId;

   public function __construct($userName, $userId) {
        $this->userName = $firstName;
        $this->userId = $userId
   }

# Constructor Property Promotion (PHP 8)
class User {

    public function __construct(protected $userName, protected $userId) {
      # ...
    }

# Static constructor
public static function create(...$params) {
    return new self($params)
}
$user = User::create(‘Joe Smith’, ‘jsmith1982’);

# Class inheritance
class SuperUser extends User {

    public function username() {
        parent::username();
        echo 'Override method';  
    }
}

# Static Method
class HelloWorld {
  public static function hello() {
    echo "Hello World!";
  }
}

# Call static method
HelloWorld::hello();

# Static method internal call
class HelloWorld {
  public static function hello() {
    echo "Hello World!";
  }

  public function __construct() {
    self::hello();
  }
}
new HelloWorld();

# Interfaces
interface Animal {
  public function makeSound();
}

class Dog implements Animal {
  public function makeSound() {
    echo "ruff!!!";
  }
}
$animal = new Dog();
$animal->makeSound();

# Trait (mix-in)
trait HelloWorld {
    public function sayHello() {
        echo 'Hello World!';
    }
}

class Greetings {
    use HelloWorld;
}

$object = new Greetings();
$object->sayHello();
```

## PHP HTTP Related Functionality

PHP has the ability to manipulate data sent to the browser from the webserver.

### HTTP Functions

* <code>header</code> — Sends a raw HTTP header to the browser
* <code>headers_list</code> — A list of response headers ready to send (or already sent)
* <code>headers_sent</code> — Checks if and where the HTTP headers have been sent
* <code>setcookie</code> — Defines a cookie to be sent along with the rest of the HTTP headers
* <code>setrawcookie</code> — Defines a cookie (without URL encoding) to be sent along

## MySQL

Many platforms that are based on PHP work with a MySQL database in the background. 

### MySQL Functions

* <code>mysqli_affected_rows</code> — The number of affected rows in the previous MySQL operation
* <code>mysqli_autocommit</code> — Turn auto-committing database modifications on or off
* <code>mysqli_change_user</code> — Changes the user of the specified database connection
* <code>mysqli_character_set_name</code> — The default character set for the database connection
* <code>mysqli_close</code> — Closes an open database connection
* <code>mysqli_commit</code> — Commits the current transaction
* <code>mysqli_connect_errno</code> — The error code from the last connection error
* <code>mysqli_connect_error</code> — The error description from the last connection error
* <code>mysqli_connect</code> — Opens a new connection to the MySQL server
* <code>mysqli_data_seek</code> — Moves the result pointer to an arbitrary row in the result set
* <code>mysqli_debug</code> — Performs debugging operations
* <code>mysqli_dump_debug_info</code> — Dumps debugging information into a log
* <code>mysqli_errno</code> — The last error code for the most recent function call
* <code>mysqli_error_list</code> — A list of errors for the most recent function call
* <code>mysqli_error</code> — The last error description for the most recent function call
* <code>mysqli_fetch_all</code> — Fetches all result rows as an array
* <code>mysqli_fetch_array</code> — Fetches a result row as an associative, a numeric array, or both
* <code>mysqli_fetch_assoc</code> — Fetches a result row as an associative array
* <code>mysqli_fetch_field_direct</code> — Metadata for a single field as an object
* <code>mysqli_fetch_field</code> — The next field in the result set as an object
* <code>mysqli_fetch_fields</code> — An array of objects that represent the fields in a result set
* <code>mysqli_fetch_lengths</code> — The lengths of the columns of the current row in the result set
* <code>mysqli_fetch_object</code> — The current row of a result set as an object
* <code>mysqli_fetch_row</code> — Fetches one row from a result set and returns it as an enumerated array
* <code>mysqli_field_count</code> — The number of columns for the most recent query
* <code>mysqli_field_seek</code> — Sets the field cursor to the given field offset
* <code>mysqli_field_tell</code> — The position of the field cursor
* <code>mysqli_free_result</code> — Frees the memory associated with a result
* <code>mysqli_get_charset</code> — A character set object
* <code>mysqli_get_client_info</code> — The MySQL client library version
* <code>mysqli_get_client_stats</code> — Returns client per-process statistics
* <code>mysqli_get_client_version</code> — The MySQL client library version as an integer
* <code>mysqli_get_connection_stats</code> — Statistics about the client connection
* <code>mysqli_get_host_info</code> — The MySQL server hostname and the connection type
* <code>mysqli_get_proto_info</code> — The MySQL protocol version
* <code>mysqli_get_server_info</code> — Returns the MySQL server version
* <code>mysqli_get_server_version</code> — The MySQL server version as an integer
* <code>mysqli_info</code> — Returns information about the most recently executed query
* <code>mysqli_init</code> — Initializes MySQLi and returns a resource for use with mysqli_real_connect()
* <code>mysqli_insert_id</code> — Returns the auto-generated ID used in the last query
* <code>mysqli_kill</code> — Asks the server to kill a MySQL thread
* <code>mysqli_more_results</code> — Checks if there are more results from a multi-query
* <code>mysqli_multi_query</code> — Performs one or more queries on the database
* <code>mysqli_next_result</code> — Prepares the next result set from mysqli_multi_query()
* <code>mysqli_num_fields</code> — The number of fields in a result set
* <code>mysqli_num_rows</code> — The number of rows in a result set
* <code>mysqli_options</code> — Sets extra connect options and affect behavior for a connection
* <code>mysqli_ping</code> — Pings a server connection or tries to reconnect if it has gone down
* <code>mysqli_prepare</code> — Prepares an SQL statement for execution
* <code>mysqli_query</code> — Performs a query against the database
* <code>mysqli_real_connect</code> — Opens a new connection to the MySQL server
* <code>mysqli_real_escape_string</code> — Escapes special characters in a string for use in an SQL statement
* <code>mysqli_real_query</code> — Executes an SQL query
* <code>mysqli_reap_async_query</code> — Returns the result from async query
* <code>mysqli_refresh</code> — Refreshes tables or caches or resets the replication server information
* <code>mysqli_rollback</code> — Rolls back the current transaction for the database
* <code>mysqli_select_db</code> — Changes the default database for the connection
* <code>mysqli_set_charset</code> — Sets the default client character set
* <code>mysqli_set_local_infile_default</code> — Unsets a user-defined handler for the LOAD LOCAL INFILE command
* <code>mysqli_set_local_infile_handler</code> — Sets a callback function for the LOAD DATA LOCAL INFILE command
* <code>mysqli_sqlstate</code> — Returns the SQLSTATE error code for the last MySQL operation
* <code>mysqli_ssl_set</code> — Establishes secure connections using SSL
* <code>mysqli_stat</code> — The current system status
* <code>mysqli_stmt_init</code> — Initializes a statement and returns an object for use with mysqli_stmt_prepare()
* <code>mysqli_store_result</code> — Transfers a result set from the last query
* <code>mysqli_thread_id</code> — The thread ID for the current connection
* <code>mysqli_thread_safe</code> — Returns if the client library is compiled as thread-safe
* <code>mysqli_use_result</code> — Initiates the retrieval of a result set from the last query executed using the mysqli_real_query()
* <code>mysqli_warning_count</code> — The number of warnings from the last query in the connection

## Date and Time

PHP has a number of date/time related functions.

### Date/Time Functions

* <code>checkdate</code> — Checks the validity of a Gregorian date
* <code>date_add</code> — Adds a number of days, months, years, hours, minutes and seconds to a date object
* <code>date_create_from_format</code> — Returns a formatted DateTime object
* <code>date_create</code> — Creates a new DateTime object
* <code>date_date_set</code> — Sets a new date
* <code>date_default_timezone_get</code> — Returns the default timezone used by all functions
* <code>date_default_timezone_set</code> — Sets the default timezone
* <code>date_diff</code> — Calculates the difference between two dates
* <code>date_format</code> — Returns a date formatted according to a specific format
* <code>date_get_last_errors</code> — Returns warnings or errors found in a date string
* <code>date_interval_create_from_date_string</code> — Sets up a DateInterval from relative parts of a string
* <code>date_interval_format</code> — Formats an interval
* <code>date_isodate_set</code> — Sets a date according to ISO 8601 standards
* <code>date_modify</code> — Modifies the timestamp
* <code>date_offset_get</code> — Returns the offset of the timezone
* <code>date_parse_from_format</code> — Returns an array with detailed information about a specified date, according to a specified format
* <code>date_parse</code> — Returns an array with detailed information about a specified date
* <code>date_sub</code> — Subtracts days, months, years, hours, minutes and seconds from a date
* <code>date_sun_info</code> — Returns an array containing information about sunset/sunrise and twilight begin/end for a specified day and location
* <code>date_sunrise</code> — The sunrise time for a specified day and location
* <code>date_sunset</code> — The sunset time for a specified day and location
* <code>date_time_set</code> — Sets the time
* <code>date_timestamp_get</code> — Returns the Unix timestamp
* <code>date_timestamp_set</code> — Sets the date and time based on a Unix timestamp
* <code>date_timezone_get</code> — Returns the time zone of a given DateTime object
* <code>date_timezone_set</code> — Sets the time zone for a DateTime object
* <code>date</code> — Formats a local date and time
* <code>getdate</code> — Date/time information of a timestamp or the current local date/time
* <code>gettimeofday</code> — The current time
* <code>gmdate</code> — Formats a GMT/UTC date and time
* <code>gmmktime</code> — The Unix timestamp for a GMT date
* <code>gmstrftime</code> — Formats a GMT/UTC date and time according to locale settings
* <code>idate</code> — Formats a local time/date as an integer
* <code>localtime</code> — The local time
* <code>microtime</code> — The current Unix timestamp with microseconds
* <code>mktime</code> — The Unix timestamp for a date
* <code>strftime</code> — Formats a local time and/or date according to locale settings
* <code>strptime</code> — Parses a time/date generated with strftime</code>
* <code>strtotime</code> — Transforms an English textual DateTime into a Unix timestamp
* <code>time</code> — The current time as a Unix timestamp
* <code>timezone_abbreviations_list</code> — Returns an array containing dst, offset, and the timezone name
* <code>timezone_identifiers_list</code> — An indexed array with all timezone identifiers
* <code>timezone_location_get</code> — Location information for a specified timezone
* <code>timezone_name_from_abbr</code> — Returns the timezone name from an abbreviation
* <code>timezone_name_get</code> — The name of the timezone
* <code>timezone_offset_get</code> — The timezone offset from GMT
* <code>timezone_open</code> — Creates a new DateTimeZone object
* <code>timezone_transitions_get</code> — Returns all transitions for the timezone
* <code>timezone_version_get</code> — Returns the version of the timezonedb

### Date and Time Formatting

* <code>d</code> — 01 to 31
* <code>j</code> — 1 to 31
* <code>D</code> — Mon through Sun
* <code>l</code> — Sunday through Saturday
* <code>N</code> — 1 (for Mon) through 7 (for Sat)
* <code>w</code> — 0 (for Sun) through 6 (for Sat)
* <code>m</code> — Months, 01 through 12
* <code>n</code> — Months, 1 through 12
* <code>F</code> — January through December
* <code>M</code> — Jan through Dec
* <code>Y</code> — Four digits year (e.g. 2018)
* <code>y</code> — Two digits year (e.g. 18)
* <code>L</code> — Defines whether it’s a leap year (1 or 0)
* <code>a</code> — am and pm
* <code>A</code> — AM and PM
* <code>g</code> — Hours 1 through 12
* <code>h</code> — Hours 01 through 12
* <code>G</code> — Hours 0 through 23
* <code>H</code> — Hours 00 through 23
* <code>i</code> — Minutes 00 to 59
* <code>s</code> — Seconds 00 to 59

## Regular Expressions

### Syntax

```
$expr = "/pattern/i";
```

### RegEx Functions

* <code>preg_match</code> - Returns 1 if the pattern was found in the string and 0 if not
* <code>preg_match_all</code> - Returns the number of times the pattern was found in the string, which may also be 0
* <code>preg_replace</code> - Returns a new string where matched patterns have been replaced with another string

### RegEx Modifiers

* <code>i</code> - Performs a case-insensitive search
* <code>m</code> - Performs a multiline search (patterns that search for the beginning or end of a string will match the beginning or end of each line)
* <code>u</code> - Enables correct matching of UTF-8 encoded patterns

### RegEx Patterns

* <code>[abc]</code> – Find one character from the options between the brackets
* <code>[^abc]</code> – Find any character NOT between the brackets
* <code>[0-9]</code> – Find one character from the range 0 to 9

### Metacharacters

* <code>|</code> - Find a match for any one of the patterns separated by | as in: cat|dog|fish
* <code>.</code> - Find just one instance of any character
* <code>^</code> - Finds a match as the beginning of a string as in: ^Hello
* <code>$</code> - Finds a match at the end of the string as in: World$
* <code>\d</code> - Find a digit
* <code>\s</code> - Find a whitespace character
* <code>\b</code> - Find a match at the beginning of a word like this: \bWORD, or at the end of a word like this: WORD\b
* <code>\uxxxx</code> - Find the Unicode character specified by the hexadecimal number xxxx

### Quantifiers

* <code>n+</code> - Matches any string that contains at least one n
* <code>n*</code> - Matches any string that contains zero or more occurrences of n
* <code>n?</code> - Matches any string that contains zero or one occurrences of n
* <code>n{x}</code> - Matches any string that contains a sequence of X n’s
* <code>n{x,y}</code> - Matches any string that contains a sequence of X to Y n’s
* <code>n{x,}</code> - Matches any string that contains a sequence of at least X n’s

### Grouping

You can use parentheses ( ) to apply quantifiers to entire patterns. They can also be used to select parts of the pattern to be used as a match.

```
$str = "Apples and bananas.";
$pattern = "/ba(na){2}/i";
echo preg_match($pattern, $str); // Outputs 1
```

## PHP Filters

Filters are used to validate and filter data that is coming from insecure sources.

### Functions

* <code>filter_has_var</code> — Checks if a variable of the specified type exists
* <code>filter_id</code> — Returns the ID belonging to a named filter
* <code>filter_input</code> — Retrieves a specified external variable by name and optionally filters it
* <code>filter_input_array</code> — Pulls external variables and optionally filters them
* <code>filter_list</code> — Returns a list of all supported filters
* <code>filter_var_array</code> — Gets multiple variables and optionally filters them
* <code>filter_var</code> — Filters a variable with a specified filter

### Constants

* <code>FILTER_VALIDATE_BOOLEAN</code> — Validates a boolean
* <code>FILTER_VALIDATE_EMAIL</code> — Certifies an e-mail address
* <code>FILTER_VALIDATE_FLOAT</code> — Confirms a float
* <code>FILTER_VALIDATE_INT</code> — Verifies an integer
* <code>FILTER_VALIDATE_IP</code> — Validates an IP address
* <code>FILTER_VALIDATE_REGEXP</code> — Confirms a regular expression
* <code>FILTER_VALIDATE_URL</code> — Validates a URL
* <code>FILTER_SANITIZE_EMAIL</code> — Removes all illegal characters from an e-mail address
* <code>FILTER_SANITIZE_ENCODED</code> — Removes/Encodes special characters
* <code>FILTER_SANITIZE_MAGIC_QUOTES</code> — Applies addslashes()
* <code>FILTER_SANITIZE_NUMBER_FLOAT</code> — Removes all characters, except digits, +- and .,eE
* <code>FILTER_SANITIZE_NUMBER_INT</code> — Gets rid of all characters except digits and + –
* <code>FILTER_SANITIZE_SPECIAL_CHARS</code> — Removes special characters
* <code>FILTER_SANITIZE_FULL_SPECIAL_CHARS</code> — Converts special characters to HTML entities
* <code>FILTER_SANITIZE_STRING</code> — Removes tags/special characters from a string, alternative: <code>FILTER_SANITIZE_STRIPPED</code>
* <code>FILTER_SANITIZE_URL</code> — Rids all illegal characters from a URL
* <code>FILTER_UNSAFE_RAW</code> —Do nothing, optionally strip/encode special characters
* <code>FILTER_CALLBACK</code> — Call a user-defined function to filter data
