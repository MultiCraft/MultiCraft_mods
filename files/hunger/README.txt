Minetest mod "Hunger"
=====================
Version: 1.1.3

(c) Copyright BlockMen (2015)


About this mod:
~~~~~~~~~~~~~~~
This mod adds hunger mechanics to Minetest, which are based on player actions and on time.
Also it changes the eating in Minetest, e.g. an Apple does not restore Health, but it rises your saturation.
Example: 1 apple fills up the hunger bar by 1 "bread" (statbar symbol).
Although the statbar show 20 hunger points (10 breads) on the HUD you can fill it up to 30 points.

By default it supports a lot of food already (see full list below) and food that for registered via the API.
For more information how to register more food see API.txt

Information:
This mod depends on the "Better HUD" mod (https://github.com/BlockMen/hud) to provide information about your current saturation.


For Modders:
~~~~~~~~~~~~
This mod alters the behavior of minetest.item_eat().
All callbacks that are registered via minetest.register_on_item_eat() are called AFTER this mod actions, so the itemstack
will have changed already when callbacks are called. You can get the original itemstack as 6th parameter of your function then.

License:
~~~~~~~~
(c) Copyright BlockMen (2015)


Code:
Licensed under the GNU LGPL version 2.1 or higher.
You can redistribute it and/or modify it under 
the terms of the GNU Lesser General Public License 
as published by the Free Software Foundation;

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

See LICENSE.txt and http://www.gnu.org/licenses/lgpl-2.1.txt


Textures:
hunger_statbar_poisen.png - BlockMen (CC-BY 3.0)

Sounds:
hunger_eat.ogg - BlockMen (CC-BY 3.0)


Github:
~~~~~~~
https://github.com/BlockMen/hunger

Forum:
~~~~~~
-

Changelog:
~~~~~~~~~~
see changelog.txt


Dependencies:
~~~~~~~~~~~~~
- Default
- Farming
- Better HUD (https://github.com/BlockMen/hud)


Supported food/mods:
~~~~~~~~~~~~~~~~~~~~
- Apples (default)
- Animalmaterials (mobf modpack)
- Bread (default)
- Bushes
- bushes_classic
- Creatures
- Dwarves (beer and such)
- Docfarming
- Fishing
- Farming plus
- Farming (default and Tenplus1's fork)
- Food
- fruit
- Glooptest
- JKMod
- kpgmobs
- Mobfcooking
- Mooretrees
- Mtfoods
- mushroom
- mush45
- Seaplants (sea)
- Simple mobs
