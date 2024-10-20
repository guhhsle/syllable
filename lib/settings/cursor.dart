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
      Pref.intensity.set(int.parse(i).clamp(0, double.infinity).toInt());
    });
    list = [
      Tile.fromPref(Pref.exponential),
      Tile.fromPref(Pref.cursorShift),
      Tile.fromListPref(Pref.syllables),
    ];
  }
}
