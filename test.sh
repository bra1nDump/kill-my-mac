# Define the function
# Function to check if two values are nearly equal within a given proximity
is_near() {
    local value1=$1
    local value2=$2
    local proximity=$3
    # Absolute difference
    local diff=$((value1 > value2 ? value1 - value2 : value2 - value1))

    # When no return is used, status code from the last command is used
    # test <expression> is the same as [ <expression> ]
    # when the test succeeds, 0 status code is returned from the command
    test $diff -le $proximity
}

# Example usage of the function
value1=100
value2=105
proximity=10

echo $(is_near $value1 $value2 $proximity)

if is_near $value1 $value2 $proximity; then
    echo "The values are near each other."
else
    echo "The values are not near each other."
fi