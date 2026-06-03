## Executive Summary

### Function Documentation
- **Total Functions:** 634
- **Documented:** 0 (0.0%)
- **Missing Functions:** 634 unique (634 total occurrences)
  - **Library Functions:** 455
  - **Hook Functions:** 179
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 440 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 440

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 3 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 215
- **Used Net Messages:** 214
- **Defined But Unused:** 1
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 2
- **Undefined Inferred Localization Keys:** 557

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 42
- **Missing Documentation:** 634 unique functions

### Missing Library Functions
Total: 455 functions

#### lia
Count: 6 functions

- `lia.bootstrap(section, msg)`
- `lia.debug(...)`
- `lia.error(msg)`
- `lia.information(msg)`
- `lia.relaydiscordMessage(embed)`
- `lia.warning(msg)`

#### lia.admin
Count: 24 functions

- `lia.admin.addPermission(groupName, permission, silent)`
- `lia.admin.applyInheritance(groupName)`
- `lia.admin.applyPunishment(client, infraction, kick, ban, time, kickKey, banKey)`
- `lia.admin.createGroup(groupName, info)`
- `lia.admin.execCommand(cmd, victim, dur, reason)`
- `lia.admin.getCommandPrivilegeID(cmd)`
- `lia.admin.getExternalPrivilegeName(id)`
- `lia.admin.hasAccess(ply, privilege)`
- `lia.admin.hasChanges()`
- `lia.admin.isProtectedStaffTarget(cmd, target)`
- `lia.admin.load()`
- `lia.admin.normalizePrivilege(privilege)`
- `lia.admin.notifyAdmin(notification)`
- `lia.admin.notifyProtectedStaffTarget(admin)`
- `lia.admin.registerPrivilege(priv)`
- `lia.admin.removeGroup(groupName)`
- `lia.admin.removePermission(groupName, permission, silent)`
- `lia.admin.renameGroup(oldName, newName)`
- `lia.admin.save(noNetwork)`
- `lia.admin.serverExecCommand(cmd, victim, dur, reason, admin)`
- `lia.admin.setPlayerUsergroup(ply, newGroup, source)`
- `lia.admin.setSteamIDUsergroup(steamId, newGroup, source)`
- `lia.admin.sync(c)`
- `lia.admin.unregisterPrivilege(id)`

#### lia.attribs
Count: 3 functions

- `lia.attribs.loadFromDir(directory)`
- `lia.attribs.register(uniqueID, data)`
- `lia.attribs.setup(client)`

#### lia.bar
Count: 6 functions

- `lia.bar.add(getValue, color, priority, identifier)`
- `lia.bar.drawAction(text, duration)`
- `lia.bar.drawAll()`
- `lia.bar.drawBar(x, y, w, h, pos, max, color)`
- `lia.bar.get(identifier)`
- `lia.bar.remove(identifier)`

#### lia.char
Count: 22 functions

- `lia.char.addCharacter(id, character)`
- `lia.char.cleanUpForPlayer(client)`
- `lia.char.create(data, callback)`
- `lia.char.delete(id, client)`
- `lia.char.getAll()`
- `lia.char.getBySteamID(steamID)`
- `lia.char.getCharBanned(charID)`
- `lia.char.getCharData(charID, key)`
- `lia.char.getCharDataRaw(charID, key)`
- `lia.char.getCharacter(charID, client, callback)`
- `lia.char.getOwnerByID(ID)`
- `lia.char.getTeamColor(client)`
- `lia.char.hookVar(varName, hookName, func)`
- `lia.char.isLoaded(charID)`
- `lia.char.loadSingleCharacter(charID, client, callback)`
- `lia.char.new(data, id, client, steamID)`
- `lia.char.registerVar(key, data)`
- `lia.char.removeCharacter(id)`
- `lia.char.restore(client, callback, id)`
- `lia.char.setCharDatabase(charID, field, value)`
- `lia.char.unloadCharacter(charID)`
- `lia.char.unloadUnusedCharacters(client, activeCharID)`

#### lia.chat
Count: 4 functions

- `lia.chat.parse(client, message, noSend)`
- `lia.chat.register(chatType, data)`
- `lia.chat.send(speaker, chatType, text, anonymous, receivers)`
- `lia.chat.timestamp(ooc)`

#### lia.class
Count: 11 functions

- `lia.class.canBe(client, class)`
- `lia.class.get(identifier)`
- `lia.class.getBodygroups(class)`
- `lia.class.getMergedBodygroups(character)`
- `lia.class.getPlayerCount(class)`
- `lia.class.getPlayers(class)`
- `lia.class.hasWhitelist(class)`
- `lia.class.loadFromDir(directory)`
- `lia.class.register(uniqueID, data)`
- `lia.class.retrieveClass(class)`
- `lia.class.retrieveJoinable(client)`

#### lia.color
Count: 16 functions

- `lia.color.adjust(color, rOffset, gOffset, bOffset, aOffset)`
- `lia.color.applyTheme(themeName, useTransition)`
- `lia.color.calculateNegativeColor(mainColor)`
- `lia.color.darken(color, factor)`
- `lia.color.getAllThemes()`
- `lia.color.getCurrentTheme()`
- `lia.color.getCurrentThemeName()`
- `lia.color.getMainColor()`
- `lia.color.isColor(v)`
- `lia.color.isTransitionActive()`
- `lia.color.lerp(frac, col1, col2)`
- `lia.color.register(name, color)`
- `lia.color.registerTheme(name, themeData)`
- `lia.color.returnMainAdjustedColors()`
- `lia.color.startThemeTransition(name)`
- `lia.color.testThemeTransition(themeName)`

#### lia.command
Count: 8 functions

- `lia.command.add(command, data)`
- `lia.command.buildSyntaxFromArguments(args)`
- `lia.command.extractArgs(text)`
- `lia.command.hasAccess(client, command, data)`
- `lia.command.openArgumentPrompt(cmdKey, missing, prefix, definitions)`
- `lia.command.parse(client, text, realCommand, arguments)`
- `lia.command.run(client, command, arguments)`
- `lia.command.send(command, ...)`

#### lia.config
Count: 14 functions

- `lia.config.add(key, name, value, callback, data)`
- `lia.config.forceSet(key, value, noSave)`
- `lia.config.get(key, default)`
- `lia.config.getChangedValues(includeDefaults)`
- `lia.config.getDisplayCategory(key)`
- `lia.config.getDisplayDesc(key)`
- `lia.config.getDisplayName(key)`
- `lia.config.getOptions(key)`
- `lia.config.load()`
- `lia.config.reset()`
- `lia.config.save()`
- `lia.config.send(client)`
- `lia.config.set(key, value)`
- `lia.config.setDefault(key, value)`

#### lia.currency
Count: 2 functions

- `lia.currency.get(amount)`
- `lia.currency.spawn(pos, amount, angle)`

#### lia.darkrp
Count: 7 functions

- `lia.darkrp.createCategory()`
- `lia.darkrp.createEntity(name, data)`
- `lia.darkrp.findEmptyPos(startPos, entitiesToIgnore, maxDistance, searchStep, checkArea)`
- `lia.darkrp.formatMoney(amount)`
- `lia.darkrp.isEmpty(position, entitiesToIgnore)`
- `lia.darkrp.notify(client, notifyType, duration, message)`
- `lia.darkrp.textWrap(text, fontName, maxLineWidth)`

#### lia.data
Count: 16 functions

- `lia.data.addEquivalencyMap(map1, map2)`
- `lia.data.decode(value)`
- `lia.data.decodeAngle(raw)`
- `lia.data.decodeVector(raw)`
- `lia.data.delete(key, global, ignoreMap)`
- `lia.data.deserialize(raw)`
- `lia.data.encodetable(value)`
- `lia.data.get(key, default)`
- `lia.data.getEquivalencyMap(map)`
- `lia.data.getPersistence()`
- `lia.data.loadPersistence()`
- `lia.data.loadPersistenceData(callback)`
- `lia.data.loadTables()`
- `lia.data.savePersistence(entities)`
- `lia.data.serialize(value)`
- `lia.data.set(key, value, global, ignoreMap)`

#### lia.db
Count: 30 functions

- `lia.db.addDatabaseFields()`
- `lia.db.bulkInsert(dbTable, rows)`
- `lia.db.bulkUpsert(dbTable, rows)`
- `lia.db.connect(callback, reconnect)`
- `lia.db.convertDataType(value, noEscape)`
- `lia.db.count(dbTable, condition)`
- `lia.db.createColumn(tableName, columnName, columnType, defaultValue)`
- `lia.db.createSnapshot(tableName)`
- `lia.db.createTable(dbName, primaryKey, schema)`
- `lia.db.delete(dbTable, condition)`
- `lia.db.escapeIdentifier(id)`
- `lia.db.exists(dbTable, condition)`
- `lia.db.fieldExists(tbl, field)`
- `lia.db.getCharacterTable(callback)`
- `lia.db.getTables()`
- `lia.db.insertOrIgnore(value, dbTable)`
- `lia.db.insertTable(value, callback, dbTable)`
- `lia.db.loadSnapshot(fileName)`
- `lia.db.loadTables()`
- `lia.db.removeColumn(tableName, columnName)`
- `lia.db.removeTable(tableName)`
- `lia.db.select(fields, dbTable, condition, limit)`
- `lia.db.selectOne(fields, dbTable, condition)`
- `lia.db.selectWithCondition(fields, dbTable, conditions, limit, orderBy)`
- `lia.db.tableExists(tbl)`
- `lia.db.transaction(queries)`
- `lia.db.updateTable(value, callback, dbTable, condition)`
- `lia.db.upsert(value, dbTable)`
- `lia.db.waitForTablesToLoad()`
- `lia.db.wipeTables(callback)`

#### lia.derma
Count: 48 functions

- `lia.derma.animateAppearance(panel, targetWidth, targetHeight, duration, alphaDuration, callback, scaleFactor)`
- `lia.derma.approachExp(current, target, speed, dt)`
- `lia.derma.circle(x, y, r)`
- `lia.derma.clampMenuPosition(panel)`
- `lia.derma.createTableUI(title, columns, data, options, charID)`
- `lia.derma.dermaMenu()`
- `lia.derma.draw(radius, x, y, w, h, col, flags)`
- `lia.derma.drawBlackBlur(panel, amount, passes, alpha, darkAlpha)`
- `lia.derma.drawBlur(panel, amount, passes, alpha)`
- `lia.derma.drawBlurAt(x, y, w, h, amount, passes, alpha)`
- `lia.derma.drawBoxWithText(text, x, y, options)`
- `lia.derma.drawCircle(x, y, radius, col, flags)`
- `lia.derma.drawCircleMaterial(x, y, radius, col, mat, flags)`
- `lia.derma.drawCircleOutlined(x, y, radius, col, thickness, flags)`
- `lia.derma.drawCircleTexture(x, y, radius, col, texture, flags)`
- `lia.derma.drawEntText(ent, text, posY, alphaOverride)`
- `lia.derma.drawGradient(x, y, w, h, direction, colorShadow, radius, flags)`
- `lia.derma.drawMaterial(radius, x, y, w, h, col, mat, flags)`
- `lia.derma.drawOutlined(radius, x, y, w, h, col, thickness, flags)`
- `lia.derma.drawShadows(radius, x, y, w, h, col, spread, intensity, flags)`
- `lia.derma.drawShadowsEx(x, y, w, h, col, flags, tl, tr, bl, br, spread, intensity, thickness)`
- `lia.derma.drawShadowsOutlined(radius, x, y, w, h, col, thickness, spread, intensity, flags)`
- `lia.derma.drawSurfaceTexture(material, color, x, y, w, h)`
- `lia.derma.drawText(text, x, y, color, alignX, alignY, font, alpha)`
- `lia.derma.drawTextOutlined(text, font, x, y, colour, xalign, outlinewidth, outlinecolour)`
- `lia.derma.drawTexture(radius, x, y, w, h, col, texture, flags)`
- `lia.derma.drawTip(x, y, w, h, text, font, textCol, outlineCol)`
- `lia.derma.easeInOutCubic(t)`
- `lia.derma.easeOutCubic(t)`
- `lia.derma.interactionTooltip(rawOptions, config)`
- `lia.derma.openOptionsMenu(title, options)`
- `lia.derma.optionsMenu(rawOptions, config)`
- `lia.derma.radialMenu(options)`
- `lia.derma.rect(x, y, w, h)`
- `lia.derma.requestArguments(title, argTypes, onSubmit, defaults)`
- `lia.derma.requestBinaryQuestion(title, question, callback, yesText, noText)`
- `lia.derma.requestButtons(title, buttons, callback, description)`
- `lia.derma.requestColorPicker(func, colorStandard)`
- `lia.derma.requestDropdown(title, options, callback, defaultValue)`
- `lia.derma.requestOptions(title, subTitle, options, callback, onCancel)`
- `lia.derma.requestPlayerSelector(doClick)`
- `lia.derma.requestPopupQuestion(question, buttons)`
- `lia.derma.requestString(title, description, callback, defaultValue, maxLength)`
- `lia.derma.setDefaultShape(shape)`
- `lia.derma.setFlag(flags, flag, bool)`
- `lia.derma.shadowText(text, font, x, y, colortext, colorshadow, dist, xalign, yalign)`
- `lia.derma.skinFunc(name, panel, a, b, c, d, e, f, g)`
- `lia.derma.wrapText(text, width, font)`

#### lia.dialog
Count: 14 functions

- `lia.dialog.getAvailableConfigurations(ply, npc, npcID)`
- `lia.dialog.getConfiguration(uniqueID)`
- `lia.dialog.getNPCData(npcID)`
- `lia.dialog.getOriginalNPCData(npcID)`
- `lia.dialog.isTableEqual(tbl1, tbl2, checked)`
- `lia.dialog.openConfigurationPicker(npc, npcID)`
- `lia.dialog.openCustomizationUI(npc, configID)`
- `lia.dialog.openDialog(client, npc, npcID)`
- `lia.dialog.registerConfiguration(uniqueID, data)`
- `lia.dialog.registerNPC(uniqueID, data, shouldSync)`
- `lia.dialog.resolveDialogTypeIdentifier(value)`
- `lia.dialog.submitConfiguration(configID, npc, payload)`
- `lia.dialog.syncDialogs()`
- `lia.dialog.syncToClients(client)`

#### lia.doors
Count: 12 functions

- `lia.doors.addPreset(mapName, presetData)`
- `lia.doors.cleanupCorruptedData()`
- `lia.doors.getCachedData(door)`
- `lia.doors.getData(door)`
- `lia.doors.getDoorDefaultValues()`
- `lia.doors.getPreset(mapName)`
- `lia.doors.setCachedData(door, data)`
- `lia.doors.setData(door, data)`
- `lia.doors.syncAllDoorsToClient(client)`
- `lia.doors.syncDoorData(door)`
- `lia.doors.updateCachedData(doorID, data)`
- `lia.doors.verifyDatabaseSchema()`

#### lia.faction
Count: 22 functions

- `lia.faction.cacheModels(models)`
- `lia.faction.formatModelData()`
- `lia.faction.get(identifier)`
- `lia.faction.getAll()`
- `lia.faction.getBodygroupNameToIndex(modelPath)`
- `lia.faction.getBodygroupWhitelistRule(faction, modelPath, bodygroupIndex, bodygroupName)`
- `lia.faction.getCategories(teamName)`
- `lia.faction.getClasses(faction)`
- `lia.faction.getDefaultAllowedSkinForFaction(faction, fallback)`
- `lia.faction.getDefaultClass(id)`
- `lia.faction.getIndex(uniqueID)`
- `lia.faction.getModelCustomizationAllowed(client, faction, context)`
- `lia.faction.getModelsFromCategory(teamName, category)`
- `lia.faction.getPlayerCount(faction)`
- `lia.faction.getPlayers(faction)`
- `lia.faction.hasWhitelist(faction)`
- `lia.faction.isBodygroupValueAllowed(faction, modelPath, bodygroupIndex, value, bodygroupName)`
- `lia.faction.isFactionCategory(faction, categoryFactions)`
- `lia.faction.isSkinAllowedForFaction(faction, skin)`
- `lia.faction.jobGenerate(index, name, color, default, models)`
- `lia.faction.loadFromDir(directory)`
- `lia.faction.register(uniqueID, data)`

#### lia.flag
Count: 2 functions

- `lia.flag.add(flag, desc, callback)`
- `lia.flag.onSpawn(client)`

#### lia.font
Count: 5 functions

- `lia.font.getAvailableFonts()`
- `lia.font.getBoldFontName(fontName)`
- `lia.font.loadFonts()`
- `lia.font.register(fontName, fontData)`
- `lia.font.registerFonts(fontName)`

#### lia.inventory
Count: 17 functions

- `lia.inventory.checkOverflow(inv, character, oldW, oldH)`
- `lia.inventory.cleanUpForCharacter(character)`
- `lia.inventory.deleteByID(id)`
- `lia.inventory.getAllStorage(includeTrunks)`
- `lia.inventory.getAllTrunks()`
- `lia.inventory.getStorage(model)`
- `lia.inventory.getTrunk(vehicleClass)`
- `lia.inventory.instance(typeID, initialData)`
- `lia.inventory.loadAllFromCharID(charID)`
- `lia.inventory.loadByID(id, noCache)`
- `lia.inventory.loadFromDefaultStorage(id, noCache)`
- `lia.inventory.new(typeID)`
- `lia.inventory.newType(typeID, invTypeStruct)`
- `lia.inventory.registerStorage(model, data)`
- `lia.inventory.registerTrunk(vehicleClass, data)`
- `lia.inventory.show(inventory, parent)`
- `lia.inventory.showDual(inventory1, inventory2, parent)`

#### lia.item
Count: 30 functions

- `lia.item.addRarities(name, color)`
- `lia.item.addWeaponOverride(className, data)`
- `lia.item.addWeaponToBlacklist(className)`
- `lia.item.applyRuntimeOverridePath(wepTable, dotPath, value)`
- `lia.item.applyWeaponOverride(uniqueID)`
- `lia.item.createInv(w, h, id)`
- `lia.item.deleteByID(id)`
- `lia.item.get(identifier)`
- `lia.item.getInstancedItemByID(itemID)`
- `lia.item.getInv(invID)`
- `lia.item.getItemByID(itemID)`
- `lia.item.getItemDataByID(itemID)`
- `lia.item.getRuntimeValue(wepTable, dotPath)`
- `lia.item.instance(index, uniqueID, itemData, x, y, callback)`
- `lia.item.isItem(object)`
- `lia.item.load(path, baseID, isBaseItem)`
- `lia.item.loadFromDir(directory)`
- `lia.item.loadItemByID(itemIndex)`
- `lia.item.loadWeaponOverrides()`
- `lia.item.loadWeaponRuntimeOverrides()`
- `lia.item.localizeDefinition(itemDef)`
- `lia.item.new(uniqueID, id)`
- `lia.item.newInv(owner, invType, callback)`
- `lia.item.overrideItem(uniqueID, overrides)`
- `lia.item.register(uniqueID, baseID, isBaseItem, path, luaGenerated)`
- `lia.item.registerInv(invType, w, h)`
- `lia.item.registerItem(id, base, properties)`
- `lia.item.restoreInv(invID, w, h, callback)`
- `lia.item.setItemDataByID(itemID, key, value, receivers, noSave, noCheckEntity)`
- `lia.item.spawn(uniqueID, position, callback, angles, data)`

#### lia.keybind
Count: 8 functions

- `lia.keybind.add(k, d, desc, cb)`
- `lia.keybind.buildReservedKeys()`
- `lia.keybind.get(a, df)`
- `lia.keybind.getDisplayCategory(action)`
- `lia.keybind.getDisplayDescription(action)`
- `lia.keybind.isKeyReserved(keyCode)`
- `lia.keybind.load()`
- `lia.keybind.save()`

#### lia.lang
Count: 8 functions

- `lia.lang.addTable(name, tbl)`
- `lia.lang.cleanupCache()`
- `lia.lang.clearCache()`
- `lia.lang.generateCacheKey(lang, key, ...)`
- `lia.lang.getLanguages()`
- `lia.lang.getLocalizedString(key, ...)`
- `lia.lang.loadFromDir(directory)`
- `lia.lang.resolveToken(value, ...)`

#### lia.loader
Count: 6 functions

- `lia.loader.checkForUpdates()`
- `lia.loader.include(path, realm)`
- `lia.loader.includeDir(dir, raw, deep, realm)`
- `lia.loader.includeEntities(path)`
- `lia.loader.includeGroupedDir(dir, raw, recursive, forceRealm)`
- `lia.loader.initializeGamemode(isReload)`

#### lia.log
Count: 3 functions

- `lia.log.add(client, logType, ...)`
- `lia.log.addType(logType, func, category)`
- `lia.log.getString(client, logType, ...)`

#### lia.menu
Count: 4 functions

- `lia.menu.add(opts, pos, onRemove)`
- `lia.menu.drawAll()`
- `lia.menu.getActiveMenu()`
- `lia.menu.onButtonPressed(id, cb)`

#### lia.module
Count: 4 functions

- `lia.module.get(identifier)`
- `lia.module.initialize()`
- `lia.module.load(uniqueID, path, variable, skipSubmodules)`
- `lia.module.loadFromDir(directory, group, skip)`

#### lia.net
Count: 8 functions

- `lia.net.addToCache(name, args)`
- `lia.net.checkBadType(name, object)`
- `lia.net.getNetVar(key, default)`
- `lia.net.isCacheHit(name, args)`
- `lia.net.profiler.log(direction, messageName, size, sender, receiver)`
- `lia.net.readBigTable(netStr, callback)`
- `lia.net.setNetVar(key, value, receiver)`
- `lia.net.writeBigTable(targets, netStr, tbl, chunkSize)`

#### lia.notices
Count: 10 functions

- `lia.notices.notify(client, message, notifType)`
- `lia.notices.notifyAdminLocalized(client, key, ...)`
- `lia.notices.notifyErrorLocalized(client, key, ...)`
- `lia.notices.notifyInfoLocalized(client, key, ...)`
- `lia.notices.notifyLocalized(client, key, notifType, ...)`
- `lia.notices.notifyMoneyLocalized(client, key, ...)`
- `lia.notices.notifySuccessLocalized(client, key, ...)`
- `lia.notices.notifyWarningLocalized(client, key, ...)`
- `lia.notices.receiveNotify()`
- `lia.notices.receiveNotifyL()`

#### lia.option
Count: 9 functions

- `lia.option.add(key, name, desc, default, callback, data)`
- `lia.option.get(key, default)`
- `lia.option.getDisplayCategory(key)`
- `lia.option.getDisplayDesc(key)`
- `lia.option.getDisplayName(key)`
- `lia.option.getOptions(key)`
- `lia.option.load()`
- `lia.option.save()`
- `lia.option.set(key, value)`

#### lia.playerinteract
Count: 9 functions

- `lia.playerinteract.addAction(name, data)`
- `lia.playerinteract.addInteraction(name, data)`
- `lia.playerinteract.getActions(client)`
- `lia.playerinteract.getCategorizedOptions(options)`
- `lia.playerinteract.getInteractions(client)`
- `lia.playerinteract.hasChanges()`
- `lia.playerinteract.isWithinRange(client, entity, customRange)`
- `lia.playerinteract.openMenu(options, isInteraction, titleText, closeKey, netMsg, preFiltered)`
- `lia.playerinteract.sync(client)`

#### lia.time
Count: 5 functions

- `lia.time.formatDHM(seconds)`
- `lia.time.getDate()`
- `lia.time.getHour()`
- `lia.time.timeSince(strTime)`
- `lia.time.toNumber(str)`

#### lia.util
Count: 40 functions

- `lia.util.animateAppearance(panel, targetWidth, targetHeight, duration, alphaDuration, callback, scaleFactor)`
- `lia.util.applyBodygroups(target, bodygroups)`
- `lia.util.canFit(pos, mins, maxs, filter)`
- `lia.util.clampMenuPosition(panel)`
- `lia.util.createTableUI(title, columns, data, options, charID)`
- `lia.util.drawBlackBlur(panel, amount, passes, alpha, darkAlpha)`
- `lia.util.drawBlur(panel, amount, passes, alpha)`
- `lia.util.drawBlurAt(x, y, w, h, amount, passes, alpha)`
- `lia.util.drawESPStyledText(text, x, y, espColor, font, fadeAlpha)`
- `lia.util.drawEntText(ent, text, posY, alphaOverride)`
- `lia.util.drawGradient(x, y, w, h, direction, colorShadow, radius, flags)`
- `lia.util.drawLookText(text, posY, alphaOverride, maxDist)`
- `lia.util.findEmptySpace(entity, filter, spacing, size, height, tolerance)`
- `lia.util.findFaction(client, name)`
- `lia.util.findPlayer(client, identifier)`
- `lia.util.findPlayerBySteamID(SteamID)`
- `lia.util.findPlayerBySteamID64(SteamID64)`
- `lia.util.findPlayerEntities(client, class)`
- `lia.util.findPlayerItems(client)`
- `lia.util.findPlayerItemsByClass(client, class)`
- `lia.util.findPlayersInBox(mins, maxs)`
- `lia.util.findPlayersInSphere(origin, radius)`
- `lia.util.formatStringNamed(format, ...)`
- `lia.util.generateRandomName(firstNames, lastNames)`
- `lia.util.getAdmins()`
- `lia.util.getBySteamID(steamID)`
- `lia.util.getMaterial(materialPath, materialParameters)`
- `lia.util.normalizeBodygroupKey(key)`
- `lia.util.normalizeBodygroups(bodygroups)`
- `lia.util.openOptionsMenu(title, options)`
- `lia.util.playerInRadius(pos, dist)`
- `lia.util.removeFeaturePosition(pos, typeId)`
- `lia.util.requestEntityInformation(client, entity, argTypes, callback)`
- `lia.util.resolveBodygroupIndex(target, identifier)`
- `lia.util.resolveBodygroups(target, bodygroups)`
- `lia.util.sendTableUI(client, title, columns, data, options, characterID)`
- `lia.util.setFeaturePosition(pos, typeId)`
- `lia.util.setPositionCallback(name, data)`
- `lia.util.stringMatches(a, b)`
- `lia.util.wrapText(text, width, font)`

#### lia.vendor
Count: 6 functions

- `lia.vendor.addPreset(name, items)`
- `lia.vendor.getAllVendorData(entity)`
- `lia.vendor.getPreset(name)`
- `lia.vendor.getVendorProperty(entity, property)`
- `lia.vendor.setVendorProperty(entity, property, value)`
- `lia.vendor.syncVendorProperty(entity, property, value, isDefault)`

#### lia.webimage
Count: 5 functions

- `lia.webimage.clearCache(skipReRegister)`
- `lia.webimage.download(n, u, cb, flags)`
- `lia.webimage.get(n, flags)`
- `lia.webimage.getStats()`
- `lia.webimage.register(n, u, cb, flags)`

#### lia.websound
Count: 6 functions

- `lia.websound.clearCache(skipReRegister)`
- `lia.websound.download(name, url, cb)`
- `lia.websound.get(name)`
- `lia.websound.getStats()`
- `lia.websound.playButtonSound(customSound, callback)`
- `lia.websound.register(name, url, cb)`

#### lia.workshop
Count: 5 functions

- `lia.workshop.addWorkshop(id)`
- `lia.workshop.gather()`
- `lia.workshop.hasContentToDownload()`
- `lia.workshop.mountContent()`
- `lia.workshop.send(ply)`

### Missing Hook Functions
Total: 179 functions

- `characterMeta:addBoost(boostID, attribID, boostAmount)`
- `characterMeta:ban(time)`
- `characterMeta:clearAllBoosts()`
- `characterMeta:delete()`
- `characterMeta:destroy()`
- `characterMeta:doesFakeRecognize(id)`
- `characterMeta:doesRecognize(id)`
- `characterMeta:getAttrib(key, default)`
- `characterMeta:getData(key, default)`
- `characterMeta:getDisplayedName(client)`
- `characterMeta:getID()`
- `characterMeta:getPlayer()`
- `characterMeta:giveFlags(flags)`
- `characterMeta:giveMoney(amount)`
- `characterMeta:hasFlags(flagStr)`
- `characterMeta:hasMoney(amount)`
- `characterMeta:isBanned()`
- `characterMeta:isMainCharacter()`
- `characterMeta:joinClass(class, isForced)`
- `characterMeta:kick()`
- `characterMeta:kickClass()`
- `characterMeta:recognize(character, name)`
- `characterMeta:removeBoost(boostID, attribID)`
- `characterMeta:save(callback)`
- `characterMeta:setAttrib(key, value)`
- `characterMeta:setData(k, v, noReplication, receiver)`
- `characterMeta:setFlags(flags)`
- `characterMeta:setup(noNetworking)`
- `characterMeta:sync(receiver)`
- `characterMeta:takeFlags(flags)`
- `characterMeta:takeMoney(amount)`
- `characterMeta:updateAttrib(key, value)`
- `entityMeta:EmitSound(soundName, soundLevel, pitchPercent, volume, channel, flags, dsp)`
- `entityMeta:checkDoorAccess(client, access)`
- `entityMeta:clearNetVars(receiver)`
- `entityMeta:getDoorOwner()`
- `entityMeta:getDoorPartner()`
- `entityMeta:getLocalVar(key, default)`
- `entityMeta:getNetVar(key, default)`
- `entityMeta:isDoor()`
- `entityMeta:isDoorLocked()`
- `entityMeta:isFemale()`
- `entityMeta:isItem()`
- `entityMeta:isLocked()`
- `entityMeta:isMoney()`
- `entityMeta:isProp()`
- `entityMeta:isSimfphysCar()`
- `entityMeta:keysLock()`
- `entityMeta:keysOwn(client)`
- `entityMeta:keysUnLock()`
- `entityMeta:playFollowingSound(soundPath, volume, shouldFollow, maxDistance, startDelay, minDistance, pitch, soundLevel, dsp)`
- `entityMeta:removeDoorAccessData()`
- `entityMeta:sendNetVar(key, receiver)`
- `entityMeta:setKeysNonOwnable(state)`
- `entityMeta:setLocalVar(key, value)`
- `entityMeta:setLocked(state)`
- `entityMeta:setNetVar(key, value, receiver)`
- `panelMeta:AvatarMask(mask)`
- `panelMeta:Background(col, rad, rtl, rtr, rbl, rbr)`
- `panelMeta:BarHover(col, height, speed)`
- `panelMeta:Blur(amount)`
- `panelMeta:Circle(col)`
- `panelMeta:CircleAvatar()`
- `panelMeta:CircleCheckbox(inner, outer, speed)`
- `panelMeta:CircleClick(col, speed, trad)`
- `panelMeta:CircleExpandHover(col, speed)`
- `panelMeta:CircleFadeHover(col, speed)`
- `panelMeta:CircleHover(col, speed, trad)`
- `panelMeta:ClearAppendOverwrite()`
- `panelMeta:ClearPaint()`
- `panelMeta:ClearTransitionFunc()`
- `panelMeta:DivTall(frac, target)`
- `panelMeta:DivWide(frac, target)`
- `panelMeta:DualText(toptext, topfont, topcol, bottomtext, bottomfont, bottomcol, alignment, centerSpacing)`
- `panelMeta:FadeHover(col, speed, rad)`
- `panelMeta:FadeIn(time, alpha)`
- `panelMeta:FillHover(col, dir, speed, mat)`
- `panelMeta:Gradient(col, dir, frac, op)`
- `panelMeta:HideVBar()`
- `panelMeta:LinedCorners(col, cornerLen)`
- `panelMeta:Material(mat, col)`
- `panelMeta:NetMessage(name, data)`
- `panelMeta:On(name, fn)`
- `panelMeta:Outline(col, width)`
- `panelMeta:ReadyTextbox()`
- `panelMeta:SetAppendOverwrite(fn)`
- `panelMeta:SetOpenURL(url)`
- `panelMeta:SetRemove(target)`
- `panelMeta:SetTransitionFunc(fn)`
- `panelMeta:SetupTransition(name, speed, fn)`
- `panelMeta:SideBlock(col, size, side)`
- `panelMeta:SquareCheckbox(inner, outer, speed)`
- `panelMeta:SquareFromHeight()`
- `panelMeta:SquareFromWidth()`
- `panelMeta:Stick(dock, margin, dontInvalidate)`
- `panelMeta:Text(text, font, col, alignment, ox, oy, paint)`
- `panelMeta:TiledMaterial(mat, tw, th, col)`
- `panelMeta:liaDeleteInventoryHooks(id)`
- `panelMeta:liaListenForInventoryChanges(inventory)`
- `panelMeta:setScaledPos(x, y)`
- `panelMeta:setScaledSize(w, h)`
- `playerMeta:Name()`
- `playerMeta:addMoney(amount)`
- `playerMeta:addPart(partID)`
- `playerMeta:banPlayer(reason, duration, banner)`
- `playerMeta:canAfford(amount)`
- `playerMeta:canEditVendor(vendor)`
- `playerMeta:consumeStamina(amount)`
- `playerMeta:createRagdoll(freeze)`
- `playerMeta:doGesture(a, b, c)`
- `playerMeta:doStaredAction(entity, callback, time, onCancel, distance)`
- `playerMeta:getAllLiliaData()`
- `playerMeta:getChar()`
- `playerMeta:getClassData()`
- `playerMeta:getDarkRPVar(var)`
- `playerMeta:getFlags()`
- `playerMeta:getItemDropPos()`
- `playerMeta:getItemWeapon()`
- `playerMeta:getItems()`
- `playerMeta:getLiliaData(key, default)`
- `playerMeta:getLocalVar(key, default)`
- `playerMeta:getMainCharacter()`
- `playerMeta:getMoney()`
- `playerMeta:getParts()`
- `playerMeta:getPlayTime()`
- `playerMeta:getRagdoll()`
- `playerMeta:getTracedEntity(distance)`
- `playerMeta:giveFlags(flags)`
- `playerMeta:hasFlags(flags)`
- `playerMeta:hasPrivilege(privilegeName)`
- `playerMeta:hasSkillLevel(skill, level)`
- `playerMeta:hasWhitelist(faction)`
- `playerMeta:isFamilySharedAccount()`
- `playerMeta:isStaff()`
- `playerMeta:isStaffOnDuty()`
- `playerMeta:isStuck()`
- `playerMeta:loadLiliaData(callback)`
- `playerMeta:meetsRequiredSkills(requiredSkillLevels)`
- `playerMeta:networkAnimation(active, boneData)`
- `playerMeta:notify(message, notifType)`
- `playerMeta:notifyAdmin(message)`
- `playerMeta:notifyAdminLocalized(key, ...)`
- `playerMeta:notifyError(message)`
- `playerMeta:notifyErrorLocalized(key, ...)`
- `playerMeta:notifyInfo(message)`
- `playerMeta:notifyInfoLocalized(key, ...)`
- `playerMeta:notifyLocalized(message, notifType, ...)`
- `playerMeta:notifyMoney(message)`
- `playerMeta:notifyMoneyLocalized(key, ...)`
- `playerMeta:notifySuccess(message)`
- `playerMeta:notifySuccessLocalized(key, ...)`
- `playerMeta:notifyWarning(message)`
- `playerMeta:notifyWarningLocalized(key, ...)`
- `playerMeta:playTimeGreaterThan(time)`
- `playerMeta:removePart(partID)`
- `playerMeta:removeRagdoll()`
- `playerMeta:requestArguments(title, argTypes, callback)`
- `playerMeta:requestBinaryQuestion(question, option1, option2, manualDismiss, callback)`
- `playerMeta:requestButtons(title, buttons)`
- `playerMeta:requestDropdown(title, subTitle, options, callback)`
- `playerMeta:requestOptions(title, subTitle, options, limit, callback, onCancel)`
- `playerMeta:requestPopupQuestion(question, buttons)`
- `playerMeta:requestString(title, subTitle, callback, default)`
- `playerMeta:resetParts()`
- `playerMeta:restoreStamina(amount)`
- `playerMeta:saveLiliaData()`
- `playerMeta:setAction(text, time, callback)`
- `playerMeta:setLiliaData(key, value, noNetworking, noSave)`
- `playerMeta:setLocalVar(key, value)`
- `playerMeta:setMainCharacter(charID)`
- `playerMeta:setNetVar(key, value)`
- `playerMeta:setRagdolled(state, time, getUpGrace)`
- `playerMeta:setWaypoint(name, vector, logo, onReach)`
- `playerMeta:stopAction()`
- `playerMeta:syncParts()`
- `playerMeta:syncVars()`
- `playerMeta:takeFlags(flags)`
- `playerMeta:takeMoney(amount)`
- `playerMeta:tostring()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 440 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 440
- **Unused Hooks:** 0 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `AddBarField(sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)`
- `AddReservedKeybinds(reserved)`
- `AddSection(sectionName, color, priority, location)`
- `AddTextField(sectionName, fieldName, labelText, valueFunc)`
- `AddToAdminStickHUD(client, target, information)`
- `AddWarning(charID, warned, warnedSteamID, timestamp, message, warner, warnerSteamID, severity)`
- `AdjustCreationData(client, data, newData, originalData)`
- `AdjustPACPartData(wearer, id, data)`
- `AdjustStaminaOffset(client, offset)`
- `AdminPrivilegesUpdated()`
- `AdminStickAddModels(allModList, tgt)`
- `AdvDupe_FinishPasting(tbl)`
- `AttachPart(client, id)`
- `BagInventoryReady(self, inventory)`
- `BagInventoryRemoved(self, inv)`
- `CanCharBeTransfered(tChar, faction, arg3)`
- `CanDeleteChar(client, character)`
- `CanDisplayCharInfo(name)`
- `CanDrawEntityHoverInfo(e, category)`
- `CanInviteToClass(client, target)`
- `CanInviteToFaction(client, target)`
- `CanItemBeTransfered(item, inventory, VendorInventoryMeasure, client)`
- `CanOpenBagPanel(item)`
- `CanOutfitChangeModel(self)`
- `CanPerformVendorEdit(self, vendor)`
- `CanPersistEntity(entity)`
- `CanPickupMoney(activator, self)`
- `CanPlayerAccessDoor(client, self, access)`
- `CanPlayerAccessVendor(client, vendor)`
- `CanPlayerChooseWeapon(weapon)`
- `CanPlayerCreateChar(client, data)`
- `CanPlayerDropItem(client, item)`
- `CanPlayerEarnSalary(client)`
- `CanPlayerEquipItem(client, item)`
- `CanPlayerHoldObject(client, entity)`
- `CanPlayerInteractItem(client, action, self, data)`
- `CanPlayerJoinClass(client, class, info)`
- `CanPlayerKnock(arg1)`
- `CanPlayerLock(client, door)`
- `CanPlayerModifyConfig(client, key)`
- `CanPlayerOpenScoreboard(arg1)`
- `CanPlayerRespawn(client, timePassed, baseTime, lastDeath)`
- `CanPlayerRotateItem(client, item)`
- `CanPlayerSeeLogCategory(client, category)`
- `CanPlayerSpawnStorage(client, entity, info)`
- `CanPlayerSwitchChar(client, currentCharacter, newCharacter)`
- `CanPlayerTakeItem(client, item)`
- `CanPlayerThrowPunch(client)`
- `CanPlayerTradeWithVendor(client, vendor, itemType, isSellingToVendor)`
- `CanPlayerUnequipItem(client, item)`
- `CanPlayerUnlock(client, door)`
- `CanPlayerUseAmmoBox(activator, self)`
- `CanPlayerUseChar(client, character)`
- `CanPlayerUseCommand(client, command)`
- `CanPlayerUseDoor(client, door)`
- `CanPlayerViewInventory()`
- `CanRunItemAction(tempItem, key)`
- `CanSaveData(ent, inventory)`
- `CanTakeEntity(client, targetEntity, itemUniqueID)`
- `CharCleanUp(character)`
- `CharDeleted(client, character)`
- `CharForceRecognized(ply, range)`
- `CharHasFlags(self, flags)`
- `CharListColumns(columns)`
- `CharListEntry(entry, row)`
- `CharListExtraDetails(client, entry, stored)`
- `CharListLoaded(newCharList)`
- `CharListUpdated(oldCharList, newCharList)`
- `CharLoaded(character)`
- `CharMenuClosed()`
- `CharMenuOpened(self)`
- `CharPostSave(self)`
- `CharPreSave(character)`
- `CharRestored(character)`
- `ChatAddText(text, ...)`
- `ChatParsed(client, chatType, message, anonymous)`
- `ChatboxPanelCreated(arg1)`
- `ChatboxTextAdded(arg1)`
- `CheckFactionLimitReached(faction, character, client)`
- `ChooseCharacter(id)`
- `CollectDoorDataFields(extras)`
- `CommandAdded(command, data)`
- `CommandRan(client, command, arg3, results)`
- `ConfigChanged(key, value, oldValue, client)`
- `ConfigureCharacterCreationSteps(self)`
- `CreateCharacter(data)`
- `CreateChatboxPanel()`
- `CreateDefaultInventory(character)`
- `CreateInformationButtons(pages)`
- `CreateInventoryPanel(inventory, parent)`
- `CreateMenuButtons(tabs)`
- `CreateSalaryTimers()`
- `DatabaseConnected()`
- `DeleteCharacter(id)`
- `DermaSkinChanged(newSkin)`
- `DiscordRelaySend(embed)`
- `DiscordRelayUnavailable()`
- `DiscordRelayed(embed)`
- `DisplayPlayerHUDInformation(client, hudInfos)`
- `DoModuleIncludes(path, MODULE)`
- `DoorDataReceived(door, syncData)`
- `DoorEnabledToggled(client, door, newState)`
- `DoorHiddenToggled(client, entity, newState)`
- `DoorLockToggled(client, door, state)`
- `DoorOwnableToggled(client, door, newState)`
- `DoorPriceSet(client, door, price)`
- `DoorTitleSet(client, door, name)`
- `DrawCharInfo(client, character, info)`
- `DrawEntityInfo(e, a, pos)`
- `DrawItemEntityInfo(self, item, infoTable, alpha)`
- `DrawLiliaModelView(client, entity)`
- `DrawPlayerInfoBackground(e, panelX, panelY, panelWidth, panelHeight, a)`
- `DrawPlayerRagdoll(entity)`
- `F1MenuClosed()`
- `F1MenuOpened(self)`
- `FetchSpawns()`
- `FilterCharModels(arg1)`
- `FilterDoorInfo(entity, doorData, doorInfo)`
- `ForceRecognizeRange(ply, range, fakeName)`
- `GetAdjustedPartData(wearer, id)`
- `GetAdminESPTarget(ent, client)`
- `GetAdminStickLists(tgt, lists)`
- `GetAllCaseClaims()`
- `GetAttributeMax(client, id)`
- `GetAttributeStartingMax(client, attribute)`
- `GetBotModel(client, faction)`
- `GetCharMaxStamina(char)`
- `GetCharacterCreateButtonTooltip(client, currentChars, maxChars)`
- `GetCharacterCreationSummary(arg1)`
- `GetCharacterDisconnectButtonTooltip(client)`
- `GetCharacterDiscordButtonTooltip(client, discordURL)`
- `GetCharacterLoadButtonTooltip(client)`
- `GetCharacterLoadMainButtonTooltip(client)`
- `GetCharacterMountButtonTooltip(client)`
- `GetCharacterReturnButtonTooltip(client)`
- `GetCharacterStaffButtonTooltip(client, hasStaffChar)`
- `GetCharacterWorkshopButtonTooltip(client, workshopURL)`
- `GetDamageScale(hitgroup, dmgInfo, damageScale)`
- `GetDefaultCharDesc(client, arg2, data)`
- `GetDefaultCharName(client, faction, data)`
- `GetDefaultInventorySize(client, char)`
- `GetDefaultInventoryType(character)`
- `GetDisplayedDescription(client, isHUD)`
- `GetDisplayedName(client, chatType)`
- `GetDoorInfo(entity, doorData, doorInfo)`
- `GetDoorInfoForAdminStick(target, extraInfo)`
- `GetEntitySaveData(ent)`
- `GetHandsAttackSpeed(arg1)`
- `GetInjuredText(c)`
- `GetInventoryMaxWeight(self, maxWeight)`
- `GetItemDropModel(itemTable, self)`
- `GetMainCharacterID()`
- `GetMainMenuPosition(character)`
- `GetMaxPlayerChar(client)`
- `GetMaxStartingAttributePoints(client, default)`
- `GetModelGender(model)`
- `GetMoneyModel(arg1)`
- `GetNPCDialogOptions(arg1)`
- `GetOOCDelay(speaker)`
- `GetPlayTime(self)`
- `GetPlayerDeathSound(client, isFemale)`
- `GetPlayerPainSound(client, paintype, isFemale)`
- `GetPlayerPunchDamage(arg1)`
- `GetPlayerPunchRagdollTime(arg1)`
- `GetPlayerRespawnLocation(client, character)`
- `GetPlayerSpawnLocation(client, character)`
- `GetPrestigePayBonus(client, char, pay, charFaction, class)`
- `GetPriceOverride(client, self, uniqueID, price, isSellingToVendor)`
- `GetRagdollTime(self, time)`
- `GetSalaryAmount(client, charFaction, class)`
- `GetWarnings(charID)`
- `GetWeaponName(wep)`
- `HandleItemTransferRequest(client, itemID, x, y, invID)`
- `InitializeStorage(entity)`
- `InitializedConfig()`
- `InitializedItems()`
- `InitializedKeybinds()`
- `InitializedModules()`
- `InitializedOptions()`
- `InitializedSchema()`
- `InteractionMenuClosed()`
- `InteractionMenuOpened(frame)`
- `InterceptClickItemIcon(self, itemIcon, keyCode)`
- `InventoryClosed(self, inventory)`
- `InventoryDataChanged(instance, key, oldValue, value)`
- `InventoryDeleted(instance)`
- `InventoryInitialized(instance)`
- `InventoryItemAdded(inventory, item)`
- `InventoryItemIconCreated(icon, item, self)`
- `InventoryItemRemoved(self, instance, preserveItem)`
- `InventoryOpened(panel, inventory)`
- `InventoryPanelCreated(panel, inventory, parent)`
- `IsCharFakeRecognized(character, id)`
- `IsCharRecognized(a, arg2)`
- `IsCharacterCreationOverridden()`
- `IsRecognizedChatType(chatType)`
- `IsSuitableForTrunk(ent)`
- `ItemCombine(client, item, target)`
- `ItemDataChanged(item, key, oldValue, newValue)`
- `ItemDefaultFunctions(arg1)`
- `ItemDeleted(instance)`
- `ItemDraggedOutOfInventory(client, item)`
- `ItemFunctionCalled(self, method, client, entity, results)`
- `ItemInitialized(item)`
- `ItemPaintOver(self, itemTable, w, h)`
- `ItemQuantityChanged(item, oldValue, quantity)`
- `ItemShowEntityMenu(entity)`
- `ItemTransfered(context)`
- `KeyLock(client, door, time)`
- `KeyUnlock(client, door, time)`
- `KickedFromChar(characterID, isCurrentChar)`
- `LiliaLoaded()`
- `LiliaModelPanelPostDrawModel(self, ent)`
- `LiliaNoticeOverride(msg, ntype)`
- `LoadCharInformation()`
- `LoadData()`
- `LoadMainCharacter()`
- `LoadMainMenuInformation(info, character)`
- `ModifyCharacterCreationSummary(arg1)`
- `ModifyCharacterModel(arg1, context)`
- `ModifyScoreboardModel(arg1, ply)`
- `ModifyVoiceIndicatorText(client, voiceText, voiceType)`
- `NetVarChanged(arg1, key, oldValue, value)`
- `OnAdminStickMenuClosed()`
- `OnAdminSystemLoaded(arg1, arg2)`
- `OnAmmoBoxUsed(activator, self, weapon, ammoType, givenAmount)`
- `OnCharAttribBoosted(client, self, attribID, boostID, arg5)`
- `OnCharAttribUpdated(client, self, key, arg4)`
- `OnCharCreated(client, character, originalData)`
- `OnCharDelete(client, id)`
- `OnCharDisconnect(client, character)`
- `OnCharFallover(self, entity, arg3)`
- `OnCharFlagsGiven(ply, self, addedFlags)`
- `OnCharFlagsTaken(ply, self, removedFlags)`
- `OnCharGetup(target, entity)`
- `OnCharKick(self, client)`
- `OnCharNetVarChanged(character, key, oldVar, value)`
- `OnCharPermakilled(self, arg2)`
- `OnCharRecognized(client, arg2)`
- `OnCharTradeVendor(client, vendor, item, isSellingToVendor, character, itemType, isFailed)`
- `OnCharVarChanged(character, varName, oldVar, newVar)`
- `OnCharacterCreationModelIconSet(icon, model, skin, bodyGroups)`
- `OnChatReceived(client, chatType, text, anonymous)`
- `OnCheaterCaught(client)`
- `OnConfigUpdated(key, oldValue, newValue)`
- `OnCreateDualInventoryPanels(panel1, panel2, inventory1, inventory2)`
- `OnCreateItemInteractionMenu(self, menu, itemTable)`
- `OnCreateStoragePanel(localInvPanel, storageInvPanel, storage)`
- `OnDataSet(key, value, gamemode, map)`
- `OnDatabaseLoaded()`
- `OnDeathSoundPlayed(client, deathSound)`
- `OnDialogNPCTypeSet(client, npc)`
- `OnEntityLoaded(ent, data)`
- `OnEntityPersistUpdated(ent, data)`
- `OnEntityPersisted(ent, entData)`
- `OnItemAdded(owner, item)`
- `OnItemCreated(itemTable, self)`
- `OnItemOverridden(item, overrides)`
- `OnItemRegistered(ITEM)`
- `OnItemSpawned(self)`
- `OnLoadTables()`
- `OnLocalVarSet(key, value)`
- `OnLocalizationLoaded()`
- `OnModelPanelSetup(self)`
- `OnNPCTypeSet(client, npc, npcID, filteredData)`
- `OnOOCMessageSent(client, message)`
- `OnOpenVendorMenu(self, vendor)`
- `OnPAC3PartTransfered(part)`
- `OnPainSoundPlayed(entity, painSound)`
- `OnPickupMoney(activator, self)`
- `OnPlayerDroppedItem(client, spawnedItem)`
- `OnPlayerInteractItem(client, action, self, result, data)`
- `OnPlayerJoinClass(target, arg2, oldClass)`
- `OnPlayerLostStackItem(itemTypeOrItem)`
- `OnPlayerObserve(client, state)`
- `OnPlayerPurchaseDoor(client, door, arg3)`
- `OnPlayerRotateItem(arg1, item, newRot)`
- `OnPlayerSwitchClass(client, class, oldClass)`
- `OnPlayerTakeItem(client, item)`
- `OnPrivilegeRegistered(arg1, arg2, arg3, arg4)`
- `OnPrivilegeUnregistered(arg1, arg2)`
- `OnRequestItemTransfer(self, arg2)`
- `OnRespawnKeyPressed(ply, key, left, baseTime, lastDeath)`
- `OnSalaryAdjust(client)`
- `OnSalaryGiven(client, char, pay, charFaction, class)`
- `OnSavedItemLoaded(loadedItems)`
- `OnServerLog(client, logType, logString, category)`
- `OnSetUsergroup(sid, new, source, ply)`
- `OnThemeChanged(themeName, useTransition)`
- `OnTicketClaimed(client, requester, ticketMessage)`
- `OnTicketClosed(client, requester, ticketMessage)`
- `OnTicketCreated(client, message)`
- `OnTransferred(target)`
- `OnUsergroupCreated(groupName, arg2)`
- `OnUsergroupPermissionsChanged(groupName, arg2)`
- `OnUsergroupRemoved(groupName)`
- `OnUsergroupRenamed(oldName, newName)`
- `OnVendorEdited(client, vendor, key)`
- `OnVoiceTypeChanged(client)`
- `OnWeaponOverrideUpdated(className, key, value)`
- `OnWeaponOverridesBulkSynced(overrides)`
- `OnWeaponRuntimeOverrideUpdated(className, dotPath, value)`
- `OnWeaponRuntimeOverridesBulkSynced(overrides)`
- `OnlineStaffDataReceived(staffData)`
- `OpenAdminStickUI(tgt)`
- `OpenCharacterMenu()`
- `OpenCharacterMenuOverride()`
- `OptionAdded(key, name, option)`
- `OptionChanged(key, old, value)`
- `OptionReceived(arg1, key, value)`
- `OverrideFactionDesc(uniqueID, arg2)`
- `OverrideFactionModelCustomization(client, faction, context, skinAllowed, bodygroupsAllowed)`
- `OverrideFactionModels(uniqueID, arg2)`
- `OverrideFactionName(uniqueID, arg2)`
- `OverrideSpawnTime(ply, baseTime)`
- `OverrideVoiceHearingStatus(listener, speaker, arg3)`
- `PaintItem(item)`
- `PlayerAccessVendor(client, vendor)`
- `PlayerBodyGroupChanged(client, oldVar, appliedGroups)`
- `PlayerCheatDetected(client)`
- `PlayerGagged(target, admin)`
- `PlayerLiliaDataLoaded(client)`
- `PlayerLoadedChar(client, character, currentChar)`
- `PlayerMessageSend(speaker, chatType, text, anonymous, receivers)`
- `PlayerModelChanged(client, newVar)`
- `PlayerMuted(target, admin)`
- `PlayerShouldPermaKill(client, inflictor, attacker)`
- `PlayerSpawnPointSelected(client, pos, ang)`
- `PlayerStaminaGained(client)`
- `PlayerStaminaLost(client)`
- `PlayerThrowPunch(client)`
- `PlayerUngagged(target, admin)`
- `PlayerUnmuted(target, admin)`
- `PlayerUseDoor(client, door)`
- `PopulateAdminStick(currentMenu, currentTarget, currentStores)`
- `PopulateAdminTabs(pages)`
- `PopulateConfigurationButtons(pages)`
- `PopulateFactionRosterOptions(list, members)`
- `PostBotSetup(client, character, inventory)`
- `PostDoorDataLoad(ent, doorData)`
- `PostDrawInventory(mainPanel, parentPanel)`
- `PostLoadData()`
- `PostLoadFonts(mainFont, mainFont)`
- `PostPlayerInitialSpawn(client)`
- `PostPlayerLoadedChar(client, character, currentChar)`
- `PostPlayerLoadout(client)`
- `PostPlayerSay(client, message, chatType, anonymous)`
- `PostScaleDamage(hitgroup, dmgInfo, damageScale)`
- `PreCharDelete(id)`
- `PreDoorDataSave(door, doorData)`
- `PreLiliaLoaded()`
- `PrePlayerInteractItem(client, action, self)`
- `PrePlayerLoadedChar(client, character, currentChar)`
- `PreSalaryGive(client, char, pay, charFaction, class)`
- `PreScaleDamage(hitgroup, dmgInfo, damageScale)`
- `RefreshFonts()`
- `RemovePart(client, id)`
- `RemoveWarning(charID, index)`
- `ResetCharacterPanel()`
- `RunAdminSystemCommand(cmd, admin, victim, dur, reason)`
- `SAM.LoadedRanks()`
- `SaveData()`
- `ScoreboardClosed(self)`
- `ScoreboardOpened(self)`
- `ScoreboardRowCreated(slot, ply)`
- `ScoreboardRowRemoved(self, ply)`
- `SetMainCharacter(charID)`
- `SetupBagInventoryAccessRules(inventory)`
- `SetupBotPlayer(client)`
- `SetupDatabase()`
- `SetupPACDataFromItems()`
- `SetupPlayerModel(client, self)`
- `SetupQuickMenu(self)`
- `ShouldAllowScoreboardOverride(client, var)`
- `ShouldBarDraw(bar)`
- `ShouldDataBeSaved()`
- `ShouldDeleteSavedItems()`
- `ShouldDisableThirdperson(client)`
- `ShouldDrawAmmo(wpn)`
- `ShouldDrawCrosshair(client, wpn)`
- `ShouldDrawEntityInfo(e)`
- `ShouldDrawPlayerInfo(e)`
- `ShouldDrawWepSelect(client)`
- `ShouldEntityLoad(ent)`
- `ShouldEntitySave(ent)`
- `ShouldHideBars()`
- `ShouldMenuButtonShow(arg1)`
- `ShouldOverrideSalaryTimers()`
- `ShouldPlayDeathSound(client, deathSound)`
- `ShouldPlayPainSound(entity, painSound)`
- `ShouldRespawnScreenAppear(ply, left, baseTime, lastDeath)`
- `ShouldSaveItem(itemTable, self)`
- `ShouldShowCharVarInCreation(key)`
- `ShouldShowClassOnScoreboard(clsData)`
- `ShouldShowFactionOnScoreboard(ply)`
- `ShouldShowPlayerOnScoreboard(ply)`
- `ShouldShowQuickMenu()`
- `ShouldSpawnClientRagdoll(client)`
- `ShowPlayerOptions(target, options)`
- `StorageCanTransferItem(client, storage, item)`
- `StorageEntityRemoved(self, inventory)`
- `StorageInventorySet(entity, inventory, isCar)`
- `StorageItemRemoved()`
- `StorageOpen(storage, isCar)`
- `StorageRestored(ent, inventory)`
- `StorageUnlockPrompt(entity)`
- `StoreSpawns(spawns)`
- `SuppressHint(hint)`
- `SyncCharList(client)`
- `ThirdPersonToggled(arg1)`
- `TicketSystemClaim(client, requester, ticketMessage)`
- `TicketSystemClose(client, requester, ticketMessage)`
- `TooltipInitialize(var, panel)`
- `TooltipLayout(var)`
- `TooltipPaint(var, w, h)`
- `TryViewModel(entity)`
- `UpdateEntityPersistence(ent)`
- `VendorClassUpdated(vendor, id, allowed)`
- `VendorEdited(liaVendorEnt, key)`
- `VendorExited()`
- `VendorFactionBuyScaleUpdated(vendor, factionID, scale)`
- `VendorFactionSellScaleUpdated(vendor, factionID, scale)`
- `VendorFactionUpdated(vendor, id, allowed)`
- `VendorItemBuyPriceUpdated(vendor, itemType, value)`
- `VendorItemMaxStockUpdated(vendor, itemType, value)`
- `VendorItemModeUpdated(vendor, itemType, value)`
- `VendorItemSellPriceUpdated(vendor, itemType, value)`
- `VendorItemStockUpdated(vendor, itemType, value)`
- `VendorMessagesUpdated(vendor)`
- `VendorOpened(vendor)`
- `VendorPropertyUpdated(vendor, propertyName, propertyValue)`
- `VendorSynchronized(vendor)`
- `VendorTradeEvent(client, vendor, itemType, isSellingToVendor)`
- `VoiceToggled(enabled)`
- `WarningIssued(client, target, reason, severity, count, warnerSteamID, arg7)`
- `WarningRemoved(client, targetClient, arg3, arg4, arg5, arg6)`
- `WeaponCycleSound()`
- `WeaponSelectSound()`
- `WebImageDownloaded(n, arg2)`
- `WebSoundDownloaded(name, path)`

## Localization Analysis

- **Unique Keys:** 3818
- **Undefined Calls:** 0
- **Argument Mismatch:** 0

### Undefined Calls

- None

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `ITEM.desc` | Unlocalized string | `Skat-Karte Playing Cards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\items\carddeck.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A standard flashlight that can be toggled.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\items\flashlight.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A Broken Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\broken_radio.lua | 2 |
| `ITEM.desc` | Unlocalized string | `Radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\radio.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A device used to bypass door locks.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking\items\lockpick.lua | 2 |
| `ITEM.name` | Unlocalized string | `Alcohol Base` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\items\base\alcohol.lua | 1 |
| `ITEM.name` | Unlocalized string | `Deck of Cards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\items\carddeck.lua | 1 |
| `ITEM.name` | Missing key | `Flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\items\flashlight.lua | 1 |
| `ITEM.name` | Unlocalized string | `Broken Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\broken_radio.lua | 1 |
| `ITEM.name` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\radio.lua | 1 |
| `ITEM.name` | Missing key | `Lockpick` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking\items\lockpick.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Comprehensive AFK protection system that automatically detects inactive players, prevents exploitation of AFK players, and integrates with restraint systems. Features configurable AFK detection, admin commands, multi-language support, and protection against various player actions.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\afk\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds drinkable alcohol that increases a player` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a full deck of playing cards that can be shuffled and drawn. Card draws sync to all players for simple in-game minigames.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Periodically posts automated advert messages in chat on a timer. Keeps players informed with rotating tips even when staff are offline.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds the ability to climb ledges using movement keys, custom climbing animations, and hooks for climb attempts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\climb\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds chat commands to open community links, easy sharing of workshop and docs, configurable commands via settings, localization for command names, and the ability to add custom URLs.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\communitycommands\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a toggleable custom cursor for the UI, a purely client-side implementation, improved menu navigation, a hotkey to quickly show or hide the cursor, and compatibility with other menu modules.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cursor\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 7 |
| `MODULE.desc` | Unlocalized string | `Adds floating combat text when hitting targets, different colors for damage types, display of damage dealt and received, scaling text based on damage amount, and client option to disable numbers.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds libraries to manage donor perks, tracking for donor ranks and perks, configurable perks by tier, and commands to adjust character slots.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds the ability to kick doors open with an animation, logging of door kick events, and a fun breach mechanic with physics force to fling doors open.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\doorkick\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds head bob and view sway, camera motion synced to actions, a realistic first-person feel, and adjustable intensity via config.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds the ability to look around without turning the body, a toggle key similar to EFT, movement direction preservation, and adjustable sensitivity while freelooking.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds teleport points for game masters, quick navigation across large maps, saving of locations for reuse, a command to list saved points, and sharing of points with other staff.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds respawning of players at hospitals with support for multiple hospital spawn locations on different maps.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hospitals\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds extra HUD elements like an FPS counter, fonts configurable with FPSHudFont, hooks so other modules can extend, performance stats display, and toggles for individual HUD elements.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds instant kill on headshots, lethality configurable per weapon, extra tension to combat, and integration with damage numbers.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\instakill\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds announcements when players join, notifications on disconnect, improved community awareness, relay of messages to Discord, and per-player toggle to hide messages.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\joinleavemessages\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds faction-based load messages, execution when players first load a character, customizable message text, color-coded formatting options, and per-faction enable toggles.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loadmessages\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds periodic cleaning of map debris, a configurable interval, reduced server lag, a whitelist for protected entities, and manual cleanup commands.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds payment to characters based on model, custom wage definitions, integration into the economy, config to exclude certain models, and logs of wages issued.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modelpay\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds an entity to tweak prop models, adjustments for scale and rotation, easy UI controls, saving of tweaked props between restarts, and undo support for recent tweaks.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds NPCs that drop items on death, DropTable to define probabilities, encouragement for looting, editable drop tables per NPC type, and weighted chances for rare items.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcdrop\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds NPCs that give money to players on death, MoneyTable to define rewards, editable money amounts per NPC type, and configurable default values.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcmoney\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds automatic NPC spawns at points, the ability for admins to force spawns, logging of spawn actions, and configuration for spawn intervals.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds ability to permanently delete map entities, logging for each removed entity, an admin-only command, confirmation prompts before removal, and restore list to undo mistakes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 4 |
| `MODULE.desc` | Unlocalized string | `Adds a first-person view that shows the full body, immersive camera transitions, compatibility with animations, smooth leaning animations, and optional third-person override.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds an anonymous rumour chat command, hiding of the sender` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds the ability to shoot door locks to open them, a quick breach alternative, a loud action that may alert others, and chance-based lock destruction.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\shootlock\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a simple lockpick tool for doors, logging of successful picks, brute-force style gameplay, configurable pick time, and chance for tools to break.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds a slot machine minigame, a workshop model for the machine, handling of payouts to winners, customizable payout odds, and sound and animation effects.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slots\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds slower movement while holding heavy weapons, speed penalties defined per weapon, encouragement for strategic choices, customizable weapon speed table, and automatic speed restore when switching.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slowweapons\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Provides Steam group membership rewards system that automatically checks group membership and gives money rewards to players who join your Steam group.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\module.lua | 7 |
| `MODULE.desc` | Unlocalized string | `Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds VManip animation support, hand gestures for items, functionality within Lilia, API for custom gesture triggers, and fallback animations when VManip is missing.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\vmanip\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds an interactive 3D war table, the ability to plan operations on a map, a workshop model, marker placement for strategies, and support for multiple map layouts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\module.lua | 6 |
| `MODULE.desc` | Unlocalized string | `Adds chat word filtering, blocking of banned phrases, an easy-to-extend list, and admin commands to modify the list.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wordfilter\module.lua | 6 |
| `MODULE.name` | Missing key | `Advertisements` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `AFK Protection` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\afk\module.lua | 1 |
| `MODULE.name` | Missing key | `Alcoholism` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\module.lua | 1 |
| `MODULE.name` | Missing key | `Animations` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Auto Restarter` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\module.lua | 1 |
| `MODULE.name` | Missing key | `Broadcasts` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 1 |
| `MODULE.name` | Missing key | `Captions` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\module.lua | 1 |
| `MODULE.name` | Missing key | `Cards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Chat Messages` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Cinematic Text` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 1 |
| `MODULE.name` | Missing key | `Climbing` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\climb\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Community Commands` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\communitycommands\module.lua | 1 |
| `MODULE.name` | Missing key | `Cursor` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cursor\module.lua | 1 |
| `MODULE.name` | Missing key | `Cutscenes` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 2 |
| `MODULE.name` | Unlocalized string | `Damage Numbers` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\module.lua | 1 |
| `MODULE.name` | Missing key | `Donator` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Door Kick` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\doorkick\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Extended Descriptions` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `First Person Effects` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects\module.lua | 1 |
| `MODULE.name` | Missing key | `Flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Free Look` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Gamemaster Points` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\module.lua | 1 |
| `MODULE.name` | Missing key | `Hospitals` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hospitals\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `HUD Extras` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\module.lua | 1 |
| `MODULE.name` | Missing key | `Instakill` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\instakill\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Join Leave Messages` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\joinleavemessages\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Load Messages` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loadmessages\module.lua | 1 |
| `MODULE.name` | Missing key | `Loyalism` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Map Cleaner` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Model Pay` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modelpay\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Model Tweaker` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `NPC Drop` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcdrop\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `NPC Money` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcmoney\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `NPC Spawner` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Perma Remove` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\module.lua | 1 |
| `MODULE.name` | Missing key | `Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Raised Weapons` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Raise Weapons` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Realistic View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Anonymous Rumors` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Shoot Lock` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\shootlock\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Simple Lockpicking` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Slot Machine` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slots\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Slow Weapons` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slowweapons\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Steam Group Rewards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\module.lua | 2 |
| `MODULE.name` | Unlocalized string | `Code Utilities` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `View Manipulation` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\vmanip\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `War Table` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\module.lua | 1 |
| `MODULE.name` | Unlocalized string | `Word Filter` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wordfilter\module.lua | 1 |
| `Privilege.Category` | Missing key | `broadcasts` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 11 |
| `Privilege.Category` | Missing key | `broadcasts` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 16 |
| `Privilege.Category` | Missing key | `cinematics` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 11 |
| `Privilege.Category` | Missing key | `cutscenes` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 12 |
| `Privilege.Category` | Missing key | `charSlots` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 11 |
| `Privilege.Category` | Missing key | `charSlots` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 16 |
| `Privilege.Category` | Missing key | `charSlots` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 21 |
| `Privilege.Category` | Missing key | `descriptions` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 11 |
| `Privilege.Category` | Missing key | `gamemasterPoints` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\module.lua | 11 |
| `Privilege.Category` | Missing key | `loyalism` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 12 |
| `Privilege.Category` | Missing key | `mapCleanup` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\module.lua | 11 |
| `Privilege.Name` | Missing key | `canUseFactionBroadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 9 |
| `Privilege.Name` | Missing key | `canUseClassBroadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 14 |
| `Privilege.Name` | Missing key | `sendCaptionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\commands.lua | 20 |
| `Privilege.Name` | Missing key | `useCinematicMenu` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 9 |
| `Privilege.Name` | Missing key | `cutsceneCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\commands.lua | 13 |
| `Privilege.Name` | Missing key | `useCutscenes` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 10 |
| `Privilege.Name` | Missing key | `subtractCharSlotsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\commands.lua | 11 |
| `Privilege.Name` | Missing key | `addCharSlotsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\commands.lua | 36 |
| `Privilege.Name` | Missing key | `setCharSlotsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\commands.lua | 65 |
| `Privilege.Name` | Missing key | `subtractCharSlots` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 9 |
| `Privilege.Name` | Missing key | `addCharSlots` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 14 |
| `Privilege.Name` | Missing key | `setCharSlots` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 19 |
| `Privilege.Name` | Missing key | `changeDescription` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 9 |
| `Privilege.Name` | Missing key | `moveToPoint` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\commands.lua | 53 |
| `Privilege.Name` | Missing key | `manageGamemasterTeleportPoints` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\module.lua | 9 |
| `Privilege.Name` | Missing key | `partytierCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\commands.lua | 16 |
| `Privilege.Name` | Missing key | `managementAssignPartyTiers` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 10 |
| `Privilege.Name` | Missing key | `forceNPCSpawn` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\module.lua | 9 |
| `Privilege.Name` | Missing key | `removeMapEntities` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\module.lua | 9 |
| `data.category` | Missing key | `advertisements` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 3 |
| `data.category` | Missing key | `advertisements` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 11 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\items\base\alcohol.lua | 6 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 8 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 18 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 28 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 38 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 48 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 58 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 68 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 78 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 88 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 98 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 108 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 118 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 128 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 138 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 148 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 158 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 168 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 178 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 188 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 198 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 208 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 218 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 228 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 238 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 248 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 258 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 268 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 278 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 288 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 298 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 308 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 318 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 328 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 338 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 348 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 358 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 368 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 378 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 388 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 398 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 408 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 418 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 428 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 438 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 448 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 458 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 468 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 478 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 488 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 498 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 508 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 518 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 528 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 538 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 548 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 558 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 568 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 578 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 588 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 598 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 608 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 618 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 628 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 638 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 648 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 658 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 668 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 678 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 688 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 698 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 708 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 718 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 728 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 738 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 748 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 758 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 768 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 778 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 788 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 798 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 808 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 818 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 828 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 838 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 848 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 858 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 868 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 878 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 888 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 898 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 908 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 918 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 928 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 938 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 948 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 958 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 968 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 978 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 988 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 998 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1008 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1018 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1028 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1038 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1048 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1058 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1068 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1078 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1088 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1098 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1108 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1118 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1128 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1138 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1148 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1158 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1168 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1178 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1188 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1198 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1208 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1218 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1228 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1238 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1248 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1258 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1268 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1278 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1288 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1298 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1308 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1318 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1328 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1338 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1348 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1358 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1368 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1378 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1388 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1398 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1408 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1418 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1428 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1438 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1448 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1458 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1468 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1478 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1488 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1498 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1508 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1518 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1528 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1538 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1548 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1558 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1568 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1578 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1588 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1598 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1608 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1618 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1628 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1638 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1648 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1658 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1668 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1678 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1688 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1698 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1708 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1718 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1728 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1738 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1748 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1758 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1768 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1778 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1788 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1798 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1808 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1818 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1828 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1838 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1848 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1858 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1868 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1878 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1888 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1898 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1908 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1918 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1928 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1938 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1948 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1958 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1968 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1978 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1988 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1998 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2008 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2018 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2028 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2038 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2048 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2058 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2068 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2078 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2088 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2098 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2108 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2118 |
| `data.category` | Missing key | `general` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 9 |
| `data.category` | Missing key | `chat` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages\config.lua | 3 |
| `data.category` | Missing key | `cinematic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 3 |
| `data.category` | Missing key | `cinematic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 11 |
| `data.category` | Missing key | `cinematic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 19 |
| `data.category` | Missing key | `HUD` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 9 |
| `data.category` | Missing key | `HUD` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 17 |
| `data.category` | Missing key | `Effects` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects\config.lua | 2 |
| `data.category` | Missing key | `flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 3 |
| `data.category` | Missing key | `flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 9 |
| `data.category` | Missing key | `flashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 15 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 2 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 8 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 16 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 24 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 33 |
| `data.category` | Missing key | `visuals` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 3 |
| `data.category` | Missing key | `visuals` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 9 |
| `data.category` | Missing key | `visuals` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 15 |
| `data.category` | Missing key | `visuals` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 21 |
| `data.category` | Missing key | `HUD` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 33 |
| `data.category` | Missing key | `spawning` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\config.lua | 31 |
| `data.category` | Missing key | `animations` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 7 |
| `data.category` | Missing key | `animations` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 13 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\config.lua | 2 |
| `data.category` | Missing key | `View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\config.lua | 8 |
| `data.category` | Unlocalized string | `.. lia.db.convertDataType(category),` | modules\administration\libraries\server.lua | 177 |
| `data.desc` | Missing key | `advertCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\commands.lua | 11 |
| `data.desc` | Missing key | `advertPriceDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 2 |
| `data.desc` | Missing key | `advertCooldownDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 10 |
| `data.desc` | Unlocalized string | `Implements a paid /advert command for server-wide announcements. Messages are colored, logged, and throttled by a cooldown to curb spam.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\module.lua | 6 |
| `data.desc` | Unlocalized string | `Comprehensive AFK protection system that automatically detects inactive players, prevents exploitation of AFK players, and integrates with restraint systems. Features configurable AFK detection, admin commands, multi-language support, and protection against various player actions.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\afk\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds drinkable alcohol that increases a player` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\module.lua | 6 |
| `data.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations\module.lua | 4 |
| `data.desc` | Missing key | `serverRestartIntervalSecondsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 8 |
| `data.desc` | Missing key | `restartCountdownFontDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 16 |
| `data.desc` | Unlocalized string | `Schedules automatic server restarts at set intervals. Players see a countdown so they can prepare before the map changes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\module.lua | 6 |
| `data.desc` | Missing key | `classBroadcastTitle` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\commands.lua | 10 |
| `data.desc` | Missing key | `factionBroadcastTitle` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\commands.lua | 64 |
| `data.desc` | Unlocalized string | `Allows staff to broadcast messages to chosen factions or classes. Every broadcast is logged and controlled through CAMI privileges.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 6 |
| `data.desc` | Missing key | `sendCaptionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\commands.lua | 18 |
| `data.desc` | Missing key | `broadcastCaptionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\commands.lua | 54 |
| `data.desc` | Unlocalized string | `Offers an API for timed on-screen captions suited for tutorials or story events. Captions can be triggered from the server or client and last for a chosen duration.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions\module.lua | 6 |
| `data.desc` | Missing key | `cardsCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\commands.lua | 2 |
| `data.desc` | Unlocalized string | `Skat-Karte Playing Cards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\items\carddeck.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a full deck of playing cards that can be shuffled and drawn. Card draws sync to all players for simple in-game minigames.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards\module.lua | 6 |
| `data.desc` | Missing key | `chatMessagesIntervalDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages\config.lua | 2 |
| `data.desc` | Unlocalized string | `Periodically posts automated advert messages in chat on a timer. Keeps players informed with rotating tips even when staff are offline.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages\module.lua | 6 |
| `data.desc` | Missing key | `cinematicMenuDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\commands.lua | 3 |
| `data.desc` | Missing key | `cinematicTextSizeDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 2 |
| `data.desc` | Missing key | `cinematicBigTextSizeDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 10 |
| `data.desc` | Missing key | `cinematicTextMusicDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 18 |
| `data.desc` | Unlocalized string | `Adds displays of cinematic splash text overlays, screen darkening with letterbox bars, support for scripted scenes, timed fades for dramatic effect, and customizable text fonts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds the ability to climb ledges using movement keys, custom climbing animations, and hooks for climb attempts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\climb\module.lua | 6 |
| `data.desc` | Missing key | `urlCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\communitycommands\libraries\shared.lua | 6 |
| `data.desc` | Unlocalized string | `Adds chat commands to open community links, easy sharing of workshop and docs, configurable commands via settings, localization for command names, and the ability to add custom URLs.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\communitycommands\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds a toggleable custom cursor for the UI, a purely client-side implementation, improved menu navigation, a hotkey to quickly show or hide the cursor, and compatibility with other menu modules.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cursor\module.lua | 6 |
| `data.desc` | Missing key | `cutsceneCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\commands.lua | 11 |
| `data.desc` | Missing key | `globalCutsceneCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\commands.lua | 45 |
| `data.desc` | Unlocalized string | `Adds a framework for simple cutscene playback, scenes defined through tables, syncing of camera movement across clients, commands to trigger cutscenes, and the ability for players to skip.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes\module.lua | 7 |
| `data.desc` | Missing key | `damageNumberFontDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 2 |
| `data.desc` | Unlocalized string | `Adds floating combat text when hitting targets, different colors for damage types, display of damage dealt and received, scaling text based on damage amount, and client option to disable numbers.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\module.lua | 6 |
| `data.desc` | Missing key | `subtractCharSlotsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\commands.lua | 9 |
| `data.desc` | Missing key | `addCharSlotsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\commands.lua | 34 |
| `data.desc` | Missing key | `setCharSlotsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\commands.lua | 63 |
| `data.desc` | Unlocalized string | `Adds libraries to manage donor perks, tracking for donor ranks and perks, configurable perks by tier, and commands to adjust character slots.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\module.lua | 6 |
| `data.desc` | Missing key | `doorkickCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\doorkick\commands.lua | 4 |
| `data.desc` | Unlocalized string | `Adds the ability to kick doors open with an animation, logging of door kick events, and a fun breach mechanic with physics force to fling doors open.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\doorkick\module.lua | 6 |
| `data.desc` | Missing key | `viewExtDescCommand` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\commands.lua | 3 |
| `data.desc` | Missing key | `setExtDescCommand` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\commands.lua | 16 |
| `data.desc` | Unlocalized string | `Adds support for long item descriptions, localization for multiple languages, better RP text display, automatic line wrapping, and fallback to short descriptions.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds head bob and view sway, camera motion synced to actions, a realistic first-person feel, and adjustable intensity via config.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects\module.lua | 6 |
| `data.desc` | Missing key | `enableFlashlightDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 2 |
| `data.desc` | Missing key | `flashlightRequiresItemDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 8 |
| `data.desc` | Missing key | `flashlightCooldownDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 14 |
| `data.desc` | Unlocalized string | `A standard flashlight that can be toggled.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\items\flashlight.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a serious flashlight with dynamic light, darkening of surroundings when turned off, adjustable brightness, and keybind toggle support.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds the ability to look around without turning the body, a toggle key similar to EFT, movement direction preservation, and adjustable sensitivity while freelooking.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\module.lua | 6 |
| `data.desc` | Missing key | `deletePoint` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\commands.lua | 4 |
| `data.desc` | Missing key | `renamePoint` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\commands.lua | 16 |
| `data.desc` | Missing key | `tpPointsTitle` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\commands.lua | 32 |
| `data.desc` | Missing key | `moveToPoint` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\commands.lua | 51 |
| `data.desc` | Unlocalized string | `Adds teleport points for game masters, quick navigation across large maps, saving of locations for reuse, a command to list saved points, and sharing of points with other staff.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds respawning of players at hospitals with support for multiple hospital spawn locations on different maps.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hospitals\module.lua | 6 |
| `data.desc` | Missing key | `enableWatermarkDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 2 |
| `data.desc` | Missing key | `watermarkLogoPathDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 8 |
| `data.desc` | Missing key | `gamemodeVersionDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 14 |
| `data.desc` | Missing key | `enableVignetteEffectDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 20 |
| `data.desc` | Missing key | `fpsHudFontDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 26 |
| `data.desc` | Unlocalized string | `Adds extra HUD elements like an FPS counter, fonts configurable with FPSHudFont, hooks so other modules can extend, performance stats display, and toggles for individual HUD elements.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\module.lua | 6 |
| `data.desc` | Missing key | `instantKillingDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\instakill\config.lua | 2 |
| `data.desc` | Unlocalized string | `Adds instant kill on headshots, lethality configurable per weapon, extra tension to combat, and integration with damage numbers.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\instakill\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds announcements when players join, notifications on disconnect, improved community awareness, relay of messages to Discord, and per-player toggle to hide messages.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\joinleavemessages\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds faction-based load messages, execution when players first load a character, customizable message text, color-coded formatting options, and per-faction enable toggles.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loadmessages\module.lua | 6 |
| `data.desc` | Missing key | `partytierCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\commands.lua | 14 |
| `data.desc` | Unlocalized string | `Adds a loyalty tier system for players, the /partytier command access, permission control through flags, automatic tier progression, and customizable rewards per tier.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 6 |
| `data.desc` | Missing key | `enableMapCleanerDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\config.lua | 3 |
| `data.desc` | Missing key | `itemCleanupTimeDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\config.lua | 9 |
| `data.desc` | Missing key | `mapCleanupTimeDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\config.lua | 17 |
| `data.desc` | Unlocalized string | `Adds periodic cleaning of map debris, a configurable interval, reduced server lag, a whitelist for protected entities, and manual cleanup commands.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds payment to characters based on model, custom wage definitions, integration into the economy, config to exclude certain models, and logs of wages issued.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modelpay\module.lua | 6 |
| `data.desc` | Missing key | `wardrobeModelDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\config.lua | 2 |
| `data.desc` | Missing key | `enableFactionModelsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\config.lua | 8 |
| `data.desc` | Missing key | `enableClassModelsDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\config.lua | 14 |
| `data.desc` | Unlocalized string | `Adds an entity to tweak prop models, adjustments for scale and rotation, easy UI controls, saving of tweaked props between restarts, and undo support for recent tweaks.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds NPCs that drop items on death, DropTable to define probabilities, encouragement for looting, editable drop tables per NPC type, and weighted chances for rare items.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcdrop\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds NPCs that give money to players on death, MoneyTable to define rewards, editable money amounts per NPC type, and configurable default values.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcmoney\module.lua | 6 |
| `data.desc` | Missing key | `forceNPCSpawnDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\commands.lua | 9 |
| `data.desc` | Missing key | `spawnCooldownDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\config.lua | 30 |
| `data.desc` | Unlocalized string | `Adds automatic NPC spawns at points, the ability for admins to force spawns, logging of spawn actions, and configuration for spawn intervals.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\module.lua | 6 |
| `data.desc` | Missing key | `permRemoveDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\commands.lua | 3 |
| `data.desc` | Unlocalized string | `Adds ability to permanently delete map entities, logging for each removed entity, an admin-only command, confirmation prompts before removal, and restore list to undo mistakes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\module.lua | 6 |
| `data.desc` | Missing key | `radioFontDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\config.lua | 2 |
| `data.desc` | Unlocalized string | `A Broken Radio` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\broken_radio.lua | 2 |
| `data.desc` | Unlocalized string | `Radio to use to talk to other people` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\items\radio.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a radio chat channel for players, font configuration via RadioFont, workshop models for radios, frequency channels for groups, and handheld radio items.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\module.lua | 6 |
| `data.desc` | Missing key | `toggleRaiseDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\commands.lua | 4 |
| `data.desc` | Missing key | `weaponRaiseSpeedDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\config.lua | 2 |
| `data.desc` | Unlocalized string | `Adds auto-lowering of weapons when running, a raise delay set by WeaponRaiseSpeed, prevention of accidental fire, a toggle to keep weapons lowered, and compatibility with melee weapons.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\module.lua | 6 |
| `data.desc` | Unlocalized string | `Toggle whether your current weapon is raised.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\libraries\shared.lua | 4 |
| `data.desc` | Unlocalized string | `Lilia port and improvement of NutScript` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 4 |
| `data.desc` | Unlocalized string | `Whether lowered/passive weapon states should be disabled.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 6 |
| `data.desc` | Unlocalized string | `How long raising or holstering a weapon takes.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 12 |
| `data.desc` | Unlocalized string | `Adds a first-person view that shows the full body, immersive camera transitions, compatibility with animations, smooth leaning animations, and optional third-person override.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\module.lua | 6 |
| `data.desc` | Missing key | `rumourCommandDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\commands.lua | 9 |
| `data.desc` | Missing key | `rumorCooldownDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\config.lua | 2 |
| `data.desc` | Missing key | `rumourRevealChanceDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\config.lua | 10 |
| `data.desc` | Unlocalized string | `Adds an anonymous rumour chat command, hiding of the sender` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds the ability to shoot door locks to open them, a quick breach alternative, a loud action that may alert others, and chance-based lock destruction.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\shootlock\module.lua | 6 |
| `data.desc` | Unlocalized string | `A device used to bypass door locks.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking\items\lockpick.lua | 2 |
| `data.desc` | Unlocalized string | `Adds a simple lockpick tool for doors, logging of successful picks, brute-force style gameplay, configurable pick time, and chance for tools to break.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds a slot machine minigame, a workshop model for the machine, handling of payouts to winners, customizable payout odds, and sound and animation effects.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slots\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds slower movement while holding heavy weapons, speed penalties defined per weapon, encouragement for strategic choices, customizable weapon speed table, and automatic speed restore when switching.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slowweapons\module.lua | 6 |
| `data.desc` | Unlocalized string | `Opens the Steam group page for joining` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\libraries\client.lua | 3 |
| `data.desc` | Unlocalized string | `Claim Steam group rewards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\libraries\client.lua | 8 |
| `data.desc` | Unlocalized string | `Opens the Steam group page for joining` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\libraries\server.lua | 72 |
| `data.desc` | Unlocalized string | `Claim Steam group rewards` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\libraries\server.lua | 81 |
| `data.desc` | Unlocalized string | `Provides Steam group membership rewards system that automatically checks group membership and gives money rewards to players who join your Steam group.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards\module.lua | 7 |
| `data.desc` | Unlocalized string | `Adds extra helper functions in lia.util, simplified utilities for common scripting tasks, a central library used by other modules, utilities for networking data, and shared constants for modules.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds VManip animation support, hand gestures for items, functionality within Lilia, API for custom gesture triggers, and fallback animations when VManip is missing.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\vmanip\module.lua | 6 |
| `data.desc` | Missing key | `mapUrlDesc` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\config.lua | 2 |
| `data.desc` | Unlocalized string | `Adds an interactive 3D war table, the ability to plan operations on a map, a workshop model, marker placement for strategies, and support for multiple map layouts.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\module.lua | 6 |
| `data.desc` | Unlocalized string | `Adds chat word filtering, blocking of banned phrases, an easy-to-extend list, and admin commands to modify the list.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wordfilter\module.lua | 6 |
| `entity.contact` | Missing key | `bozdev` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove\module.lua | 4 |
| `lia.config.add:name` | Missing key | `advertPrice` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 1 |
| `lia.config.add:name` | Missing key | `advertCooldown` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert\config.lua | 9 |
| `lia.config.add:name` | Missing key | `serverRestartIntervalSeconds` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 1 |
| `lia.config.add:name` | Missing key | `restartCountdownFont` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter\config.lua | 15 |
| `lia.config.add:name` | Missing key | `chatMessagesInterval` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages\config.lua | 1 |
| `lia.config.add:name` | Missing key | `cinematicTextSize` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 1 |
| `lia.config.add:name` | Missing key | `cinematicBigTextSize` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 9 |
| `lia.config.add:name` | Missing key | `cinematicTextMusic` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext\config.lua | 17 |
| `lia.config.add:name` | Missing key | `damageNumberFont` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 1 |
| `lia.config.add:name` | Missing key | `enableFlashlight` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 1 |
| `lia.config.add:name` | Missing key | `flashlightRequiresItem` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 7 |
| `lia.config.add:name` | Missing key | `flashlightCooldown` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight\config.lua | 13 |
| `lia.config.add:name` | Missing key | `enableWatermark` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 1 |
| `lia.config.add:name` | Missing key | `watermarkLogoPath` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 7 |
| `lia.config.add:name` | Missing key | `gamemodeVersion` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 13 |
| `lia.config.add:name` | Missing key | `enableVignetteEffect` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 19 |
| `lia.config.add:name` | Missing key | `fpsHudFont` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 25 |
| `lia.config.add:name` | Missing key | `instantKilling` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\instakill\config.lua | 1 |
| `lia.config.add:name` | Missing key | `enableMapCleaner` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\config.lua | 2 |
| `lia.config.add:name` | Missing key | `itemCleanupTime` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\config.lua | 8 |
| `lia.config.add:name` | Missing key | `mapCleanupTime` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner\config.lua | 16 |
| `lia.config.add:name` | Missing key | `wardrobeModel` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\config.lua | 1 |
| `lia.config.add:name` | Missing key | `enableFactionModels` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\config.lua | 7 |
| `lia.config.add:name` | Missing key | `enableClassModels` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker\config.lua | 13 |
| `lia.config.add:name` | Missing key | `spawnCooldown` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\config.lua | 26 |
| `lia.config.add:name` | Missing key | `radioFont` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\config.lua | 1 |
| `lia.config.add:name` | Missing key | `weaponRaiseSpeed` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\config.lua | 1 |
| `lia.config.add:name` | Unlocalized string | `Weapons Always Raised` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 5 |
| `lia.config.add:name` | Unlocalized string | `Weapon Toggle Time` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons\module.lua | 11 |
| `lia.config.add:name` | Missing key | `rumorCooldown` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\config.lua | 1 |
| `lia.config.add:name` | Missing key | `rumourRevealChance` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour\config.lua | 9 |
| `lia.config.add:name` | Missing key | `mapUrl` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\config.lua | 1 |
| `lia.flag.add:desc` | Unlocalized string | `Access to Faction Broadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 20 |
| `lia.flag.add:desc` | Unlocalized string | `Access to Class Broadcast` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts\module.lua | 21 |
| `lia.flag.add:desc` | Unlocalized string | `Access to /partytier` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism\module.lua | 7 |
| `lia.option.add:desc` | Unlocalized string | `How long (in seconds) floating damage numbers stay on screen` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 8 |
| `lia.option.add:desc` | Unlocalized string | `Base alpha for floating damage numbers` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 16 |
| `lia.option.add:desc` | Unlocalized string | `Toggle realistic first person head bobbing and motion effects` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects\config.lua | 1 |
| `lia.option.add:desc` | Unlocalized string | `Enable or disable the freelook functionality.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 1 |
| `lia.option.add:desc` | Unlocalized string | `Set the maximum freelook angle vertically.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 7 |
| `lia.option.add:desc` | Unlocalized string | `Set the maximum freelook angle horizontally.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 15 |
| `lia.option.add:desc` | Unlocalized string | `Set the smoothness of the freelook movement.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 23 |
| `lia.option.add:desc` | Unlocalized string | `Prevent freelook while aiming down sights.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 32 |
| `lia.option.add:desc` | Unlocalized string | `Enable FPS display on the HUD` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 32 |
| `lia.option.add:desc` | Unlocalized string | `Enable or disable the alternate weapon lowering angles.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\libraries\client.lua | 1 |
| `lia.option.add:desc` | Unlocalized string | `Enable or disable the realistic view system.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\config.lua | 1 |
| `lia.option.add:desc` | Unlocalized string | `Enable or disable full-body angles in realistic view.` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\config.lua | 7 |
| `lia.option.add:name` | Unlocalized string | `Damage Number Duration` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 8 |
| `lia.option.add:name` | Unlocalized string | `Damage Number Alpha` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers\config.lua | 16 |
| `lia.option.add:name` | Unlocalized string | `First Person Effects` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects\config.lua | 1 |
| `lia.option.add:name` | Unlocalized string | `Enable Freelook` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 1 |
| `lia.option.add:name` | Unlocalized string | `Freelook Vertical Limit` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 7 |
| `lia.option.add:name` | Unlocalized string | `Freelook Horizontal Limit` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 15 |
| `lia.option.add:name` | Unlocalized string | `Freelook Smoothness` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 23 |
| `lia.option.add:name` | Unlocalized string | `Freelook Block ADS` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook\config.lua | 32 |
| `lia.option.add:name` | Unlocalized string | `FPS Draw` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras\config.lua | 32 |
| `lia.option.add:name` | Unlocalized string | `Use Alternate Lowering` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\libraries\client.lua | 1 |
| `lia.option.add:name` | Unlocalized string | `Enable Realistic View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\config.lua | 1 |
| `lia.option.add:name` | Unlocalized string | `Use Full Body for Realistic View` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\config.lua | 7 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 215
- **Used Net Messages:** 214
- **Defined But Unused:** 1
- **Used But Undefined:** 0

### Used But Undefined

None

## Config: Undefined lia.config.get Keys

Total: **2** call(s) reference a config key that has no matching `lia.config.add`.

### By Key

| Config Key | Occurrences |
|---|---:|
| `ChatRange` | 2 |

### Details

#### `ChatRange`

- **D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\libraries\shared.lua** line 13: `local speakRange = lia.config.get("ChatRange", 280)`
- **D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio\libraries\shared.lua** line 37: `local speakRange = lia.config.get("ChatRange", 280)`

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism`

### Module Documentation Report

- **Undocumented Hooks:**
  - `AddTextField()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations`

### Module Documentation Report

- **Undocumented Hooks:**
  - `OnPlayerEnterSequence()`
  - `OnPlayerLeaveSequence()`
  - `ShouldWeaponBeRaised()`

- **Undocumented lia.* Functions:**
  - `lia.anim.getModelClass()`
  - `lia.anim.getModelGender()`
  - `lia.anim.getWeaponHoldType()`
  - `lia.anim.setModelClass()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.caption.finish()`
  - `lia.caption.start()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism`

### Module Documentation Report

- **Undocumented Hooks:**
  - `AddTextField()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio`

### Module Documentation Report

- **Undocumented Hooks:**
  - `AddTextField()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons`

### Module Documentation Report

- **Undocumented Hooks:**
  - `ShouldPreventLoweredWeaponView()`
  - `ShouldWeaponBeRaised()`

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.utilities.blend()`
  - `lia.utilities.colorCycle()`
  - `lia.utilities.colorToHex()`
  - `lia.utilities.currentLocalTime()`
  - `lia.utilities.darken()`
  - `lia.utilities.daysBetween()`
  - `lia.utilities.deserializeAngle()`
  - `lia.utilities.deserializeVector()`
  - `lia.utilities.dprint()`
  - `lia.utilities.formatTimestamp()`
  - `lia.utilities.hMSToSeconds()`
  - `lia.utilities.lerpColor()`
  - `lia.utilities.lerpHSV()`
  - `lia.utilities.lighten()`
  - `lia.utilities.rainbow()`
  - `lia.utilities.rgb()`
  - `lia.utilities.secondsToDHMS()`
  - `lia.utilities.serializeAngle()`
  - `lia.utilities.serializeVector()`
  - `lia.utilities.spawnEntities()`
  - `lia.utilities.spawnProp()`
  - `lia.utilities.speedTest()`
  - `lia.utilities.timeDifference()`
  - `lia.utilities.timeUntil()`
  - `lia.utilities.toText()`
  - `lia.utilities.weekdayName()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\.git | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\.github | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\advert | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\afk | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism | 1 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\animations | 3 | 4 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\autorestarter | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\broadcasts | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\captions | 0 | 2 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cards | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\chatmessages | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cinematictext | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\climb | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\communitycommands | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cursor | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\cutscenes | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\damagenumbers | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\doorkick | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\extendeddescriptions | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\firstpersoneffects | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\flashlight | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\freelook | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\gamemasterpoints | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hospitals | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\hud_extras | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\instakill | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\joinleavemessages | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loadmessages | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\loyalism | 1 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\mapcleaner | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modelpay | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\modeltweaker | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcdrop | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcmoney | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\permaremove | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\radio | 1 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raiseweapons | 2 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\rumour | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\shootlock | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\simple_lockpicking | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slots | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slowweapons | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\steamgrouprewards | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities | 0 | 26 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\vmanip | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable | 0 | 0 |
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wordfilter | 0 | 0 |
