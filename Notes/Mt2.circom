pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/switcher.circom";//takes input, organizes signals, and gives output
include "../node_modules/circomlib/circuits/poseidon.circom";//hash
include "../node_modules/circomlib/circuits/bitify.circom";//organizes in bits to hash in correct order

template Mkt2VerifierLevel() {
    signal input sibling;//value heeded to hash
    signal input low;//value of lower level
    signal input selector;//key to bits
    signal output root;//hash of tree

    component sw = Switcher();//initiate swittcher from lib
    component hash = Poseidon(2);//create hash

    sw.sel <== selector;//connect selector to connect low and sibling[i]
    sw.L <== low;//connects low input to the left of the switcher 
    sw.R <== sibling;//connects sibling to the right of the switcher

    log(44444444444);//can see the values of certain wires
    log(sw.outL);//output of switcher left
    log(sw.outR);output of switcher right

    hash.inputs[0] <== sw.outL;//connect hash to switcher left
    hash.inputs[1] <== sw.outR;//connect hash to switcher right, Posiedon has two input values

    root <== hash.out;//hash output is the root of the tree
}

template Mkt2Verifier(nLevels) {//creates verifier

    signal input key;//public
    signal input value;//secrete key
    signal input root;//root of the last level
    signal input siblings[nLevels];//array of siblings

    component n2b = Num2Bits(nLevels);//initiate component to 3 bits
    component levels[nLevels];//create array containing verifier levels

    component hashV = Poseidon(1);//to do a hash of one value

    hashV.inputs[0] <== value;//initial hash of secrete key to create first low input

    n2b.in <== key;//connect key recieved externally to num2bits template

    for (var i=nLevels-1; i>=0; i--) {//connecting the circuit from root down
        levels[i] = Mkt2VerifierLevel();//create circuit for current level
        levels[i].sibling <== siblings[i];//connecting sibling of verifier
        levels[i].selector <== n2b.out[i];//connect selecter to correct bit
        if (i==nLevels-1) {//if first level
            levels[i].low <== hashV.out;//if first level number to hash comes from secrete key
        } else {
            levels[i].low <== levels[i+1].root;//connect level to the low of current level
        }
    }

    root === levels[0].root;//final root
}