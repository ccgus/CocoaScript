//
//  MemoryAllocation.js
//  UnitTests
//
//  Created by Logan Collins on 7/25/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

function main(iterations) {
    var array = [];
    for (var i=0; i<iterations; i++) {
        var dict = {}
        dict["string"] = "foobar";
        dict["integer"] = 100;
        dict["boolean"] = true;
        //dict{"date"} = NSDate.date();

        array[i] = dict;
    }
    
    var count = array.length;

    var result = null;
    if (count == iterations) {
        result = [true, null];
    }
    else {
        result = [false, "Number of iterations to created objects is inconsistent"];
    }
    return result;
}
