const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
let [stacksInputs, movesInputs] = textInput.split('\n\n').map((input) => input.split('\n'));
const nbColumns = stacksInputs.pop().replace(/ /g, '').split('').length;
const stacksInputsSanitized = stacksInputs.map(s => s.replace(/[\[\]]/g, '').split(/\s{0,3}\s/g));

const stacks = stacksInputsSanitized.reduceRight(
        (arr, inputs) => {
        inputs.forEach((value, stackIndex) => {
            if (value !== '') {
                arr[stackIndex].push(value);
            }
        });
        return arr;
    },
    Array.from({length: nbColumns}, (_) => [])
);

const moves = movesInputs.map(move => {
    const [,numberOfItems,,fromNumber,,toNumber] = move.split(' ').map(i => parseInt(i));
    return {
        numberOfItems,
        from: fromNumber - 1,
        to: toNumber - 1
    };
});


/** PART I */
console.log('---------- PART I ----------');
const partOne = (originalStacks, moves) => {
    let stacks = JSON.parse(JSON.stringify(originalStacks));
    moves.forEach(move => {
        for (let i = 0; i < move.numberOfItems; i++) {
            stacks[move.to].push(stacks[move.from].pop())
        }
    });

    return stacks.reduce((result, stack) => `${result}${stack.pop()}`, '');
};

console.log(partOne(stacks, moves));


/** PART II */
console.log('---------- PART II ----------');

const partTwo = (originalStacks, moves) => {
    let stacks = JSON.parse(JSON.stringify(originalStacks));
    moves.forEach(move => {
        const buffer = [];
        for (let i = 0; i < move.numberOfItems; i++) {
            buffer.push(stacks[move.from].pop())
        }
        stacks[move.to].push(...buffer.reverse())
    });

    return stacks.reduce((result, stack) => `${result}${stack.pop()}`, '');
};

console.log(partTwo(stacks, moves));
