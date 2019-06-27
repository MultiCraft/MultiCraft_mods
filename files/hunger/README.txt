MultiCraft Game mod: Hunger
=====================
Version: 1.1.3

(c) Copyright BlockMen (2015)


About this mod:
~~~~~~~~~~~~~~~
This mod adds hunger mechanics to Minetest, which are based on player actions and on time.
Also it changes the eating in Minetest, e.g. an Apple does not restore Health, but it rises your saturation.
Example: 1 apple fills up the hunger bar by 1 "bread" (statbar symbol).
Although the statbar show 20 hunger points (10 breads) on the HUD you can fill it up to 30 points.

For Modders:
~~~~~~~~~~~~
This mod alters the behavior of minetest.item_eat().
All callbacks that are registered via minetest.register_on_item_eat() are called AFTER this mod actions, so the itemstack
will have changed already when callbacks are called. You can get the original itemstack as 6th parameter of your function then.

License:
~~~~~~~~
(c) Copyright BlockMen (2015)
https://github.com/BlockMen/hunger


Code:
Licensed under the GNU LGPL version 3.0 or higher.
You can redistribute it and/or modify it under 
the terms of the GNU Lesser General Public License 
as published by the Free Software Foundation;

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

See LICENSE.txt and http://www.gnu.org/licenses/lgpl-3.0.txt

Textures:
Copyright (C) MultiCraft Development Team

Sound: WTFPL
