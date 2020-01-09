//
print("JAVASCRIPT: Starting loadStoriesList");

var debug = 1;
var toClass = {}.toString;

function createStory(item, i) {
	var name = item["CFBundleTypeName"];
	var role = item["CFBundleTypeRole"];
	print("Looking at strings");
	print("name class " + toClass(name) + " length " + name.length());
	print("role class " + role.class + " length " + role.length());
}

for (var j = 0; j < 100; j++) {
  print("==== LOOP " + j + " =====");
  var itemDictPath = "/Applications/Xcode.app/Contents/Info.plist";
  var itemDict = NSDictionary.dictionaryWithContentsOfFile(itemDictPath);
  var itemList = itemDict["CFBundleDocumentTypes"];
  for (var i = 0; i < itemList.length; i++) {
	createStory(itemList[i], i);
  }
}

print("JAVASCRIPT: Done loadStoriesList");
