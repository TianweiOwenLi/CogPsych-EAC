
const double extend = 2.0, shrink = 0.5; // learnable with enough data

double leitner(List<int> time, List<int> rate, double hl) {
  switch (rate.last) {
    case 2: {
      return hl * extend;
    }

    case 0: {
      return hl * shrink;
    }

    default: {
      return hl * extend * shrink;
    }

  }
}