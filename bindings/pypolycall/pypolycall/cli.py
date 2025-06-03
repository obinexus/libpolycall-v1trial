"""
PyPolyCall CLI Entry Point
Command-line interface for LibPolyCall Trial v1 Python binding
"""

import sys
import argparse
import asyncio
import logging
from typing import Optional

from .core.client import PolyCallClient
from .core.binding import ProtocolBinding
from .config.manager import ConfigManager

def setup_logging(level: str = "INFO") -> None:
    """Setup logging configuration"""
    logging.basicConfig(
        level=getattr(logging, level.upper()),
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )

def create_parser() -> argparse.ArgumentParser:
    """Create command line argument parser"""
    parser = argparse.ArgumentParser(
        description="PyPolyCall - LibPolyCall Trial v1 Python Binding",
        epilog="Protocol compliance: This binding requires polycall.exe runtime"
    )
    
    parser.add_argument(
        "--version", 
        action="version",
        version="PyPolyCall 1.0.0"
    )
    
    parser.add_argument(
        "--host",
        default="localhost",
        help="polycall.exe runtime host (default: localhost)"
    )
    
    parser.add_argument(
        "--port", 
        type=int,
        default=8084,
        help="polycall.exe runtime port (default: 8084)"
    )
    
    parser.add_argument(
        "--config",
        help="Configuration file path"
    )
    
    parser.add_argument(
        "--log-level",
        choices=["DEBUG", "INFO", "WARNING", "ERROR"],
        default="INFO",
        help="Logging level (default: INFO)"
    )
    
    subparsers = parser.add_subparsers(dest="command", help="Available commands")
    
    # Client command
    client_parser = subparsers.add_parser("client", help="Start PolyCall client")
    client_parser.add_argument("--auth", help="Authentication credentials file")
    
    # Test command  
    test_parser = subparsers.add_parser("test", help="Test protocol connection")
    
    # Info command
    info_parser = subparsers.add_parser("info", help="Show protocol information")
    
    return parser

async def run_client(host: str, port: int, auth_file: Optional[str] = None) -> None:
    """Run PolyCall client"""
    client = PolyCallClient(host=host, port=port)
    
    try:
        print(f"Connecting to polycall.exe at {host}:{port}...")
        await client.connect()
        print("Connected successfully!")
        
        if auth_file:
            print(f"Authenticating with {auth_file}...")
            # Load auth credentials and authenticate
            # Implementation depends on auth file format
        
        print("Client ready. Press Ctrl+C to exit.")
        
        # Keep client running
        while True:
            await asyncio.sleep(1)
            
    except KeyboardInterrupt:
        print("\nShutting down client...")
    except Exception as e:
        print(f"Client error: {e}")
    finally:
        await client.shutdown()

async def test_connection(host: str, port: int) -> None:
    """Test connection to polycall.exe runtime"""
    binding = ProtocolBinding(polycall_host=host, polycall_port=port)
    
    try:
        print(f"Testing connection to polycall.exe at {host}:{port}...")
        success = await binding.connect()
        
        if success:
            print("✓ Connection successful")
            print("✓ Protocol handshake completed")
        else:
            print("✗ Connection failed")
            sys.exit(1)
            
    except Exception as e:
        print(f"✗ Connection test failed: {e}")
        sys.exit(1)
    finally:
        await binding.shutdown()

def show_info() -> None:
    """Show protocol and binding information"""
    from . import get_protocol_info
    
    info = get_protocol_info()
    
    print("PyPolyCall Protocol Information")
    print("=" * 40)
    print(f"Binding Version: {info['binding_version']}")
    print(f"Protocol Version: {info['protocol_version']}")
    print(f"Runtime Required: {info['polycall_runtime_required']}")
    print(f"Adapter Pattern: {info['adapter_pattern']}")
    print(f"Zero Trust: {info['zero_trust_compliant']}")
    print(f"State Machine: {info['state_machine_binding']}")
    print(f"Telemetry: {info['telemetry_enabled']}")
    print("=" * 40)
    print("PROTOCOL COMPLIANCE:")
    print("- This binding requires polycall.exe runtime")
    print("- All execution goes through protocol validation")
    print("- User code acts as adapter, not engine")

async def main() -> None:
    """Main CLI entry point"""
    parser = create_parser()
    args = parser.parse_args()
    
    setup_logging(args.log_level)
    
    if args.command == "client":
        await run_client(args.host, args.port, args.auth)
    elif args.command == "test":
        await test_connection(args.host, args.port)
    elif args.command == "info":
        show_info()
    else:
        parser.print_help()

def main_sync() -> None:
    """Synchronous wrapper for main"""
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nOperation cancelled by user")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main_sync()
