//
// a script for simple 2 operator frequency modulation synthesis
// warning: makes annoying noises
// some results sound better than others. 
// example available at https://soundcloud.com/catpants/fm-1
//

// modulates oscillator b with adsr envelope e, uses result to modulate oscillator a. 
// result is modulated with adsr envelope d and sent to speaker
SqrOsc b => ADSR e => SqrOsc a => ADSR d => dac;



// set gain levels. distorts in an interesting way above 1. 
50 => a.gain => b.gain => d.gain => e.gain;

//start a loop
while ( true ) { 
    
    // randomize adsr envelope times and print to console
    Math.random2f(1000, 5000) => float Ad;
    Math.random2f(500, 1000) => float Dd;
    Math.random2f(.3, 1) => float Sd;
    Math.random2f(1000, 5000) => float Ae;
    Math.random2f(500, 1000) => float De;
    Math.random2f(.3, 1) => float Se;
    <<< "A attack:", Ad, "ms, A decay:", Dd, "ms, A sustain level %:", Sd * 100 >>>;
    <<< "B attack:", Ae, "ms, B decay:", De, "ms, B sustain level %:", Se * 100 >>>; 

    // attack decay sustain release times - modulates sound over time on key trigger. 
    // ignores release time because it causes problems running the script over time.
    e.set( Ae::ms, De::ms, Se, 10::ms ); 
    d.set( Ad::ms, Dd::ms, Sd, 10::ms ); 
    
    // trigger asdr on new note
    e.keyOn();
    d.keyOn();
    
    // randomize a number and send it to y
    Math.random2f(1, 25000) => float y;
    
    // print y, which will be the main frequency of the note
    <<< y >>>;
    
   
    // do math on y to get f and ff, to be used as frequencies for the oscillators a and b, then print value to console.
    y * Math.random2f( .000001, .5 ) => float f => a.freq;
    y * Math.random2f( .5, 1.5 ) => float ff => b.freq;
    <<< f, ff >>>;
    
    // randomize how long a note is played
    Math.random2f( 3000, 10000 )::ms => now;
    
    //let go of key after time has passed
    e.keyOff();
    d.keyOff();
    
    // wait for adsr key release to finish
    10::ms => now;
    }