import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class CursorLayer extends Layer {
  @override
  void construct() {
    String syllables = '';
    for (String point in Pref.syllables.value) {
      syllables = syllables + point;
    }

    action = Tile.fromPref(Pref.intensity, onPrefInput: (i) {
      Pref.intensity.set(int.parse(i).clamp(1, 10000));
    });
    list = [
      Tile.fromPref(Pref.cursorDelay, suffix: 'ms', onPrefInput: (i) {
        Pref.cursorDelay.set(int.parse(i).clamp(1, 10000));
      }),
      Tile.fromPref(Pref.exponential),
      Tile.fromPref(Pref.normalised),
      Tile.fromPref(Pref.cursorShift),
      Tile.fromListPref(Pref.syllables),
    ];
  }
}
