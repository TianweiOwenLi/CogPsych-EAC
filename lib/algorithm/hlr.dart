
import 'dart:math';

num gradient(List<int> time, List<int> rate, double hl) {
  num ret = 0.0;

  for (int i = 0; i < time.length; i++) {
    double recallPercent = 0.5; // default
    if (rate[i] == 2) recallPercent = 0.7;
    if (rate[i] == 0) recallPercent = 0.0;

    // prevents unwanted negative feedback
    // due to clustered study sessions
    if (time[i] < hl && rate[i] == 2) continue;

    // Loss function. See documentations for derivation.
    ret += 2 * (pow(0.5, (time[i] / hl)) - recallPercent / 2)
        * (pow(0.5, time[i] / hl) * log(0.5) * (- time[i] / hl));
  }
  return ret;
}

double hlr(List<int> time, List<int> rate, prevHL) {
  // initialize hl
  double hl = prevHL;
  double lr = 50;

  // gradient descent
  for (int t = 0; t < 10000; t++) {
    num grad = gradient(time, rate, hl);
    hl -= lr * grad;
    if (grad.abs() <= 0.0000001) {
      break;
    }
  }

  return hl;
}