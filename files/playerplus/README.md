PlayerPlus mod for minetest

This mod lets the player move faster when walking on ice, slows down the player
when walking on snow or in water, and makes touching a cactus hurt... enjoy!

https://forum.minetest.net/viewtopic.php?t=10090&p=153667

- 0.1 - Initial release
- 0.2 - 3d_armor mod compatibility
- 0.3 - Optimized code
- 0.4 - Added suffocation when inside nodes
- 0.5 - Slow down when walking in water
- 0.6 - Code tidy and tweak, increased damage by cactus and suffocation
- 0.7 - Added global 'playerplus' table to hold node names gathered around player


API:

Every second the mod checks which node the player is standing on, which node is
at foot and head level and stores inside a global table to be used by mods:

- playerplus[name].nod_stand
- playerplus[name].nod_foot
- playerplus[name].nod_head
