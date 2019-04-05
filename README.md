# OneDollarRecognizer
A simple recognizer (ported from SS3 and Yoshiki implementation)

The $1 Unistroke Recognizer is a 2-D single-stroke recognizer designed for rapid prototyping of gesture-based user interfaces. 
In machine learning terms, $1 is an instance-based nearest-neighbor classifier with a Euclidean scoring function, i.e., a geometric template matcher. 
$1 is an extension of the proportional shape matching approach used in SHARK, which itself is an adaptation of Tappert's elastic matching approach with zero look-ahead. 
Despite its simplicity, $1 requires very few templates to perform well and is only about 100 lines of code, making it easy to deploy. An optional enhancement called Protractor improves $1's speed. 
The $N Multistroke Recognizer extends $1 to gestures with multiple strokes. The $P Point-Cloud Recognizer is the latest in the dollar family, performing unistroke and multistroke recognition without the combinatoric overhead of $N.
http://depts.washington.edu/aimgroup/proj/dollar/index.html
