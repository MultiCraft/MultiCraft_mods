mobs:register_mob("mobs_animal:rat", {
		lifetimer = 1,
	})

-- compatibility
mobs:alias_mob("mobs:rat", "mobs_animal:rat")
mobs:alias_mob("mobs:rat_meat", "mobs:meat_raw")
mobs:alias_mob("mobs:rat_cooked", "mobs:meat")