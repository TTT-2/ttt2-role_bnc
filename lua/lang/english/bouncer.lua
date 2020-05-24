L = LANG.GetLanguageTableReference("english")

-- GENERAL ROLE LANGUAGE STRINGS
L[BOUNCER.name] = "Bouncer"
L["info_popup_" .. BOUNCER.name] = [[You're a Bouncer. Doors seem to attrackt you.
Sneak or duck to become invisible and manipulate the doors on the map for other players.
You have to walk slowly to use your special weapons (default: Alt key).]]
L["body_found_" .. BOUNCER.abbr] = "They were a Bouncer!"
L["search_role_" .. BOUNCER.abbr] = "This person was a Bouncer"
L["target_" .. BOUNCER.name] = "Bouncer"
L["ttt2_desc_" .. BOUNCER.name] = [[The Bouncer plays in the traitor team. He has a special appreciation for doors.]]

-- OTHER ROLE LANGUAGE STRINGS
L["weapon_doorghost_name"] = "Door's Ghost"
L["weapon_doorghost_desc"] = "Use this on doors to infect them with the evil spirit of the Door's Ghost."
L["doorghost_help_msb1"] = "{primaryfire} infects the door with the ghost"
L["doorghost_help_msb2"] = "{secondaryfire} removes the ghost from the door"
L["doorghost_not_hauntable"] = "This door can't be haunted."
L["doorghost_already_haunted"] = "This door is already haunted."
L["doorghost_is_locked"] = "This door can't be haunted becaused it's locked."
L["doorghost_now_haunted"] = "This door is now haunted."
L["doorghost_not_haunted"] = "This door is not haunted."
L["doorghost_now_unhaunted"] = "This door isn't haunted anymore."
L["door_is_haunted"] = "This door is haunted"
