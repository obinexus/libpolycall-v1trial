"""
PyPolyCall - LibPolyCall Trial v1 Python Binding
Protocol-compliant adapter for polycall.exe runtime

PROTOCOL LAW COMPLIANCE:
- This binding acts as an ADAPTER, not an engine
- All execution must go through polycall.exe
- No bypassing of protocol runtime allowed
- Zero-trust architecture enforced
"""

import sys
import warnings
from typing import Optional

# Version and metadata
__version__ = "1.0.0"
__author__ = "OBINexusComputing"
__protocol_version__ = "1.0"
__polycall_min_version__ = "1.0.0"

# Protocol compliance check
def _check_protocol_compliance():
    """Verify protocol compliance at import time"""
    if sys.version_info < (3, 8):
        raise ImportError("PyPolyCall requires Python 3.8 or higher for protocol compliance")

# Perform compliance check
_check_protocol_compliance()

# Core binding imports - ADAPTER PATTERN ONLY
try:
    from .core.client import PolyCallClient
    from .core.binding import ProtocolBinding
    from .protocol.handler import ProtocolHandler
    from .protocol.state_machine import StateMachine
    from .config.manager import ConfigManager
    from .telemetry.observer import TelemetryObserver
    
    # Protocol constants
    from .protocol.constants import (
        PROTOCOL_VERSION,
        DEFAULT_POLYCALL_PORT,
        MESSAGE_TYPES,
        STATE_TRANSITIONS,
        HANDSHAKE_SEQUENCE
    )
    
except ImportError as e:
    warnings.warn(f"PyPolyCall binding incomplete: {e}", ImportWarning)
    # Define minimal interface for graceful degradation
    PolyCallClient = None
    ProtocolBinding = None

# Public API - ADAPTER INTERFACE ONLY
__all__ = [
    # Core adapter classes
    "PolyCallClient",
    "ProtocolBinding", 
    "ProtocolHandler",
    "StateMachine",
    "ConfigManager",
    "TelemetryObserver",
    
    # Protocol constants
    "PROTOCOL_VERSION",
    "DEFAULT_POLYCALL_PORT", 
    "MESSAGE_TYPES",
    "STATE_TRANSITIONS",
    "HANDSHAKE_SEQUENCE",
    
    # Metadata
    "__version__",
    "__author__",
    "__protocol_version__",
]

# Protocol compliance documentation
def get_protocol_info() -> dict:
    """
    Get protocol compliance information
    
    Returns:
        dict: Protocol compliance metadata
    """
    return {
        "binding_version": __version__,
        "protocol_version": __protocol_version__,
        "polycall_runtime_required": True,
        "adapter_pattern": True,
        "zero_trust_compliant": True,
        "state_machine_binding": True,
        "telemetry_enabled": True,
    }

# Compliance warning for developers
def _protocol_warning():
    """Issue protocol compliance warning"""
    print("=" * 60)
    print("PYPOLYCALL PROTOCOL COMPLIANCE NOTICE")
    print("=" * 60)
    print("This binding is an ADAPTER for polycall.exe runtime.")
    print("- Do NOT bypass polycall.exe for execution")
    print("- All logic must submit to protocol validation")
    print("- Use FFI and config for behavior declaration")
    print("- Runtime behavior controlled by polycall.exe ONLY")
    print("=" * 60)

# Show warning on import (development mode)
if __debug__:
    _protocol_warning()
