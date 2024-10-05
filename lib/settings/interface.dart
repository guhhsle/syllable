import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class InterfaceLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(Pref.appbar);
    list = [
      Tile.fromPref(Pref.animations),
      Tile.fromPref(Pref.fontSize, onPrefInput: (i) {
        Pref.fontSize.set(int.parse(i).clamp(0, double.infinity));
      }),
      Tile.fromPref(Pref.fontBold),
      Tile.fromPref(Pref.fontAlign),
    ];
  }
}
