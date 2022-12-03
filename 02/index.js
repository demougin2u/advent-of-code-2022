const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
const formattedInput = textInput.split('\n');

const SHAPES = {
    'A': {
        score: 1,
        defeatBy: 'B',
        myId: 'X'
    },
    'B': {
        score: 2,
        defeatBy: 'C',
        myId: 'Y'
    },
    'C': {
        score: 3,
        defeatBy: 'A',
        myId: 'Z'
    },
}

const INVERTED_SHAPE = Object.keys(SHAPES).reduce((inverted, shapeKey) => {
    inverted[SHAPES[shapeKey].myId] = {...SHAPES[shapeKey], myId: shapeKey};
    return inverted;
}, {});

const WIN_SCORE = 6;
const DRAW_SCORE = 3;
const LOOSE_SCORE = 0;


/** PART I */
const partOne = input => input.reduce((score, round) => {
    const [opponentStringShape, myStringShape] = round.split(' ');
    const myShape = INVERTED_SHAPE[myStringShape];
    score += myShape.score;
    if (opponentStringShape === myShape.myId) return score + DRAW_SCORE;
    if (opponentStringShape === myShape.defeatBy) return score + LOOSE_SCORE;
    return score + WIN_SCORE;
}, 0);

console.log('---------- PART I ----------');
console.log(partOne(formattedInput));



/**  PART II */
// X => Loose
// Y => Draw
// Z => Win

const partTwo = input => input.reduce((score, round) => {
    const [opponentStringShape, moveToDo] = round.split(' ');
    const opponentShape = SHAPES[opponentStringShape];
    let myShape;
    switch(moveToDo) {
        // X => Loose
        case 'X':
        myShape = Object.entries(SHAPES).find((([, shape]) => shape.defeatBy === opponentStringShape)).pop();
        score += LOOSE_SCORE;
        break;
        // Y => Draw
        case 'Y':
        myShape = opponentShape;
        score += DRAW_SCORE
        break;
        // Z => Win
        case 'Z':
        myShape = SHAPES[opponentShape.defeatBy];
        score += WIN_SCORE;
        break;
    }

    return score + myShape.score;
}, 0);

console.log('---------- PART II ----------');
console.log(partTwo(formattedInput));