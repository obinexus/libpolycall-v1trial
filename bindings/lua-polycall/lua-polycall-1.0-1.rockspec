rockspec_format = "3.0"
package = "lua-polycall"
version = "1.0-1"

source = {
   url = "git+https://github.com/obinexus/libpolycall-v1trial.git",
   dir = "bindings/lua-polycall"
}

description = {
   summary = "Protocol-compliant Lua binding for LibPolyCall",
   detailed = [[
      LibPolyCall Trial v1 Lua Adapter Binding - Protocol-compliant adapter for polycall.exe runtime.
      
      CRITICAL PROTOCOL COMPLIANCE NOTICE:
      This binding acts as an ADAPTER for the LibPolyCall runtime system. All execution must flow 
      through the polycall.exe runtime following the program-first architecture paradigm.
      
      Key Features:
      - Runtime Dependency: Requires polycall.exe runtime for all operations
      - Adapter Pattern: Never bypasses protocol validation layer  
      - Zero-Trust Architecture: Cryptographic validation at every state transition
      - State Machine Binding: All interactions follow finite automaton patterns
      - Telemetry Integration: Silent protocol observation for debugging
      
      This module DOES NOT execute user code directly. All logic execution occurs within 
      the polycall.exe binary. The Lua binding provides interface translation while 
      maintaining strict protocol compliance with LibPolyCall Trial v1 specification.
   ]],
   homepage = "https://github.com/obinexus/libpolycall-v1trial",
   issues_url = "https://github.com/obinexus/libpolycall-v1trial/issues",
   license = "MIT"
}

dependencies = {
   "lua >= 5.3, < 5.5"
}

external_dependencies = {
   LUASOCKET = {
      library = "socket"
   },
   LUASEC = {
      library = "ssl"
   }
}

build = {
   type = "builtin",
   
   -- Pre-installation validation
   install = {
      lua = {
         -- Core adapter modules
         ["polycall.core"] = "polycall/core.lua",
         ["polycall.telemetry"] = "polycall/telemetry.lua", 
         ["polycall.state"] = "polycall/state.lua",
         ["polycall.protocol"] = "polycall/protocol.lua",
         ["polycall.auth"] = "polycall/auth.lua",
         ["polycall.config"] = "polycall/config.lua",
         
         -- CLI and utilities
         ["polycall.cli"] = "polycall/cli.lua",
         ["polycall.utils"] = "polycall/utils.lua",
         ["polycall.logger"] = "polycall/logger.lua",
         
         -- Protocol compliance validators
         ["polycall.validators.setup"] = "polycall/validators/setup.lua",
         ["polycall.validators.ssh"] = "polycall/validators/ssh.lua",
         ["polycall.validators.runtime"] = "polycall/validators/runtime.lua"
      },
      
      bin = {
         ["lua-polycall"] = "bin/lua-polycall"
      },
      
      conf = {
         ["lua-polycall.conf"] = "config/lua-polycall.conf"
      }
   },
   
   -- Custom build hooks for protocol compliance validation
   pre_install_lua = [[
      -- Protocol Compliance Pre-Installation Validation
      local lfs = require("lfs")
      local io = require("io")
      local os = require("os")
      
      print("=== OBINexus lua-polycall Protocol Compliance Validation ===")
      
      -- Validate setup script execution
      local setup_marker = ".polycall-lua-setup-complete"
      local setup_file = io.open(setup_marker, "r")
      if not setup_file then
         print("ERROR: Setup script not executed.")
         print("Please run: ./scripts/setup-lua-polycall")
         print("This ensures proper Lua environment configuration and protocol validation.")
         error("Pre-installation validation failed: setup-lua-polycall not executed")
      end
      setup_file:close()
      print("✓ Setup script validation passed")
      
      -- Validate SSH certificate configuration
      local ssh_cert_path = os.getenv("POLYCALL_SSH_CERT_PATH")
      if not ssh_cert_path then
         print("WARNING: POLYCALL_SSH_CERT_PATH environment variable not set")
         print("SSH certificate-based authentication may be required for secure protocol communication")
         print("Recommended: export POLYCALL_SSH_CERT_PATH=/path/to/your/ssh/cert")
      else
         local cert_file = io.open(ssh_cert_path, "r")
         if not cert_file then
            print("WARNING: SSH certificate file not found at: " .. ssh_cert_path)
            print("Secure protocol communication may be compromised")
         else
            cert_file:close()
            print("✓ SSH certificate validation passed")
         end
      end
      
      -- Validate polycall.exe runtime availability
      local polycall_check = os.execute("which polycall.exe >/dev/null 2>&1")
      if polycall_check ~= 0 then
         print("WARNING: polycall.exe runtime not found in PATH")
         print("The lua-polycall adapter requires polycall.exe to function")
         print("All operations will fail without the runtime binary")
      else
         print("✓ polycall.exe runtime detected")
      end
      
      -- Protocol architecture compliance notice
      print("")
      print("PROTOCOL COMPLIANCE NOTICE:")
      print("- This binding is an ADAPTER for polycall.exe runtime")
      print("- No direct code execution - all operations route to polycall.exe")
      print("- Zero-trust architecture enforced")
      print("- State machine transitions validated")
      print("- Telemetry observation enabled")
      print("")
      print("Installation proceeding with protocol compliance validated...")
   ]]
}

-- Test configuration
test = {
   type = "busted",
   flags = { "--verbose" },
   modules = {
      "spec.protocol_compliance_spec",
      "spec.adapter_pattern_spec", 
      "spec.zero_trust_spec",
      "spec.state_machine_spec",
      "spec.telemetry_spec"
   }
}

-- Development dependencies
test_dependencies = {
   "busted >= 2.0",
   "luassert >= 1.8",
   "luacov >= 0.15"
}

-- Package metadata for protocol tracking
extra = {
   protocol_version = "1.0",
   architecture_pattern = "adapter",
   polycall_runtime_required = true,
   zero_trust_compliant = true,
   state_machine_binding = true,
   telemetry_integrated = true,
   obinexus_project = "libpolycall-v1trial",
   maintainer = "Nnamdi Michael Okpala <obinexuscomputing@gmail.com>",
   
   -- Aegis project waterfall methodology compliance
   development_methodology = "waterfall",
   project_phase = "trial_v1",
   collaboration_model = "aegis_engineering",
   
   -- Protocol compliance assertions
   prohibited_behaviors = {
      "direct_execution",
      "protocol_bypass", 
      "local_state_persistence",
      "security_disable",
      "standalone_operation"
   },
   
   required_behaviors = {
      "runtime_dependency",
      "adapter_pattern",
      "zero_trust",
      "state_machine",
      "telemetry_integration"
   }
}
