package com.dfrobot.angelo.blunobasicdemo;

/**
 * Created by Jerry Liu on 2018-03-05.
 */

class RandomForestClassifier {
    public static int predict_0(double[] features) {
        int[] classes = new int[4];

        if (features[79] <= 0.0102784633636) {
            classes[0] = 2;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 0;
        } else {
            if (features[2] <= -56.6107139587) {
                classes[0] = 0;
                classes[1] = 0;
                classes[2] = 1;
                classes[3] = 0;
            } else {
                classes[0] = 0;
                classes[1] = 0;
                classes[2] = 0;
                classes[3] = 1;
            }
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_1(double[] features) {
        int[] classes = new int[4];

        if (features[123] <= 55.5) {
            if (features[45] <= 991.5) {
                classes[0] = 0;
                classes[1] = 1;
                classes[2] = 0;
                classes[3] = 0;
            } else {
                classes[0] = 1;
                classes[1] = 0;
                classes[2] = 0;
                classes[3] = 0;
            }
        } else {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 2;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_2(double[] features) {
        int[] classes = new int[4];

        if (features[153] <= 87.0) {
            if (features[85] <= 78.5) {
                classes[0] = 0;
                classes[1] = 0;
                classes[2] = 1;
                classes[3] = 0;
            } else {
                classes[0] = 0;
                classes[1] = 0;
                classes[2] = 0;
                classes[3] = 1;
            }
        } else {
            classes[0] = 0;
            classes[1] = 2;
            classes[2] = 0;
            classes[3] = 0;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_3(double[] features) {
        int[] classes = new int[4];

        if (features[4] <= 120.664993286) {
            if (features[87] <= 98.0) {
                classes[0] = 0;
                classes[1] = 0;
                classes[2] = 0;
                classes[3] = 1;
            } else {
                classes[0] = 0;
                classes[1] = 1;
                classes[2] = 0;
                classes[3] = 0;
            }
        } else {
            classes[0] = 2;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 0;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_4(double[] features) {
        int[] classes = new int[4];

        if (features[75] <= 6.15837287903) {
            classes[0] = 0;
            classes[1] = 2;
            classes[2] = 0;
            classes[3] = 0;
        } else {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 2;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_5(double[] features) {
        int[] classes = new int[4];

        if (features[21] <= 1.15791290696e+13) {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 2;
        } else {
            if (features[104] <= 1.04548848894e+14) {
                classes[0] = 0;
                classes[1] = 0;
                classes[2] = 1;
                classes[3] = 0;
            } else {
                classes[0] = 0;
                classes[1] = 1;
                classes[2] = 0;
                classes[3] = 0;
            }
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_6(double[] features) {
        int[] classes = new int[4];

        if (features[107] <= -1.0880388306e+15) {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 2;
            classes[3] = 0;
        } else {
            classes[0] = 0;
            classes[1] = 2;
            classes[2] = 0;
            classes[3] = 0;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_7(double[] features) {
        int[] classes = new int[4];

        if (features[76] <= -1.69838738441) {
            classes[0] = 0;
            classes[1] = 2;
            classes[2] = 0;
            classes[3] = 0;
        } else {
            classes[0] = 2;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 0;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_8(double[] features) {
        int[] classes = new int[4];

        if (features[151] <= 68.5) {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 1;
        } else {
            if (features[27] <= 1093.4921875) {
                classes[0] = 0;
                classes[1] = 1;
                classes[2] = 0;
                classes[3] = 0;
            } else {
                if (features[122] <= 278.5) {
                    classes[0] = 0;
                    classes[1] = 0;
                    classes[2] = 1;
                    classes[3] = 0;
                } else {
                    classes[0] = 1;
                    classes[1] = 0;
                    classes[2] = 0;
                    classes[3] = 0;
                }
            }
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict_9(double[] features) {
        int[] classes = new int[4];

        if (features[12] <= 2392725.25) {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 0;
            classes[3] = 1;
        } else {
            classes[0] = 0;
            classes[1] = 0;
            classes[2] = 3;
            classes[3] = 0;
        }
        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < 4; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static int predict(double[] features) {
        int n_classes = 4;
        int[] classes = new int[n_classes];
        classes[RandomForestClassifier.predict_0(features)]++;
        classes[RandomForestClassifier.predict_1(features)]++;
        classes[RandomForestClassifier.predict_2(features)]++;
        classes[RandomForestClassifier.predict_3(features)]++;
        classes[RandomForestClassifier.predict_4(features)]++;
        classes[RandomForestClassifier.predict_5(features)]++;
        classes[RandomForestClassifier.predict_6(features)]++;
        classes[RandomForestClassifier.predict_7(features)]++;
        classes[RandomForestClassifier.predict_8(features)]++;
        classes[RandomForestClassifier.predict_9(features)]++;

        int class_idx = 0;
        int class_val = classes[0];
        for (int i = 1; i < n_classes; i++) {
            if (classes[i] > class_val) {
                class_idx = i;
                class_val = classes[i];
            }
        }
        return class_idx;
    }

    public static void main(String[] args) {
        if (args.length == 156) {

            // Features:
            double[] features = new double[args.length];
            for (int i = 0, l = args.length; i < l; i++) {
                features[i] = Double.parseDouble(args[i]);
            }

            // Prediction:
            int prediction = RandomForestClassifier.predict(features);
            System.out.println(prediction);

        }
    }
}