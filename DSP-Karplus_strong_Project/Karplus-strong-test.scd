s.options.sampleRate_(44100);
s.options.memSize = (2.pow(20));
ServerOptions
s.options.numBuffers


//frequeny range from 130.81 - 987.77 Hz


//hear sound by evaluate the next two code block

(
s.waitForBoot({ // automatically create a Routine

SynthDef(\KarplusS, { |out, amp = 0.5, trig = 1, freq = 440, maxdelaytime = 0.2 , decaytime = 0.2 ,delaytime = 1, pan = 0,  add= 0.04, timbre = 0.5|
	var snd, env;
	env = EnvGen.kr(Env.perc, doneAction: Done.freeSelf);
	snd = Pluck.ar(in:WhiteNoise.ar(amp),
			       trig: Impulse.kr(trig),
			       maxdelaytime:maxdelaytime ,
			       delaytime:freq.reciprocal , //XLine.kr(freq.reciprocal,freq.lastForWhich, 0.2),
			       decaytime: decaytime,
			       coef:timbre,
			       add: add
		);
    snd = Pan2.ar(snd,pan,amp);
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

	Out.ar(out, snd * env);
}).add;

s.sync;

x = Synth("KarplusS");
})
)




(
Pbind(
	\instrument, \KarplusS,
	\amp,Pseq([0.5, 0.4, 0.3,],inf),
	\trig,Pseq([0, 1],inf),   // vibrato
	\freq,Pxrand([130.81, 146.83, 164.81, 196, 220, 261.6, 293.67, 329.63, 392, 440, 523.25, 587.33, 659.26,783.99,880],inf),
    \dur, Pxrand([1, 1/2,1/4],inf),
	\maxdelaytime,10,
    \decaytime,2,
	\add,0.04, // physical pressure change the timbre
	\timbre,0.65 // lower number sounds more like a guitar
).play

)



