Minetest Mod - Railcart [railcart]
==================================

Minetest version: 0.4.13

Depends: railtrack

Proof of concept ground up re-write of the carts mod. Currently uses media files
borrowed from the original carts mod by PilzAdam.

Please note, this mod makes heavy use of metadata so that carts are able to
travel through unloaded map chunks, therefor a 'carts' privilege is required
to place or pick up carts in multiplayer mode.

Crafting
--------

S = Steel Ingot [default:steel_ingot]
W = Wood [group:wood]

Railcart: [railcart:cart]

+---+---+---+
| S |   | S |
+---+---+---+
| S |   | S |
+---+---+---+
| W | S | W |
+---+---+---+

