import 'dart:math';

String getRandomErrorEmoji([int seed]) {
  var errorSigns = ["💢", "📛", "‼️", "🆘", "⚠️", "👹", "👀", "💥", "🔥", "⛈"];
  return errorSigns[Random(seed).nextInt(errorSigns.length)];
}
