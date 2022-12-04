const fs = require('fs');
const path = require('path');

const textInput = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf-8');
const formattedInput = textInput.split('\n');

const priorities = Object.fromEntries(
    ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    .split('')
    .map((itemType, index) => [itemType, index])
    .filter((([itemType,]) => itemType !== ''))
);

/** PART I */
const partOne = input => input.reduce((sum, bag) => {
    const itemsInBag = bag.split('');
    const [compartment1, compartment2] = [itemsInBag.slice(0, (itemsInBag.length - 1) / 2 + 1), itemsInBag.slice((itemsInBag.length - 1) / 2 + 1)];
    const commonsItems = compartment1.reduce((commons, item) => {
        if (compartment2.includes(item) && !commons.includes(item)) {
            return [...commons, item ];
        }
        return commons;
    }, []);
    return sum + commonsItems.reduce((commonsPrioritiesSum, item) => priorities[item] + commonsPrioritiesSum, 0);
}, 0);

console.log('---------- PART I ----------');
console.log(partOne(formattedInput));


const partTwo = input => {
    const elvesGroups = input.reduce((groups, bag, index) => {
        if (index % 3 === 0) {
            return [...groups, [bag.split('')]];
        }
        const currentGroup = groups.pop();
        currentGroup.push(bag.split(''));
        return [...groups, currentGroup];
    }, []);

    return elvesGroups.reduce((sumPriorities, [elf1, elf2, elf3]) => {
        const commonsItems = elf1.reduce((commons, item) => {
        if (elf2.includes(item) && elf3.includes(item) && !commons.includes(item)) {
            return [...commons, item ];
        }
        return commons;
    }, []);
    return sumPriorities + commonsItems.reduce((commonsPrioritiesSum, item) => priorities[item] + commonsPrioritiesSum, 0);
    }, 0);
}

console.log('---------- PART II ----------');
console.log(partTwo(formattedInput));