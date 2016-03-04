Minetest Mod - Railtrack [railtrack]
====================================

Minetest version: 0.4.13

Depends: default

Proof of concept rail networking system which enables rail-carts to travel
through unloaded map chunks.

Please note, this mod makes heavy use of metadata so that much of the processing
gets done as tracks are laid, for this reason a 'rails' privilege is required in
order to place rails when using multiplayer mode.

Crafting
--------

R = Rail [default:rail]
F = Mese Crystal Fragment [default:mese_crystal_fragment]
C = Coal Lump [default:coal_lump]
D = Diamond [default:diamond]
M = Mese Block [default:mese]

Powered Rail: [railtrack:powerrail]

By default these rails apply a positive acceleration during the time a cart
remains on a given section of track. When used with the mesecons mod the rails
will require power from a mesecon source to become active.

+---+---+---+
| R | F | R |
+---+---+---+

Braking Rail: [railtrack:brakerail]

By default these rails apply a negative acceleration during the time a cart
remains on a given section of track. When used with the mesecons mod the rails
will require power from a mesecon source to become active.

+---+---+---+
| R | C | R |
+---+---+---+

Superconducting Rail: [railtrack:superrail]

Zero friction rails that are easier to manage and are also a little less
cpu-intensive by avoiding the use of square root calculations.

+---+---+---+
| R | D | R |
+---+---+---+

Switching Rail: [railtrack:switchrail]

Currently depends on mesecons to do much other than provide a convenient, zero
friction union to join long sections of superconducting rails.

+---+---+---+
| R | M | R |
+---+---+---+

Misc Items
----------

Rail Fixer: [railtrack:fixer]

Only available in creative menu or with give(me) privileges.

Rail Inspector [railtrack:inspector]

Only available in creative menu or with give(me) privileges.

