local Maid = {Connections = {}, Properties = {Debug = false}}

function Maid:Traceback(...)
    if self.Properties.Debug then
        return warn(...)
    end
end

function Maid:Verify(Name)
    return rawget(self.Connections, Name)
end

function Maid:Register(Name, Callback)
    if self:Verify(Name) then
        return false, self:Traceback(Name, "Is already registered")
    end
    self.Connections[Name] = Callback
    local Registered = self:Verify(Name)
    if Registered then
        self:Traceback(Name, "Was registered")
    end
    return Registered
end

function Maid:DeRegister(Name)
    local Connection = self:Verify(Name)
    if not Connection then
        return
    end
    if typeof(Connection) == "RBXScriptConnection" then
		Connection:Disconnect()
	end
	rawset(self.Connections, Name, nil)
	self:Traceback(Name, "Was deregistered")
    return self:Verify(Name)
end

function Maid:ClearRegister()
    for Connection in next, self.Connections do
        self:DeRegister(Connection)
    end
    return true, self:Traceback("Register was cleared")
end

return Maid
