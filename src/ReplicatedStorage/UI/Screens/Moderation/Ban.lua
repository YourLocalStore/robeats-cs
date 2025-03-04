local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedTextBox = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextBox)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local Ban = Roact.Component:extend("Ban")

local function noop() end

Ban.defaultProps = {
    OnBan = noop
}

function Ban:init()
    self.moderationService = self.props.moderationService

    self:setState({
        banReason = ""
    })
end

function Ban:render()
    local state = self.props.location.state

    return e(RoundedFrame, {
        
    }, {
        BanText = e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.5, 0.4),
            AnchorPoint = Vector2.new(0.5, 1),
            Size = UDim2.fromScale(0.5, 0.1),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(172, 172, 172),
            Text = string.format("Are you sure you want to ban %s?", state.playerName),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextScaled = true
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 26
            })
        }),
        BanReason = e(RoundedTextBox, {
            Position = UDim2.fromScale(0.5, 0.52),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromScale(0.5 , 0.2),
            BackgroundColor3 = Color3.fromRGB(51, 51, 51),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            ClearTextOnFocus = false,
            Text = self.state.banReason,
            TextScaled = true,
            TextWrapped = true,
            PlaceholderText = "Ban reason...",
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            [Roact.Change.Text] = function(banReason)
                self:setState({
                    banReason = banReason.Text
                })
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 22
            })
        }),
        BackButton = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.25, 0.65),
            Size = UDim2.fromScale(0.245, 0.05),
            HoldSize = UDim2.fromScale(0.25, 0.05),
            BackgroundColor3 = Color3.fromRGB(78, 78, 78),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            OnClick = function()
                self.props.history:goBack()
            end
        }),
        BanButton = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.5, 0.65),
            Size = UDim2.fromScale(0.25, 0.05),
            HoldSize = UDim2.fromScale(0.25, 0.05),
            BackgroundColor3 = Color3.fromRGB(228, 19, 19),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Ban",
            OnClick = function()
                self.moderationService:BanUser(state.userId, self.state.banReason)
                self.props.history:goBack()
            end
        })
    })
end

return withInjection(Ban, {
    moderationService = "ModerationService"
})