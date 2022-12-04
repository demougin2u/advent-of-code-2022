const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
const formattedInput = textInput.split('\n');


/** PART I */
const partOne = assignmentPairs => assignmentPairs.reduce((nbFullyContain, assignmentPair) => {
    const [elf1, elf2] = assignmentPair.split(',').map(elf => elf.split('-').map(val => parseInt(val)))
    const [min, max] = [Math.min(elf1[0], elf2[0]), Math.max(elf1[1], elf2[1])];
    if ((elf1[0] === min && elf1[1] === max) || (elf2[0] === min && elf2[1] === max)) {
        return nbFullyContain + 1;
    }

    return nbFullyContain;
}, 0);

console.log('---------- PART I ----------');
console.log(partOne(formattedInput));

const partTwo = assignmentPairs => assignmentPairs.reduce((nbFullyContain, assignmentPair) => {
    const [elf1, elf2] = assignmentPair.split(',').map(elf => elf.split('-').map(val => parseInt(val)))
    if ((elf1[1] >= elf2[0] && elf1[1] <= elf2[1]) || (elf2[1] >= elf1[0] && elf2[1] <= elf1[1])) {
        return nbFullyContain + 1;
    }

    return nbFullyContain;
}, 0);

console.log('---------- PART II ----------');
console.log(partTwo(formattedInput));
