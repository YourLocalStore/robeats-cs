local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)
local SPDict = require(game.ReplicatedStorage.Shared.SPDict)
local AssertType = require(game.ReplicatedStorage.Shared.AssertType)

local EnvironmentSetup = {}
EnvironmentSetup.Mode = {
	Menu = 0;
	Game = 1;
}

local _game_environment
local _element_protos_folder
local _local_elements_folder
local _player_gui

function EnvironmentSetup:initial_setup()
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

	_game_environment = game.Workspace.GameEnvironment
	_game_environment.Parent = nil
	
	_element_protos_folder = game.Workspace.ElementProtos
	_element_protos_folder.Parent = game.ReplicatedStorage
	
	_local_elements_folder = Instance.new("Folder",game.Workspace)
	_local_elements_folder.Name = "LocalElements"
	
	_player_gui = Instance.new("ScreenGui")
	_player_gui.Parent = game.Players.LocalPlayer.PlayerGui
	_player_gui.IgnoreGuiInset = false
	_player_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end

function EnvironmentSetup:set_mode(mode)
	AssertType:is_enum_member(mode, EnvironmentSetup.Mode)
	if mode == EnvironmentSetup.Mode.Game then
		_game_environment.Parent = game.Workspace
	else
		_game_environment.Parent = nil
	end
end

function EnvironmentSetup:get_game_environment_center_position()
	return _game_environment.GameEnvironmentCenter.Position
end

function EnvironmentSetup:get_game_environment()
	return _game_environment
end

function EnvironmentSetup:get_element_protos_folder()
	return _element_protos_folder
end

function EnvironmentSetup:get_local_elements_folder()
	return _local_elements_folder
end

function EnvironmentSetup:get_player_gui_root()
	return _player_gui
end

function EnvironmentSetup:get_robeats_game_stage()
	return _game_environment.Platform
end

return EnvironmentSetup
