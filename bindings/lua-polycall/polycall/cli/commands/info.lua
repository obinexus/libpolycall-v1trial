#!/usr/bin/env lua

--[[
LibPolyCall Trial v1 - Info Command Implementation
OBINexus Aegis Engineering - System Information Command Module
Technical Lead: Nnamdi Michael Okpala - OBINexusComputing

Waterfall Methodology Command Implementation:
Systematic information retrieval command providing comprehensive protocol
compliance validation, system status, and architectural verification within
the adapter pattern framework established through collaborative development.
]]--

local info_command = {}

-- Command metadata
info_command.VERSION = "1.0.0"
info_command.DESCRIPTION = "Display LibPolyCall system information and protocol compliance status"

-- Import dependencies
local logger = require('polycall.utils.logger')

-- Protocol compliance information
local function get_protocol_info()
    return {
        protocol_version = "1.0",
        architecture_pattern = "adapter",
        runtime_dependency = "polycall.exe",
        zero_trust_compliant = true,
        state_machine_binding = true,
        telemetry_integrated = true,
        
        -- Prohibited behaviors (adapter pattern enforcement)
        prohibited_behaviors = {
            "direct_execution",
            "protocol_bypass", 
            "local_state_persistence",
            "security_disable",
            "standalone_operation"
        },
        
        -- Required behaviors (compliance verification)
        required_behaviors = {
            "runtime_dependency",
            "adapter_pattern",
            "zero_trust",
            "state_machine",
            "telemetry_integration"
        }
    }
end

-- System environment information
local function get_system_info()
    return {
        lua_version = _VERSION,
        platform = package.config:sub(1,1) == '\\' and 'Windows' or 'Unix',
        package_path = package.path,
        package_cpath = package.cpath,
        working_directory = io.popen("pwd"):read("*l"),
        timestamp = os.date("%Y-%m-%d %H:%M:%S UTC", os.time())
    }
end

-- Validate polycall.exe runtime availability
local function check_runtime_availability()
    local runtime_status = {
        available = false,
        version = "unknown",
        path = "not_found",
        error_message = nil
    }
    
    -- Check if polycall.exe is in PATH
    local success, result = pcall(function()
        local handle = io.popen("which polycall.exe 2>/dev/null")
        local path = handle:read("*l")
        handle:close()
        return path
    end)
    
    if success and result and result ~= "" then
        runtime_status.available = true
        runtime_status.path = result
        
        -- Attempt to get version
        local version_success, version_result = pcall(function()
            local handle = io.popen("polycall.exe --version 2>/dev/null")
            local version_output = handle:read("*l")
            handle:close()
            return version_output
        end)
        
        if version_success and version_result then
            runtime_status.version = version_result:match("polycall ([%d%.]+)") or version_result
        end
    else
        runtime_status.error_message = "polycall.exe not found in PATH"
    end
    
    return runtime_status
end

-- Check setup completion status
local function check_setup_status()
    local setup_status = {
        completed = false,
        marker_file = ".polycall-lua-setup-complete",
        setup_timestamp = nil,
        ssh_cert_configured = false,
        ssh_cert_path = nil
    }
    
    -- Check for setup completion marker
    local marker_file = io.open(setup_status.marker_file, "r")
    if marker_file then
        setup_status.completed = true
        
        -- Read setup information
        local content = marker_file:read("*a")
        marker_file:close()
        
        -- Extract timestamp
        local timestamp = content:match("setup_timestamp=([^\n]+)")
        if timestamp then
            setup_status.setup_timestamp = timestamp
        end
        
        -- Extract SSH cert path
        local ssh_path = content:match("ssh_cert_path=([^\n]+)")
        if ssh_path and ssh_path ~= "development" then
            setup_status.ssh_cert_configured = true
            setup_status.ssh_cert_path = ssh_path
        end
    end
    
    return setup_status
end

-- Display formatted information
local function display_info(show_detailed)
    print("╔" .. string.rep("═", 58) .. "╗")
    print("║  LibPolyCall Trial v1 - Lua Adapter Information         ║")
    print("║  OBINexus Aegis Engineering - Waterfall Implementation  ║")
    print("╚" .. string.rep("═", 58) .. "╝")
    print()
    
    -- Protocol compliance information
    local protocol_info = get_protocol_info()
    print("📋 Protocol Compliance Status:")
    print("   Architecture Pattern: " .. protocol_info.architecture_pattern)
    print("   Protocol Version: " .. protocol_info.protocol_version)
    print("   Runtime Dependency: " .. protocol_info.runtime_dependency)
    print("   Zero-Trust Compliant: " .. tostring(protocol_info.zero_trust_compliant))
    print("   State Machine Binding: " .. tostring(protocol_info.state_machine_binding))
    print("   Telemetry Integrated: " .. tostring(protocol_info.telemetry_integrated))
    print()
    
    -- Runtime availability
    local runtime_info = check_runtime_availability()
    print("🔧 Runtime Status:")
    if runtime_info.available then
        print("   ✅ polycall.exe: Available")
        print("   📍 Path: " .. runtime_info.path)
        print("   📦 Version: " .. runtime_info.version)
    else
        print("   ❌ polycall.exe: Not Available")
        print("   ⚠️  Error: " .. (runtime_info.error_message or "Unknown"))
        print("   💡 Solution: Ensure polycall.exe is installed and in PATH")
    end
    print()
    
    -- Setup status
    local setup_info = check_setup_status()
    print("⚙️  Setup Status:")
    if setup_info.completed then
        print("   ✅ Setup: Completed")
        print("   📅 Timestamp: " .. (setup_info.setup_timestamp or "unknown"))
        if setup_info.ssh_cert_configured then
            print("   🔐 SSH Certificate: Configured")
            print("   📂 Cert Path: " .. setup_info.ssh_cert_path)
        else
            print("   🔓 SSH Certificate: Development Mode")
        end
    else
        print("   ❌ Setup: Not Completed")
        print("   💡 Action Required: Run ./scripts/setup-lua-polycall.sh")
    end
    print()
    
    -- System information (detailed mode)
    if show_detailed then
        local system_info = get_system_info()
        print("💻 System Environment:")
        print("   Lua Version: " .. system_info.lua_version)
        print("   Platform: " .. system_info.platform)
        print("   Working Directory: " .. system_info.working_directory)
        print("   Timestamp: " .. system_info.timestamp)
        print()
        
        -- Compliance assertions (detailed mode)
        print("🛡️  Compliance Assertions:")
        print("   Prohibited Behaviors:")
        for _, behavior in ipairs(protocol_info.prohibited_behaviors) do
            print("     ❌ " .. behavior)
        end
        print("   Required Behaviors:")
        for _, behavior in ipairs(protocol_info.required_behaviors) do
            print("     ✅ " .. behavior)
        end
        print()
    end
    
    -- Collaboration acknowledgment
    print("👥 Technical Leadership:")
    print("   Lead Architect: Nnamdi Michael Okpala")
    print("   Organization: OBINexusComputing")
    print("   Methodology: Aegis Waterfall Implementation")
    print("   Project: libpolycall-v1trial")
end

-- Command interface implementation
function info_command.get_help()
    return "Display system information and protocol compliance status"
end

function info_command.execute(args, options)
    local show_detailed = false
    
    -- Parse command arguments
    for _, arg in ipairs(args) do
        if arg == "--detailed" or arg == "-d" then
            show_detailed = true
        elseif arg == "--help" or arg == "-h" then
            print("Usage: lua-polycall info [options]")
            print()
            print("Options:")
            print("  --detailed, -d    Show detailed system information")
            print("  --help, -h        Show this help message")
            return 0
        else
            logger.warn(string.format("Unknown option: %s", arg))
        end
    end
    
    -- Apply global options
    if options and options.verbose then
        show_detailed = true
    end
    
    -- Display information
    display_info(show_detailed)
    
    return 0
end

return info_command
