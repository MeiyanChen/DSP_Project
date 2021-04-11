SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbmodem1431201", 9600);



(
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read;
		ascii.postln;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a, {
			~val = ~charArray.collect(_.digit).convertDigits;
			~charArray = [ ];
		})
	}.loop;
}).play;
)
~getValues.postln;

~val.postln;
~getValues.stop; // stop routine
~port.close;// SC or Arduino, only one port can be running


(
SynthDef.new(\saw,{
	arg cutoff = 1000;
	var sig;
	sig = Saw.ar([50,51]);
	sig = RLPF.ar(sig, cutoff.lag(0.02), 0.25, 0.2);
	Out.ar(0, sig);
}).add;
)

~synth = Synth(\saw,[\cutoff, 200]);

~synth = Synth(\saw,[\cutoff, ~val.linexp(0, 1023, 80, 4000)]);

(
~control = Routine.new({
	{
		~synth.set(\cutoff, ~val.linexp(0, 1023, 80, 4000));
		0.01.wait;
	}.loop;
})
)

~control.stop;
~synth.free;