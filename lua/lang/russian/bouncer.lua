L = LANG.GetLanguageTableReference("Русский")

-- GENERAL ROLE LANGUAGE STRINGS
L[BOUNCER.name] = "Вышибала"
L["info_popup_" .. BOUNCER.name] = [[Вы вышибала. Двери, кажется, привлекают тебя.
Крадитесь или присядьте, чтобы стать невидимым и управлять дверями на карте для других игроков.
Вы должны идти медленно, чтобы использовать свое специальное оружие (по умолчанию: клавиша Alt).]]
L["body_found_" .. BOUNCER.abbr] = "Он был вышибалой!"
L["search_role_" .. BOUNCER.abbr] = "Этот человек был вышибалой"
L["target_" .. BOUNCER.name] = "Вышибала"
L["ttt2_desc_" .. BOUNCER.name] = [[Вышибала играет в команде предателей. Он особенно ценит двери.]]

-- OTHER ROLE LANGUAGE STRINGS
L["weapon_doorghost_name"] = "Призрак двери"
L["weapon_doorghost_desc"] = "Используйте это на дверях, чтобы заразить их злым духом дверного призрака."
L["doorghost_help_msb1"] = "{primaryfire} заражает дверь призраком"
L["doorghost_help_msb2"] = "{secondaryfire} убирает призрака из двери"
L["doorghost_not_hauntable"] = "Эту дверь нельзя заразить призраком."
L["doorghost_already_haunted"] = "В этой двери уже есть призраки."
L["doorghost_is_locked"] = "Эту дверь нельзя заразить призраком, потому что она заперта."
L["doorghost_now_haunted"] = "В этой двери теперь есть призрак."
L["doorghost_not_haunted"] = "В этой двери нет призраков."
L["doorghost_now_unhaunted"] = "В этой двери больше нет призраков."
L["door_is_haunted"] = "В этой двери есть призрак"
