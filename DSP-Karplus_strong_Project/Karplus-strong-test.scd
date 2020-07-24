s.options.sampleRate_(44100);
s.options.memSize_(2.pow(20));


//a simple example
(

{Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)


(
s.waitForBoot({ // automatically create a Routine

SynthDef(\KarplusS, { |out, freq = 0.1, trig = 2, pitch = 0.001|
	var sig, env;
	env = EnvGen.kr(Env.perc, doneAction: Done.freeSelf);
	sig = Pluck.ar(WhiteNoise.ar(freq), Impulse.kr(trig), 8 , pitch , 6);
    Out.ar(out, env*sig!2)
}).add;

s.sync;

x = Synth("KarplusS");
})
)



(
Pbind(
	\instrument, \KarplusS,
	\freq,Pxrand([0.51,0.52, 0.5],inf),
	\trig,Pseq([0.1,2],inf),
	\scale, Scale.minorPentatonic,
	\pitch,Pxrand([0.011,0.0113,0.0115,0.0117,0.0019,0.0015, 0.002, 0.003,0.004],inf),
    \dur, Pxrand([2, 1,1/2,1/4, 1/8],inf),
).play)