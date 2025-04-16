return {
    Checks = {
        command = "check",    --Command for checking /check by default
        policejob = "police", --If you want to add more PD jobs, edit the "isLEO function" in server.lua
        maxadams = 20,        --Maximal of "adams" can be full
        maxunions = 20,       --Maximal of "unions" can be full
        notify = "ox_lib",    -- ox_lib / custom, you can edit it in client.lua at the bottom
    }
}
