const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
const datastream = textInput.split('');

/** PART I */
console.log('---------- PART I ----------');
const partOne = (datastream, nbDistinctChar) => {
    let buffer = [];
    return datastream.findIndex(character => {
        buffer.push(character);
        if (buffer.length > nbDistinctChar) {
            buffer.splice(0, buffer.length - nbDistinctChar);
        }

        if (buffer.length !== nbDistinctChar) return false;

        return buffer.reduce((acc, char) => {
            if (acc.includes(char)) {
                return acc;
            }
            return [...acc, char];
        }).length === nbDistinctChar;
    }) + 1;
};
console.log(partOne(datastream, 4));


/** PART II */
console.log('---------- PART II ----------');
console.log(partOne(datastream, 14));
