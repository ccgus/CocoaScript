framework("AppKit");
framework("CoreGraphics");

for (var n = 0; n < 3000; n++) {
    print(n);
    var path=NSBezierPath.bezierPath();
    path.moveToPoint(NSMakePoint(0,0));
    path.lineToPoint(NSMakePoint(10,10));
    path.lineToPoint(NSMakePoint(150,200));
    path.closePath();
}