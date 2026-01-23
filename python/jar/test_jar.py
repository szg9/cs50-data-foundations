import pytest
from jar import Jar


def test_init():
    jar = Jar(10)
    assert jar.capacity == 10
    assert jar.size == 0

    with pytest.raises(ValueError):
        invalid_args = ["cat", -10]
        for arg in invalid_args:
            jar = Jar(arg)


def test_str():
    jar = Jar(10)
    jar.deposit(3)
    assert str(jar) == "🍪🍪🍪"

    jar = Jar(10)
    jar.deposit(1)
    assert str(jar) == "🍪"

    jar = Jar(10)
    assert str(jar) == ""


def test_deposit():
    jar = Jar(10)

    with pytest.raises(ValueError):
        jar.deposit(15)

    jar.deposit(5)
    assert jar.size == 5

    with pytest.raises(ValueError):
        jar.deposit(-10)


def test_withdraw():
    jar = Jar(10)

    jar.deposit(10)
    jar.withdraw(5)
    assert jar.size == 5

    with pytest.raises(ValueError):
        jar.withdraw(10)

    with pytest.raises(ValueError):
        jar.withdraw(-10)