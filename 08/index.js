const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
const trees = textInput.split('\n').map(line => line.split('').map(tree => parseInt(tree)));
const width = trees[0].length;
const height = trees.length;

const isOnEdge = (x, y) => x % (width - 1) === 0 || y % (height - 1) === 0 ;

const isLineSmallerThan = (tree, x, y, deltaX, deltaY) => {
    const [neighboorX, neighboorY] = [deltaX + x, deltaY + y];
    if (trees[neighboorY][neighboorX] >= tree) return false;
    if (isOnEdge(neighboorX, neighboorY)) return true;
    return isLineSmallerThan(tree, neighboorX, neighboorY, deltaX, deltaY);
}

/** PART I */
console.log('---------- PART I ----------');
const partOne = (trees) => trees.reduce((nbOfTreeVisibles, treesLine, y) =>
    nbOfTreeVisibles + treesLine.reduce((nbOfTreeVisibleOnLine, tree, x) => {
        if (isOnEdge(x, y)
            || [[-1, 0], [1, 0], [0, -1], [0, 1]].some(([deltaX, deltaY]) => isLineSmallerThan(tree, x, y, deltaX, deltaY))
        ) {
            return nbOfTreeVisibleOnLine + 1;
        }

        return nbOfTreeVisibleOnLine;
    }, 0)
, 0);
console.log(partOne(trees));


/** PART II */
console.log('---------- PART II ----------');
const partTwo = () => '';
console.log(partTwo());
