#!/usr/bin/env lua

--[[
LibPolyCall Trial v1 - Info Command Implementation
OBINexus Aegis Engineering - Protocol Information Display
Technical Lead: Nnamdi Michael Okpala - OBINexusComputing

COMMAND ARCHITECTURE:
Implements systematic information display following the adapter pattern protocol.
Provides comprehensive protocol compliance information and system diagnostics.
]]--

local info_command = {}

-- Command metadata
info_command.VERSION = "1.0.0"
info_command.DESCRIPTION = "Display protocol binding information and system diagnostics"

-- Import dependencies with graceful degradation
local function safe_require(module_name)
    local success, module = pcall(require, module_name)
    if success then
        return module
    else
        -- Return mock logger for standalone operation
        return {
            debug = function() end,
            info = function() end,
            warn = function() end,
            error = function() end
        }
    end
end

local logger = safe_require('polycall.utils.logger')
local validator = safe_require('polycall.utils.validator')

-- Protocol information constants
local PROTOCOL_INFO = {
    version = "1.0",
    architecture_pattern = "adapter",
    runtime_dependency = "polycall.exe",
    binding_type = "lua",
    compliance_level = "zero_trust",
    author = "Nnamdi Michael Okpala - OBINexusComputing",
    project = "libpolycall-v1trial",
    license = "MIT"
}

-- System diagnostic functions
local function get_lua_version()
    return _VERSION or "Unknown Lua Version"
end

local function get_system_info()
    local info = {
        lua_version = get_lua_version(),
        platform = os.getenv("OS") or "Unix-like",
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        working_directory = os.getenv("PWD") or "Unknown"
    }
    return info
end

local function check_polycall_runtime()
    -- Attempt to detect polycall.exe runtime availability
    local success, result = pcall(function()
        local handle = io.popen("which polycall.exe 2>/dev/null || echo 'not_found'")
        local output = handle:read("*l")
        handle:close()
        return output and output ~= "not_found" and output ~= ""
    end)
    
    return {
        available = success and result,
        path = result and success and result or "Not Found",
        status = success and result and "Available" or "Not Available"
    }
end

local function get_module_status()
    local modules = {
        "polycall.core.binding",
        "polycall.core.protocol", 
        "polycall.core.state",
        "polycall.core.telemetry",
        "polycall.core.auth",
        "polycall.utils.logger",
        "polycall.utils.validator",
        "polycall.utils.crypto"
    }
    
    local status = {}
    for _, module_name in ipairs(modules) do
        local success, _ = pcall(require, module_name)
        status[module_name] = success and "✓ Available" or "✗ Missing"
    end
    
    return status
end

-- Command help text
function info_command.get_help()
    return "Display protocol binding information and system diagnostics"
end

-- Main command execution
function info_command.execute(args, options)
    logger.info("Executing info command", {
        args_count = #args,
        detailed = options and options.detailed or false
    })
    
    -- Parse command arguments
    local show_detailed = false
    local show_system = false
    local show_modules = false
    
    for _, arg in ipairs(args) do
        if arg == "--detailed" then
            show_detailed = true
        elseif arg == "--system" then
            show_system = true
        elseif arg == "--modules" then
            show_modules = true
        elseif arg == "--all" then
            show_detailed = true
            show_system = true
            show_modules = true
        end
    end
    
    -- Default to basic info if no specific flags
    if not show_detailed and not show_system and not show_modules then
        show_detailed = options and options.detailed or false
    end
    
    -- Display protocol information header
    print("================================================================")
    print("  LibPolyCall Trial v1 - Lua Adapter Binding")
    print("  OBINexus Aegis Engineering - Protocol Information")
    print("  Technical Lead: " .. PROTOCOL_INFO.author)
    print("================================================================")
    print("")
    
    -- Basic protocol information
    print("Protocol Information:")
    print(string.format("  Version: %s", PROTOCOL_INFO.version))
    print(string.format("  Architecture Pattern: %s", PROTOCOL_INFO.architecture_pattern))
    print(string.format("  Runtime Dependency: %s", PROTOCOL_INFO.runtime_dependency))
    print(string.format("  Binding Type: %s", PROTOCOL_INFO.binding_type))
    print(string.format("  Compliance Level: %s", PROTOCOL_INFO.compliance_level))
    print(string.format("  Project: %s", PROTOCOL_INFO.project))
    print(string.format("  License: %s", PROTOCOL_INFO.license))
    print("")
    
    -- Detailed information
    if show_detailed then
        print("Detailed Protocol Specifications:")
        print("  • Zero-Trust Architecture: All operations route through polycall.exe")
        print("  • Adapter Pattern Enforcement: No direct execution permitted")
        print("  • State Machine Validation: Protocol transitions validated")
        print("  • Telemetry Integration: Silent observation framework enabled")
        print("  • Cryptographic Security: Zero-trust authentication required")
        print("  • Systematic Validation: Input validation framework active")
        print("")
        
        -- Runtime status
        local runtime_status = check_polycall_runtime()
        print("Runtime Status:")
        print(string.format("  polycall.exe Status: %s", runtime_status.status))
        print(string.format("  Runtime Path: %s", runtime_status.path))
        print("")
    end
    
    -- System information
    if show_system then
        local system_info = get_system_info()
        print("System Information:")
        print(string.format("  Lua Version: %s", system_info.lua_version))
        print(string.format("  Platform: %s", system_info.platform))
        print(string.format("  Timestamp: %s", system_info.timestamp))
        print(string.format("  Working Directory: %s", system_info.working_directory))
        print("")
    end
    
    -- Module status
    if show_modules then
        print("Module Dependencies:")
        local module_status = get_module_status()
        for module_name, status in pairs(module_status) do
            print(string.format("  %-30s %s", module_name, status))
        end
        print("")
    end
    
    -- Protocol compliance notice
    print("Protocol Compliance Notice:")
    print("  This adapter binding enforces the LibPolyCall protocol specification.")
    print("  All operations must route through polycall.exe runtime for compliance.")
    print("  Direct execution is prohibited under the adapter pattern architecture.")
    print("")
    
    -- Usage guidance
    if show_detailed then
        print("Usage Examples:")
        print("  lua-polycall info                    # Basic information")
        print("  lua-polycall info --detailed         # Detailed protocol specs")
        print("  lua-polycall info --system           # System diagnostics")
        print("  lua-polycall info --modules          # Module dependency status")
        print("  lua-polycall info --all              # Complete information")
        print("")
    end
    
    logger.info("Info command completed successfully")
    return 0
end

-- Command validation
function info_command.validate()
    return true
end

-- Export command module
return info_command
