from os import path
from typing import List, Optional


def get_component_makefiles(
    component_path: str, component_name: str, legacy: bool = False
) -> List[str]:
    """Helper to get makefile paths for a component."""
    makefiles = []

    # Base makefiles
    makefiles.extend(
        [
            path.join(component_path, 'Android.bp'),
            path.join(component_path, 'Android.mk'),
            path.join(component_path, f'{component_name}-vendor.mk'),
            path.join(component_path, 'BoardConfigVendor.mk'),
        ]
    )

    return makefiles


def get_component_guard(component_name: str) -> str:
    """Get the guard variable name for a component."""
    return f'TARGET_COMMON_QTI_COMPONENTS'


def get_component_prop_files(component_path: str) -> List[str]:
    """Get proprietary file lists for a component."""
    prop_files = []
    base_prop_file = path.join(component_path, 'proprietary-files.txt')
    if path.exists(base_prop_file):
        prop_files.append(base_prop_file)
    return prop_files
