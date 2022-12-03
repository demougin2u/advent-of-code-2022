const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
const formattedInput = textInput.split('\n');


const getElvesCalories = input => input.reduce(
        (acc, value) => {
            if (value === '') {
                acc.push(0)
                return acc
            }

            const currentElfCalories = acc.pop()
            acc.push(currentElfCalories + parseInt(value))
            return acc
        }, [0]
    );

/** PART I */
const partOne = input =>
     Math.max(...getElvesCalories(input));

console.log('---------- PART I ----------');
console.log(partOne(formattedInput));



/**  PART II */
const partTwo = input => getElvesCalories(input).reduce((topThree, currentCalorie) => {
        const min = Math.min(...topThree);

        if (currentCalorie > min) topThree.splice(topThree.indexOf(min), 1, currentCalorie);

        return topThree;
    }, [0, 0, 0])
    .reduce((sum, value) => sum + value);

console.log('---------- PART II ----------');
console.log(partTwo(formattedInput));