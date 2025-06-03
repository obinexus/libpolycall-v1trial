"""
Protocol Constants - LibPolyCall Trial v1
PROTOCOL LAW: These constants define the contract with polycall.exe
"""

# Protocol Version
PROTOCOL_VERSION = "1.0"

# Default polycall.exe runtime port
DEFAULT_POLYCALL_PORT = 8084

# Message Types (must match polycall.exe protocol)
MESSAGE_TYPES = {
    "HANDSHAKE": 0x01,
    "AUTH": 0x02, 
    "COMMAND": 0x03,
    "RESPONSE": 0x04,
    "ERROR": 0x05,
    "HEARTBEAT": 0x06,
    "HANDLER_DECLARATION": 0x07,
    "REQUEST_EXECUTION": 0x08,
    "STATE_TRANSITION": 0x09,
    "TELEMETRY": 0x0A,
}

# State Machine Transitions (zero-trust sequence)
STATE_TRANSITIONS = {
    "INIT": ["HANDSHAKE"],
    "HANDSHAKE": ["AUTH", "ERROR"],
    "AUTH": ["READY", "ERROR"],
    "READY": ["EXECUTING", "HEARTBEAT", "SHUTDOWN"],
    "EXECUTING": ["READY", "ERROR"],
    "HEARTBEAT": ["READY"],
    "ERROR": ["INIT", "SHUTDOWN"],
    "SHUTDOWN": []
}

# Handshake Sequence (cryptographic verification)
HANDSHAKE_SEQUENCE = {
    "MAGIC_NUMBER": 0x504C43,  # "PLC"
    "VERSION_CHECK": True,
    "CRYPTO_SEED_REQUIRED": True,
    "ZERO_TRUST_VALIDATION": True,
}

# Protocol Flags
PROTOCOL_FLAGS = {
    "NONE": 0x00,
    "ENCRYPTED": 0x01,
    "COMPRESSED": 0x02,
    "URGENT": 0x04,
    "RELIABLE": 0x08,
    "ZERO_TRUST": 0x10,
}

# Telemetry Constants
TELEMETRY_TYPES = {
    "STATE_CHANGE": "state_change",
    "REQUEST_TRACE": "request_trace",
    "ERROR_CAPTURE": "error_capture",
    "PERFORMANCE_METRIC": "performance_metric",
    "SECURITY_EVENT": "security_event",
}

# Error Codes
ERROR_CODES = {
    "PROTOCOL_VIOLATION": 1001,
    "AUTHENTICATION_FAILED": 1002,
    "UNAUTHORIZED_ACCESS": 1003,
    "STATE_TRANSITION_INVALID": 1004,
    "HANDLER_NOT_FOUND": 1005,
    "EXECUTION_TIMEOUT": 1006,
    "CRYPTO_VERIFICATION_FAILED": 1007,
}
