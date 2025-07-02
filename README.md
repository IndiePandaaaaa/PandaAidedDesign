# PandaAidedDesign
PandaAidedDesign collects multiple different computer aided design (CAD) files written mostly in OpenSCAD to be printed out via FDM printing. 

## Table of Contents

- [Part Descriptions](#part-discriptions)
	- [Mounting Brackets](#mounting-brackets)
	- [Computer Case Accessoires](#computer-case-accessoires)
	- [Raspberry Pi Accessoires](#raspberry-pi-accessoires)
	- [Audio Equipment Accessoires](#audio-equipment-accessoires)
	- [Workshop Accessoires](#workshop-accessoires)
- [Future Plans](#future-plans)
- [My Printer](#my-printer)
- [Licence](#licence)

## Part Descriptions

### Mounting Brackets

#### [cable tie bracket](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202304CableTieBracket.scad)

Parametric model, generates a bracket for a given number of cable ties, to mount to a surface.

#### [Apple Watch charging bracket](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202308AppleWatchChargingBracket.scad)

Parametric model, primarily constructed to be clamped onto an [elgato](https://www.elgato.com/) master mount and secured with a cable tie, but the diameter of the clamp may be changed.

### Computer Case Accessoires

#### [stackable hard disk bay](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202304hddBayStackable.scad)

Generates a bay to mount 3.5 inch HDD on 120 mm fan screw holes. There is a bracket which combines 3 HDD bays to be screwed together and mounted on a 120 mm fan for better cooling of the drives. The cables to connect the drives are located on the backside (mounting side) of the bay and leave between the bays and the fan.

#### [cable combs](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202312CableCombs.scad)

Parametric model, cable combs for custom made AWG 16 computer ATX PSU cables.

### Raspberry Pi Accessoires

#### [Raspberry Pi Cooling Frame](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202410PiCoolFrame.scad)

Combines the Pi with an 80 mm active case fan for noise reduction (vs. 40 mm fan or smaller) and optimal cooling. It's also wall mountable.

- fitting case for Pi 3: [Joy-IT ARMOR CASE](https://joy-it.net/de/products/RB-ALUcase+07)
- fitting case for Pi 4: [Joy-IT ARMOR CASE](https://joy-it.net/de/products/RB-AlucaseP4+07)

### Audio Equipment Accessoires

#### [Logitech G](https://www.logitechg.com/) Blue Yeti X

- [usb protector](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202310YetiXmicroUSBProtector.scad): little plastic piece, mounted with cable tie, protects the usb cable from being bent back while microphone is used with a microphone arm
- [microphone suspension](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202402MicrophoneSuspension.scad): microphone spider for microphone arm to reduce vibrations

### Workshop Accessoires

#### [Bosch](https://www.bosch-professional.com/) GCM 305-216 D Professional (miter saw)

- [workpiece stop](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202401BoschPro216-305dAccessories.scad): plate with the slot-in mechanism for the material base, as helper to cut multiple parts of the same length
- [vacuum adapter](https://github.com/IndiePandaaaaa/PandaAidedDesign/blob/main/202401BoschPro216-305dAccessories.scad): optimizes the collection of saw dust colleted while sawing, taking away dust at a second spot (the dust bag is still mounted).

## Future Plans

- add a folder with printable models in STL
- merging files for better structure
- add more models to support my workflow

## My Printer

The printer I use is a [Prusa](https://www.prusa3d.com/de/) MK3S+. Most models are printed using black PLA.

## Licence

This work is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

