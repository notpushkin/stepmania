-- sm-ssc fallback theme | script ring 03 | Gameplay.lua
-- [en] This file is used to store settings that should be different in each
-- game mode.

-- shakesoda calls this pump.lua
local function CurGameName()
	return GAMESTATE:GetCurrentGame():GetName()
end

-- Check the active game mode against a string. Cut down typing this in metrics.
function IsGame(str)
	if CurGameName() == str then
		return true
	end
	return false
end

-- GetExtraColorThreshold()
-- [en] returns the difficulty threshold in meter
-- for songs that should be counted as boss songs.
function GetExtraColorThreshold()
	local Modes = {
		dance = 10,
		pump = 21,
		beat = 12,
		kb7 = 10,
		para = 10,
		techno = 10,
		lights = 10, -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

-- GameCompatibleModes:
-- [en] returns possible modes for ScreenSelectPlayMode
function GameCompatibleModes()
	local Modes = {
		dance = "Single,Double,Solo,Versus,Couple",
		pump = "Single,Double,HalfDouble,Versus,Couple,Routine",
		beat = "5Keys,7Keys,10Keys,14Keys,Versus5,Versus7",
		kb7 = "KB7",
		para = "Single",
		techno = "Single4,Single5,Single8,Double4,Double8",
		lights = "Single" -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

function SelectProfileKeys()
	local sGame = CurGameName()
	if sGame == "pump" then
		return "Up,Down,Start,Back,Center,DownLeft,DownRight"
	elseif sGame == "dance" then
		return "Up,Down,Start,Back,Up2,Down2"
	else
		return "Up,Down,Start,Back"
	end
end

-- ScoreKeeperClass:
-- [en] Determines the correct ScoreKeeper class to use.
function ScoreKeeperClass()
	-- rave scorekeeper
	if GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then return "ScoreKeeperRave" end
	if GAMESTATE:GetCurrentStyle() then
		local styleType = GAMESTATE:GetCurrentStyle():GetStyleType()
		if styleType == 'StyleType_TwoPlayersSharedSides' then return "ScoreKeeperShared" end
	end
	return "ScoreKeeperNormal"
end

-- ComboContinue:
-- [en] 
function ComboContinue()
	local Continue = {
		dance = GAMESTATE:GetPlayMode() == "PlayMode_Oni" and "TapNoteScore_W2" or "TapNoteScore_W3",
		pump = "TapNoteScore_W3",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Continue[CurGameName()]
end

function ComboMaintain()
	local Maintain = {
		dance = "TapNoteScore_W3",
		pump = "TapNoteScore_W4",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Maintain[CurGameName()]
end

function ComboPerRow()
	sGame = CurGameName()
	if sGame == "pump" then
		return true
	elseif GAMESTATE:GetPlayMode() == "PlayMode_Oni" then
		return true
	else
		return false
	end
end

function EvalUsesCheckpointsWithJudgments()
	return (CurGameName() == "pump") and true or false
end

-- these need cleanup really.
function HitCombo()
	local Combo = {
		dance = 2,
		pump = 4,
		beat = 2,
		kb7 = 2,
		para = 2
	}
	return Combo[CurGameName()]
end

function MissCombo()
	local Combo = {
		dance = 2,
		pump = 4,
		beat = 0,
		kb7 = 0,
		para = 0
	}
	return Combo[CurGameName()]
end

-- FailCombo:
-- [en] The combo that causes game failure.
function FailCombo()
	local Combo = {
		dance = -1, -- ITG uses 30
		pump = 51, -- Pump Pro uses 30, real Pump uses 51
		beat = -1,
		kb7 = -1,
		para = -1
	}
	return Combo[CurGameName()]
end

function RoutineSkinP1()
	local Combo = {
		dance = "midi-routine-p1",
		pump = "cmd-routine-p1",
		beat = "default",
		kb7 = "default",
		para = "default"
	}
	return Combo[CurGameName()]
end

function RoutineSkinP2()
	local Combo = {
		dance = "midi-routine-p2",
		pump = "cmd-routine-p2",
		beat = "default",
		kb7 = "retrobar",
		para = "default"
	}
	return Combo[CurGameName()]
end

-- todo: use tables for some of these -aj
function HoldTiming()
	return IsGame("pump") and 0 or PREFSMAN:GetPreference("TimingWindowSecondsHold")
end

function ShowHoldJudgments()
	return not IsGame("pump")
end

local tNotePositions = {
	-- StepMania 3.9/4.0
	Normal = { -144, 144, },
	-- ITG
	Lower = { -125, 145, }
}

function GetTapPosition( sType )
	bCategory = (sType == 'Standard') and 1 or 2
	-- true: Normal
	-- false: Lower
	bPreference = GetUserPrefB("UserPrefNotePosition") and "Normal" or "Lower"
	tNotePos = tNotePositions[bPreference]
	return tNotePos[bCategory]
end

function ComboUnderField()
	return ThemePrefs.Get("ComboUnderField")
end

local CodeDetectorCodes = {
	-- steps
	PrevSteps1 = {
		default = "",
		dance = "Up,Up",
		pump = "+UpLeft",
	},
	PrevSteps2 = {
		default = "MenuUp,MenuUp",
		dance = "MenuUp,MenuUp",
		pump = "",
	},
	NextSteps1 = {
		default = "",
		dance = "Down,Down",
		pump = "+UpRight",
	},
	NextSteps2 = {
		default = "MenuDown,MenuDown",
		dance = "MenuDown,MenuDown",
		pump = "",
	},
	-- group
	NextGroup = {
		default = "",
		dance = "MenuUp,MenuRight,MenuRight",
		pump = "",
	},
	PrevGroup = {
		default = "",
		dance = "MenuUp,MenuDown,MenuUp,MenuDown",
		pump = "",
	},
	CloseCurrentFolder = {
		default = "MenuUp-MenuDown",
	},
	-- sorts
	NextSort1 = {
		default = "@MenuLeft-@MenuRight-Start",
		dance = "@MenuLeft-@MenuRight-Start",
		pump = "@MenuLeft-@MenuRight-Start",
	},
	NextSort2 = {
		default = "MenuLeft-MenuRight",
		dance = "MenuLeft-MenuRight",
		pump = "MenuLeft-MenuRight",
	},
	NextSort3 = {
		default = "",
		dance = "@Left-@Right-Start",
		pump = "@DownLeft-@DownRight-Start",
	},
	NextSort4 = {
		default = "",
		dance = "Left-Right",
		pump = "DownLeft-DownRight",
	},
	-- modemenu
	ModeMenu1 = {
		default = "",
		dance = "Up,Down,Up,Down",
	},
	ModeMenu2 = {
		default = "MenuUp,MenuDown,MenuUp,MenuDown",
	},
	-- Evaluation:
	SaveScreenshot1 = {
		default = "MenuLeft-MenuRight",
	},
	SaveScreenshot2 = {
		default = "Select",
	},
	-- modifiers section
	CancelAll = {
		default = "",
		dance = "Left,Right,Left,Right,Left,Right,Left,Right",
	},
	--- specific modifiers
	Mirror = {
		default = "",
		dance = "Up,Left,Right,Left,Right",
		pump = "DownRight,DownLeft,UpRight,UpLeft,DownRight,DownLeft,UpRight,UpLeft,Center",
	},
	Left = {
		default = "",
		dance = "Up,Down,Right,Left",
	},
	Right = {
		default = "",
		dance = "Up,Down,Left,Right",
	},
	Shuffle = {
		default = "",
		dance = "Down,Up,Down,Up",
		pump = "UpLeft,UpRight,UpLeft,UpRight,DownLeft,DownRight,DownLeft,DownRight,Center", -- random
	},
	SuperShuffle = {
		default = "",
		dance = "Down,Up,Left,Right",
		pump = "UpLeft,UpRight,DownLeft,DownRight,UpLeft,UpRight,DownLeft,DownRight,Center"
	},
	Reverse = {
		default = "",
		dance = "Down,Left,Right,Left,Right",
		pump = "UpLeft,DownLeft,UpRight,DownRight,UpLeft,DownLeft,UpRight,DownRight,DownRight", -- drop
	},
	HoldNotes = {
		default = "",
		dance = "Right,Left,Down,Up",
	},
	Mines = {
		default = "",
	},
	Dark = {
		default = "",
	},
	Hidden = {
		default = "",
		pump = "UpLeft,UpRight,DownLeft,DownRight,Center", -- vanish
	},
	RandomVanish = {
		default = "",
	},
	-- boost (accel), brake (decel), stealth (nonstep)
	--- next/prev modifiers
	NextTransform = {
		default = "",
	},
	NextScrollSpeed = {
		default = "",
		dance = "Up,Left,Down,Left,Up",
		pump = "UpLeft,UpRight,UpLeft,UpRight,Center",
	},
	PreviousScrollSpeed = {
		default = "",
		dance = "Down,Right,Up,Right,Down",
		pump = "UpRight,UpLeft,UpRight,UpLeft,Center",
	},
	NextAccel = {
		default = "",
		dance = "Left,Right,Down,Up",
	},
	NextEffect = {
		default = "",
		dance = "Left,Down,Right",
	},
	NextAppearance = {
		default = "",
		dance = "Left,Up,Right",
	},
	NextTurn = {
		default = "",
	},
	-- cancel all in player options
	CancelAllPlayerOptions = {
		default = "",
		dance = "Left,Right,Left,Right,Left,Right",
	},
};

function GetCodeForGame(codeName)
	local gameName = string.lower(CurGameName())
	local inputCode = CodeDetectorCodes[codeName]
	return inputCode[gameName] or inputCode["default"]
end
