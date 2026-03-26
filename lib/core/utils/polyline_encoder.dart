import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

/// Encodes a list of LatLng into a Google Encoded Polyline (precision 5).
String encodePolyline(List<LatLng> points) {
  var output = StringBuffer();

  int plat = 0;
  int plng = 0;

  for (var point in points) {
    int lat = (point.latitude * 1e5).round();
    int lng = (point.longitude * 1e5).round();

    _encode(lat - plat, output);
    _encode(lng - plng, output);

    plat = lat;
    plng = lng;
  }

  return output.toString();
}

void _encode(int v, StringBuffer output) {
  v = v < 0 ? ~(v << 1) : v << 1;
  while (v >= 0x20) {
    output.writeCharCode((0x20 | (v & 0x1f)) + 63);
    v >>= 5;
  }
  output.writeCharCode(v + 63);
}
