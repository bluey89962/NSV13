/obj/structure/girder
	name = "girder"
	icon_state = "girder"
	desc = "A large structural assembly made out of iron; It requires a layer of iron before it can be considered a wall."
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	var/state = GIRDER_NORMAL
	var/girderpasschance = 20 // percentage chance that a projectile passes through the girder.
	var/can_displace = TRUE //If the girder can be moved around by wrenching it
	max_integrity = 200
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/girder/examine(mob/user)
	. = ..()
	switch(state)
		if(GIRDER_REINF)
			. += "<span class='notice'>The support struts are <b>screwed</b> in place.</span>"
		if(GIRDER_REINF_STRUTS)
			. += "<span class='notice'>The support struts are <i>unscrewed</i> and the inner <b>grille</b> is intact.</span>"
		if(GIRDER_NORMAL)
			if(can_displace)
				. += "<span class='notice'>The bolts are <b>wrenched</b> in place.</span>"
		if(GIRDER_DISPLACED)
			. += "<span class='notice'>The bolts are <i>loosened</i>, but the <b>screws</b> are holding [src] together.</span>"
		if(GIRDER_DISASSEMBLED)
			. += "<span class='notice'>[src] is disassembled! You probably shouldn't be able to see this examine message.</span>"

/obj/structure/girder/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	if(istype(W, /obj/item/gun/energy/plasmacutter))
		balloon_alert(user, "You start slicing apart the girder")
		if(W.use_tool(src, user, 40, volume=100))
			balloon_alert(user, "Girder sliced apart")
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)
			return

	else if(istype(W, /obj/item/pickaxe/drill/jackhammer))
		to_chat(user, "<span class='notice'>You smash through the girder!</span>")
		new /obj/item/stack/sheet/iron(get_turf(src))
		W.play_tool_sound(src)
		qdel(src)


	else if(istype(W, /obj/item/stack))
		if(iswallturf(loc))
			balloon_alert(user, "Wall already present")
			return
		if(!isfloorturf(src.loc))
			balloon_alert(user, "Floor is missing")
			return
		if (locate(/obj/structure/falsewall) in src.loc.contents)
			balloon_alert(user, "There already is a false wall")
			return

		if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/S = W
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need at least two rods to create a false wall!</span>")
					return
				balloon_alert(user, "You start building a reinforced false wall")
				if(do_after(user, 20, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					balloon_alert(user, "False wall created")
					var/obj/structure/falsewall/iron/FW = new (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else
				if(S.get_amount() < 5)
					to_chat(user, "<span class='warning'>You need at least five rods to add plating!</span>")
					return
				balloon_alert(user, "You start adding plating")
				if(do_after(user, 40, target = src))
					if(S.get_amount() < 5)
						return
					S.use(5)
					balloon_alert(user, "Plating added")
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall/mineral/iron)
					transfer_fingerprints_to(T)
					qdel(src)
				return

		if(!istype(W, /obj/item/stack/sheet))
			return

		var/obj/item/stack/sheet/S = W

		if (try_nsv_walls(S, user)) //NSV13 - try to build our walls
			return

		if(istype(S, /obj/item/stack/sheet/iron))
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two sheets of iron to create a false wall!</span>")
					return
				balloon_alert(user, "You start building false wall")
				if(do_after(user, 20, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					balloon_alert(user, "False wall created")
					var/obj/structure/falsewall/iron/F = new (loc) //NSV13 - iron falsewall
					transfer_fingerprints_to(F)
					qdel(src)
					return
			else
				if(S.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two sheets of iron to finish a wall!</span>")
					return
				balloon_alert(user, "You start adding plating")
				if (do_after(user, 40, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					balloon_alert(user, "Plating alert")
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall/steel) //Nsv13 - Bay style walls
					transfer_fingerprints_to(T)
					qdel(src)
				return

		if(istype(S, /obj/item/stack/sheet/plasteel))
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need at least two sheets to create a false wall!</span>")
					return
				balloon_alert(user, "You start building reinforced false wall")
				if(do_after(user, 20, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					balloon_alert(user, "Reinforced false wall created")
					var/obj/structure/falsewall/reinforced/FW = new (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else
				if(state == GIRDER_REINF)
					if(S.get_amount() < 1)
						return
					balloon_alert(user, "You start finilizing reinforced wall")
					if(do_after(user, 50, target = src))
						if(S.get_amount() < 1)
							return
						S.use(1)
						balloon_alert(user, "Wall fully reinforced")
						var/turf/T = get_turf(src)
						T.PlaceOnTop(/turf/closed/wall/r_wall)
						transfer_fingerprints_to(T)
						qdel(src)
					return
				else
					if(S.get_amount() < 1)
						return
					balloon_alert(user, "You start reinforcing girder")
					if(do_after(user, 60, target = src))
						if(S.get_amount() < 1)
							return
						S.use(1)
						balloon_alert(user, "Girder reinforced")
						var/obj/structure/girder/reinforced/R = new (loc)
						transfer_fingerprints_to(R)
						qdel(src)
					return

		if(S.sheettype && S.sheettype != "runed")
			var/M = S.sheettype
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need at least two sheets to create a false wall!</span>")
					return
				if(do_after(user, 20, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					balloon_alert(user, "False wall created")
					var/F = text2path("/obj/structure/falsewall/[M]")
					var/obj/structure/FW = new F (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else
				if(S.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need at least two sheets to add plating!</span>")
					return
				balloon_alert(user, "You start adding plating")
				if (do_after(user, 40, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					balloon_alert(user, "Plating added")
					var/turf/T = get_turf(src)
					T.PlaceOnTop(text2path("/turf/closed/wall/mineral/[M]"))
					transfer_fingerprints_to(T)
					qdel(src)
				return

		add_hiddenprint(user)

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			if(!user.transferItemToLoc(P, drop_location()))
				return
			balloon_alert(user, "You fit the pipe into [src]")
	else
		return ..()

// Screwdriver behavior for girders
/obj/structure/girder/screwdriver_act(mob/user, obj/item/tool)
	if(..())
		return TRUE

	. = FALSE
	if(state == GIRDER_DISPLACED)
		user.visible_message("<span class='warning'>[user] disassembles the girder.</span>",
							 "<span class='notice'>You start to disassemble the girder...</span>",
							 "You hear clanking and banging noises.")
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_DISPLACED)
				return
			state = GIRDER_DISASSEMBLED
			balloon_alert(user, "Girder disassembled")
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)
		return TRUE

	else if(state == GIRDER_REINF)
		balloon_alert(user, "You start unsecuring support struts")
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_REINF)
				return
			balloon_alert(user, "Support struts unsecured")
			state = GIRDER_REINF_STRUTS
		return TRUE

	else if(state == GIRDER_REINF_STRUTS)
		balloon_alert(user, "You start securing support struts")
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_REINF_STRUTS)
				return
			balloon_alert(user, "Support struts secured")
			state = GIRDER_REINF
		return TRUE

// Wirecutter behavior for girders
/obj/structure/girder/wirecutter_act(mob/user, obj/item/tool)
	. = FALSE
	if(state == GIRDER_REINF_STRUTS)
		balloon_alert(user, "You start removing the inner grille")
		if(tool.use_tool(src, user, 40, volume=100))
			balloon_alert(user, "Inner grille removed")
			new /obj/item/stack/sheet/plasteel(get_turf(src))
			var/obj/structure/girder/G = new (loc)
			transfer_fingerprints_to(G)
			qdel(src)
		return TRUE

/obj/structure/girder/wrench_act(mob/user, obj/item/tool)
	. = FALSE
	if(state == GIRDER_DISPLACED)
		if(!isfloorturf(loc))
			balloon_alert(user, "Floor is missing")

		balloon_alert(user, "You start securing girder")
		if(tool.use_tool(src, user, 40, volume=100))
			balloon_alert(user, "Girder secured")
			var/obj/structure/girder/G = new (loc)
			transfer_fingerprints_to(G)
			qdel(src)
		return TRUE
	else if(state == GIRDER_NORMAL && can_displace)
		balloon_alert(user, "You start unsecuring girder")
		if(tool.use_tool(src, user, 40, volume=100))
			balloon_alert(user, "Girder unsecured")
			var/obj/structure/girder/displaced/D = new (loc)
			transfer_fingerprints_to(D)
			qdel(src)
		return TRUE

/obj/structure/girder/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return prob(girderpasschance)
	else
		if(istype(mover, /obj/item/projectile))
			return prob(girderpasschance)
		else
			return 0

/obj/structure/girder/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	. = !density
	if(istype(caller))
		. = . || (caller.pass_flags & PASSGRILLE)

/obj/structure/girder/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/remains = pick(/obj/item/stack/rods, /obj/item/stack/sheet/iron)
		new remains(loc)
	qdel(src)

/obj/structure/girder/narsie_act()
	new /obj/structure/girder/cult(loc)
	qdel(src)

/obj/structure/girder/displaced
	name = "displaced girder"
	icon_state = "displaced"
	anchored = FALSE
	state = GIRDER_DISPLACED
	girderpasschance = 25
	max_integrity = 120

/obj/structure/girder/reinforced
	name = "reinforced girder"
	icon_state = "reinforced"
	state = GIRDER_REINF
	girderpasschance = 0
	max_integrity = 350



//////////////////////////////////////////// cult girder //////////////////////////////////////////////

/obj/structure/girder/cult
	name = "runed girder"
	desc = "Framework made of a strange and shockingly cold metal. It doesn't seem to have any bolts."
	icon = 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	can_displace = FALSE

/obj/structure/girder/cult/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/melee/cultblade/dagger) && iscultist(user)) //Cultists can demolish cult girders instantly with their tomes
		user.visible_message("<span class='warning'>[user] strikes [src] with [W]!</span>", "<span class='notice'>You demolish [src].</span>")
		new /obj/item/stack/sheet/runed_metal(drop_location(), 1)
		qdel(src)

	else if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return

		balloon_alert(user, "You start slicing apart the girder")
		if(W.use_tool(src, user, 40, volume=50))
			balloon_alert(user, "Girder sliced apart")
			var/obj/item/stack/sheet/runed_metal/R = new(drop_location(), 1)
			transfer_fingerprints_to(R)
			qdel(src)

	else if(istype(W, /obj/item/pickaxe/drill/jackhammer))
		to_chat(user, "<span class='notice'>Your jackhammer smashes through the girder!</span>")
		var/obj/item/stack/sheet/runed_metal/R = new(drop_location(), 2)
		transfer_fingerprints_to(R)
		W.play_tool_sound(src)
		qdel(src)

	else if(istype(W, /obj/item/stack/sheet/runed_metal))
		var/obj/item/stack/sheet/runed_metal/R = W
		if(R.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need at least one sheet of runed metal to construct a runed wall!</span>")
			return 0
		user.visible_message("<span class='notice'>[user] begins laying runed metal on [src]...</span>", "<span class='notice'>You begin constructing a runed wall...</span>")
		if(do_after(user, 50, target = src))
			if(R.get_amount() < 1)
				return
			user.visible_message("<span class='notice'>[user] plates [src] with runed metal.</span>", "<span class='notice'>You construct a runed wall.</span>")
			R.use(1)
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/cult)
			qdel(src)

	else
		return ..()

/obj/structure/girder/cult/narsie_act()
	return

/obj/structure/girder/cult/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/runed_metal(drop_location(), 1)
	qdel(src)

/obj/structure/girder/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			return list("mode" = RCD_FLOORWALL, "delay" = 20, "cost" = 8)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 13)
	return FALSE

/obj/structure/girder/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	var/turf/T = get_turf(src)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			balloon_alert(user, "Wall finished")
			T.PlaceOnTop(/turf/closed/wall/ship) //NSV13 - Ship wall construction
			qdel(src)
			return TRUE
		if(RCD_DECONSTRUCT)
			balloon_alert(user, "Girder deconstructed")
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/girder/bronze
	name = "wall gear"
	desc = "A girder made out of sturdy bronze, made to resemble a gear."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "wall_gear"
	can_displace = FALSE

/obj/structure/girder/bronze/attackby(obj/item/W, mob/living/user, params)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount = 0))
			return
		balloon_alert(user, "You start slicing apart [src]")
		if(W.use_tool(src, user, 40, volume=50))
			balloon_alert(user, "[src] sliced apart")
			var/obj/item/stack/tile/bronze/B = new(drop_location(), 2)
			transfer_fingerprints_to(B)
			qdel(src)

	else if(istype(W, /obj/item/pickaxe/drill/jackhammer))
		to_chat(user, "<span class='notice'>Your jackhammer smashes through the girder!</span>")
		var/obj/item/stack/tile/bronze/B = new(drop_location(), 2)
		transfer_fingerprints_to(B)
		W.play_tool_sound(src)
		qdel(src)

	else if(istype(W, /obj/item/stack/tile/bronze))
		var/obj/item/stack/tile/bronze/B = W
		if(B.get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two bronze sheets to build a bronze wall!</span>")
			return FALSE
		user.visible_message("<span class='notice'>[user] begins plating [src] with bronze...</span>", "<span class='notice'>You begin constructing a bronze wall...</span>")
		if(do_after(user, 50, target = src))
			if(B.get_amount() < 2)
				return
			user.visible_message("<span class='notice'>[user] plates [src] with bronze!</span>", "<span class='notice'>You construct a bronze wall.</span>")
			B.use(2)
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/bronze)
			qdel(src)

	else
		return ..()
