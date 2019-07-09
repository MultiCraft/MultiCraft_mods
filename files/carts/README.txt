 MultiCraft Game mod: carts
==========================
Based on (and fully compatible with) the mod "carts" by PilzAdam
and the one contained in the subgame "minetest_game".
Target: Run smoothly as possible, even on laggy servers.


 Features
----------
- A fast cart for your railway or roller coaster
- Easily configurable cart speed using the Advanced Settings
- Boost and brake rails
- By mesecons controlled Start-Stop rails
- Detector rails that send a mesecons signal when the cart drives over them
- Rail junction switching with the 'right/left' walking keys
- Handbrake with the 'back' key
- Support for non-minetest_game subgames


 Settings
----------
This mod can be adjusted to fit the conditions of a player or server.
Use the Advanced Settings dialog in the main menu or tune your
minetest.conf file manually:

boost_cart.speed_max = 10
   ^ Possible values: 1 ... 100
   ^ Maximal speed of the cart in m/s

boost_cart.punch_speed_max = 7
   ^ Possible values: -1 ... 100
   ^ Maximal speed to which the driving player can accelerate the cart
     by punching from inside the cart. -1 will disable this feature.


Carts, based almost entirely on the mod boost_cart [1], which
itself is based on (and fully compatible with) the carts mod [2].

The model was originally designed by stujones11 [3] (CC-0).

Cart textures are based on original work from PixelBOX by Gambit (permissive
license).

[1] https://github.com/SmallJoker/boost_cart/
[2] https://github.com/PilzAdam/carts/
[3] https://github.com/stujones11/railcart/


 Authors
---------
klankbeeld (CC-BY 3.0)
	http://freesound.org/people/klankbeeld/sounds/174042/
	cart_rail.*.ogg
