# Clock
This is a project that I started after finding [this awesome clock](https://clockclock.com/) on reddit. It seemed like a fun project to learn about embedded systems and a good excuse to finally get a 3D printer.

This is still very much a work in progress but as I progress more parts will show up here.

## Progress
### CAD
- [x] ~Motor mounting bracket~
- [x] ~Inner clock hand~
- [x] ~Outer clock hand~
- [ ] LED mounting bracket
- [x] ~Organize `.scad` file for general consumption and small tweaks~
- [ ] Generate `.stl` files for all independent parts for printing

### Controller
- [ ] Decide between Arduino or RaspberryPi
- [ ] Would I2C work for this? Can it select fast enough?
- [ ] Stepper motor control code
- [ ] Game loop style animation library

## Open Questions
- I need to be able to reset the position of all the hands so they can align properly to form the digits. How should I do that?
- Would I2C work for this? Can it select fast enough?

## Notes
- It looks like the [stepper motors](https://www.elegoo.com/product/elegoo-5-sets-28byj-48-5v-stepper-motor-uln2003-motor-driver-board-for-arduino/) I'm using need >900 microseconds between steps, so I need to make sure thats ok. 1ms should be enough to make it work given 2048 steps at 1ms per step is ~2s per revolution which should be fine (it might actually be too fast).
- RaspberryPi supports an I2C bus so that could work to control the stepper motors. The [MCP23017](https://www.adafruit.com/product/732) chip is 16 GPIO pins per chip, and there are 3 address ports so I could chain 8 of them giving me 128 total pins. Adafruit has a [pretty good tutorial](https://learn.adafruit.com/mcp230xx-gpio-expander-on-the-raspberry-pi/hooking-it-all-up) showing how to use it, but they don't explain how to set the correct addresses for multiple chips so I'll have to look into that.
- The current controller circuits I have, [ULN2003A](https://en.wikipedia.org/wiki/ULN2003A), need 4 pins per motor which equates to a whopping 192 pins needed to drive all 48 motors and that's just stupid. Additionally, that's over the 128 pin max with a single I2C bus, so I would need either a second I2C bus or a second RaspberryPi which is even more stupid. That said, I found an [interesting article](http://www.tigoe.net/pcomp/code/circuits/motors/stepper-motors/) about a circuit that can control stepper motors with a `ULN2003` chip using only 2 pins, some resistors and a diode, cutting the total pin count in half to 96 which I can do with 6 `MCP23017`s.
- I really like the idea of using a RaspberryPi for this over an Arduino because it comes with Wifi for setting the correct time. It also would allow me to write the animation code in python which I expect would be much simpler than using Arduino, if for no other reason than I already know python.
