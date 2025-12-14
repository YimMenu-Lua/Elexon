
--MP Helper
local util = {}

function util.mp()
    return "MP" .. stats.get_int("MPPLY_LAST_MP_CHAR") .. "_"
end

return util