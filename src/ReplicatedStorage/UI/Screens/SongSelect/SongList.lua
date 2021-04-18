local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Promise = require(game.ReplicatedStorage.Knit.Util.Promise)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedLargeScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedLargeScrollingFrame)

local SongButton = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongButton)

local SongList = Roact.Component:extend("SongList")

local function noop() end

SongList.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    OnSongSelected = noop
}

-- LOL SEARCHING GO BYE BYE, PLEASE FIX
-- RIP SEARCHING

--[[
    startIndex = floor(scrollPosition / elementHeight)
    endIndex = ceil((scrollPosition + scrollSize) / elementHeight)
]]

function SongList:init()
    self._songbuttons = {}
    self._list_layout_ref = Roact.createRef()
    self:setState({
        search = "";
        found = SongDatabase:filter_keys();
    })

    self.OnSearchChanged = function(o)
        self:setState({
            search = o.Text;
        })
    end
end


function SongList:didUpdate(_, prevState)
    if self.state.search ~= prevState.search then
        Promise.new(function(resolve)
            resolve(SongDatabase:filter_keys(self.state.search))
        end):andThen(function(found)
            self:setState({
                found = found
            })
        end)
    end
end

function SongList:render()
    return Roact.createElement("Frame", {
        AnchorPoint = self.props.AnchorPoint,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = self.props.Position,
        Size = self.props.Size,
    }, {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),
        SongList = Roact.createElement(RoundedLargeScrollingFrame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.05, 0),
            Size = UDim2.new(1, 0, 0.95, 0),
            Padding = UDim.new(0, 4),
            HorizontalAlignment = "Right",
            items = self.state.found;
            renderItem = function(id)
                return Roact.createElement(SongButton, {
                    SongKey = id,
                    OnClick = self.props.OnSongSelected
                })
            end,
            getStableId = function(id)
                return id
            end,
            getItemSize = function()
                return 80
            end
        }),
        SearchBar = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.fromRGB(31, 31, 31),
            Position = UDim2.new(1, 0, 0.04, 0),
            Size = UDim2.new(1, 0, 0.04, 0),
            AnchorPoint = Vector2.new(1, 1),
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
            SearchBox = Roact.createElement("TextBox", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.02, 0, 0, 0),
                Size = UDim2.new(0.98, 0, 1, 0),
                ClearTextOnFocus = false,
                Font = Enum.Font.GothamBold,
                PlaceholderColor3 = Color3.fromRGB(181, 181, 181),
                PlaceholderText = "Search here...",
                Text = self.state.search,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Roact.Change.Text] = self.OnSearchChanged
            }, {
                UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 17,
                    MinTextSize = 7,
                })
            })
        })
    })
end

return SongList
