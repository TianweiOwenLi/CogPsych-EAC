
import 'dart:math';

num loss(List<int> time, List<int> rate, double hl) {
  assert(time.length == rate.length);
  int n = time.length;

  // recall-rate loss
  num recallRateLoss = 0.0;
  for (int i = 0; i < n; i++) {
    num recallEst = pow(0.5, time[i] / hl);
    recallRateLoss += pow((recallEst - rate[i] / 2.0), 2);
  }

  return recallRateLoss + 0.1 * pow(hl, 2); // L2 regularization
}

num gradient(List<int> time, List<int> rate, double hl) {
  num ret = 0.0;
  for (int i = 0; i < time.length; i++) {
    ret += 2 * (pow(0.5, (time[i] / hl)) - rate[i] / 2)
        * (pow(0.5, time[i] / hl) * log(0.5) * (- time[i] / hl));
  }
  // regularization
  return ret + 0.0001 * hl;
}

double hlr(List<int> time, List<int> rate, prevHL) {
  // initialize hl
  double hl = prevHL;
  double lr = 500;

  for (int t = 0; t < 100; t++) {
    // num lossValM = loss(time, rate, hl - 1);
    // num lossValP = loss(time, rate, hl + 1);
    // num grad = (lossValM - lossValP) / 2;
    num grad = gradient(time, rate, hl);
    print("grad: $grad");
    hl -= lr * grad;
    print("hl: $hl");
  }

  return hl;
}