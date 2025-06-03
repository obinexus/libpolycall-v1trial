"""
ProtocolBinding - Core Adapter for polycall.exe
PROTOCOL LAW: This class acts as ADAPTER ONLY
"""

import asyncio
import logging
from typing import Any, Dict, Optional, Callable
from ..protocol.handler import ProtocolHandler
from ..protocol.constants import DEFAULT_POLYCALL_PORT

logger = logging.getLogger(__name__)

class ProtocolBinding:
    """
    Core Protocol Binding Adapter
    
    PROTOCOL COMPLIANCE:
    - Acts as adapter to polycall.exe runtime
    - Never bypasses protocol validation
    - Submits all user logic through FFI/config
    - Maintains zero-trust architecture
    """
    
    def __init__(self, 
                 polycall_host: str = "localhost",
                 polycall_port: int = DEFAULT_POLYCALL_PORT,
                 binding_config: Optional[Dict[str, Any]] = None):
        """
        Initialize Protocol Binding Adapter
        
        Args:
            polycall_host: polycall.exe runtime host
            polycall_port: polycall.exe runtime port (default: 8084)
            binding_config: Adapter configuration
        """
        self.polycall_host = polycall_host
        self.polycall_port = polycall_port
        self.config = binding_config or {}
        
        # Protocol handler - ADAPTER ONLY
        self.protocol_handler = ProtocolHandler(
            host=polycall_host,
            port=polycall_port
        )
        
        # User logic registry (submitted to polycall.exe)
        self.user_handlers: Dict[str, Callable] = {}
        
        # Connection state
        self._connected = False
        self._authenticated = False
        
        logger.info(f"ProtocolBinding initialized for {polycall_host}:{polycall_port}")
    
    async def connect(self) -> bool:
        """
        Connect to polycall.exe runtime
        
        Returns:
            bool: Connection success
        """
        try:
            await self.protocol_handler.connect()
            self._connected = True
            logger.info("Connected to polycall.exe runtime")
            return True
        except Exception as e:
            logger.error(f"Failed to connect to polycall.exe: {e}")
            return False
    
    async def authenticate(self, credentials: Dict[str, Any]) -> bool:
        """
        Authenticate with polycall.exe runtime
        
        Args:
            credentials: Authentication credentials
            
        Returns:
            bool: Authentication success
        """
        if not self._connected:
            raise RuntimeError("Must connect before authentication")
        
        try:
            success = await self.protocol_handler.authenticate(credentials)
            self._authenticated = success
            if success:
                logger.info("Authenticated with polycall.exe runtime")
            return success
        except Exception as e:
            logger.error(f"Authentication failed: {e}")
            return False
    
    def register_handler(self, route: str, handler: Callable) -> None:
        """
        Register user logic handler (submitted to polycall.exe)
        
        Args:
            route: API route pattern
            handler: User logic function
            
        Note:
            Handler is registered but execution controlled by polycall.exe
        """
        if not callable(handler):
            raise ValueError("Handler must be callable")
        
        self.user_handlers[route] = handler
        logger.info(f"Handler registered for route: {route}")
        
        # Submit handler declaration to polycall.exe
        asyncio.create_task(self._submit_handler_declaration(route, handler))
    
    async def _submit_handler_declaration(self, route: str, handler: Callable) -> None:
        """
        Submit handler declaration to polycall.exe runtime
        
        Args:
            route: API route
            handler: Handler function
        """
        if not self._authenticated:
            logger.warning(f"Cannot submit handler {route} - not authenticated")
            return
        
        try:
            # Submit through protocol handler to polycall.exe
            await self.protocol_handler.submit_handler_declaration(route, handler)
            logger.info(f"Handler declaration submitted for {route}")
        except Exception as e:
            logger.error(f"Failed to submit handler declaration: {e}")
    
    async def execute_request(self, route: str, data: Any) -> Any:
        """
        Execute request through polycall.exe runtime
        
        Args:
            route: Target route
            data: Request data
            
        Returns:
            Any: Response from polycall.exe execution
        """
        if not self._authenticated:
            raise RuntimeError("Must authenticate before request execution")
        
        # All execution goes through polycall.exe - NEVER bypass
        return await self.protocol_handler.execute_request(route, data)
    
    async def shutdown(self) -> None:
        """Shutdown binding adapter"""
        try:
            await self.protocol_handler.disconnect()
            self._connected = False
            self._authenticated = False
            logger.info("ProtocolBinding shutdown complete")
        except Exception as e:
            logger.error(f"Shutdown error: {e}")
    
    @property
    def is_connected(self) -> bool:
        """Check if connected to polycall.exe"""
        return self._connected
    
    @property 
    def is_authenticated(self) -> bool:
        """Check if authenticated with polycall.exe"""
        return self._authenticated
