import '../template/layer.dart';
import '../template/tile.dart';
import '../book/clear.dart';
import '../data.dart';

class InterfaceLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(Pref.appbar);
    list = [
      Tile.fromPref(Pref.fontSize, onPrefInput: (i) {
        Pref.fontSize.set(int.parse(i).clamp(0, 1000));
      }),
      Tile.fromPref(Pref.fontBold),
      Tile.fromPref(Pref.fontAlign),
      Tile.fromPref(Pref.clearAnimation, suffix: 'ms', onPrefInput: (i) {
        Pref.clearAnimation.set(int.parse(i).clamp(0, 10000));
      }),
      Tile.fromPref(Pref.preload, onPrefInput: (i) {
        Pref.preload.set(int.parse(i).clamp(16, 10000));
        current.value.resetLoadedText();
      }),
    ];
  }
}
