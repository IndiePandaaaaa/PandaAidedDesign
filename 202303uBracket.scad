// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

$fn = $preview ? 25 : 75;

// DEFAULT VALUES
DEVICE_WIDTH = 42;
DEVICE_HEIGHT = 12.5;

//DIGITUS Ultra Slim HDMI Splitter DS-45322 DEVICE_WIDTH = 83.1; DEVICE_HEIGHT = 8.9;
//LOGILINK Digital to Analog Audio Converter CA0101 v2 DEVICE_WIDTH = 53.5; DEVICE_HEIGHT = 21.5;
//DELL 130W PSU DEVICE_WIDTH = 76.2; DEVICE_HEIGHT = 24.4;
//HP 120W PSU DEVICE_WIDTH = 68.6; DEVICE_HEIGHT = 25.2;
//USB Cable Plug DEVICE_WIDTH = 11; DEVICE_HEIGHT = 14.5;

MATERIAL_THICKNESS = 2.5;
SCREW_DIAMETER = 3.5;

module Bracket(screwSocketWidth, thicknessBracket, deviceWidth, deviceHeight, chamfer = 1) {
  uBracket(screwSocketWidth=screwSocketWidth, thicknessBracket=thicknessBracket, deviceWidth=deviceWidth, deviceHeight=deviceHeight);
}

module uBracket(screwSocketWidth, thicknessBracket, deviceWidth, deviceHeight, chamfer = 1) {
  difference() {
    screwSocketWidth = SCREW_DIAMETER * 2 + 5;

    deviceWidth = deviceWidth + 0.1; // added .1 for tolerance issues
    linear_extrude(height=screwSocketWidth) {
      endWidth = (screwSocketWidth + thicknessBracket) * 2;
      polygon(
        points=[
          [0, 0],
          [screwSocketWidth + thicknessBracket, 0],
          [screwSocketWidth + thicknessBracket, deviceHeight],
          [screwSocketWidth + thicknessBracket + deviceWidth, deviceHeight],
          [screwSocketWidth + thicknessBracket + deviceWidth, 0],
          [endWidth + deviceWidth, 0],
          [endWidth + deviceWidth, thicknessBracket],
          [screwSocketWidth + thicknessBracket + deviceWidth + thicknessBracket, thicknessBracket],
          [
            screwSocketWidth + thicknessBracket + deviceWidth + thicknessBracket,
            deviceHeight + thicknessBracket - chamfer,
          ],
          [
            screwSocketWidth + thicknessBracket + deviceWidth + thicknessBracket - chamfer,
            deviceHeight + thicknessBracket,
          ],
          [screwSocketWidth + chamfer, deviceHeight + thicknessBracket],
          [screwSocketWidth, deviceHeight + thicknessBracket - chamfer],
          [screwSocketWidth, thicknessBracket],
          [0, thicknessBracket],
        ]
      );
    }

    for (i = [0:1]) {
      translate(
        [
          screwSocketWidth / 2 + (screwSocketWidth + deviceWidth + thicknessBracket * 2) * i,
          thicknessBracket + .1,
          screwSocketWidth / 2,
        ]
      )
        rotate([-90, 0, 0])
          screw(SCREW_DIAMETER, 12, true);
    }
  }
}
uBracket(screwSocketWidth=SCREW_DIAMETER * 4, thicknessBracket=MATERIAL_THICKNESS, deviceWidth=30, deviceHeight=10, chamfer=1);
