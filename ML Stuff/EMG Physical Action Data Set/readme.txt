
1. Title: EMG Physical Action DataSet


2. Sources:
   - Original owner: Theo Theodoridis
     School of Computer Science and Electronic Engineering
     University of Essex
     Wivenhoe Park, Colchester, CO4 3SQ, UK
     ttheod@gmail.com
     http://sites.google.com/site/ttheod/
   - Donors: Theo Theodoridis
   - Date: 28/07/11


3. Relevant Information:   
   3.1 Protocol:
       Three male and one female subjects (age 25 to 30), who have experienced aggression in scenarios
       such as physical fighting, took part in the experiment. Throughout 20 individual experiments,
       each subject had to perform ten normal and ten aggressive activities. Regarding the rights of the
       subjects involved, ethical regulations and safety precaution have been followed based on the code
       of ethics of the British psychological society. The regulations explain the ethical legislations
       to be applied when experiments with human subjects are conducted. According to the experimental
       setup and the precautions taken, the ultimate risk of injuries was minimal. The subjects were aware
       that since their involvement in this series of experiments was voluntary, it was made clear that
       they could withdraw at any time from the study.

   3.2 Instrumentation:
       The Essex robotic arena was the main experimental hall where the data collection took place.
       With area 4x5.5m, the subjects expressed aggressive physical activities at random locations. A
       professional kick-boxing standing bag has been used, 1.75m tall, with a human figure drawn on
       its body. The subjects’ performance has been recorded by the Delsys EMG apparatus, interfacing
       human activity with myoelectrical contractions. Based on this context, the data acquisition process
       involved eight skin-surface electrodes placed on the upper arms (biceps and triceps), and upper legs
       (thighs and hamstrings).

   3.3 Data Setup:
       The overall number of electrodes is 8, which corresponds to 8 input time series one for a muscle
       channel (ch1-8). Each time series contains ~10000 samples (~15 actions per experimental session
       for each subject).


4. Number of Instances: ~10,000 


5. Number of Attributes: 8


6. Attribute Information:
   Each file in the dataset contains in overall 8 columns, and is organised as follows:

   +---------+---------------+---------------+---------------+---------------+
   | Segment |     R-Arm     |     L-Arm     |     R-Leg     |     L-Leg     |
   +---------+-------+-------+-------+-------+-------+-------+-------+-------+
   | Channel | ch1   | ch2   | ch3   | ch4   | ch5   | ch6   | ch7   | ch8   |
   | Muscle  | R-Bic | R-Tri | L-Bic | L-Tri | R-Thi | R-Ham | L-Thi | L-Ham |
   | Column  | 0     | 1     | 2     | 3     | 4     | 5     | 6     | 7     |
   +---------+-------+-------+-------+-------+-------+-------+-------+-------+

   Segment: A segment defines a body segment or limb.
	    - Right arm (R-Arm)
	    - Left arm (L-Arm)
	    - Right leg (R-Leg)
	    - Left leg (L-Leg)

   Channel: A channel corresponds to an electrode attached on a muscle.

   Muscle:  A pair of muscles that corresponds to a segment.
	    - R-Bic: right bicep (C1)
	    - R-Tri: right tricep (C2)
	    - L-Bic: left bicep (C3)
	    - L-Tri: left tricep (C4)
	    - R-Thi: right thigh (C5)
	    - R-Ham: right hamstring (C6)
	    - L-Thi: left thigh (C7)
	    - L-Ham: left hamstring (C8)


7. Number of Classes: 20
   The dataset consists of 10 normal, and 10 aggressive physical actions.
   Normal: Bowing, Clapping, Handshaking, Hugging, Jumping, Running, Seating, Standing, Walking, Waving
   Aggressive: Elbowing, Frontkicking, Hamering, Headering, Kneeing, Pulling, Punching, Pushing, Sidekicking, Slapping


8. Other:
   The log folder contains the formatted data files that can be loaded by the commercial Delsys software for visualisation.
   The txt folder contains the actual EMG data.   
   Note that the data collected from 2nd subject have not been filtered so the time series are noisy.
