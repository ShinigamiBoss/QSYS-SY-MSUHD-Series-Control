PluginInfo = {
    Name = "SY Electronics~MSUHD Series",
    Version = "1.0.0-master",
    Id = "q-sys.community.template.0.0.0-master", -- show this is just a unique id. Show some commented out 'fun' unique ids
    Description = "A Plugin for control the SY Electronics MSUHD matrix series",
    ShowDebug = true,
    Author = "Fabio Feliciosi"
}

ButtonSize = {50,30}



function GetProperties()
    props = {
        {
            Name = "IP Address",
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
        
    }
    return props
end

function GetControls(props)
    return {
        {
            Name = "In",
            ControlType = "Button",
            ButtonType = "Toggle",
            Count = props["Input #"].Value,
            DefautlValue = 8

        },
        {
            Name = "Out",
            ControlType = "Button",
            ButtonType = "Toggle",
            Count = props["Output #"].Value,
            DefautlValue = 8
        }
    }
end


function GetControlLayout(props)

    -- layout holds representaiton of Controls
    local layout = {}

    local graphics = {}

    for x=1,props["Input #"].Value do
        layout["In "..x] = {
            Size = ButtonSize,
            Style = "Button",
            ButtonStyle = "Toggle",
            Position = { ButtonSize[1]*(x - 1) + 50, 10 },
        }
    end

    for x=1,props["Output #"].Value do
        layout["Out "..x] = {
            Style = "Button",
            ButtonStyle = "Toggle",
            Position = { ButtonSize[1]*(x - 1) + 50, 40 },
            Size = ButtonSize,
        }
    end

    graphics = {
        {
            Type = "Label",
            Text = "Input",
            HTextAlign = "Left",
            Position = { 10, 10 },
            Size = { 40, ButtonSize[2] }
        },
        {
            Type = "Label",
            Text = "Output",
            HTextAlign = "Left",
            Position = { 10, 40 },
            Size = { 40, ButtonSize[2] }
        },
    }

    return layout, graphics;
end


function MutuallyExclude(val, on)
    for index, value in ipairs(val) do
        value.Boolean = false
    end
    val[on].Boolean = true
end

--Communication variables
SetOut = "SET OUT"
SetIn = " VS IN"
GetStatus = "GET STA\r"

if Controls then

    sock = TcpSocket.New()
    sock.ReconnectTimeout = 5

    function SendCommand(command)
        if sock.IsConnected == true then
            sock:Write(command.."\r")
        else
            sock:Connect(Properties["IP Address"].Value, Properties["Port"].Value)
            Timer.CallAfter(function()
                    if sock.IsConnected ==true then
                        sock:Write(command.."\r")
                    else
                        print("Cannot connect to machine...")
                    end
                 end, 1)
        end
    end

    --Defautl input selection is 1
    SelectedInput = 1

    Inputs = {}

    for x=1, Properties["Input #"].Value do
        Inputs[x] = Controls["In"][x]

        Inputs[x].EventHandler = function()
            SelectedInput = x
            MutuallyExclude(Inputs,x)
        end
    end

    MutuallyExclude(Inputs, SelectedInput)

    Outputs = {}

    for x=1, Properties["Output #"].Value do
        Outputs[x] = Controls["Out"][x]

        Outputs[x].EventHandler = function()
            Command = SetOut..x..SetIn..SelectedInput
            SendCommand(Command)
        end
    end
    
    sock:Connect(Properties["IP Address"].Value, Properties["Port"].Value)

    feedback = Timer:New()
    feedback.EventHandler = function()
        SendCommand(GetStatus)
    end

    feedback:Start(1)

    sock.Data = function(sock)
        --TODO Handle Feedback
        SocketData = sock:ReadLine(TcpSocket.EOL.CrLf)
        print(SocketData)
    end
end