//////////step 3 --------- make a connection to arduino uno with supercollider/////////////////////////////////////////

(
SerialPort.devices; // detect the device name
~port = SerialPort.new("/dev/cu.usbmodem1431401", 9600); // modifiy the device name to connect to arduino
~val = [];
~xyz = [];
~charArray = [];

)


/////////step 4 --------- convert arduino data to interger to control sound from sensor ///////////////////////////////
(
~zLayer = 15000;
~zLayerOff = 24000;
~plucked = false;
~sound = Synth(\KarplusS, [\pitch, ~pitch]);

~getValues = Routine.new({
	var myChar, myAscii, combined;
	{
		myChar = ~port.read.asAscii;
		myAscii = myChar.ascii;

		// sometimes this is Integer instead of Char, no clue why...
		if(myChar.class == Char){
			if(myChar.isDecDigit, {
				~charArray = ~charArray.add(myChar);
			});
			// 59 = ":", if we get a ":" we combine all the currently collected chars and convert them to an integer adding it to xyz
			if(myAscii == 58, {
				combined = ~charArray.join("").asInteger;
				~xyz = ~xyz.add(combined);
				~charArray = [];
			});
			// 13 = linebreak, if we have a linebreak / carriage return we know we finished a line and can save it in val
			if(myAscii == 13, {
				combined = ~charArray.join("").asInteger;
				~xyz = ~xyz.add(combined);
				~val = ~xyz;
				~xyz = [];
				~charArray = [];

				// ~val.postln; // here it has the value of each message sent from arduino as an array [x,y,z]
				// y and z seem to work fine, x starts somewhere around 14000 and ends at 65000 around the middle of the sensor sometimes. 65535 is the maximum for 16bits, which seems to be the maximum for the Arduino Uno
				((~val[2] <= ~zLayer) && ~plucked.not).if ({
					"pluck".postln;
					~plucked = true;
					~pitch = ~val[0].linlin(0, 65000, 48, 48 + (12 *3)).floor.postln;

					~sound.set(\pitch, ~pitch); ~sound.set(\t_trig, 1);

				});

				((~val[2] >= ~zLayerOff) && ~plucked).if ({
					~plucked = false;
				});

				"--------- ".postln;

			});
		}
	}.loop;
}).play;
)

////////////step 5 --------  ready to play on sensor //////////////////////////////////////////////////////////////////

~getValues.stop; //it can stop receiving data, otherwise use Command + "." (period.) to stop the server running synth and routine


/*
~val[0].postln; // ~val[0] ->x , ~val[1] ->y, ~val[2] ->z


~xyz.postln;

