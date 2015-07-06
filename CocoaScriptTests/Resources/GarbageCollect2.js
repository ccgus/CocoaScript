

function createStory(j) {
  var role = NSString.stringWithString("CFBundleTypeRole");
  var ddict = NSMutableDictionary.dictionary();
  var dict = {};
  ddict["role"] = role;
  dict["role"] = ddict["role"];
  ddict["role"] = dict["role"];
  role = ddict["role"];
  print("role " + j + " length " + role.length);
}

for (var j = 0; j < 10000; j++) {
  //print("==== LOOP " + j + " =====");
  createStory(j);
}
