import sys
from functools import wraps


def patch_pandas_read_csv() -> None:
    """Make pandas HTTP CSV reads use the browser transport in Pyodide."""
    if sys.platform != "emscripten":
        return

    import pandas as pd
    from pyodide.http import open_url

    if getattr(pd.read_csv, "_course_utils_patched", False):
        return

    original_read_csv = pd.read_csv

    @wraps(original_read_csv)
    def read_csv(filepath_or_buffer, *args, **kwargs):
        if isinstance(filepath_or_buffer, str) and filepath_or_buffer.startswith(
            ("https://", "http://")
        ):
            filepath_or_buffer = open_url(filepath_or_buffer)

        return original_read_csv(filepath_or_buffer, *args, **kwargs)

    read_csv._course_utils_patched = True
    pd.read_csv = read_csv
