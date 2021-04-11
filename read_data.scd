SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbmodem1431201", 9600);
~val = [];
~xyz = [];
~charArray = [];
(
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

				~val.postln; // here it has the value of each message sent from arduino as an array [x,y,z]
				// y and z seem to work fine, x starts somewhere around 14000 and ends at 65000 around the middle of the sensor sometimes. 65535 is the maximum for 16bits, which seems to be the maximum for the Arduino Uno
			});
		}
	}.loop;
}).play;
)

~getValues.stop;

~val.postln;
~xyz.postln;

