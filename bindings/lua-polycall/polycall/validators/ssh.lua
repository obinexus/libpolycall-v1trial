#!/usr/bin/env lua

--[[
LibPolyCall Trial v1 - SSH Certificate Validator
OBINexus Aegis Engineering - SSH Certificate Validation Framework
Technical Lead: Nnamdi Michael Okpala - OBINexusComputing

VALIDATION ARCHITECTURE:
Implements systematic SSH certificate validation following zero-trust principles.
All SSH operations must route through polycall.exe runtime for security compliance.
]]--

local ssh_validator = {}

-- Import dependencies with graceful degradation
local function safe_require(module_name)
    local success, module = pcall(require, module_name)
    if success then
        return module
    else
        return {
            debug = function() end,
            info = function() end,
            warn = function() end,
            error = function() end
        }
    end
end

local logger = safe_require('polycall.utils.logger')

-- SSH validation constants
ssh_validator.CERTIFICATE_TYPES = {
    RSA = "rsa",
    ECDSA = "ecdsa",
    ED25519 = "ed25519",
    DSA = "dsa"
}

ssh_validator.KEY_LENGTHS = {
    RSA_MIN = 2048,
    RSA_RECOMMENDED = 4096,
    ECDSA_MIN = 256,
    ED25519_LENGTH = 256
}

-- Validate SSH certificate file accessibility
function ssh_validator.validate_certificate_file(cert_path)
    if not cert_path then
        return false, "Certificate path not provided"
    end
    
    if type(cert_path) ~= "string" then
        return false, "Certificate path must be a string"
    end
    
    if #cert_path == 0 then
        return false, "Certificate path cannot be empty"
    end
    
    -- Check file accessibility
    local cert_file = io.open(cert_path, "r")
    if not cert_file then
        return false, string.format("Certificate file not accessible: %s", cert_path)
    end
    
    cert_file:close()
    
    logger.debug("SSH certificate file validation successful", {
        cert_path = cert_path
    })
    
    return true
end

-- Validate SSH certificate content structure
function ssh_validator.validate_certificate_content(cert_path)
    local file_valid, file_error = ssh_validator.validate_certificate_file(cert_path)
    if not file_valid then
        return false, file_error
    end
    
    local success, content = pcall(function()
        local file = io.open(cert_path, "r")
        local content = file:read("*all")
        file:close()
        return content
    end)
    
    if not success then
        return false, "Failed to read certificate file content"
    end
    
    -- Basic SSH certificate format validation
    if not content:match("^ssh%-[%w%-]+") and not content:match("^-----BEGIN") then
        return false, "Invalid SSH certificate format"
    end
    
    -- Check for private key indicators (security validation)
    if content:match("PRIVATE KEY") then
        logger.warn("Private key detected in certificate validation", {
            cert_path = cert_path
        })
        return false, "Private key files should not be used for certificate validation"
    end
    
    logger.debug("SSH certificate content validation successful", {
        cert_path = cert_path,
        content_length = #content
    })
    
    return true
end

-- Get SSH certificate information
function ssh_validator.get_certificate_info(cert_path)
    local valid, error_msg = ssh_validator.validate_certificate_content(cert_path)
    if not valid then
        return nil, error_msg
    end
    
    local cert_info = {
        path = cert_path,
        exists = true,
        accessible = true,
        type = "public_key", -- Default assumption
        format = "openssh",
        validation_timestamp = os.time(),
        
        -- Security metadata
        zero_trust_compliant = true,
        adapter_pattern_enforced = true,
        polycall_runtime_required = true
    }
    
    -- Attempt to determine certificate type from content
    local success, content = pcall(function()
        local file = io.open(cert_path, "r")
        local content = file:read("*all")
        file:close()
        return content
    end)
    
    if success and content then
        if content:match("ssh%-rsa") then
            cert_info.key_type = ssh_validator.CERTIFICATE_TYPES.RSA
        elseif content:match("ssh%-ecdsa") then
            cert_info.key_type = ssh_validator.CERTIFICATE_TYPES.ECDSA
        elseif content:match("ssh%-ed25519") then
            cert_info.key_type = ssh_validator.CERTIFICATE_TYPES.ED25519
        else
            cert_info.key_type = "unknown"
        end
        
        cert_info.content_length = #content
    end
    
    logger.info("SSH certificate information extracted", cert_info)
    
    return cert_info
end

-- Validate SSH configuration for polycall.exe runtime
function ssh_validator.validate_ssh_config(ssh_config)
    if not ssh_config then
        return false, "SSH configuration required"
    end
    
    if type(ssh_config) ~= "table" then
        return false, "SSH configuration must be a table"
    end
    
    -- Validate required SSH configuration fields
    local required_fields = {
        "host",
        "username"
    }
    
    for _, field in ipairs(required_fields) do
        if not ssh_config[field] then
            return false, string.format("Required SSH field missing: %s", field)
        end
    end
    
    -- Validate SSH host format
    if type(ssh_config.host) ~= "string" or #ssh_config.host == 0 then
        return false, "SSH host must be a non-empty string"
    end
    
    -- Validate SSH username format
    if type(ssh_config.username) ~= "string" or #ssh_config.username == 0 then
        return false, "SSH username must be a non-empty string"
    end
    
    -- Validate port if provided
    if ssh_config.port then
        if type(ssh_config.port) ~= "number" then
            return false, "SSH port must be a number"
        end
        
        if ssh_config.port < 1 or ssh_config.port > 65535 then
            return false, "SSH port must be between 1 and 65535"
        end
    end
    
    -- Validate certificate path if provided
    if ssh_config.cert_path then
        local cert_valid, cert_error = ssh_validator.validate_certificate_file(ssh_config.cert_path)
        if not cert_valid then
            return false, string.format("SSH certificate validation failed: %s", cert_error)
        end
    end
    
    logger.debug("SSH configuration validation successful", {
        host = ssh_config.host,
        username = ssh_config.username,
        port = ssh_config.port or 22,
        has_cert_path = ssh_config.cert_path ~= nil
    })
    
    return true
end

-- Generate SSH connection configuration for polycall.exe runtime
function ssh_validator.generate_ssh_connection_config(ssh_config)
    local config_valid, config_error = ssh_validator.validate_ssh_config(ssh_config)
    if not config_valid then
        return nil, config_error
    end
    
    local connection_config = {
        -- Connection parameters
        host = ssh_config.host,
        port = ssh_config.port or 22,
        username = ssh_config.username,
        
        -- Security configuration
        zero_trust_authentication = true,
        adapter_pattern_enforcement = true,
        polycall_runtime_routing = true,
        
        -- Protocol metadata
        protocol_version = "1.0",
        architecture_pattern = "adapter",
        runtime_dependency = "polycall.exe",
        
        -- Validation metadata
        config_validated = true,
        validation_timestamp = os.time(),
        generated_by = "ssh_validator"
    }
    
    -- Include certificate path if provided
    if ssh_config.cert_path then
        connection_config.cert_path = ssh_config.cert_path
        connection_config.authentication_method = "certificate"
    else
        connection_config.authentication_method = "interactive"
    end
    
    logger.info("SSH connection configuration generated", {
        host = connection_config.host,
        port = connection_config.port,
        username = connection_config.username,
        auth_method = connection_config.authentication_method
    })
    
    return connection_config
end

-- Test SSH connectivity through polycall.exe runtime
function ssh_validator.test_ssh_connectivity(ssh_config)
    local config_valid, config_error = ssh_validator.validate_ssh_config(ssh_config)
    if not config_valid then
        return false, config_error
    end
    
    logger.protocol("Testing SSH connectivity through polycall.exe runtime", {
        host = ssh_config.host,
        username = ssh_config.username,
        adapter_pattern = true
    })
    
    -- ADAPTER PATTERN ENFORCEMENT:
    -- All SSH connectivity must route through polycall.exe runtime
    -- Direct SSH connections are prohibited
    local test_result = {
        connected = false,
        message = "SSH connectivity testing requires polycall.exe runtime",
        adapter_pattern_enforced = true,
        zero_trust_compliant = true,
        runtime_dependency = "polycall.exe",
        test_timestamp = os.time()
    }
    
    -- In production, this would route the SSH test through polycall.exe
    -- For demonstration, we show adapter pattern compliance
    logger.info("SSH connectivity test completed", test_result)
    
    return test_result
end

-- Get SSH validator status information
function ssh_validator.get_validator_status()
    return {
        module_name = "ssh_validator",
        version = "1.0.0",
        protocol_version = "1.0",
        architecture_pattern = "adapter",
        zero_trust_compliant = true,
        supported_key_types = ssh_validator.CERTIFICATE_TYPES,
        minimum_key_lengths = ssh_validator.KEY_LENGTHS,
        runtime_dependency = "polycall.exe",
        validation_capabilities = {
            "certificate_file_validation",
            "certificate_content_validation",
            "ssh_config_validation",
            "connection_config_generation",
            "connectivity_testing"
        }
    }
end

return ssh_validator
