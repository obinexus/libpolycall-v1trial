#!/usr/bin/env python3
"""
PyPolyCall - LibPolyCall Trial v1 Python Binding
Clean Architecture Implementation for polycall.exe Runtime
"""

from setuptools import setup, find_packages
import os
import sys

# Ensure Python version compatibility
if sys.version_info < (3, 8):
    raise RuntimeError("PyPolyCall requires Python 3.8 or higher for clean architecture support")

# Read README for long description
def read_readme():
    readme_path = os.path.join(os.path.dirname(__file__), 'README.md')
    if os.path.exists(readme_path):
        with open(readme_path, 'r', encoding='utf-8') as f:
            return f.read()
    return "PyPolyCall - LibPolyCall Trial v1 Python Binding (Clean Architecture)"

# Read requirements from each layer
def read_requirements():
    """Read requirements with layer-specific organization"""
    base_requirements = [
        # Core Protocol Dependencies
        "aiohttp>=3.8.0",
        "websockets>=11.0.0", 
        "httpx>=0.24.0",
        
        # Serialization
        "msgpack>=1.0.0",
        "protobuf>=4.23.0",
        "pydantic>=2.0.0",
        
        # Security (Zero-Trust)
        "cryptography>=41.0.0",
        "PyJWT>=2.8.0",
        "bcrypt>=4.0.0",
        
        # Configuration
        "PyYAML>=6.0.0",
        "python-dotenv>=1.0.0",
        
        # Structured Logging
        "structlog>=23.0.0",
        "attrs>=23.0.0",
        
        # FFI
        "cffi>=1.15.0",
    ]
    
    return base_requirements

setup(
    name="pypolycall",
    version="1.0.0",
    author="OBINexusComputing",
    author_email="contact@obinexuscomputing.com",
    description="LibPolyCall Trial v1 Python Binding - Clean Architecture Implementation",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="https://gitlab.com/obinexuscomputing/libpolycall-v1trial/tree/main/bindings/pypolycall",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Software Development :: Libraries :: Application Frameworks",
        "Topic :: System :: Networking",
        "Topic :: Internet :: WWW/HTTP :: HTTP Servers",
        "Topic :: Software Development :: Code Generators",
        "Intended Audience :: System Administrators",
    ],
    python_requires=">=3.8",
    install_requires=read_requirements(),
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "pytest-cov>=4.0.0",
            "pytest-asyncio>=0.21.0",
            "black>=23.0.0",
            "flake8>=6.0.0",
            "mypy>=1.0.0",
            "isort>=5.12.0",
            "bandit>=1.7.0",  # Security linting
        ],
        "telemetry": [
            "prometheus-client>=0.17.0",
            "opentelemetry-api>=1.20.0",
            "opentelemetry-sdk>=1.20.0",
        ],
        "crypto": [
            "pycryptodome>=3.18.0",
            "keyring>=24.0.0",
        ],
        "extensions": [
            "pluggy>=1.3.0",
            "importlib-metadata>=6.0.0",
        ],
        "all": [
            # Include all extras
            "prometheus-client>=0.17.0",
            "opentelemetry-api>=1.20.0",
            "opentelemetry-sdk>=1.20.0",
            "pycryptodome>=3.18.0",
            "keyring>=24.0.0",
            "pluggy>=1.3.0",
            "importlib-metadata>=6.0.0",
        ]
    },
    entry_points={
        "console_scripts": [
            # Main CLI entry point
            "pypolycall=pypolycall.cli.main:main",
            
            # Layer-specific entry points
            "pypolycall-core=pypolycall.core.binding:main",
            "pypolycall-telemetry=pypolycall.core.telemetry:main",
            "pypolycall-config=pypolycall.config.manager:main",
            
            # Extension entry points
            "pypolycall-extension=pypolycall.cli.extensions:main",
        ],
        "pypolycall.extensions": [
            # Extension discovery entry points
        ],
    },
    project_urls={
        "Bug Reports": "https://gitlab.com/obinexuscomputing/libpolycall-v1trial/-/issues",
        "Source": "https://gitlab.com/obinexuscomputing/libpolycall-v1trial/tree/main/bindings/pypolycall",
        "Documentation": "https://docs.obinexuscomputing.com/libpolycall",
        "Architecture Guide": "https://docs.obinexuscomputing.com/libpolycall/python-binding",
    },
    keywords="api binding protocol polymorphic zero-trust telemetry clean-architecture ffi",
    zip_safe=False,
    include_package_data=True,
    package_data={
        "pypolycall": [
            "config/*.json",
            "config/*.yaml", 
            "config/schemas/*.json",
            "cli/templates/*.py",
            "core/templates/*.c",
            "core/templates/*.h",
        ],
    },
    # Architecture validation
    cmdclass={},
)
