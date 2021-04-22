///////////////////step 1 ------- set the memory size for supercollider and then boot the server//////////////////////

s.options.sampleRate_(44100);
s.options.memSize = (2.pow(20));
s.boot; //or use" command + b "
//ServerOptions
//s.options.numBuffers



//frequeny range from 130.81 - 987.77 Hz (49 -84 midi)

// delayTime is controlling the pitch here. The delay time is reciprocal to the pitch. // 1/100th of a sec is 100Hz, 1/400th of a sec is 400Hz.


//////////////////step 2-------- evaluate synthdef to have sound//////////////////////////////////////////////////////
(
s.waitForBoot({ // automatically create a Routine

SynthDef(\KarplusS, { |out, amp = 0.1, t_trig=1, pitch = 69, maxdelaytime = 0.2 , decaytime = 5 ,delaytime = 1, pan = 0,  add= 0.04, timbre = 0.5|
	var snd, env;
	snd = Pluck.ar(in:WhiteNoise.ar(amp),
			       trig: t_trig,
			       maxdelaytime:maxdelaytime ,
			       //delaytime:Lag.kr(pitch.midicps.reciprocal, 2) , //XLine.kr(freq.reciprocal,freq.lastForWhich, 0.2),
			       delaytime:pitch.midicps.reciprocal,
			       decaytime: decaytime,
			       coef:timbre,
			       add: add
		);
    snd = Pan2.ar(snd,pan);
    snd = AllpassN.ar(in: snd, maxdelaytime: 2, delaytime: 0.3, decaytime: 5, mul: 3.0);
	snd = GVerb.ar(snd, roomsize:50,
			            revtime:3,
			            damping:0.5,
			            inputbw:0.27,
			            spread:30,
			            drylevel:0.2,
			            earlyreflevel:0.5,
			            taillevel:0.5);
	snd = LeakDC.ar(snd).clip2;

	Out.ar(out, snd);
}).add;

s.sync;

})
)


/*
x = Synth(\KarplusS);
x.set(\pitch, 60);

(
Pmono(
	\KarplusS,
	\pitch,Pseq([60, 62, 64, 65, 67, 69])
).play;

)
// ~val[0].linexp(0, 65535, 49, 89)]

(
~control = Routine.new({
	{
		(instrument: \KarplusS, \pitch: [69, 71]).play;
		0.1.wait;
	}.loop;
}).play
)



(
Pmono(
	\KarplusS,
	\amp,Pseq([0.5, 0.4, 0.3,],inf),
	\t_trig, 1,   // vibrato
	\freq,Pxrand([130.81, 146.83, 164.81, 196, 220, 261.6, 293.67, 329.63, 392, 440, 523.25, 587.33, 659.26,783.99,880],inf),
    \dur, Pxrand([1, 1/2,1/4, 4],inf),
	\maxdelaytime,10,
    \decaytime,2,
	\add,0.04, // physical pressure change the timbre
	\timbre,0.65 // lower number sounds more like a guitar
).play

)




s.quit
s.stop

{ SinOsc.ar(~val[0].linexp(0, 65535, 100, 1000), 0, 0.5) }.play;

s.nodeTree


