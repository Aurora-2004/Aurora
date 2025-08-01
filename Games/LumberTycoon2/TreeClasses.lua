local Month = os.date("%B")
local Trees = {

    ["Generic"]     = true,
    ["Oak"]         = true,
    ["Cherry"]      = true,
    ["SnowGlow"]    = true,
    ["Pine"]        = true,
    ["Fir"]         = true,
    ["Frost"]       = true,
    ["Birch"]       = true,
    ["Volcano"]     = true,
    ["GoldSwampy"]  = true,
    ["GreenSwampy"] = true,
    ["Palm"]        = true,
    ["Walnut"]      = true,
    ["Koa"]         = true,
    ["CaveCrawler"] = true,
    ["LoneCave"]    = true,
    ["Spooky"]      = Month == "October",
    ["SpookyNeon"]  = Month == "October",
    ["BlueSpruce"]  = Month == "December",

}

return Trees
