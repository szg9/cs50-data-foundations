import pytest
from project import get_rows
from project import validate_tags
from project import validate_dates


def test_get_rows():
    values =[[], ["2026-01-31", "2026-02-01", "2026-02-02"]]

    with pytest.raises(ValueError):
        for value in values:
            get_rows(value)


def test_validate_tags():
    assert validate_tags("")
    assert validate_tags("    ")
    assert validate_tags("happy")
    assert validate_tags("sad, depressed, tired")
    assert not validate_tags("sad123, depressed, tired")
    assert not validate_tags("sad123")
    assert not validate_tags("good!")
    assert not validate_tags("bad, good!")
    assert not validate_tags("bad,good")


def test_validate_dates():
    assert validate_dates(["2026-02-01"])
    assert validate_dates(["2026-02-01", "2026-02-01"])
    assert not validate_dates(["2025/12/11"])
    assert not validate_dates(["01-01-2026"])
    assert not validate_dates(["2025-02-30"])
    assert not validate_dates(["cat"])
    assert not validate_dates(["2026-02-01", "cat"])

