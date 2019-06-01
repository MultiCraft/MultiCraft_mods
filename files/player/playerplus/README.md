MultiCraft Game mod: PlayerPlus

This mod lets the player move faster when walking on ice, slows down the player
when walking on snow, makes touching a cactus hurt and suffocates player when
their head is inside a solid node... enjoy!

https://forum.minetest.net/viewtopic.php?t=10090&p=153667


The mod has been rewritten and optimized to work with Player Physics API:
https://forum.minetest.net/viewtopic.php?f=9&t=22172
Removed POVA, monoids support, knock-back, glitch.

API:
Every second the mod checks which node the player is standing on, which node is
at foot and head level and stores inside a global table to be used by mods:

- playerplus[name].nod_stand
- playerplus[name].nod_foot
- playerplus[name].nod_head
