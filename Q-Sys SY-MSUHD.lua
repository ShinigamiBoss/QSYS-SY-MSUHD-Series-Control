--require("QSYS Lua Extension")

PluginInfo = {
    Name = "SY Electronics~MSUHD Series",
    Version = "1.0.0-master",
    Id = "q-sys.community.template.0.0.0-master", -- show this is just a unique id. Show some commented out 'fun' unique ids
    Description = "A Plugin for control the SY Electronics MSUHD matrix series",
    ShowDebug = true,
    Author = "Fabio Feliciosi"
}

-- We can let users determine some of the plugin properties by exposing them here
-- While this function can be very useful, it is completely optional and not always needed.
-- If no Properties are set here, only the position and fill properties of your plugin will show in the Properties pane
function GetProperties()
    props = {
        {
            Name = "IP Adress",
            Type = "string",
            Value = "192.168.1.239"
        },
        {
            Name = "Port",
            Type = "integer",
            Min = 1,
            Max = 65535,
            Value = 23
        },
        {
            Name = "Input #",
            Type = "integer",
            Value = 8,
            Min = 1,
            Max = 64
        },
        {
            Name = "Output #",
            Type = "integer",
            Value = 8,
            Min = 1,
            Max = 64
        },
        {
            Name = "On In Color",
            Type = "string",
            Value = "#FFDF0024"
        },
        {
            Name = "Off In Color",
            Type = "string",
            Value = "#FF6C000D"
        },
        {
            Name = "On Out Color",
            Type = "string",
            Value = "#FFF289AE"
        },
        {
            Name = "Off Out Color",
            Type = "string",
            Value = "#FF754053"
        }
    }
    return props
end

-- The below function is where you will populate the controls for your plugin.
-- If you've written some of the Runtime code already, simply use the control names you populated in Text Controller/Control Script, and use their Properties to inform the values here
-- ControlType can be Button, Knob, Indicator or Text
-- ButtonType ( ControlType == Button ) can be Momentary, Toggle or Trigger
-- IndicatorType ( ControlType == Indicator ) can be Led, Meter, Text or Status
-- ControlUnit ( ControlType == Knob ) can be Hz, Float, Integer, Pan, Percent, Position or Seconds
function GetControls(props)
    ctls = {
        {
            Name = "InputButton",
            ControlType = "Button",
            ButtonType = "Trigger",
            Count = props["Input #"].Value,
            UserPin = true
        },
        {
            Name = "InputButton",
            ControlType = "Button",
            ButtonType = "Trigger",
            Count = props["Output #"].Value,
            UserPin = true
        },
    }
    return ctls
end
